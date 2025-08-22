// To parse this JSON data, do
//
//     final categoryByParentId = categoryByParentIdFromJson(jsonString);

import 'dart:convert';

CategoryByParentId categoryByParentIdFromJson(String str) =>
    CategoryByParentId.fromJson(json.decode(str));

String categoryByParentIdToJson(CategoryByParentId data) =>
    json.encode(data.toJson());

class CategoryByParentId {
  final String? status;
  final Data? data;

  CategoryByParentId({
    this.status,
    this.data,
  });

  factory CategoryByParentId.fromJson(Map<String, dynamic> json) =>
      CategoryByParentId(
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
  final String? name;
  final String? imageName;
  final String? slug;
  final int? priorityOrder;
  final bool? isVisibleOnApp;
  final int? subCategoryLevel;
  final DateTime? createdAt;
  final dynamic parentId;

  Data({
    this.id,
    this.name,
    this.imageName,
    this.slug,
    this.priorityOrder,
    this.isVisibleOnApp,
    this.subCategoryLevel,
    this.createdAt,
    this.parentId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        imageName: json["imageName"],
        slug: json["slug"],
        priorityOrder: json["priorityOrder"],
        isVisibleOnApp: json["isVisibleOnApp"],
        subCategoryLevel: json["subCategoryLevel"],
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
        "subCategoryLevel": subCategoryLevel,
        "createdAt": createdAt?.toIso8601String(),
        "parentId": parentId,
      };
}
