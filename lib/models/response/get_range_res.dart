// To parse this JSON data, do
//
//     final getNearByRangeResModel = getNearByRangeResModelFromJson(jsonString);

import 'dart:convert';

GetNearByRangeResModel getNearByRangeResModelFromJson(String str) =>
    GetNearByRangeResModel.fromJson(json.decode(str));

String getNearByRangeResModelToJson(GetNearByRangeResModel data) =>
    json.encode(data.toJson());

class GetNearByRangeResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  GetNearByRangeResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory GetNearByRangeResModel.fromJson(Map<String, dynamic> json) =>
      GetNearByRangeResModel(
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
  final int? distanceRange;
  final String? rangeUnitType;
  final int? countryId;
  final DateTime? createdAt;
  final Country? country;

  Datum({
    this.id,
    this.distanceRange,
    this.rangeUnitType,
    this.countryId,
    this.createdAt,
    this.country,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        distanceRange: json["distanceRange"],
        rangeUnitType: json["rangeUnitType"],
        countryId: json["countryId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "distanceRange": distanceRange,
        "rangeUnitType": rangeUnitType,
        "countryId": countryId,
        "createdAt": createdAt?.toIso8601String(),
        "__country__": country?.toJson(),
      };
}

class Country {
  final String? countryName;

  Country({
    this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryName: json["countryName"],
      );

  Map<String, dynamic> toJson() => {
        "countryName": countryName,
      };
}
