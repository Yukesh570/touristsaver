// To parse this JSON data, do
//
//     final membershipGetOneForFreeByMember = membershipGetOneForFreeByMemberFromJson(jsonString);

import 'dart:convert';

MembershipGetOneForFreeByMember membershipGetOneForFreeByMemberFromJson(
        String str) =>
    MembershipGetOneForFreeByMember.fromJson(json.decode(str));

String membershipGetOneForFreeByMemberToJson(
        MembershipGetOneForFreeByMember data) =>
    json.encode(data.toJson());

class MembershipGetOneForFreeByMember {
  final String? status;
  final Data? data;

  MembershipGetOneForFreeByMember({
    this.status,
    this.data,
  });

  factory MembershipGetOneForFreeByMember.fromJson(Map<String, dynamic> json) =>
      MembershipGetOneForFreeByMember(
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
  final double? universalPiiinks;
  final double? packageFee;
  final String? subscriptionType;
  final String? marketingType;
  final String? packageCurrencyName;
  final dynamic packageCurrencySymbol;
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

  Data({
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
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
      };
}
