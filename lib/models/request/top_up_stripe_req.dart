// To parse this JSON data, do
//
//     final topUpReqModel = topUpReqModelFromJson(jsonString);

import 'dart:convert';

TopUpStripeReqModel topUpStripeReqModelFromJson(String str) =>
    TopUpStripeReqModel.fromJson(json.decode(str));

String topUpStripeReqModelToJson(TopUpStripeReqModel data) =>
    json.encode(data.toJson());

class TopUpStripeReqModel {
  TopUpStripeReqModel({
    this.paymentGateway,
    this.membershipPackageId,
    this.countryId,
  });

  final String? paymentGateway;
  final String? membershipPackageId;
  final String? countryId;

  factory TopUpStripeReqModel.fromJson(Map<String, dynamic> json) =>
      TopUpStripeReqModel(
        paymentGateway: json["paymentGateway"],
        membershipPackageId: json["membershipPackageId"],
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "paymentGateway": paymentGateway,
        "membershipPackageId": membershipPackageId,
        "countryId": countryId,
      };
}
