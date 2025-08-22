// To parse this JSON data, do
//
//     final verifyEmailOtpReqModel = verifyEmailOtpReqModelFromJson(jsonString);

import 'dart:convert';

VerifyEmailOtpReqModel verifyEmailOtpReqModelFromJson(String str) =>
    VerifyEmailOtpReqModel.fromJson(json.decode(str));

String verifyEmailOtpReqModelToJson(VerifyEmailOtpReqModel data) =>
    json.encode(data.toJson());

class VerifyEmailOtpReqModel {
  VerifyEmailOtpReqModel({
    required this.phoneNumberPrefix,
    required this.phoneNumber,
    required this.email,
    required this.emailOtp,
    required this.countryId,
    this.appSign,
  });

  final String phoneNumberPrefix;
  final String phoneNumber;
  final String email;
  final String emailOtp;
  final int countryId;
  final String? appSign;

  factory VerifyEmailOtpReqModel.fromJson(Map<String, dynamic> json) =>
      VerifyEmailOtpReqModel(
        phoneNumberPrefix: json["phoneNumberPrefix"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        emailOtp: json["emailOTP"],
        countryId: json["countryId"],
        appSign: json["appSign"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneNumber": phoneNumber,
        "email": email,
        "emailOTP": emailOtp,
        "countryId": countryId,
        "appSign": appSign,
      };
}
