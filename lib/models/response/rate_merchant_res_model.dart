// To parse this JSON data, do
//
//     final rateMerchantResModel = rateMerchantResModelFromJson(jsonString);

import 'dart:convert';

RateMerchantResModel rateMerchantResModelFromJson(String str) =>
    RateMerchantResModel.fromJson(json.decode(str));

String rateMerchantResModelToJson(RateMerchantResModel data) =>
    json.encode(data.toJson());

class RateMerchantResModel {
  final String? status;
  final Data? data;

  RateMerchantResModel({
    this.status,
    this.data,
  });

  factory RateMerchantResModel.fromJson(Map<String, dynamic> json) =>
      RateMerchantResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final dynamic review;
  final String? rating;
  final int? merchantId;
  final int? memberId;
  final int? id;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.review,
    this.rating,
    this.merchantId,
    this.memberId,
    this.id,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        review: json["review"],
        rating: json["rating"],
        merchantId: json["merchantId"],
        memberId: json["memberId"],
        id: json["id"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "rating": rating,
        "merchantId": merchantId,
        "memberId": memberId,
        "id": id,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
