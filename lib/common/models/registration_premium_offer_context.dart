import 'package:touristsaver/models/response/membership_offer_code_details.dart';
import 'package:touristsaver/models/response/register_res.dart';

class RegistrationPremiumOfferContext {
  const RegistrationPremiumOfferContext({
    required this.memberPremiumCode,
    required this.discount,
    required this.packageId,
    required this.premiumCodeIsPaid,
    required this.isGiveaway,
    this.pendingRegistrationAccess = false,
  });

  final String memberPremiumCode;
  final String? discount;
  final int? packageId;
  final bool? premiumCodeIsPaid;
  final bool isGiveaway;
  final bool pendingRegistrationAccess;

  bool get hasCode => memberPremiumCode.trim().isNotEmpty;

  Map<String, dynamic> toPremiumData() {
    return {
      'memberPremiumCode': memberPremiumCode.trim().toUpperCase(),
      'discount': discount,
      'packageId': packageId,
      'membershipPackageId': packageId,
      'premiumCodeIsPaid': premiumCodeIsPaid,
      'isGiveaway': isGiveaway,
    };
  }

  Map<String, dynamic> toRouteExtra() => {
        ...toPremiumData(),
        'pendingRegistrationAccess': pendingRegistrationAccess,
      };

  factory RegistrationPremiumOfferContext.fromRegistrationResponse({
    required String memberPremiumCode,
    required Data data,
  }) {
    return RegistrationPremiumOfferContext(
      memberPremiumCode: memberPremiumCode,
      discount: data.discount,
      packageId: data.packageId,
      premiumCodeIsPaid: data.premiumCodeIsPaid,
      isGiveaway: data.isGiveaway == true,
      pendingRegistrationAccess: true,
    );
  }

  factory RegistrationPremiumOfferContext.fromRouteExtra(
    Map<String, dynamic> extra,
  ) {
    return RegistrationPremiumOfferContext(
      memberPremiumCode: extra['memberPremiumCode']?.toString() ?? '',
      discount: extra['discount']?.toString(),
      packageId: _asInt(extra['packageId'] ?? extra['membershipPackageId']),
      premiumCodeIsPaid: _asBool(extra['premiumCodeIsPaid']),
      isGiveaway: extra['isGiveaway'] == true,
      pendingRegistrationAccess: extra['pendingRegistrationAccess'] == true,
    );
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static bool? _asBool(dynamic value) {
    if (value is bool) return value;
    final normalized = value?.toString().trim().toLowerCase();
    if (normalized == 'true') return true;
    if (normalized == 'false') return false;
    return null;
  }
}

class MembershipOfferPaymentPreview {
  const MembershipOfferPaymentPreview({
    required this.originalAmount,
    required this.discountPercent,
    required this.discountAmount,
    required this.payableAmount,
    required this.memberPremiumCodeForPaymentIntent,
    required this.isComplimentary,
  });

  final double originalAmount;
  final double discountPercent;
  final double discountAmount;
  final double payableAmount;
  final String? memberPremiumCodeForPaymentIntent;
  final bool isComplimentary;
}

MembershipOfferPaymentPreview membershipOfferPaymentPreview({
  required double originalAmount,
  required Map<dynamic, dynamic>? premiumData,
}) {
  final details = premiumData == null
      ? null
      : MembershipOfferCodeDetails.fromJson(
          Map<String, dynamic>.from(premiumData),
        );
  final discountPercent = details?.effectiveDiscountPercent ?? 0;
  final discountAmount = originalAmount * (discountPercent / 100);
  final payableAmount =
      (originalAmount - discountAmount).clamp(0, double.infinity).toDouble();
  final hasPartialDiscount =
      discountPercent > 0 && discountPercent < 100 && originalAmount > 0;
  final code = premiumData?['memberPremiumCode']?.toString().trim();

  return MembershipOfferPaymentPreview(
    originalAmount: originalAmount,
    discountPercent: discountPercent,
    discountAmount: discountAmount,
    payableAmount: payableAmount,
    memberPremiumCodeForPaymentIntent:
        hasPartialDiscount && code != null && code.isNotEmpty
            ? code.toUpperCase()
            : null,
    isComplimentary: details?.isComplimentaryMembership ?? false,
  );
}
