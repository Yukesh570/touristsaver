// To parse this JSON data, do
//
//     final markFavouriteReqModel = markFavouriteReqModelFromJson(jsonString);

import 'dart:convert';

MarkFavouriteReqModel markFavouriteReqModelFromJson(String str) =>
    MarkFavouriteReqModel.fromJson(json.decode(str));

String markFavouriteReqModelToJson(MarkFavouriteReqModel data) =>
    json.encode(data.toJson());

class MarkFavouriteReqModel {
  final int? merchantId;

  MarkFavouriteReqModel({
    this.merchantId,
  });

  factory MarkFavouriteReqModel.fromJson(Map<String, dynamic> json) =>
      MarkFavouriteReqModel(
        merchantId: json["merchantId"],
      );

  Map<String, dynamic> toJson() => {
        "merchantId": merchantId,
      };
}
