import 'dart:convert';

String phoneOtpReqToJson(PhoneOtpReq data) => json.encode(data.toJson());

class PhoneOtpReq {
  String? phoneNumberPrefix;
  String? phoneNumber;
  String? phoneVerifiedBy;
  String? email;
  int? countryId;
  String? appSign;
  String? memberReferralCode;

  PhoneOtpReq({
    this.phoneNumberPrefix,
    this.phoneNumber,
    this.phoneVerifiedBy,
    this.email,
    this.countryId,
    this.appSign,
    this.memberReferralCode,
  });

  Map<String, dynamic> toJson() => {
        "phoneVerifiedBy": phoneVerifiedBy,
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneNumber": phoneNumber,
        "email": email,
        "countryId": countryId,
        "appSign": appSign,
        "memberReferralCode":
            memberReferralCode == null || memberReferralCode!.isEmpty
                ? null
                : memberReferralCode,
      };
}
