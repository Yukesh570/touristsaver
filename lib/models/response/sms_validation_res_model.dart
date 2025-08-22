// To parse this JSON data, do
//
//     final smsValidationModel = smsValidationModelFromJson(jsonString);

import 'dart:convert';

SmsValidationModel smsValidationModelFromJson(String str) =>
    SmsValidationModel.fromJson(json.decode(str));

String smsValidationModelToJson(SmsValidationModel data) =>
    json.encode(data.toJson());

class SmsValidationModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  SmsValidationModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory SmsValidationModel.fromJson(Map<String, dynamic> json) =>
      SmsValidationModel(
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
  final String? medium;
  final String? mediumDisplayName;
  final bool? displayOnApp;
  final int? order;
  final DateTime? createdAt;

  Datum({
    this.id,
    this.medium,
    this.mediumDisplayName,
    this.displayOnApp,
    this.order,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        medium: json["medium"],
        mediumDisplayName: json["mediumDisplayName"],
        displayOnApp: json["displayOnApp"],
        order: json["order"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "medium": medium,
        "mediumDisplayName": mediumDisplayName,
        "displayOnApp": displayOnApp,
        "order": order,
        "createdAt": createdAt?.toIso8601String(),
      };
}
