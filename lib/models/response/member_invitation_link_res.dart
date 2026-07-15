import 'dart:convert';

class MemberInvitationLink {
  const MemberInvitationLink({
    required this.url,
    required this.refType,
    required this.memberReferralCode,
    required this.refCode,
    required this.campaignId,
    required this.campaignName,
    required this.feature,
    required this.channel,
  });

  final String url;
  final String refType;
  final String memberReferralCode;
  final String refCode;
  final int? campaignId;
  final String? campaignName;
  final String feature;
  final String channel;

  bool get hasCampaignContext => campaignId != null;

  factory MemberInvitationLink.fromJson(Map<String, dynamic> json) {
    final url = json['url']?.toString().trim() ?? '';
    if (url.isEmpty) {
      throw const FormatException('Member invitation link URL is missing');
    }

    return MemberInvitationLink(
      url: url,
      refType: json['ref_type']?.toString() ?? '',
      memberReferralCode: json['memberReferralCode']?.toString() ?? '',
      refCode: json['ref_code']?.toString() ?? '',
      campaignId: _intValue(json['campaignId']),
      campaignName: _nonEmptyString(json['campaignName']),
      feature: json['feature']?.toString() ?? '',
      channel: json['channel']?.toString() ?? '',
    );
  }

  static int? _intValue(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  static String? _nonEmptyString(dynamic value) {
    final result = value?.toString().trim() ?? '';
    return result.isEmpty ? null : result;
  }
}

MemberInvitationLink memberInvitationLinkFromResponse(dynamic responseData) {
  final dynamic decoded =
      responseData is String ? jsonDecode(responseData) : responseData;
  if (decoded is! Map) {
    throw const FormatException('Invalid member invitation link response');
  }

  final response = Map<String, dynamic>.from(decoded);
  final dynamic data = response['data'];
  if (data is! Map) {
    throw const FormatException('Member invitation link data is missing');
  }

  return MemberInvitationLink.fromJson(Map<String, dynamic>.from(data));
}
