// To parse this JSON data, do
//
//     final sureApplyPiiinkResModel = sureApplyPiiinkResModelFromJson(jsonString);

import 'dart:convert';

SureApplyPiiinkResModel sureApplyPiiinkResModelFromJson(String str) =>
    SureApplyPiiinkResModel.fromJson(json.decode(str));

String sureApplyPiiinkResModelToJson(SureApplyPiiinkResModel data) =>
    json.encode(data.toJson());

class SureApplyPiiinkResModel {
  SureApplyPiiinkResModel({
    required this.status,
  });

  final String status;

  factory SureApplyPiiinkResModel.fromJson(Map<String, dynamic> json) =>
      SureApplyPiiinkResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
