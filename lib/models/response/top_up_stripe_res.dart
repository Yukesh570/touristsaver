// To parse this JSON data, do
//
//     final topUpResModel = topUpResModelFromJson(jsonString);

import 'dart:convert';

TopUpStripeResModel topUpStripeResModelFromJson(String str) =>
    TopUpStripeResModel.fromJson(json.decode(str));

String topUpStripeResModelToJson(TopUpStripeResModel data) =>
    json.encode(data.toJson());

class TopUpStripeResModel {
  TopUpStripeResModel({
    this.clientSecret,
  });

  final String? clientSecret;

  factory TopUpStripeResModel.fromJson(Map<String, dynamic> json) =>
      TopUpStripeResModel(
        clientSecret: json["clientSecret"],
      );

  Map<String, dynamic> toJson() => {
        "clientSecret": clientSecret,
      };
}
