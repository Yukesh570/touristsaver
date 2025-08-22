// To parse this JSON data, do
//
//     final memberOtpResModel = memberOtpResModelFromJson(jsonString);

import 'dart:convert';

VerifyEmailOtpResModel verifymemberOtpResModelFromJson(String str) =>
    VerifyEmailOtpResModel.fromJson(json.decode(str));

String verifymemberOtpResModelToJson(VerifyEmailOtpResModel data) =>
    json.encode(data.toJson());

class VerifyEmailOtpResModel {
  VerifyEmailOtpResModel({
    required this.status,
    required this.message,
  });

  final String status;
  final String message;

  factory VerifyEmailOtpResModel.fromJson(Map<String, dynamic> json) =>
      VerifyEmailOtpResModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
