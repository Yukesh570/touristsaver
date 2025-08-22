// To parse this JSON data, do
//
//     final appVersionLogModel = appVersionLogModelFromJson(jsonString);

import 'dart:convert';

AppVersionLogModel appVersionLogModelFromJson(String str) =>
    AppVersionLogModel.fromJson(json.decode(str));

String appVersionLogModelToJson(AppVersionLogModel data) =>
    json.encode(data.toJson());

class AppVersionLogModel {
  final String? status;
  final List<Datum>? data;

  AppVersionLogModel({
    this.status,
    this.data,
  });

  factory AppVersionLogModel.fromJson(Map<String, dynamic> json) =>
      AppVersionLogModel(
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
  final String? appStoreType;
  final String? version;
  final String? storeLink;
  final String? featureList;
  final bool? forceUpdate;
  final DateTime? createdAt;

  Datum({
    this.id,
    this.appStoreType,
    this.version,
    this.storeLink,
    this.featureList,
    this.forceUpdate,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        appStoreType: json["appStoreType"],
        version: json["version"],
        storeLink: json["storeLink"],
        featureList: json["featureList"],
        forceUpdate: json["forceUpdate"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "appStoreType": appStoreType,
        "version": version,
        "storeLink": storeLink,
        "featureList": featureList,
        "forceUpdate": forceUpdate,
        "createdAt": createdAt?.toIso8601String(),
      };
}
