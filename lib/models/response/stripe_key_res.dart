// To parse this JSON data, do
//
//     final stripeKeyResModel = stripeKeyResModelFromJson(jsonString);

import 'dart:convert';

StripeKeyResModel stripeKeyResModelFromJson(String str) =>
    StripeKeyResModel.fromJson(json.decode(str));

String stripeKeyResModelToJson(StripeKeyResModel data) =>
    json.encode(data.toJson());

class StripeKeyResModel {
  final String? status;
  final Data? data;

  StripeKeyResModel({
    this.status,
    this.data,
  });

  factory StripeKeyResModel.fromJson(Map<String, dynamic> json) =>
      StripeKeyResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? stripePublishableKey;

  Data({
    this.id,
    this.stripePublishableKey,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        stripePublishableKey: json["stripePublishableKey"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stripePublishableKey": stripePublishableKey,
      };
}
