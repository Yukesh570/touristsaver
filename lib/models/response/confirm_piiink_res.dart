// To parse this JSON data, do
//
//     final confirmApplyPiiinkResModel = confirmApplyPiiinkResModelFromJson(jsonString);

import 'dart:convert';

ConfirmApplyPiiinkResModel confirmApplyPiiinkResModelFromJson(String str) =>
    ConfirmApplyPiiinkResModel.fromJson(json.decode(str));

String confirmApplyPiiinkResModelToJson(ConfirmApplyPiiinkResModel data) =>
    json.encode(data.toJson());

class ConfirmApplyPiiinkResModel {
  ConfirmApplyPiiinkResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory ConfirmApplyPiiinkResModel.fromJson(Map<String, dynamic> json) =>
      ConfirmApplyPiiinkResModel(
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
    this.merchantInfo,
    this.universalPiiinkBalanceOnHold,
    this.merchantPiiinkBalanceOnHold,
    this.universalPiiinkBalance,
    this.merchantPiiinkBalance,
    this.merchantDiscountPercentage,
    this.totalTransactionAmount,
    this.totalPiiinkDiscount,
    this.discountedTransactionAmount,
    this.merchantRebateToMember,
    this.hasUniversalPiiinks,
    this.hasMerchantPiiinks,
    this.terminalUserId,
    this.terminalId,
  });

  final MerchantInfo? merchantInfo;
  final double? universalPiiinkBalanceOnHold;
  final double? merchantPiiinkBalanceOnHold;
  final double? universalPiiinkBalance;
  final double? merchantPiiinkBalance;
  final double? merchantDiscountPercentage;
  final double? totalTransactionAmount;
  final double? totalPiiinkDiscount;
  final double? discountedTransactionAmount;
  final double? merchantRebateToMember;
  final bool? hasUniversalPiiinks;
  final bool? hasMerchantPiiinks;
  final int? terminalUserId;
  final int? terminalId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        merchantInfo: json["merchantInfo"] == null
            ? null
            : MerchantInfo.fromJson(json["merchantInfo"]),
        universalPiiinkBalanceOnHold:
            json["universalPiiinkBalanceOnHold"].toDouble(),
        merchantPiiinkBalanceOnHold:
            json["merchantPiiinkBalanceOnHold"].toDouble(),
        universalPiiinkBalance: json["universalPiiinkBalance"].toDouble(),
        merchantPiiinkBalance: json["merchantPiiinkBalance"].toDouble(),
        merchantDiscountPercentage:
            json["merchantDiscountPercentage"].toDouble(),
        totalTransactionAmount: json["totalTransactionAmount"].toDouble(),
        totalPiiinkDiscount: json["totalPiiinkDiscount"].toDouble(),
        discountedTransactionAmount:
            json["discountedTransactionAmount"].toDouble(),
        merchantRebateToMember: json["merchantRebateToMember"].toDouble(),
        hasUniversalPiiinks: json["hasUniversalPiiinks"],
        hasMerchantPiiinks: json["hasMerchantPiiinks"],
        terminalUserId: json["terminalUserId"],
        terminalId: json["terminalId"],
      );

  Map<String, dynamic> toJson() => {
        "merchantInfo": merchantInfo?.toJson(),
        "universalPiiinkBalanceOnHold":
            universalPiiinkBalanceOnHold!.toDouble(),
        "merchantPiiinkBalanceOnHold": merchantPiiinkBalanceOnHold!.toDouble(),
        "universalPiiinkBalance": universalPiiinkBalance!.toDouble(),
        "merchantPiiinkBalance": merchantPiiinkBalance!.toDouble(),
        "merchantDiscountPercentage": merchantDiscountPercentage!.toDouble(),
        "totalTransactionAmount": totalTransactionAmount!.toDouble(),
        "totalPiiinkDiscount": totalPiiinkDiscount!.toDouble(),
        "discountedTransactionAmount": discountedTransactionAmount!.toDouble(),
        "merchantRebateToMember": merchantRebateToMember!.toDouble(),
        "hasUniversalPiiinks": hasUniversalPiiinks,
        "hasMerchantPiiinks": hasMerchantPiiinks,
        "terminalUserId": terminalUserId,
        "terminalId": terminalId,
      };
}

