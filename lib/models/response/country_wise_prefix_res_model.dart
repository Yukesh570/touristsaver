// To parse this JSON data, do
//
//     final countryWisePrefixResModel = countryWisePrefixResModelFromJson(jsonString);

import 'dart:convert';

CountryWisePrefixResModel countryWisePrefixResModelFromJson(String str) =>
    CountryWisePrefixResModel.fromJson(json.decode(str));

String countryWisePrefixResModelToJson(CountryWisePrefixResModel data) =>
    json.encode(data.toJson());

class CountryWisePrefixResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  CountryWisePrefixResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory CountryWisePrefixResModel.fromJson(Map<String, dynamic> json) =>
      CountryWisePrefixResModel(
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
  final String? phonePrefix;
  final String? countryName;
  final dynamic logoUrl;
  final DateTime? createdAt;

  Datum({
    this.id,
    this.phonePrefix,
    this.countryName,
    this.logoUrl,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        phonePrefix: json["phonePrefix"],
        countryName: json["countryName"],
        logoUrl: json["logoUrl"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phonePrefix": phonePrefix,
        "countryName": countryName,
        "logoUrl": logoUrl,
        "createdAt": createdAt?.toIso8601String(),
      };
}
