// To parse this JSON data, do
//
//     final confirmApplyPiiinkReqModel = confirmApplyPiiinkReqModelFromJson(jsonString);

import 'dart:convert';

ConfirmApplyPiiinkReqModel confirmApplyPiiinkReqModelFromJson(String str) =>
    ConfirmApplyPiiinkReqModel.fromJson(json.decode(str));

String confirmApplyPiiinkReqModelToJson(ConfirmApplyPiiinkReqModel data) =>
    json.encode(data.toJson());

class ConfirmApplyPiiinkReqModel {
  ConfirmApplyPiiinkReqModel({
    required this.totalAmount,
    required this.transactionQRCode,
    required this.week,
    required this.hour,
    this.lang,
  });

  final double totalAmount;
  final String transactionQRCode;
  final int week;
  final int hour;
  final String? lang;

  factory ConfirmApplyPiiinkReqModel.fromJson(Map<String, dynamic> json) =>
      ConfirmApplyPiiinkReqModel(
        totalAmount: json["totalAmount"].toDouble(),
        transactionQRCode: json["transactionQRCode"],
        week: json["week"],
        hour: json["hour"],
        lang: json['lang'],
      );

  Map<String, dynamic> toJson() => {
        "totalAmount": totalAmount,
        "transactionQRCode": transactionQRCode,
        "week": week,
        "hour": hour,
        "lang": lang,
      };
}
