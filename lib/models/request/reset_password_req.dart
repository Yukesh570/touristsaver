import 'dart:convert';

String resetPasswordReqModelToJson(ResetPasswordReqModel data) =>
    json.encode(data.toJson());

class ResetPasswordReqModel {
  ResetPasswordReqModel({
    required this.phoneNumberPrefix,
    required this.countryId,
    required this.phoneNumber,
    required this.otp,
    required this.newPassword,
    required this.newConfirmPassword,
  });

  final String phoneNumberPrefix;
  final int countryId;
  final String phoneNumber;
  final String otp;
  final String newPassword;
  final String newConfirmPassword;

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "countryId": countryId,
        "phoneNumber": phoneNumber,
        "OTP": otp,
        "newPassword": newPassword,
        "newConfirmPassword": newConfirmPassword,
      };
}
