// To parse this JSON data, do
//
//     final transferPiiinksReqModel = transferPiiinksReqModelFromJson(jsonString);

import 'dart:convert';

TransferPiiinksReqModel transferPiiinksReqModelFromJson(String str) =>
    TransferPiiinksReqModel.fromJson(json.decode(str));

String transferPiiinksReqModelToJson(TransferPiiinksReqModel data) =>
    json.encode(data.toJson());

class TransferPiiinksReqModel {
  final int? merchantId;
  final double? balance;
  final String? phoneNumber;
  final String? uniqueMemberCode;

  TransferPiiinksReqModel({
    this.merchantId,
    this.balance,
    this.phoneNumber,
    this.uniqueMemberCode,
  });

  factory TransferPiiinksReqModel.fromJson(Map<String, dynamic> json) =>
      TransferPiiinksReqModel(
        merchantId: json["merchantId"],
        balance: json["balance"]?.toDouble(),
        phoneNumber: json["phoneNumber"],
        uniqueMemberCode: json["uniqueMemberCode"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
        "balance": balance,
        "phoneNumber": phoneNumber,
        "uniqueMemberCode": uniqueMemberCode,
      };
}
