import 'dart:convert';

GetLangResModel getLangResModelFromJson(String str) =>
    GetLangResModel.fromJson(json.decode(str));

class GetLangResModel {
  final String? status;
  final List<Datum>? data;

  GetLangResModel({
    this.status,
    this.data,
  });

  factory GetLangResModel.fromJson(Map<String, dynamic> json) =>
      GetLangResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  final int? id;
  final String? countryName;
  final String? imageUrl;
  final String? lang;
  final bool? langEnable;

  Datum({
    this.id,
    this.countryName,
    this.imageUrl,
    this.lang,
    this.langEnable,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        countryName: json["countryName"],
        imageUrl: json["imageUrl"],
        lang: json["lang"],
        langEnable: json["langEnable"],
      );
}
