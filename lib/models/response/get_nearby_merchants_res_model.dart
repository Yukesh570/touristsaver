// To parse this JSON data, do
//
//     final getNearByMerchantsResModel = getNearByMerchantsResModelFromJson(jsonString);

import 'dart:convert';

GetNearByMerchantsResModel getNearByMerchantsResModelFromJson(String str) =>
    GetNearByMerchantsResModel.fromJson(json.decode(str));

String getNearByMerchantsResModelToJson(GetNearByMerchantsResModel data) =>
    json.encode(data.toJson());

class GetNearByMerchantsResModel {
  final String? status;
  final List<Datum>? data;

  GetNearByMerchantsResModel({
    this.status,
    this.data,
  });

  factory GetNearByMerchantsResModel.fromJson(Map<String, dynamic> json) =>
      GetNearByMerchantsResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  final int? merchantImageInfoId;
  final String? merchantImageInfoLogoUrl;
  final String? merchantImageInfoSlider1;
  final String? merchantImageInfoSlider2;
  final String? merchantImageInfoSlider3;
  final String? merchantImageInfoSlider4;
  final String? merchantImageInfoSlider5;
  final String? merchantImageInfoSlider6;
  final DateTime? merchantImageInfoCreatedAt;
  final int? merchantImageInfoMerchantId;
  final String? merchantname;
  final int? id;
  final String? maxdiscount;
  final dynamic favoritemerchant;
  final double? distance;
  final double? latitude;
  final double? longitude;

  Datum({
    this.merchantImageInfoId,
    this.merchantImageInfoLogoUrl,
    this.merchantImageInfoSlider1,
    this.merchantImageInfoSlider2,
    this.merchantImageInfoSlider3,
    this.merchantImageInfoSlider4,
    this.merchantImageInfoSlider5,
    this.merchantImageInfoSlider6,
    this.merchantImageInfoCreatedAt,
    this.merchantImageInfoMerchantId,
    this.merchantname,
    this.id,
    this.maxdiscount,
    this.favoritemerchant,
    this.distance,
    this.latitude,
    this.longitude,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        merchantImageInfoId: json["merchantImageInfo_id"],
        merchantImageInfoLogoUrl: json["merchantImageInfo_logoUrl"],
        merchantImageInfoSlider1: json["merchantImageInfo_slider1"],
        merchantImageInfoSlider2: json["merchantImageInfo_slider2"],
        merchantImageInfoSlider3: json["merchantImageInfo_slider3"],
        merchantImageInfoSlider4: json["merchantImageInfo_slider4"],
        merchantImageInfoSlider5: json["merchantImageInfo_slider5"],
        merchantImageInfoSlider6: json["merchantImageInfo_slider6"],
        merchantImageInfoCreatedAt: json["merchantImageInfo_createdAt"] == null
            ? null
            : DateTime.parse(json["merchantImageInfo_createdAt"]),
        merchantImageInfoMerchantId: json["merchantImageInfo_merchantId"],
        merchantname: json["merchantname"],
        id: json["id"],
        maxdiscount: json["maxdiscount"],
        favoritemerchant: json["favoritemerchant"],
        distance: json["distance"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "merchantImageInfo_id": merchantImageInfoId,
        "merchantImageInfo_logoUrl": merchantImageInfoLogoUrl,
        "merchantImageInfo_slider1": merchantImageInfoSlider1,
        "merchantImageInfo_slider2": merchantImageInfoSlider2,
        "merchantImageInfo_slider3": merchantImageInfoSlider3,
        "merchantImageInfo_slider4": merchantImageInfoSlider4,
        "merchantImageInfo_slider5": merchantImageInfoSlider5,
        "merchantImageInfo_slider6": merchantImageInfoSlider6,
        "merchantImageInfo_createdAt":
            merchantImageInfoCreatedAt?.toIso8601String(),
        "merchantImageInfo_merchantId": merchantImageInfoMerchantId,
        "merchantname": merchantname,
        "id": id,
        "maxdiscount": maxdiscount,
        "favoritemerchant": favoritemerchant,
        "distance": distance,
        "latitude": latitude,
        "longitude": longitude,
      };
}
