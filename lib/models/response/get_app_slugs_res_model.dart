// To parse this JSON data, do
//
//     final getAppSlugResModel = getAppSlugResModelFromJson(jsonString);

import 'dart:convert';

GetAppSlugResModel getAppSlugResModelFromJson(String str) =>
    GetAppSlugResModel.fromJson(json.decode(str));

String getAppSlugResModelToJson(GetAppSlugResModel data) =>
    json.encode(data.toJson());

class GetAppSlugResModel {
  final String? status;
  final Data? data;

  GetAppSlugResModel({
    this.status,
    this.data,
  });

  factory GetAppSlugResModel.fromJson(Map<String, dynamic> json) =>
      GetAppSlugResModel(
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
  final String? information;
  final String? slug;

  Data({
    this.id,
    this.information,
    this.slug,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        information: json["information"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "information": information,
        "slug": slug,
      };
}
