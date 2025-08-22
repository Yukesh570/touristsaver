// To parse this JSON data, do
//
//     final topUpReqModel = topUpReqModelFromJson(jsonString);

import 'dart:convert';

RegisterTopUpStripeReqModel registerTopUpStripeReqModelFromJson(String str) =>
    RegisterTopUpStripeReqModel.fromJson(json.decode(str));

String registerTopUpStripeReqModelToJson(RegisterTopUpStripeReqModel data) =>
    json.encode(data.toJson());

class RegisterTopUpStripeReqModel {
  RegisterTopUpStripeReqModel({
    this.paymentGateway,
    this.membershipPackageId,
    this.countryId,
    // this.memberPremiumCode,
    this.isTopupUponRegistration,
  });

  final String? paymentGateway;
  final String? membershipPackageId;
  final String? countryId;
  // final String? memberPremiumCode;
  final bool? isTopupUponRegistration;

  factory RegisterTopUpStripeReqModel.fromJson(Map<String, dynamic> json) =>
      RegisterTopUpStripeReqModel(
        paymentGateway: json["paymentGateway"],
        membershipPackageId: json["membershipPackageId"],
        countryId: json["countryId"],
        //  memberPremiumCode: json["memberPremiumCode"],
        isTopupUponRegistration: json["isTopupUponRegistration"],
      );

  Map<String, dynamic> toJson() => {
        "paymentGateway": paymentGateway,
        "membershipPackageId": membershipPackageId,
        "countryId": countryId,
        //   "memberPremiumCode": memberPremiumCode,
        "isTopupUponRegistration": isTopupUponRegistration,
      };
}
