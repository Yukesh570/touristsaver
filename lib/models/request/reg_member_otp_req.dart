import 'dart:convert';

EmailMemberOtpReqModel emailmemberOtpReqModelFromJson(String str) =>
    EmailMemberOtpReqModel.fromJson(json.decode(str));

String emailmemberOtpReqModelToJson(EmailMemberOtpReqModel data) =>
    json.encode(data.toJson());

class EmailMemberOtpReqModel {
  EmailMemberOtpReqModel({
    required this.phoneNumberPrefix,
    required this.phoneNumber,
    required this.email,
    // required this.countryId,
    required this.memberReferralCode,
  });

  final String phoneNumberPrefix;
  final String phoneNumber;
  final String email;
  // final int countryId;
  final dynamic memberReferralCode;

  factory EmailMemberOtpReqModel.fromJson(Map<String, dynamic> json) =>
      EmailMemberOtpReqModel(
        phoneNumberPrefix: json["phoneNumberPrefix"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        // countryId: json["countryId"],
        memberReferralCode: json["memberReferralCode"] == 'null'
            ? null
            : json["memberReferralCode"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneNumber": phoneNumber,
        "email": email,
        // "countryId": countryId,
        "memberReferralCode":
            memberReferralCode == 'null' ? null : memberReferralCode,
      };
}
