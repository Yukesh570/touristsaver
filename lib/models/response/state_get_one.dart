// To parse this JSON data, do
//
//     final stateGetOneResModel = stateGetOneResModelFromJson(jsonString);

import 'dart:convert';

StateGetOneResModel stateGetOneResModelFromJson(String str) =>
    StateGetOneResModel.fromJson(json.decode(str));

String stateGetOneResModelToJson(StateGetOneResModel data) =>
    json.encode(data.toJson());

class StateGetOneResModel {
  StateGetOneResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory StateGetOneResModel.fromJson(Map<String, dynamic> json) =>
      StateGetOneResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.stateName,
    this.stateShortName,
    this.imageUrl,
    this.isAssignedToOwner,
    this.createdAt,
    this.countryId,
    this.country,
  });

  final int? id;
  final String? stateName;
  final String? stateShortName;
  final String? imageUrl;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final int? countryId;
  final Country? country;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        stateName: json["stateName"],
        stateShortName: json["stateShortName"],
        imageUrl: json["imageUrl"],
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stateName": stateName,
        "stateShortName": stateShortName,
        "imageUrl": imageUrl,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "__country__": country?.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.countryName,
    this.countryShortName,
    this.imageUrl,
    this.currencyName,
    this.currencySymbol,
    this.symbolIsPrefix,
    this.taxationUnitValue,
    this.isAssignedToOwner,
    this.createdAt,
  });

  final int? id;
  final String? countryName;
  final String? countryShortName;
  final String? imageUrl;
  final String? currencyName;
  final String? currencySymbol;
  final bool? symbolIsPrefix;
  final double? taxationUnitValue;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
        countryShortName: json["countryShortName"],
        imageUrl: json["imageUrl"],
        currencyName: json["currencyName"],
        currencySymbol: json["currencySymbol"],
        symbolIsPrefix: json["symbolIsPrefix"],
        taxationUnitValue: json["taxationUnitValue"]?.toDouble(),
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
        "countryShortName": countryShortName,
        "imageUrl": imageUrl,
        "currencyName": currencyName,
        "currencySymbol": currencySymbol,
        "symbolIsPrefix": symbolIsPrefix,
        "taxationUnitValue": taxationUnitValue,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
      };
}
