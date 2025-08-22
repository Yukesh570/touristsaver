// To parse this JSON data, do
//
//     final subCategoryListResModel = subCategoryListResModelFromJson(jsonString);

import 'dart:convert';

SubCategoryListResModel subCategoryListResModelFromJson(String str) =>
    SubCategoryListResModel.fromJson(json.decode(str));

String subCategoryListResModelToJson(SubCategoryListResModel data) =>
    json.encode(data.toJson());

class SubCategoryListResModel {
  SubCategoryListResModel({
    this.status,
    this.data,
  });

  final String? status;
  final List<Datum>? data;

  factory SubCategoryListResModel.fromJson(Map<String, dynamic> json) =>
      SubCategoryListResModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.imageName,
    this.slug,
    this.priorityOrder,
    this.isVisibleOnApp,
    this.createdAt,
    this.parentId,
  });

  final int? id;
  final String? name;
  final String? imageName;
  final String? slug;
  final int? priorityOrder;
  final bool? isVisibleOnApp;
  final DateTime? createdAt;
  final int? parentId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        imageName: json["imageName"],
        slug: json["slug"],
        priorityOrder: json["priorityOrder"],
        isVisibleOnApp: json["isVisibleOnApp"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        parentId: json["parentId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageName": imageName,
        "slug": slug,
        "priorityOrder": priorityOrder,
        "isVisibleOnApp": isVisibleOnApp,
        "createdAt": createdAt?.toIso8601String(),
        "parentId": parentId,
      };
}
