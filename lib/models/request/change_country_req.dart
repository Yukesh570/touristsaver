// To parse this JSON data, do
//
//     final changeCountryReqModel = changeCountryReqModelFromJson(jsonString);

import 'dart:convert';

ChangeCountryReqModel changeCountryReqModelFromJson(String str) =>
    ChangeCountryReqModel.fromJson(json.decode(str));

String changeCountryReqModelToJson(ChangeCountryReqModel data) =>
    json.encode(data.toJson());

class ChangeCountryReqModel {
  ChangeCountryReqModel({
    required this.countryId,
    required this.stateId,
    required this.phoneNumber,
    required this.phoneNumberPrefix,
    this.appSign,
  });

  final int countryId;
  final int stateId;
  final String phoneNumber;
  final String phoneNumberPrefix;
  final String? appSign;

  factory ChangeCountryReqModel.fromJson(Map<String, dynamic> json) =>
      ChangeCountryReqModel(
        countryId: json["countryId"],
        stateId: json["stateId"],
        phoneNumber: json["phoneNumber"],
        phoneNumberPrefix: json["phoneNumberPrefix"],
        appSign: json["appSign"],
      );

  Map<String, dynamic> toJson() => {
        "countryId": countryId,
        "stateId": stateId,
        "phoneNumber": phoneNumber,
        "phoneNumberPrefix": phoneNumberPrefix,
        "appSign": appSign,
      };
}
