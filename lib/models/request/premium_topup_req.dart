// To parse this JSON data, do
//
//     final premiumTopUpReqModel = premiumTopUpReqModelFromJson(jsonString);

import 'dart:convert';

PremiumTopUpReqModel premiumTopUpReqModelFromJson(String str) =>
    PremiumTopUpReqModel.fromJson(json.decode(str));

String premiumTopUpReqModelToJson(PremiumTopUpReqModel data) =>
    json.encode(data.toJson());

class PremiumTopUpReqModel {
  PremiumTopUpReqModel({
    this.memberPremiumCode,
  });

  final String? memberPremiumCode;

  factory PremiumTopUpReqModel.fromJson(Map<String, dynamic> json) =>
      PremiumTopUpReqModel(
        memberPremiumCode: json["memberPremiumCode"],
      );

  Map<String, dynamic> toJson() => {
        "memberPremiumCode": memberPremiumCode,
      };
}
