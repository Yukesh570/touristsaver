// To parse this JSON data, do
//
//     final isPayEnableResModel = isPayEnableResModelFromJson(jsonString);

import 'dart:convert';

IsPayEnableResModel isPayEnableResModelFromJson(String str) =>
    IsPayEnableResModel.fromJson(json.decode(str));

String isPayEnableResModelToJson(IsPayEnableResModel data) =>
    json.encode(data.toJson());

class IsPayEnableResModel {
  IsPayEnableResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory IsPayEnableResModel.fromJson(Map<String, dynamic> json) =>
      IsPayEnableResModel(
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
    this.countryName,
    this.countryShortName,
    this.imageUrl,
    this.phonePrefix,
    this.currencyName,
    this.currencySymbol,
    this.symbolIsPrefix,
    this.transactionIsEnabled,
    this.transactionEnableDate,
    this.taxationUnitValue,
    this.isPiiinkCountry,
    this.isAssignedToOwner,
    this.createdAt,
  });

  final int? id;
  final String? countryName;
  final String? countryShortName;
  final dynamic imageUrl;
  final String? phonePrefix;
  final String? currencyName;
  final String? currencySymbol;
  final bool? symbolIsPrefix;
  final bool? transactionIsEnabled;
  final DateTime? transactionEnableDate;
  final double? taxationUnitValue;
  final bool? isPiiinkCountry;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        countryName: json["countryName"],
        countryShortName: json["countryShortName"],
        imageUrl: json["imageUrl"],
        phonePrefix: json["phonePrefix"],
        currencyName: json["currencyName"],
        currencySymbol: json["currencySymbol"],
        symbolIsPrefix: json["symbolIsPrefix"],
        transactionIsEnabled: json["transactionIsEnabled"],
        transactionEnableDate: json["transactionEnableDate"] == null
            ? null
            : DateTime.parse(json["transactionEnableDate"]),
        taxationUnitValue: json["taxationUnitValue"]?.toDouble(),
        isPiiinkCountry: json["isPiiinkCountry"],
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
        "phonePrefix": phonePrefix,
        "currencyName": currencyName,
        "currencySymbol": currencySymbol,
        "symbolIsPrefix": symbolIsPrefix,
        "transactionIsEnabled": transactionIsEnabled,
        "transactionEnableDate": transactionEnableDate?.toIso8601String(),
        "taxationUnitValue": taxationUnitValue,
        "isPiiinkCountry": isPiiinkCountry,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
      };
}
