// To parse this JSON data, do
//
//     final selectCharityReqModel = selectCharityReqModelFromJson(jsonString);

import 'dart:convert';

SelectCharityReqModel selectCharityReqModelFromJson(String str) =>
    SelectCharityReqModel.fromJson(json.decode(str));

String selectCharityReqModelToJson(SelectCharityReqModel data) =>
    json.encode(data.toJson());

class SelectCharityReqModel {
  SelectCharityReqModel({
    this.charityId,
  });

  final int? charityId;

  factory SelectCharityReqModel.fromJson(Map<String, dynamic> json) =>
      SelectCharityReqModel(
        charityId: json["charityId"],
      );

  Map<String, dynamic> toJson() => {
        "charityId": charityId,
      };
}
