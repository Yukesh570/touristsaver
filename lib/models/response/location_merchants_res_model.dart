// To parse this JSON data, do
//
//     final locationMerchantsResModel = locationMerchantsResModelFromJson(jsonString);

import 'dart:convert';

LocationMerchantsResModel locationMerchantsResModelFromJson(String str) =>
    LocationMerchantsResModel.fromJson(json.decode(str));

String locationMerchantsResModelToJson(LocationMerchantsResModel data) =>
    json.encode(data.toJson());

class LocationMerchantsResModel {
  final String? status;
  final List<Merchant>? merchants;

  LocationMerchantsResModel({
    this.status,
    this.merchants,
  });

  factory LocationMerchantsResModel.fromJson(Map<String, dynamic> json) =>
      LocationMerchantsResModel(
        status: json["status"],
        merchants: json["merchants"] == null
            ? []
            : List<Merchant>.from(
                json["merchants"]!.map((x) => Merchant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "merchants": merchants == null
            ? []
            : List<dynamic>.from(merchants!.map((x) => x.toJson())),
      };
}

class Merchant {
  final int? xId;
  final String? xMerchantName;

  Merchant({
    this.xId,
    this.xMerchantName,
  });

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        xId: json["x_id"],
        xMerchantName: json["x_merchantName"],
      );

  Map<String, dynamic> toJson() => {
        "x_id": xId,
        "x_merchantName": xMerchantName,
      };
}
