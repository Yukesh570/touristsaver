import 'dart:convert';

part 'category_list_res.g.dart';

CategoryListResModel categoryListResModelFromJson(String str) =>
    CategoryListResModel.fromJson(json.decode(str));

String categoryListResModelToJson(CategoryListResModel data) =>
    json.encode(data.toJson());

class CategoryListResModel {
  final String? status;
  final Data? data;

  CategoryListResModel({
    this.status,
    this.data,
  });

  factory CategoryListResModel.fromJson(Map<String, dynamic> json) =>
      CategoryListResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  Data({
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
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
  final String? name;
  final String? imageName;
  final String? slug;
  final int? priorityOrder;
  final bool? isVisibleOnApp;
  final int? subCategoryLevel;
  final DateTime? createdAt;
  final int? parentId;
  final List<Datum>? children;

  Datum({
    this.id,
    this.name,
    this.imageName,
    this.slug,
    this.priorityOrder,
    this.isVisibleOnApp,
    this.subCategoryLevel,
    this.createdAt,
    this.parentId,
    this.children,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        children: json["__children__"] == null
            ? []
            : List<Datum>.from(
                json["__children__"]!.map((x) => Datum.fromJson(x))),
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
        "__children__": children == null
            ? []
            : List<dynamic>.from(children!.map((x) => x.toJson())),
      };
}

// CategoryListResModel categoryListResModelFromJson(String str) =>
//     CategoryListResModel.fromJson(json.decode(str));

// String categoryListResModelToJson(CategoryListResModel data) =>
//     json.encode(data.toJson());

// @JsonSerializable()
// class CategoryListResModel {
//   CategoryListResModel({
//     this.status,
//     this.data,
//   });

//   final String? status;
//   final Data? data;

//   factory CategoryListResModel.fromJson(Map<String, dynamic> json) =>
//       _$CategoryListResModelFromJson(json);

//   Map<String, dynamic> toJson() => _$CategoryListResModelToJson(this);
// }

// @JsonSerializable()
// class Data {
//   Data({
//     this.data,
//     this.hasMore,
//     this.count,
//     this.totalCount,
//     this.page,
//   });

//   final List<Datum>? data;
//   final bool? hasMore;
//   final int? count;
//   final int? totalCount;
//   final int? page;

//   factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

//   Map<String, dynamic> toJson() => _$DataToJson(this);
// }

// @JsonSerializable()
// class Datum {
//   Datum({
//     this.id,
//     this.name,
//     this.imageName,
//     this.slug,
//     this.priorityOrder,
//     this.isVisibleOnApp,
//     this.createdAt,
//     this.parentId,
//   });

//   final int? id;
//   final String? name;
//   final String? imageName;
//   final String? slug;
//   final int? priorityOrder;
//   final bool? isVisibleOnApp;
//   final DateTime? createdAt;
//   final dynamic parentId;

//   factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

//   Map<String, dynamic> toJson() => _$DatumToJson(this);
// }
