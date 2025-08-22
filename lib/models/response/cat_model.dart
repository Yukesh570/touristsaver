// To parse this JSON data, do
//
//     final memberCategoryResModel = memberCategoryResModelFromJson(jsonString);

import 'dart:convert';

MemberCategoryResModel memberCategoryResModelFromJson(String str) =>
    MemberCategoryResModel.fromJson(json.decode(str));

String memberCategoryResModelToJson(MemberCategoryResModel data) =>
    json.encode(data.toJson());

class MemberCategoryResModel {
  final String? status;
  final List<Datum>? data;

  MemberCategoryResModel({
    this.status,
    this.data,
  });

  factory MemberCategoryResModel.fromJson(Map<String, dynamic> json) =>
      MemberCategoryResModel(
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
  final int? id;
  final String? name;
  final int? parentId;

  Datum({
    this.id,
    this.name,
    this.parentId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        parentId: json["parentId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "parentId": parentId,
      };
}
