// To parse this JSON data, do
//
//     final favOrNot = favOrNotFromJson(jsonString);

import 'dart:convert';

FavOrNot favOrNotFromJson(String str) => FavOrNot.fromJson(json.decode(str));

String favOrNotToJson(FavOrNot data) => json.encode(data.toJson());

class FavOrNot {
  final String? status;
  final bool? data;

  FavOrNot({
    this.status,
    this.data,
  });

  factory FavOrNot.fromJson(Map<String, dynamic> json) => FavOrNot(
        status: json["status"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data,
      };
}
