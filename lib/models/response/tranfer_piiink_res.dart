// To parse this JSON data, do
//
//     final transferPiiinkResModel = transferPiiinkResModelFromJson(jsonString);

import 'dart:convert';

TransferPiiinkResModel transferPiiinkResModelFromJson(String str) =>
    TransferPiiinkResModel.fromJson(json.decode(str));

String transferPiiinkResModelToJson(TransferPiiinkResModel data) =>
    json.encode(data.toJson());

class TransferPiiinkResModel {
  TransferPiiinkResModel({
    this.status,
  });

  final String? status;

  factory TransferPiiinkResModel.fromJson(Map<String, dynamic> json) =>
      TransferPiiinkResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
