// To parse this JSON data, do
//
//     final confirmTopUpReqModel = confirmTopUpReqModelFromJson(jsonString);

import 'dart:convert';

ConfirmTopUpReqModel confirmTopUpReqModelFromJson(String str) =>
    ConfirmTopUpReqModel.fromJson(json.decode(str));

String confirmTopUpReqModelToJson(ConfirmTopUpReqModel data) =>
    json.encode(data.toJson());

class ConfirmTopUpReqModel {
  ConfirmTopUpReqModel({
    required this.paymentIntent,
    required this.paymentIntentClientSecret,
  });

  final String paymentIntent;
  final String paymentIntentClientSecret;

  factory ConfirmTopUpReqModel.fromJson(Map<String, dynamic> json) =>
      ConfirmTopUpReqModel(
        paymentIntent: json["payment_intent"],
        paymentIntentClientSecret: json["payment_intent_client_secret"],
      );

  Map<String, dynamic> toJson() => {
        "payment_intent": paymentIntent,
        "payment_intent_client_secret": paymentIntentClientSecret,
      };
}
