// To parse this JSON data, do
//
//     final changePasswordReqModel = changePasswordReqModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordReqModel changePasswordReqModelFromJson(String str) =>
    ChangePasswordReqModel.fromJson(json.decode(str));

String changePasswordReqModelToJson(ChangePasswordReqModel data) =>
    json.encode(data.toJson());

class ChangePasswordReqModel {
  ChangePasswordReqModel({
    required this.currentPassword,
    required this.newPassword,
    required this.newConfirmPassword,
  });

  final String currentPassword;
  final String newPassword;
  final String newConfirmPassword;

  factory ChangePasswordReqModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordReqModel(
        currentPassword: json["currentPassword"],
        newPassword: json["newPassword"],
        newConfirmPassword: json["newConfirmPassword"],
      );

  Map<String, dynamic> toJson() => {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "newConfirmPassword": newConfirmPassword,
      };
}
