// To parse this JSON data, do
//
//     final memberShipPackageResModel = memberShipPackageResModelFromJson(jsonString);

import 'dart:convert';

MemberShipPackageResModel memberShipPackageResModelFromJson(String str) =>
    MemberShipPackageResModel.fromJson(json.decode(str));

String memberShipPackageResModelToJson(MemberShipPackageResModel data) =>
    json.encode(data.toJson());

class MemberShipPackageResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  MemberShipPackageResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory MemberShipPackageResModel.fromJson(Map<String, dynamic> json) =>
      MemberShipPackageResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  final int? id;
  final String? packageName;
  final dynamic description;
  final int? durationInDays;
  final double? universalPiiinks;
  final double? packageFee;
  final String? subscriptionType;
  final String? marketingType;
  final String? packageCurrencyName;
  final String? packageCurrencySymbol;
  final String? boxBackgroundImageUrl;
  final String? boxTextColor;
  final String? boxBackgroundColor;
  final String? boxBorderColor;
  final String? buttonColor;
  final String? buttonTextColor;
  final String? amountTextColor;
  final int? order;
  final bool? displayOnApp;
  final DateTime? createdAt;
  final int? countryId;
  final Country? country;

  Datum({
    this.id,
    this.packageName,
    this.description,
    this.durationInDays,
    this.universalPiiinks,
    this.packageFee,
    this.subscriptionType,
    this.marketingType,
    this.packageCurrencyName,
    this.packageCurrencySymbol,
    this.boxBackgroundImageUrl,
    this.boxTextColor,
    this.boxBackgroundColor,
    this.boxBorderColor,
    this.buttonColor,
    this.buttonTextColor,
    this.amountTextColor,
    this.order,
    this.displayOnApp,
    this.createdAt,
    this.countryId,
    this.country,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        packageName: json["packageName"],
        description: json["description"],
        durationInDays: json["durationInDays"],
        universalPiiinks: json["universalPiiinks"]?.toDouble(),
        packageFee: json["packageFee"]?.toDouble(),
        subscriptionType: json["subscriptionType"],
        marketingType: json["marketingType"],
        packageCurrencyName: json["packageCurrencyName"],
        packageCurrencySymbol: json["packageCurrencySymbol"],
        boxBackgroundImageUrl: json["boxBackgroundImageUrl"],
        boxTextColor: json["boxTextColor"],
        boxBackgroundColor: json["boxBackgroundColor"],
        boxBorderColor: json["boxBorderColor"],
        buttonColor: json["buttonColor"],
        buttonTextColor: json["buttonTextColor"],
        amountTextColor: json["amountTextColor"],
        order: json["order"],
        displayOnApp: json["displayOnApp"],
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
        "marketingType": marketingType,
        "packageCurrencyName": packageCurrencyName,
        "packageCurrencySymbol": packageCurrencySymbol,
        "boxBackgroundImageUrl": boxBackgroundImageUrl,
        "boxTextColor": boxTextColor,
        "boxBackgroundColor": boxBackgroundColor,
        "boxBorderColor": boxBorderColor,
        "buttonColor": buttonColor,
        "buttonTextColor": buttonTextColor,
        "amountTextColor": amountTextColor,
        "order": order,
        "displayOnApp": displayOnApp,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "__country__": country?.toJson(),
      };
}

class Country {
  final int? id;
  final String? countryName;
  final String? phonePrefix;
  final String? currencySymbol;

  Country({
    this.id,
    this.countryName,
    this.phonePrefix,
    this.currencySymbol,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
        phonePrefix: json["phonePrefix"],
        currencySymbol: json["currencySymbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
        "phonePrefix": phonePrefix,
        "currencySymbol": currencySymbol,
      };
}
