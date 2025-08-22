// To parse this JSON data, do
//
//     final sureApplyPiiinkReqModel = sureApplyPiiinkReqModelFromJson(jsonString);

import 'dart:convert';

String sureApplyPiiinkReqModelToJsonMainMerchant(
        SureApplyPiiinkReqModel data) =>
    json.encode(data.toJsonMainMerchant());

String sureApplyPiiinkReqModelToJsonTerminalMerchant(
        SureApplyPiiinkReqModel data) =>
    json.encode(data.toJsonTerminalMerchant());

class SureApplyPiiinkReqModel {
  SureApplyPiiinkReqModel({
    required this.totalAmount,
    required this.piiinkWalletType,
    required this.transactionQrCode,
    required this.week,
    required this.hour,
    this.terminalUserId,
    this.terminalId,
    this.lang,
  });

  final double totalAmount;
  final String piiinkWalletType;
  final String transactionQrCode;
  final int week;
  final int hour;
  final int? terminalUserId;
  final int? terminalId;
  final String? lang;

  Map<String, dynamic> toJsonMainMerchant() => {
        "totalAmount": totalAmount,
        "piiinkWalletType": piiinkWalletType,
        "transactionQRCode": transactionQrCode,
        "week": week,
        "hour": hour,
        "lang": lang,
      };

  Map<String, dynamic> toJsonTerminalMerchant() => {
        "totalAmount": totalAmount,
        "piiinkWalletType": piiinkWalletType,
        "week": week,
        "hour": hour,
        "lang": lang,
        "terminalUserId": terminalUserId,
        "terminalId": terminalId,
      };
}
