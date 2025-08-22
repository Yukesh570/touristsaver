// To parse this JSON data, do
//
//     final memFreePackageResModel = memFreePackageResModelFromJson(jsonString);

import 'dart:convert';

MemFreePackageResModel memFreePackageResModelFromJson(String str) =>
    MemFreePackageResModel.fromJson(json.decode(str));

String memFreePackageResModelToJson(MemFreePackageResModel data) =>
    json.encode(data.toJson());

class MemFreePackageResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  MemFreePackageResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory MemFreePackageResModel.fromJson(Map<String, dynamic> json) =>
      MemFreePackageResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  final int? id;
  final String? packageName;
  final String? description;
  final int? durationInDays;
  final int? universalPiiinks;
  final int? packageFee;
  final String? subscriptionType;
  final DateTime? createdAt;
  final int? countryId;
  final Country? country;

  Datum({
    this.id,
    this.packageName,
    this.description,
    this.durationInDays,
    this.universalPiiinks,
    this.packageFee,
    this.subscriptionType,
    this.createdAt,
    this.countryId,
    this.country,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        packageName: json["packageName"],
        description: json["description"],
        durationInDays: json["durationInDays"],
        universalPiiinks: json["universalPiiinks"],
        packageFee: json["packageFee"],
        subscriptionType: json["subscriptionType"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "packageName": packageName,
        "description": description,
        "durationInDays": durationInDays,
        "universalPiiinks": universalPiiinks,
        "packageFee": packageFee,
        "subscriptionType": subscriptionType,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "__country__": country?.toJson(),
      };
}

class Country {
  final int? id;
  final String? countryName;
  final String? phonePrefix;
  final String? currencySymbol;

  Country({
    this.id,
    this.countryName,
    this.phonePrefix,
    this.currencySymbol,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
        phonePrefix: json["phonePrefix"],
        currencySymbol: json["currencySymbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
        "phonePrefix": phonePrefix,
        "currencySymbol": currencySymbol,
      };
}
