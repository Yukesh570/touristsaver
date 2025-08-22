// To parse this JSON data, do
//
//     final postalCodeGetAllResModel = postalCodeGetAllResModelFromJson(jsonString);

import 'dart:convert';

PostalCodeGetAllResModel postalCodeGetAllResModelFromJson(String str) =>
    PostalCodeGetAllResModel.fromJson(json.decode(str));

String postalCodeGetAllResModelToJson(PostalCodeGetAllResModel data) =>
    json.encode(data.toJson());

class PostalCodeGetAllResModel {
  PostalCodeGetAllResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  factory PostalCodeGetAllResModel.fromJson(Map<String, dynamic> json) =>
      PostalCodeGetAllResModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  Datum({
    this.id,
    this.code,
    this.createdById,
    this.lastUpdatedById,
    this.countryId,
    this.regionId,
    this.stateId,
    this.areaId,
  });

  final int? id;
  final String? code;
  final int? createdById;
  final int? lastUpdatedById;
  final int? countryId;
  final int? regionId;
  final int? stateId;
  final int? areaId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        code: json["code"],
        createdById: json["createdById"],
        lastUpdatedById: json["lastUpdatedById"],
        countryId: json["countryId"],
        regionId: json["regionId"],
        stateId: json["stateId"],
        areaId: json["areaId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "createdById": createdById,
        "lastUpdatedById": lastUpdatedById,
        "countryId": countryId,
        "regionId": regionId,
        "stateId": stateId,
        "areaId": areaId,
      };
}
