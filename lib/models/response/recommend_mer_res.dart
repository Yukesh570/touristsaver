// To parse this JSON data, do
//
//     final recommendMerchantResModel = recommendMerchantResModelFromJson(jsonString);

import 'dart:convert';

RecommendMerchantResModel recommendMerchantResModelFromJson(String str) =>
    RecommendMerchantResModel.fromJson(json.decode(str));

String recommendMerchantResModelToJson(RecommendMerchantResModel data) =>
    json.encode(data.toJson());

class RecommendMerchantResModel {
  final String? status;
  final List<Datum>? data;

  RecommendMerchantResModel({
    this.status,
    this.data,
  });

  factory RecommendMerchantResModel.fromJson(Map<String, dynamic> json) =>
      RecommendMerchantResModel(
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
  final bool? isTransferred;
  final String? transferRequestRejectReason;
  final bool? isApproved;
  final bool? isRejected;
  final String? rejectReason;
  final bool? isVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.isTransferred,
    this.transferRequestRejectReason,
    this.isApproved,
    this.isRejected,
    this.rejectReason,
    this.isVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        isTransferred: json["isTransferred"],
        transferRequestRejectReason: json["transferRequestRejectReason"],
        isApproved: json["isApproved"],
        isRejected: json["isRejected"],
        rejectReason: json["rejectReason"],
        isVerified: json["isVerified"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isTransferred": isTransferred,
        "transferRequestRejectReason": transferRequestRejectReason,
        "isApproved": isApproved,
        "isRejected": isRejected,
        "rejectReason": rejectReason,
        "isVerified": isVerified,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
