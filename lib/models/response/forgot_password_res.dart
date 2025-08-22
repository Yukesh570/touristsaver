import 'dart:convert';

ForgotPasswordResModel forgotPasswordResModelFromJson(String str) =>
    ForgotPasswordResModel.fromJson(json.decode(str));

class ForgotPasswordResModel {
  ForgotPasswordResModel({
    this.status,
    this.emailOTPSent,
    this.message,
  });

  String? status;
  bool? emailOTPSent;
  String? message;

  factory ForgotPasswordResModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResModel(
        status: json["status"],
        emailOTPSent: json["emailOTPSent"],
        message: json["message"],
      );
}
