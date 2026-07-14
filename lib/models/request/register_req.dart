import 'dart:convert';

String registerReqModelToJson(RegisterReqModel data) =>
    json.encode(data.toJson());

class RegisterReqModel {
  RegisterReqModel(
      {required this.smsotp,
      required this.charityId,
      required this.phoneVerifiedBy,
      required this.firstname,
      required this.lastname,
      required this.email,
      required this.membershipCountryId,
      required this.residenceCountryReferenceId,
      required this.residentialPostalCode,
      required this.phoneNumber,
      required this.countryId,
      required this.stateId,
      required this.issuerCode,
      required this.password,
      required this.confirmPassword,
      required this.memberPremiumCode,
      required this.discoveryInvitationCode,
      required this.memberReferralCode,
      required this.phoneNumberPrefix});

  final String phoneNumberPrefix;
  final String smsotp;
  final String firstname;
  final String lastname;
  final String email;
  final int membershipCountryId;
  final int residenceCountryReferenceId;
  final String? residentialPostalCode;
  final String phoneNumber;
  final int? charityId;
  final String phoneVerifiedBy;
  final int countryId;
  final int? stateId;
  final dynamic issuerCode;
  final String password;
  final String confirmPassword;
  final dynamic memberPremiumCode;
  final dynamic discoveryInvitationCode;
  final dynamic memberReferralCode;

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "SMSOTP": smsotp,
        "phoneVerifiedBy": phoneVerifiedBy,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "membershipCountryId": membershipCountryId,
        "residenceCountryReferenceId": residenceCountryReferenceId,
        "residentialPostalCode": residentialPostalCode,
        "phoneNumber": phoneNumber,
        "countryId": countryId,
        if (stateId != null) "stateId": stateId,
        "charityId": charityId,
        "issuerCode": issuerCode == 'null' ? null : issuerCode,
        "password": password,
        "confirmPassword": confirmPassword,
        "memberPremiumCode":
            memberPremiumCode == 'null' ? null : memberPremiumCode,
        "discoveryInvitationCode":
            discoveryInvitationCode == 'null' ? null : discoveryInvitationCode,
        "memberReferralCode":
            memberReferralCode == 'null' ? null : memberReferralCode,
      };
}
