import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';

class BranchRegistrationReferral {
  const BranchRegistrationReferral({
    this.issuerCode,
    this.memberReferralCode,
    this.campaign,
  });

  final String? issuerCode;
  final String? memberReferralCode;
  final String? campaign;

  bool get hasRegistrationCode =>
      issuerCode != null || memberReferralCode != null;

  factory BranchRegistrationReferral.fromPayload(Map<dynamic, dynamic> data) {
    final refType = _nonEmptyString(data['ref_type'])?.toLowerCase();
    final refCode = _nonEmptyString(data['ref_code']);

    if (refCode != null && (refType == 'issuer' || refType == 'merchant')) {
      return BranchRegistrationReferral(
        issuerCode: refCode,
        campaign: _nonEmptyString(data['~campaign']),
      );
    }

    if (refCode != null && refType == 'member') {
      return BranchRegistrationReferral(
        memberReferralCode: refCode,
        campaign: _nonEmptyString(data['~campaign']),
      );
    }

    return BranchRegistrationReferral(
      issuerCode: _nonEmptyString(data['issuercode']),
      memberReferralCode: _nonEmptyString(data['memberReferralCode']),
      campaign: _nonEmptyString(data['~campaign']),
    );
  }

  static String? _nonEmptyString(dynamic value) {
    if (value == null) return null;
    final result = value.toString().trim();
    if (result.isEmpty || result.toLowerCase() == 'null') return null;
    return result;
  }
}

Map<String, String> registrationQueryParametersFor(
  BranchRegistrationReferral? referral,
) {
  return {
    'issuercode': referral?.issuerCode ?? '',
    'memberReferralCode': referral?.memberReferralCode ?? '',
  };
}

class BranchReferralService {
  BranchReferralService._();

  static final StreamController<BranchRegistrationReferral> _controller =
      StreamController<BranchRegistrationReferral>.broadcast();

  static StreamSubscription<Map>? _branchSubscription;
  static BranchRegistrationReferral? _pendingReferral;

  static Stream<BranchRegistrationReferral> get referrals => _controller.stream;
  static BranchRegistrationReferral? get pendingReferral => _pendingReferral;

  static void start() {
    if (_branchSubscription != null) return;

    _branchSubscription = FlutterBranchSdk.listSession().listen(
      (data) {
        const encoder = JsonEncoder.withIndent('  ');
        debugPrint(
          'BRANCH_PAYLOAD:\n${encoder.convert(Map<String, dynamic>.from(data))}',
        );

        if (data['+clicked_branch_link'] != true) return;

        final referral = BranchRegistrationReferral.fromPayload(data);
        debugPrint(
          'BRANCH_NORMALIZED: '
          'issuerCode=${referral.issuerCode}, '
          'memberReferralCode=${referral.memberReferralCode}, '
          'campaign=${referral.campaign}',
        );

        if (!referral.hasRegistrationCode) return;
        _pendingReferral = referral;
        _controller.add(referral);
      },
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('BRANCH_ERROR: $error');
      },
    );
  }

  static BranchRegistrationReferral? takePendingReferral() {
    final referral = _pendingReferral;
    _pendingReferral = null;
    return referral;
  }

  static void markHandled(BranchRegistrationReferral referral) {
    if (identical(_pendingReferral, referral)) {
      _pendingReferral = null;
    }
  }
}
