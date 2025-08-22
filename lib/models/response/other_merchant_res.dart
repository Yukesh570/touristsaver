// To parse this JSON data, do
//
//     final otherMerchantResModel = otherMerchantResModelFromJson(jsonString);

import 'dart:convert';

OtherMerchantResModel otherMerchantResModelFromJson(String str) =>
    OtherMerchantResModel.fromJson(json.decode(str));

String otherMerchantResModelToJson(OtherMerchantResModel data) =>
    json.encode(data.toJson());

class OtherMerchantResModel {
  OtherMerchantResModel({
    this.status,
    this.results,
  });

  final String? status;
  final List<Result>? results;

  factory OtherMerchantResModel.fromJson(Map<String, dynamic> json) =>
      OtherMerchantResModel(
        status: json["status"],
        results: json["results"] == null
            ? null
            : List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "results": results == null
            ? null
            : List<dynamic>.from(results!.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.merchantName,
    this.maxDiscount,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.merchantEmail,
    this.merchantPhoneNumber,
    this.email,
    this.stripeSubscriptionId,
    this.stripeCustomerId,
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
  final dynamic stripeSubscriptionId;
  final dynamic stripeCustomerId;
  final String? phoneNumber;
  final String? businessRegistrationNumber;
  final List<double>? latlon;
  final String? buildingNo;
  final String? streetInfo;
  final dynamic city;
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
  final String? postalCodeUser;
  final int? postalCodeId;
  final dynamic memberAsRefererId;
  final dynamic whiteLabelId;
  final int? merchantPackageId;
  final bool? isPremium;
  final dynamic packageExpirydate;
  final int? signerId;
  final String? signerType;
  final int? charityId;
  final MerchantImageInfo? merchantImageInfo;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        merchantName: json["merchantName"],
        maxDiscount: json["maxDiscount"]?.toDouble(),
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        merchantEmail: json["merchantEmail"],
        merchantPhoneNumber: json["merchantPhoneNumber"],
        email: json["email"],
        stripeSubscriptionId: json["stripeSubscriptionId"],
        stripeCustomerId: json["stripeCustomerId"],
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
        "stripeSubscriptionId": stripeSubscriptionId,
        "stripeCustomerId": stripeCustomerId,
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
        "__merchantImageInfo__": merchantImageInfo?.toJson(),
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
