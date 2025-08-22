// To parse this JSON data, do
//
//     final topUpHistoryResModel = topUpHistoryResModelFromJson(jsonString);

import 'dart:convert';

TopUpHistoryResModel topUpHistoryResModelFromJson(String str) =>
    TopUpHistoryResModel.fromJson(json.decode(str));

String topUpHistoryResModelToJson(TopUpHistoryResModel data) =>
    json.encode(data.toJson());

class TopUpHistoryResModel {
  final String? status;
  final Map<String, List<Datum>>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  TopUpHistoryResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory TopUpHistoryResModel.fromJson(Map<String, dynamic> json) =>
      TopUpHistoryResModel(
        status: json["status"],
        data: Map.from(json["data"]!).map((k, v) =>
            MapEntry<String, List<Datum>>(
                k, List<Datum>.from(v.map((x) => Datum.fromJson(x))))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": Map.from(data!).map((k, v) => MapEntry<String, dynamic>(
            k, List<dynamic>.from(v.map((x) => x.toJson())))),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  final int? id;
  final String? transactionId;
  final double? totalAmount;
  final double? piiinksProvided;
  final String? transactionCurrency;
  final double? totalAmountInUsd;
  final double? foreignTotalAmount;
  final String? foreignTransactionCurrency;
  final String? foreignCurrencySymbol;
  final String? status;
  final DateTime? transactionDate;
  final int? memberId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? issuerCountryId;
  final int? memberCountryId;
  final dynamic memberBelongingToWhiteLabelId;
  final int? membershipPackageId;
  final bool? isMemberWhiteLabel;
  final int? issuerId;
  final String? issuerType;
  final String? charityFrom;
  final int? charityId;
  final dynamic clubOrCharityId;
  final String? clubOrCharityType;
  final int? clubCharitySignerId;
  final String? clubCharitySignerType;
  final double? issuerCountryConversionRate;
  final double? memberCountryConversionRateInUsd;
  final double? foreignCountryConversionRate;
  final bool? isMemberMadeByCp;
  final dynamic remarks;
  final bool? isTopupUponRegistration;
  final dynamic memberPremiumCodeId;
  final dynamic supporterMerchantId;
  final MemberCountry? memberCountry;

  Datum({
    this.id,
    this.transactionId,
    this.totalAmount,
    this.piiinksProvided,
    this.transactionCurrency,
    this.totalAmountInUsd,
    this.foreignTotalAmount,
    this.foreignTransactionCurrency,
    this.foreignCurrencySymbol,
    this.status,
    this.transactionDate,
    this.memberId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.issuerCountryId,
    this.memberCountryId,
    this.memberBelongingToWhiteLabelId,
    this.membershipPackageId,
    this.isMemberWhiteLabel,
    this.issuerId,
    this.issuerType,
    this.charityFrom,
    this.charityId,
    this.clubOrCharityId,
    this.clubOrCharityType,
    this.clubCharitySignerId,
    this.clubCharitySignerType,
    this.issuerCountryConversionRate,
    this.memberCountryConversionRateInUsd,
    this.foreignCountryConversionRate,
    this.isMemberMadeByCp,
    this.remarks,
    this.isTopupUponRegistration,
    this.memberPremiumCodeId,
    this.supporterMerchantId,
    this.memberCountry,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        transactionId: json["transactionId"],
        totalAmount: json["totalAmount"]?.toDouble(),
        piiinksProvided: json["piiinksProvided"]?.toDouble(),
        transactionCurrency: json["transactionCurrency"],
        totalAmountInUsd: json["totalAmountInUSD"]?.toDouble(),
        foreignTotalAmount: json["foreignTotalAmount"]?.toDouble(),
        foreignTransactionCurrency: json["foreignTransactionCurrency"],
        foreignCurrencySymbol: json["foreignCurrencySymbol"],
        status: json["status"],
        transactionDate: json["transactionDate"] == null
            ? null
            : DateTime.parse(json["transactionDate"]),
        memberId: json["memberId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        issuerCountryId: json["issuerCountryId"],
        memberCountryId: json["memberCountryId"],
        memberBelongingToWhiteLabelId: json["memberBelongingToWhiteLabelId"],
        membershipPackageId: json["membershipPackageId"],
        isMemberWhiteLabel: json["isMemberWhiteLabel"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
        charityFrom: json["charityFrom"],
        charityId: json["charityId"],
        clubOrCharityId: json["club_or_charity_id"],
        clubOrCharityType: json["club_or_charity_type"],
        clubCharitySignerId: json["club_charity_signer_id"],
        clubCharitySignerType: json["club_charity_signer_type"],
        issuerCountryConversionRate:
            json["issuerCountryConversionRate"]?.toDouble(),
        memberCountryConversionRateInUsd:
            json["memberCountryConversionRateInUSD"]?.toDouble(),
        foreignCountryConversionRate:
            json["foreignCountryConversionRate"]?.toDouble(),
        isMemberMadeByCp: json["isMemberMadeByCP"],
        remarks: json["remarks"],
        isTopupUponRegistration: json["isTopupUponRegistration"],
        memberPremiumCodeId: json["memberPremiumCodeId"],
        supporterMerchantId: json["supporterMerchantId"],
        memberCountry: json["__memberCountry__"] == null
            ? null
            : MemberCountry.fromJson(json["__memberCountry__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transactionId": transactionId,
        "totalAmount": totalAmount,
        "piiinksProvided": piiinksProvided,
        "transactionCurrency": transactionCurrency,
        "totalAmountInUSD": totalAmountInUsd,
        "foreignTotalAmount": foreignTotalAmount,
        "foreignTransactionCurrency": foreignTransactionCurrency,
        "foreignCurrencySymbol": foreignCurrencySymbol,
        "status": status,
        "transactionDate": transactionDate?.toIso8601String(),
        "memberId": memberId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "issuerCountryId": issuerCountryId,
        "memberCountryId": memberCountryId,
        "memberBelongingToWhiteLabelId": memberBelongingToWhiteLabelId,
        "membershipPackageId": membershipPackageId,
        "isMemberWhiteLabel": isMemberWhiteLabel,
        "issuerId": issuerId,
        "issuerType": issuerType,
        "charityFrom": charityFrom,
        "charityId": charityId,
        "club_or_charity_id": clubOrCharityId,
        "club_or_charity_type": clubOrCharityType,
        "club_charity_signer_id": clubCharitySignerId,
        "club_charity_signer_type": clubCharitySignerType,
        "issuerCountryConversionRate": issuerCountryConversionRate,
        "memberCountryConversionRateInUSD": memberCountryConversionRateInUsd,
        "foreignCountryConversionRate": foreignCountryConversionRate,
        "isMemberMadeByCP": isMemberMadeByCp,
        "remarks": remarks,
        "isTopupUponRegistration": isTopupUponRegistration,
        "memberPremiumCodeId": memberPremiumCodeId,
        "supporterMerchantId": supporterMerchantId,
        "__memberCountry__": memberCountry?.toJson(),
      };
}

class MemberCountry {
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
  final String? timeZone;
  final String? stripeSecretKey;
  final String? stripeWebhookSecret;

  MemberCountry({
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
    this.timeZone,
    this.stripeSecretKey,
    this.stripeWebhookSecret,
  });

  factory MemberCountry.fromJson(Map<String, dynamic> json) => MemberCountry(
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
        timeZone: json["timeZone"],
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
        "timeZone": timeZone,
        "stripeSecretKey": stripeSecretKey,
        "stripeWebhookSecret": stripeWebhookSecret,
      };
}
