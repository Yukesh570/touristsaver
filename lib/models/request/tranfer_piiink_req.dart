// To parse this JSON data, do
//
//     final transferPiiinkReqModel = transferPiiinkReqModelFromJson(jsonString);

import 'dart:convert';

TransferPiiinkReqModel transferPiiinkReqModelFromJson(String str) =>
    TransferPiiinkReqModel.fromJson(json.decode(str));

String transferPiiinkReqModelToJson(TransferPiiinkReqModel data) =>
    json.encode(data.toJson());

class TransferPiiinkReqModel {
  TransferPiiinkReqModel({
    this.merchantId,
    this.balance,
    this.phonePrefix,
    this.phoneNumber,
  });

  final int? merchantId;
  final double? balance;
  final String? phonePrefix;
  final String? phoneNumber;

  factory TransferPiiinkReqModel.fromJson(Map<String, dynamic> json) =>
      TransferPiiinkReqModel(
        merchantId: json["merchantId"],
        balance: json["balance"].toDouble(),
        phonePrefix: json["phonePrefix"],
        phoneNumber: json["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "balance": balance,
        "phonePrefix": phonePrefix,
        "phoneNumber": phoneNumber,
      };
}
