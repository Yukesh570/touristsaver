// To parse this JSON data, do
//
//     final userDeleteResModel = userDeleteResModelFromJson(jsonString);

import 'dart:convert';

UserDeleteResModel userDeleteResModelFromJson(String str) =>
    UserDeleteResModel.fromJson(json.decode(str));

String userDeleteResModelToJson(UserDeleteResModel data) =>
    json.encode(data.toJson());

class UserDeleteResModel {
  final String? status;
  final String? message;

  UserDeleteResModel({
    this.status,
    this.message,
  });

  factory UserDeleteResModel.fromJson(Map<String, dynamic> json) =>
      UserDeleteResModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
