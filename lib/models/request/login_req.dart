// To parse this JSON data, do
//
//     final loginReqModel = loginReqModelFromJson(jsonString);

import 'dart:convert';

LoginReqModel loginReqModelFromJson(String str) =>
    LoginReqModel.fromJson(json.decode(str));

String loginReqModelToJson(LoginReqModel data) => json.encode(data.toJson());

class LoginReqModel {
  LoginReqModel(
      {required this.phoneNumberPrefix,
      required this.emailPhone,
      required this.password,
      this.countryId,
      this.lang});

  final String phoneNumberPrefix;
  final String emailPhone;
  final String password;
  final String? countryId;
  final String? lang;

  factory LoginReqModel.fromJson(Map<String, dynamic> json) => LoginReqModel(
        phoneNumberPrefix: json["phoneNumberPrefix"],
        emailPhone: json["emailPhone"],
        password: json["password"],
        countryId: json["countryId"],
        lang: json['lang'],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "emailPhone": emailPhone,
        "password": password,
        "countryId": countryId,
        "lang": lang,
      };
}
