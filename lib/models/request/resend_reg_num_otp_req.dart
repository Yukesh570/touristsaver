// To parse this JSON data, do
//
//     final memberOtpReqModel = memberOtpReqModelFromJson(jsonString);

import 'dart:convert';

NumberMemberOtpReqModel numbermemberOtpReqModelFromJson(String str) =>
    NumberMemberOtpReqModel.fromJson(json.decode(str));

String numbermemberOtpReqModelToJson(NumberMemberOtpReqModel data) =>
    json.encode(data.toJson());

class NumberMemberOtpReqModel {
  NumberMemberOtpReqModel({
    required this.phoneNumberPrefix,
    required this.phoneNumber,
    required this.email,
    required this.countryId,
    this.otpMedium,
    this.appSign,
  });

  final String phoneNumberPrefix;
  final String phoneNumber;
  final String email;
  final String? otpMedium;
  final int countryId;
  final String? appSign;

  factory NumberMemberOtpReqModel.fromJson(Map<String, dynamic> json) =>
      NumberMemberOtpReqModel(
          phoneNumberPrefix: json["phoneNumberPrefix"],
          phoneNumber: json["phoneNumber"],
          email: json["email"],
          countryId: json["countryId"],
          appSign: json["appSign"],
          otpMedium: json["otpMedium"]);

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "otpMedium": otpMedium,
        "phoneNumber": phoneNumber,
        "email": email,
        "countryId": countryId,
        "appSign": appSign,
      };
}
