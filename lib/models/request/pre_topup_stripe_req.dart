// To parse this JSON data, do
//
//     final topUpReqModel = topUpReqModelFromJson(jsonString);

import 'dart:convert';

PremiumTopUpStripeReqModel premiumTopUpStripeReqModelFromJson(String str) =>
    PremiumTopUpStripeReqModel.fromJson(json.decode(str));

String premiumTopUpStripeReqModelToJson(PremiumTopUpStripeReqModel data) =>
    json.encode(data.toJson());

class PremiumTopUpStripeReqModel {
  PremiumTopUpStripeReqModel({
    this.paymentGateway,
    this.membershipPackageId,
    this.countryId,
    this.memberPremiumCode,
  });

  final String? paymentGateway;
  final String? membershipPackageId;
  final String? countryId;
  final String? memberPremiumCode;

  factory PremiumTopUpStripeReqModel.fromJson(Map<String, dynamic> json) =>
      PremiumTopUpStripeReqModel(
        paymentGateway: json["paymentGateway"],
        membershipPackageId: json["membershipPackageId"],
        countryId: json["countryId"],
        memberPremiumCode: json["memberPremiumCode"],
      );

  Map<String, dynamic> toJson() => {
        "paymentGateway": paymentGateway,
        "membershipPackageId": membershipPackageId,
        "countryId": countryId,
        "memberPremiumCode": memberPremiumCode,
      };
}