class MerchantInfo {
  MerchantInfo({
    this.id,
    this.merchantName,
    this.maxDiscount,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.merchantEmail,
    this.merchantPhoneNumber,
    this.email,
    this.password,
    this.phoneNumber,
    this.businessRegistrationNumber,
    this.latlon,
    this.buildingNo,
    this.streetInfo,
    this.city,
    this.registrationIsComplete,
    this.isAgreementComplete,
    this.registrationCompletedStep,
    this.rejectReason,
    this.registrationStatus,
    this.transactionCode,
    this.isPopularFlag,
    this.popularOrder,
    this.agreedTermAndCondition,
    this.isImported,
    this.emailSent,
    this.createdAt,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.postalCodeUser,
    this.postalCodeId,
    this.memberAsRefererId,
    this.whiteLabelId,
    this.merchantPackageId,
    this.isPremium,
    this.packageExpirydate,
    this.signerId,
    this.signerType,
    this.charityId,
    this.country,
    this.merchantImageInfo,
  });

  final int? id;
  final String? merchantName;
  final double? maxDiscount;
  final String? contactPersonFirstName;
  final String? contactPersonLastName;
  final String? merchantEmail;
  final String? merchantPhoneNumber;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? businessRegistrationNumber;
  final List<double>? latlon;
  final String? buildingNo;
  final String? streetInfo;
  final String? city;
  final bool? registrationIsComplete;
  final bool? isAgreementComplete;
  final int? registrationCompletedStep;
  final dynamic rejectReason;
  final String? registrationStatus;
  final String? transactionCode;
  final bool? isPopularFlag;
  final int? popularOrder;
  final bool? agreedTermAndCondition;
  final bool? isImported;
  final bool? emailSent;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final dynamic postalCodeUser;
  final int? postalCodeId;
  final dynamic memberAsRefererId;
  final dynamic whiteLabelId;
  final int? merchantPackageId;
  final bool? isPremium;
  final dynamic packageExpirydate;
  final int? signerId;
  final String? signerType;
  final int? charityId;
  final Country? country;
  final MerchantImageInfo? merchantImageInfo;

