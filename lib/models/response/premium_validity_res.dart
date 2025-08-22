import 'dart:convert';

PremiumValidityResModel premiumValidityResModelFromJson(String str) =>
    PremiumValidityResModel.fromJson(json.decode(str));

String premiumValidityResModelToJson(PremiumValidityResModel data) =>
    json.encode(data.toJson());

class PremiumValidityResModel {
  PremiumValidityResModel({
    this.status,
  });

  final String? status;

  factory PremiumValidityResModel.fromJson(Map<String, dynamic> json) =>
      PremiumValidityResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
