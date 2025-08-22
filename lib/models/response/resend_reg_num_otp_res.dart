// To parse this JSON data, do
//
//     final memberOtpResModel = memberOtpResModelFromJson(jsonString);

import 'dart:convert';

ResendRegNumberOtpResModel resendRegNumberOtpResModelFromJson(String str) =>
    ResendRegNumberOtpResModel.fromJson(json.decode(str));

String resendRegNumberOtpResModelToJson(ResendRegNumberOtpResModel data) =>
    json.encode(data.toJson());

class ResendRegNumberOtpResModel {
  ResendRegNumberOtpResModel({
    required this.status,
    required this.message,
  });

  final String status;
  final String message;

  factory ResendRegNumberOtpResModel.fromJson(Map<String, dynamic> json) =>
      ResendRegNumberOtpResModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
