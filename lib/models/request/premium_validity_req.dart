// To parse this JSON data, do
//
//     final premiumValidityReqModel = premiumValidityReqModelFromJson(jsonString);

import 'dart:convert';

PremiumValidityReqModel premiumValidityReqModelFromJson(String str) =>
    PremiumValidityReqModel.fromJson(json.decode(str));

String premiumValidityReqModelToJson(PremiumValidityReqModel data) =>
    json.encode(data.toJson());

class PremiumValidityReqModel {
  PremiumValidityReqModel({
    this.memberPremiumCode,
    this.issuerCode,
  });

  final String? memberPremiumCode;
  final String? issuerCode;

  factory PremiumValidityReqModel.fromJson(Map<String, dynamic> json) =>
      PremiumValidityReqModel(
          memberPremiumCode: json["memberPremiumCode"],
          issuerCode: json["issuerCode"]);

  Map<String, dynamic> toJson() => {
        "memberPremiumCode": memberPremiumCode,
        "issuerCode": issuerCode,
      };
}