  factory MerchantInfo.fromJson(Map<String, dynamic> json) => MerchantInfo(
        id: json["id"],
        merchantName: json["merchantName"],
        maxDiscount: json["maxDiscount"].toDouble(),
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        merchantEmail: json["merchantEmail"],
        merchantPhoneNumber: json["merchantPhoneNumber"],
        email: json["email"],
        password: json["password"],
        phoneNumber: json["phoneNumber"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        latlon: json["latlon"] == null
            ? null
            : List<double>.from(json["latlon"].map((x) => x.toDouble())),
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        city: json["city"],
        registrationIsComplete: json["registrationIsComplete"],
        isAgreementComplete: json["isAgreementComplete"],
        registrationCompletedStep: json["registrationCompletedStep"],
        rejectReason: json["rejectReason"],
        registrationStatus: json["registrationStatus"],
        transactionCode: json["transactionCode"],
        isPopularFlag: json["isPopularFlag"],
        popularOrder: json["popularOrder"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        isImported: json["isImported"],
        emailSent: json["emailSent"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        postalCodeUser: json["postalCodeUser"],
        postalCodeId: json["postalCodeId"],
        memberAsRefererId: json["memberAsRefererId"],
        whiteLabelId: json["whiteLabelId"],
        merchantPackageId: json["merchantPackageId"],
        isPremium: json["isPremium"],
        packageExpirydate: json["packageExpirydate"],
        signerId: json["signerId"],
        signerType: json["signerType"],
        charityId: json["charityId"],
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
        merchantImageInfo: json["__merchantImageInfo__"] == null
            ? null
            : MerchantImageInfo.fromJson(json["__merchantImageInfo__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "merchantName": merchantName,
        "maxDiscount": maxDiscount,
        "contactPersonFirstName": contactPersonFirstName,
        "contactPersonLastName": contactPersonLastName,
        "merchantEmail": merchantEmail,
        "merchantPhoneNumber": merchantPhoneNumber,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "businessRegistrationNumber": businessRegistrationNumber,
        "latlon": latlon == null
            ? null
            : List<dynamic>.from(latlon!.map((x) => x.toDouble())),
        "buildingNo": buildingNo,
        "streetInfo": streetInfo,
        "city": city,
        "registrationIsComplete": registrationIsComplete,
        "isAgreementComplete": isAgreementComplete,
        "registrationCompletedStep": registrationCompletedStep,
        "rejectReason": rejectReason,
        "registrationStatus": registrationStatus,
        "transactionCode": transactionCode,
        "isPopularFlag": isPopularFlag,
        "popularOrder": popularOrder,
        "agreedTermAndCondition": agreedTermAndCondition,
        "isImported": isImported,
        "emailSent": emailSent,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "postalCodeUser": postalCodeUser,
        "postalCodeId": postalCodeId,
        "memberAsRefererId": memberAsRefererId,
        "whiteLabelId": whiteLabelId,
        "merchantPackageId": merchantPackageId,
        "isPremium": isPremium,
        "packageExpirydate": packageExpirydate,
        "signerId": signerId,
        "signerType": signerType,
        "charityId": charityId,
        "__country__": country?.toJson(),
        "__merchantImageInfo__": merchantImageInfo?.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.countryName,
    this.countryShortName,
    this.imageUrl,
    this.phonePrefix,
    this.currencyName,
    this.currencySymbol,
    this.symbolIsPrefix,
    this.taxationUnitValue,
    this.isPiiinkCountry,
    this.isAssignedToOwner,
    this.createdAt,
  });

  final int? id;
  final String? countryName;
  final String? countryShortName;
  final String? imageUrl;
  final String? phonePrefix;
  final String? currencyName;
  final String? currencySymbol;
  final bool? symbolIsPrefix;
  final double? taxationUnitValue;
  final bool? isPiiinkCountry;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
        countryShortName: json["countryShortName"],
        imageUrl: json["imageUrl"],
        phonePrefix: json["phonePrefix"],
        currencyName: json["currencyName"],
        currencySymbol: json["currencySymbol"],
        symbolIsPrefix: json["symbolIsPrefix"],
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
        "taxationUnitValue": taxationUnitValue,
        "isPiiinkCountry": isPiiinkCountry,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
      };
}

class MerchantImageInfo {
  MerchantImageInfo({
    this.id,
    this.logoUrl,
    this.slider1,
    this.slider2,
    this.slider3,
    this.slider4,
    this.slider5,
    this.slider6,
    this.createdAt,
    this.merchantId,
  });

  final int? id;
  final String? logoUrl;
  final String? slider1;
  final String? slider2;
  final String? slider3;
  final String? slider4;
  final String? slider5;
  final String? slider6;
  final DateTime? createdAt;
  final int? merchantId;

  factory MerchantImageInfo.fromJson(Map<String, dynamic> json) =>
      MerchantImageInfo(
        id: json["id"],
        logoUrl: json["logoUrl"],
        slider1: json["slider1"],
        slider2: json["slider2"],
        slider3: json["slider3"],
        slider4: json["slider4"],
        slider5: json["slider5"],
        slider6: json["slider6"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        merchantId: json["merchantId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logoUrl": logoUrl,
        "slider1": slider1,
        "slider2": slider2,
        "slider3": slider3,
        "slider4": slider4,
        "slider5": slider5,
        "slider6": slider6,
        "createdAt": createdAt?.toIso8601String(),
        "merchantId": merchantId,
      };
}
