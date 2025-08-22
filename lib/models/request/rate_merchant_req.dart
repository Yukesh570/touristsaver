// To parse this JSON data, do
//
//     final rateMerchantReqModel = rateMerchantReqModelFromJson(jsonString);

import 'dart:convert';

RateMerchantReqModel rateMerchantReqModelFromJson(String str) =>
    RateMerchantReqModel.fromJson(json.decode(str));

String rateMerchantReqModelToJson(RateMerchantReqModel data) =>
    json.encode(data.toJson());

class RateMerchantReqModel {
  final String? review;
  final dynamic rating;
  final int? merchantId;

  RateMerchantReqModel({
    this.review,
    this.rating,
    this.merchantId,
  });

  factory RateMerchantReqModel.fromJson(Map<String, dynamic> json) =>
      RateMerchantReqModel(
        review: json["review"],
        rating: json["rating"],
        merchantId: json["merchantId"],
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "rating": rating,
        "merchantId": merchantId,
      };
}
