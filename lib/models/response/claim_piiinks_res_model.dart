// To parse this JSON data, do
//
//     final claimPiiinksResModel = claimPiiinksResModelFromJson(jsonString);

import 'dart:convert';

ClaimPiiinksResModel claimPiiinksResModelFromJson(String str) =>
    ClaimPiiinksResModel.fromJson(json.decode(str));

String claimPiiinksResModelToJson(ClaimPiiinksResModel data) =>
    json.encode(data.toJson());

class ClaimPiiinksResModel {
  final String? status;
  final int? universalPiiinks;

  ClaimPiiinksResModel({
    this.status,
    this.universalPiiinks,
  });

  factory ClaimPiiinksResModel.fromJson(Map<String, dynamic> json) =>
      ClaimPiiinksResModel(
        status: json["status"],
        universalPiiinks: json["universalPiiinks"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "universalPiiinks": universalPiiinks,
      };
}
