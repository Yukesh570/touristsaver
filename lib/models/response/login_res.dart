// To parse this JSON data, do
//
//     final loginResModel = loginResModelFromJson(jsonString);

import 'dart:convert';

LoginResModel loginResModelFromJson(String str) =>
    LoginResModel.fromJson(json.decode(str));

String loginResModelToJson(LoginResModel data) => json.encode(data.toJson());

class LoginResModel {
  final String? status;
  final Data? data;

  LoginResModel({
    this.status,
    this.data,
  });

  factory LoginResModel.fromJson(Map<String, dynamic> json) => LoginResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final String? accessToken;
  final User? user;

  Data({
    this.accessToken,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "user": user?.toJson(),
      };
}

class User {
  final int? countryId;
  final String? countryName;
  final String? phonePrefix;
  final String? issuerType;

  User({
    this.countryId,
    this.countryName,
    this.phonePrefix,
    this.issuerType,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        countryId: json["countryId"],
        countryName: json["countryName"],
        phonePrefix: json["phonePrefix"],
        issuerType: json["issuerType"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "countryName": countryName,
        "phonePrefix": phonePrefix,
        "issuerType": issuerType,
      };
}
