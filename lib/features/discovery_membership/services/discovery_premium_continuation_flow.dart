import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/discovery_membership/services/discovery_continuation_dio.dart';
import 'package:touristsaver/features/top_up/services/top_up_dio.dart';
import 'package:touristsaver/models/request/confirm_topup_req.dart';
import 'package:touristsaver/models/response/confirm_topup_res.dart';

enum DiscoveryContinuationStatus { activated, cancelled, failed }

class DiscoveryContinuationResult {
  const DiscoveryContinuationResult(this.status, [this.message]);

  final DiscoveryContinuationStatus status;
  final String? message;
}

/// Runs the same Discovery-to-Premium payment lifecycle from any member screen.
class DiscoveryPremiumContinuationFlow {
  const DiscoveryPremiumContinuationFlow();

  Future<DiscoveryContinuationResult> continueWith(
    DiscoveryMembershipContext membership,
  ) async {
    final int? entitlementId = membership.entitlementId;
    if (entitlementId == null) {
      return const DiscoveryContinuationResult(
        DiscoveryContinuationStatus.failed,
        'We could not prepare your Premium continuation. Please try again.',
      );
    }

    try {
      final intent =
          await DiscoveryContinuationDio().createPaymentIntent(entitlementId);
      if (intent == null) {
        return const DiscoveryContinuationResult(
          DiscoveryContinuationStatus.failed,
          'We could not prepare your Premium continuation. Please try again.',
        );
      }
      if (intent.isFree || intent.completed) {
        return const DiscoveryContinuationResult(
          DiscoveryContinuationStatus.activated,
        );
      }

      final String? clientSecret = intent.clientSecret;
      if (clientSecret == null || clientSecret.isEmpty) {
        return const DiscoveryContinuationResult(
          DiscoveryContinuationStatus.failed,
          'Payment could not be prepared.',
        );
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'TouristSaver',
          style: ThemeMode.light,
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      final int secretIndex = clientSecret.indexOf('_secret_');
      if (secretIndex <= 0) throw StateError('Invalid payment reference');
      final confirmation = await DioTopUpStripe().confirmTopUp(
        confirmTopUpReqModel: ConfirmTopUpReqModel(
          paymentIntent: clientSecret.substring(0, secretIndex),
          paymentIntentClientSecret: clientSecret,
        ),
      );
      if (confirmation is ConfirmTopUpResModel &&
          confirmation.status?.toLowerCase() == 'success') {
        return const DiscoveryContinuationResult(
          DiscoveryContinuationStatus.activated,
        );
      }
      return const DiscoveryContinuationResult(
        DiscoveryContinuationStatus.failed,
        'We could not confirm your Premium Membership. Please contact TouristSaver support before trying again.',
      );
    } on StripeException catch (error) {
      if (error.error.code == FailureCode.Canceled) {
        return const DiscoveryContinuationResult(
          DiscoveryContinuationStatus.cancelled,
          'Payment cancelled. No charge was made.',
        );
      }
      return DiscoveryContinuationResult(
        DiscoveryContinuationStatus.failed,
        error.error.localizedMessage ?? 'Payment could not be completed.',
      );
    } catch (_) {
      return const DiscoveryContinuationResult(
        DiscoveryContinuationStatus.failed,
        'Payment could not be completed. Please try again.',
      );
    }
  }
}
