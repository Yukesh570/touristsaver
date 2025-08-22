// To parse this JSON data, do
//
//     final premiumCodeTopUpHistory = premiumCodeTopUpHistoryFromJson(jsonString);

import 'dart:convert';

PremiumCodeTopUpHistory premiumCodeTopUpHistoryFromJson(String str) =>
    PremiumCodeTopUpHistory.fromJson(json.decode(str));

String premiumCodeTopUpHistoryToJson(PremiumCodeTopUpHistory data) =>
    json.encode(data.toJson());

class PremiumCodeTopUpHistory {
  final String? status;
  final Map<String, List<Datum>>? data;

  PremiumCodeTopUpHistory({
    this.status,
    this.data,
  });

  factory PremiumCodeTopUpHistory.fromJson(Map<String, dynamic> json) =>
      PremiumCodeTopUpHistory(
        status: json["status"],
        data: Map.from(json["data"]!).map((k, v) =>
            MapEntry<String, List<Datum>>(
                k, List<Datum>.from(v.map((x) => Datum.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class Datum {
  final int? id;
  final int? codeOwnerId;
  final String? codeOwnerType;
  final String? memberPremiumCode;
  final bool? isApplied;
  final DateTime? appliedDate;
  final DateTime? expiryDate;
  final DateTime? applyIntentExpiryDate;
  final bool? isGiveaway;
  final int? piiinksProvided;
  final String? generateType;
  final DateTime? createdAt;
  final DateTime? assignedDate;
  final int? membershipPackageId;
  final int? memberId;
  final int? countryId;
  final int? collaborationPackageId;
  final int? merchantPackageId;
  final MembershipPackage? membershipPackage;

  Datum({
    this.id,
    this.codeOwnerId,
    this.codeOwnerType,
    this.memberPremiumCode,
    this.isApplied,
    this.appliedDate,
    this.expiryDate,
    this.applyIntentExpiryDate,
    this.isGiveaway,
    this.piiinksProvided,
    this.generateType,
    this.createdAt,
    this.assignedDate,
    this.membershipPackageId,
    this.memberId,
    this.countryId,
    this.collaborationPackageId,
    this.merchantPackageId,
    this.membershipPackage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        codeOwnerId: json["codeOwnerId"],
        codeOwnerType: json["codeOwnerType"],
        memberPremiumCode: json["memberPremiumCode"],
        isApplied: json["isApplied"],
        appliedDate: json["appliedDate"] == null
            ? null
            : DateTime.parse(json["appliedDate"]),
        expiryDate: json["expiryDate"] == null
            ? null
            : DateTime.parse(json["expiryDate"]),
        applyIntentExpiryDate: json["applyIntentExpiryDate"] == null
            ? null
            : DateTime.parse(json["applyIntentExpiryDate"]),
        isGiveaway: json["isGiveaway"],
        piiinksProvided: json["piiinksProvided"],
        generateType: json["generateType"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        assignedDate: json["assignedDate"] == null
            ? null
            : DateTime.parse(json["assignedDate"]),
        membershipPackageId: json["membershipPackageId"],
        memberId: json["memberId"],
        countryId: json["countryId"],
        collaborationPackageId: json["collaborationPackageId"],
        merchantPackageId: json["merchantPackageId"],
        membershipPackage: json["__membershipPackage__"] == null
            ? null
            : MembershipPackage.fromJson(json["__membershipPackage__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codeOwnerId": codeOwnerId,
        "codeOwnerType": codeOwnerType,
        "memberPremiumCode": memberPremiumCode,
        "isApplied": isApplied,
        "appliedDate": appliedDate?.toIso8601String(),
        "expiryDate": expiryDate?.toIso8601String(),
        "applyIntentExpiryDate": applyIntentExpiryDate?.toIso8601String(),
        "isGiveaway": isGiveaway,
        "piiinksProvided": piiinksProvided,
        "generateType": generateType,
        "createdAt": createdAt?.toIso8601String(),
        "assignedDate": assignedDate?.toIso8601String(),
        "membershipPackageId": membershipPackageId,
        "memberId": memberId,
        "countryId": countryId,
        "collaborationPackageId": collaborationPackageId,
        "merchantPackageId": merchantPackageId,
        "__membershipPackage__": membershipPackage?.toJson(),
      };
}

class MembershipPackage {
  final int? id;
  final String? packageName;
  final dynamic description;
  final int? durationInDays;
  final int? universalPiiinks;
  final int? packageFee;
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

  MembershipPackage({
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

  factory MembershipPackage.fromJson(Map<String, dynamic> json) =>
      MembershipPackage(
        id: json["id"],
        packageName: json["packageName"],
        description: json["description"],
        durationInDays: json["durationInDays"],
        universalPiiinks: json["universalPiiinks"],
        packageFee: json["packageFee"],
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
