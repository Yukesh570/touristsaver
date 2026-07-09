import 'package:touristsaver/common/models/premium_code_classification.dart';

class MembershipOfferCodeDetails {
  const MembershipOfferCodeDetails({
    required this.isGiveaway,
    this.discount,
    this.premiumCodeIsPaid,
    this.codeOwnerId,
    this.codeOwnerType,
    this.assignedToName,
    this.proudlySupportsSource = false,
  });

  final bool isGiveaway;
  final String? discount;
  final bool? premiumCodeIsPaid;
  final int? codeOwnerId;
  final String? codeOwnerType;
  final String? assignedToName;
  final bool proudlySupportsSource;

  double get discountPercent => membershipOfferDiscountPercent(discount);

  bool get isComplimentaryMembership => isExplicitComplimentaryMembershipOffer(
        isGiveaway: isGiveaway,
        premiumCodeIsPaid: premiumCodeIsPaid,
        discountPercent: discountPercent,
      );

  double get effectiveDiscountPercent =>
      effectiveMembershipOfferDiscountPercent(
        discount: discount,
        isGiveaway: isGiveaway,
        premiumCodeIsPaid: premiumCodeIsPaid,
      );

  factory MembershipOfferCodeDetails.fromJson(Map<String, dynamic> json) {
    final owner = _firstMap([
      json['codeOwner'],
      json['__codeOwner__'],
      json['assignedTo'],
      json['__assignedTo__'],
    ]);

    final codeOwnerType = _nonEmptyString(json['codeOwnerType']);
    final recognitionStyle =
        _nonEmptyString(json['recognitionStyle'])?.toLowerCase();

    return MembershipOfferCodeDetails(
      isGiveaway: json['isGiveaway'] == true,
      discount: _nonEmptyString(json['discount']),
      premiumCodeIsPaid: _asBool(json['premiumCodeIsPaid']),
      codeOwnerId: _asInt(json['codeOwnerId']),
      codeOwnerType: codeOwnerType,
      assignedToName: _firstNonEmpty([
        owner?['merchantName'],
        owner?['businessName'],
        owner?['displayName'],
        owner?['name'],
        json['merchantDisplayName'],
        json['assignedToName'],
        json['codeOwnerName'],
      ]),
      proudlySupportsSource: recognitionStyle == 'supporting' ||
          json['isFundraisingCampaign'] == true ||
          const {'charity', 'club'}.contains(codeOwnerType?.toLowerCase()),
    );
  }

  static Map<String, dynamic>? _firstMap(List<dynamic> values) {
    for (final value in values) {
      if (value is Map<String, dynamic>) return value;
      if (value is Map) return Map<String, dynamic>.from(value);
    }
    return null;
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

  static String? _nonEmptyString(dynamic value) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? null : text;
  }

  static String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = _nonEmptyString(value);
      if (text != null) return text;
    }
    return null;
  }
}
