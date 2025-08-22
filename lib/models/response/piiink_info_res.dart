// To parse this JSON data, do
//
//     final piiinkInfoResModel = piiinkInfoResModelFromJson(jsonString);

import 'dart:convert';

PiiinkInfoResModel piiinkInfoResModelFromJson(String str) =>
    PiiinkInfoResModel.fromJson(json.decode(str));

String piiinkInfoResModelToJson(PiiinkInfoResModel data) =>
    json.encode(data.toJson());

class PiiinkInfoResModel {
  final String? status;
  final Data? data;

  PiiinkInfoResModel({
    this.status,
    this.data,
  });

  factory PiiinkInfoResModel.fromJson(Map<String, dynamic> json) =>
      PiiinkInfoResModel(
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
  final bool? hideRemoveAccount;
  final bool? hideReferredMerchantInApp;
  final String? name;
  final String? address;
  final String? phoneNumber1;
  final String? phoneNumber2;
  final String? email;
  final String? registrationNumber;
  final bool? allowMerchantEditBankInfo;
  final bool? allowMerchantEditImageInfo;
  final bool? allowMerchantRegisterForCharity;
  final bool? allowMerchantRegisterForClub;
  final bool? hideMerchantPaymentCodeScanOption;
  final int? merchantPiiinkUponReferral;
  final int? piiinkUponMemberReferral;
  final int? upgradeGraceDiscountPeriod;
  final int? memberReferTransactionKpi;
  final DateTime? createdAt;
  final int? countryId;

  Data({
    this.id,
    this.hideRemoveAccount,
    this.hideReferredMerchantInApp,
    this.name,
    this.address,
    this.phoneNumber1,
    this.phoneNumber2,
    this.email,
    this.registrationNumber,
    this.allowMerchantEditBankInfo,
    this.allowMerchantEditImageInfo,
    this.allowMerchantRegisterForCharity,
    this.allowMerchantRegisterForClub,
    this.hideMerchantPaymentCodeScanOption,
    this.merchantPiiinkUponReferral,
    this.piiinkUponMemberReferral,
    this.upgradeGraceDiscountPeriod,
    this.memberReferTransactionKpi,
    this.createdAt,
    this.countryId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        hideRemoveAccount: json["hideRemoveAccount"],
        hideReferredMerchantInApp: json["hideReferredMerchantInApp"],
        name: json["name"],
        address: json["address"],
        phoneNumber1: json["phoneNumber1"],
        phoneNumber2: json["phoneNumber2"],
        email: json["email"],
        registrationNumber: json["registrationNumber"],
        allowMerchantEditBankInfo: json["allowMerchantEditBankInfo"],
        allowMerchantEditImageInfo: json["allowMerchantEditImageInfo"],
        allowMerchantRegisterForCharity:
            json["allowMerchantRegisterForCharity"],
        allowMerchantRegisterForClub: json["allowMerchantRegisterForClub"],
        hideMerchantPaymentCodeScanOption:
            json["hideMerchantPaymentCodeScanOption"],
        merchantPiiinkUponReferral: json["merchantPiiinkUponReferral"],
        piiinkUponMemberReferral: json["piiinkUponMemberReferral"],
        upgradeGraceDiscountPeriod: json["upgradeGraceDiscountPeriod"],
        memberReferTransactionKpi: json["memberReferTransactionKPI"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hideRemoveAccount": hideRemoveAccount,
        "hideReferredMerchantInApp": hideReferredMerchantInApp,
        "name": name,
        "address": address,
        "phoneNumber1": phoneNumber1,
        "phoneNumber2": phoneNumber2,
        "email": email,
        "registrationNumber": registrationNumber,
        "allowMerchantEditBankInfo": allowMerchantEditBankInfo,
        "allowMerchantEditImageInfo": allowMerchantEditImageInfo,
        "allowMerchantRegisterForCharity": allowMerchantRegisterForCharity,
        "allowMerchantRegisterForClub": allowMerchantRegisterForClub,
        "hideMerchantPaymentCodeScanOption": hideMerchantPaymentCodeScanOption,
        "merchantPiiinkUponReferral": merchantPiiinkUponReferral,
        "piiinkUponMemberReferral": piiinkUponMemberReferral,
        "upgradeGraceDiscountPeriod": upgradeGraceDiscountPeriod,
        "memberReferTransactionKPI": memberReferTransactionKpi,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
      };
}

// // To parse this JSON data, do
// //
// //     final piiinkInfoResModel = piiinkInfoResModelFromJson(jsonString);

// import 'dart:convert';

// PiiinkInfoResModel piiinkInfoResModelFromJson(String str) =>
//     PiiinkInfoResModel.fromJson(json.decode(str));

// String piiinkInfoResModelToJson(PiiinkInfoResModel data) =>
//     json.encode(data.toJson());

// class PiiinkInfoResModel {
//   final String? status;
//   final Data? data;

//   PiiinkInfoResModel({
//     this.status,
//     this.data,
//   });

//   factory PiiinkInfoResModel.fromJson(Map<String, dynamic> json) =>
//       PiiinkInfoResModel(
//         status: json["status"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   final int? id;
//   final bool? hideRemoveAccount;
//   final bool? hideReferredMerchantInApp;
//   final bool? hideMerchantPaymentCodeScanOption;
//   final String? name;
//   final String? address;
//   final String? phoneNumber1;
//   final String? phoneNumber2;
//   final String? email;
//   final String? registrationNumber;
//   final bool? allowMerchantEditBankInfo;
//   final bool? allowMerchantEditImageInfo;
//   final DateTime? createdAt;
//   final int? countryId;

//   Data({
//     this.id,
//     this.hideRemoveAccount,
//     this.hideReferredMerchantInApp,
//     this.hideMerchantPaymentCodeScanOption,
//     this.name,
//     this.address,
//     this.phoneNumber1,
//     this.phoneNumber2,
//     this.email,
//     this.registrationNumber,
//     this.allowMerchantEditBankInfo,
//     this.allowMerchantEditImageInfo,
//     this.createdAt,
//     this.countryId,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         hideRemoveAccount: json["hideRemoveAccount"],
//         hideReferredMerchantInApp: json["hideReferredMerchantInApp"],
//         hideMerchantPaymentCodeScanOption:
//             json["hideMerchantPaymentCodeScanOption"],
//         name: json["name"],
//         address: json["address"],
//         phoneNumber1: json["phoneNumber1"],
//         phoneNumber2: json["phoneNumber2"],
//         email: json["email"],
//         registrationNumber: json["registrationNumber"],
//         allowMerchantEditBankInfo: json["allowMerchantEditBankInfo"],
//         allowMerchantEditImageInfo: json["allowMerchantEditImageInfo"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         countryId: json["countryId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "hideRemoveAccount": hideRemoveAccount,
//         "hideReferredMerchantInApp": hideReferredMerchantInApp,
//         "hideMerchantPaymentCodeScanOption": hideMerchantPaymentCodeScanOption,
//         "name": name,
//         "address": address,
//         "phoneNumber1": phoneNumber1,
//         "phoneNumber2": phoneNumber2,
//         "email": email,
//         "registrationNumber": registrationNumber,
//         "allowMerchantEditBankInfo": allowMerchantEditBankInfo,
//         "allowMerchantEditImageInfo": allowMerchantEditImageInfo,
//         "createdAt": createdAt?.toIso8601String(),
//         "countryId": countryId,
//       };
// }
