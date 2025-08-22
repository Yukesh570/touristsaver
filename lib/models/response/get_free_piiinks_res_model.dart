// To parse this JSON data, do
//
//     final getFreePiinksResModel = getFreePiinksResModelFromJson(jsonString);

import 'dart:convert';

GetFreePiinksResModel getFreePiinksResModelFromJson(String str) =>
    GetFreePiinksResModel.fromJson(json.decode(str));

String getFreePiinksResModelToJson(GetFreePiinksResModel data) =>
    json.encode(data.toJson());

class GetFreePiinksResModel {
  final String? status;
  final Data? data;

  GetFreePiinksResModel({
    this.status,
    this.data,
  });

  factory GetFreePiinksResModel.fromJson(Map<String, dynamic> json) =>
      GetFreePiinksResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  final int? id;
  final String? packageName;
  final dynamic description;
  final int? durationInDays;
  final int? universalPiiinks;
  final int? packageFee;
  final String? subscriptionType;
  final DateTime? createdAt;
  final int? countryId;
  final Country? country;

  Data({
    this.id,
    this.packageName,
    this.description,
    this.durationInDays,
    this.universalPiiinks,
    this.packageFee,
    this.subscriptionType,
    this.createdAt,
    this.countryId,
    this.country,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        packageName: json["packageName"],
        description: json["description"],
        durationInDays: json["durationInDays"],
        universalPiiinks: json["universalPiiinks"],
        packageFee: json["packageFee"],
        subscriptionType: json["subscriptionType"],
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
        "packageName": packageName,
        "description": description,
        "durationInDays": durationInDays,
        "universalPiiinks": universalPiiinks,
        "packageFee": packageFee,
        "subscriptionType": subscriptionType,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "__country__": country?.toJson(),
      };
}

class Country {
  final int? id;
  final String? countryName;
  final String? countryShortName;
  final String? imageUrl;
  final String? phonePrefix;
  final String? transactionCodePrefix;
  final String? currencyName;
  final String? currencySymbol;
  final bool? symbolIsPrefix;
  final bool? transactionIsEnabled;
  final dynamic transactionEnableDate;
  final int? taxationUnitValue;
  final bool? isPiiinkCountry;
  final bool? isActive;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final String? lang;
  final bool? langEnable;
  final String? stripeSecretKey;
  final String? stripeWebhookSecret;

  Country({
    this.id,
    this.countryName,
    this.countryShortName,
    this.imageUrl,
    this.phonePrefix,
    this.transactionCodePrefix,
    this.currencyName,
    this.currencySymbol,
    this.symbolIsPrefix,
    this.transactionIsEnabled,
    this.transactionEnableDate,
    this.taxationUnitValue,
    this.isPiiinkCountry,
    this.isActive,
    this.isAssignedToOwner,
    this.createdAt,
    this.lang,
    this.langEnable,
    this.stripeSecretKey,
    this.stripeWebhookSecret,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
        countryShortName: json["countryShortName"],
        imageUrl: json["imageUrl"],
        phonePrefix: json["phonePrefix"],
        transactionCodePrefix: json["transactionCodePrefix"],
        currencyName: json["currencyName"],
        currencySymbol: json["currencySymbol"],
        symbolIsPrefix: json["symbolIsPrefix"],
        transactionIsEnabled: json["transactionIsEnabled"],
        transactionEnableDate: json["transactionEnableDate"],
        taxationUnitValue: json["taxationUnitValue"],
        isPiiinkCountry: json["isPiiinkCountry"],
        isActive: json["isActive"],
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lang: json["lang"],
        langEnable: json["langEnable"],
        stripeSecretKey: json["stripeSecretKey"],
        stripeWebhookSecret: json["stripeWebhookSecret"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
        "countryShortName": countryShortName,
        "imageUrl": imageUrl,
        "phonePrefix": phonePrefix,
        "transactionCodePrefix": transactionCodePrefix,
        "currencyName": currencyName,
        "currencySymbol": currencySymbol,
        "symbolIsPrefix": symbolIsPrefix,
        "transactionIsEnabled": transactionIsEnabled,
        "transactionEnableDate": transactionEnableDate,
        "taxationUnitValue": taxationUnitValue,
        "isPiiinkCountry": isPiiinkCountry,
        "isActive": isActive,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
        "lang": lang,
        "langEnable": langEnable,
        "stripeSecretKey": stripeSecretKey,
        "stripeWebhookSecret": stripeWebhookSecret,
      };
}
