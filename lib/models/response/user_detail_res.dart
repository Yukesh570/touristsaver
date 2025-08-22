// // To parse this JSON data, do
// //
// //     final userProfileResModel = userProfileResModelFromJson(jsonString);

// import 'dart:convert';

// UserProfileResModel userProfileResModelFromJson(String str) =>
//     UserProfileResModel.fromJson(json.decode(str));

// String userProfileResModelToJson(UserProfileResModel data) =>
//     json.encode(data.toJson());

// class UserProfileResModel {
//   UserProfileResModel({
//     this.data,
//   });

//   final Data? data;

//   factory UserProfileResModel.fromJson(Map<String, dynamic> json) =>
//       UserProfileResModel(
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   Data({
//     this.results,
//   });

//   final Results? results;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         results:
//             json["results"] == null ? null : Results.fromJson(json["results"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "results": results?.toJson(),
//       };
// }

// class Results {
//   Results({
//     this.id,
//     this.phoneNumberPrefix,
//     this.firstname,
//     this.lastname,
//     this.uniqueMemberCode,
//     this.email,
//     this.postalCode,
//     this.phoneNumber,
//     this.phoneVerifiedBy,
//     this.memberType,
//     this.turnedToPremiumDate,
//     this.createdAt,
//     this.originCountryId,
//     this.countryId,
//     this.stateId,
//     this.issuerCodeId,
//     this.whiteLabelId,
//     this.charityId,
//     this.issuerId,
//     this.issuerType,
//     this.isEmailVerified,
//     this.charity,
//     this.country,
//     this.state,
//   });

//   final int? id;
//   final String? firstname;
//   final String? lastname;
//   final dynamic uniqueMemberCode;
//   final String? email;
//   final String? phoneNumberPrefix;
//   final String? postalCode;
//   final String? phoneNumber;
//   final String? phoneVerifiedBy;
//   final String? memberType;
//   final dynamic turnedToPremiumDate;
//   final DateTime? createdAt;
//   final int? originCountryId;
//   final int? countryId;
//   final int? stateId;
//   final dynamic issuerCodeId;
//   final dynamic whiteLabelId;
//   final int? charityId;
//   final int? issuerId;
//   final String? issuerType;
//   final bool? isEmailVerified;
//   final Charity? charity;
//   final Country? country;
//   final States? state;

//   factory Results.fromJson(Map<String, dynamic> json) => Results(
//         id: json["id"],
//         firstname: json["firstname"],
//         lastname: json["lastname"],
//         uniqueMemberCode: json["uniqueMemberCode"],
//         email: json["email"],
//         postalCode: json["postalCode"],
//         phoneNumberPrefix: json["phoneNumberPrefix"],
//         phoneNumber: json["phoneNumber"],
//         phoneVerifiedBy: json["phoneVerifiedBy"],
//         memberType: json["memberType"],
//         turnedToPremiumDate: json["turnedToPremiumDate"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         originCountryId: json["originCountryId"],
//         countryId: json["countryId"],
//         stateId: json["stateId"],
//         issuerCodeId: json["issuerCodeId"],
//         whiteLabelId: json["whiteLabelId"],
//         charityId: json["charityId"],
//         issuerId: json["issuerId"],
//         issuerType: json["issuerType"],
//         isEmailVerified: json["isEmailVerified"],
//         charity: json["__charity__"] == null
//             ? null
//             : Charity.fromJson(json["__charity__"]),
//         country: json["__country__"] == null
//             ? null
//             : Country.fromJson(json["__country__"]),
//         state: json["__state__"] == null
//             ? null
//             : States.fromJson(json["__state__"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "firstname": firstname,
//         "lastname": lastname,
//         "uniqueMemberCode": uniqueMemberCode,
//         "email": email,
//         "postalCode": postalCode,
//         "phoneNumberPrefix": phoneNumberPrefix,
//         "phoneNumber": phoneNumber,
//         "phoneVerifiedBy": phoneVerifiedBy,
//         "memberType": memberType,
//         "turnedToPremiumDate": turnedToPremiumDate,
//         "createdAt": createdAt?.toIso8601String(),
//         "originCountryId": originCountryId,
//         "countryId": countryId,
//         "stateId": stateId,
//         "issuerCodeId": issuerCodeId,
//         "whiteLabelId": whiteLabelId,
//         "charityId": charityId,
//         "issuerId": issuerId,
//         "issuerType": issuerType,
//         "__charity__": charity?.toJson(),
//         "__country__": country?.toJson(),
//         "__state__": state?.toJson(),
//       };
// }
// To parse this JSON data, do
//
//     final userProfileResModel = userProfileResModelFromJson(jsonString);

import 'dart:convert';

UserProfileResModel userProfileResModelFromJson(String str) =>
    UserProfileResModel.fromJson(json.decode(str));

String userProfileResModelToJson(UserProfileResModel data) =>
    json.encode(data.toJson());

class UserProfileResModel {
  final Data? data;

  UserProfileResModel({
    this.data,
  });

  factory UserProfileResModel.fromJson(Map<String, dynamic> json) =>
      UserProfileResModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  final String? status;
  final String? issuerCode;
  final String? issuerName;
  final int? issuerId;
  final String? issuerType;
  final Results? results;

  Data({
    this.status,
    this.issuerCode,
    this.issuerName,
    this.issuerId,
    this.issuerType,
    this.results,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        issuerCode: json["issuerCode"],
        issuerName: json["issuerName"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
        results:
            json["results"] == null ? null : Results.fromJson(json["results"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "issuerCode": issuerCode,
        "issuerName": issuerName,
        "issuerId": issuerId,
        "issuerType": issuerType,
        "results": results?.toJson(),
      };
}

class Results {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? uniqueMemberCode;
  final String? email;
  final String? postalCode;
  final String? phoneNumberPrefix;
  final String? phoneNumber;
  final String? memberType;
  final String? phoneVerifiedBy;
  final DateTime? turnedToPremiumDate;
  final String? selectedAppLang;
  final DateTime? createdAt;
  final int? originCountryId;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? issuerCodeId;
  final bool? referrerMemberRewarded;
  final dynamic referrerMemberId;
  final dynamic whiteLabelId;
  final dynamic charityId;
  final int? issuerId;
  final String? issuerType;
  final dynamic fcmNotificationKey;
  final dynamic supporterMerchantId;
  final bool? isEmailVerified;
  final bool? bulkEmailSend;
  final dynamic areaRegionAssignedDate;
  final dynamic charity;
  final Country? country;
  final States? state;

  Results({
    this.id,
    this.firstname,
    this.lastname,
    this.uniqueMemberCode,
    this.email,
    this.postalCode,
    this.phoneNumberPrefix,
    this.phoneNumber,
    this.memberType,
    this.phoneVerifiedBy,
    this.turnedToPremiumDate,
    this.selectedAppLang,
    this.createdAt,
    this.originCountryId,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.issuerCodeId,
    this.referrerMemberRewarded,
    this.referrerMemberId,
    this.whiteLabelId,
    this.charityId,
    this.issuerId,
    this.issuerType,
    this.fcmNotificationKey,
    this.supporterMerchantId,
    this.isEmailVerified,
    this.bulkEmailSend,
    this.areaRegionAssignedDate,
    this.charity,
    this.country,
    this.state,
  });

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        uniqueMemberCode: json["uniqueMemberCode"],
        email: json["email"],
        postalCode: json["postalCode"],
        phoneNumberPrefix: json["phoneNumberPrefix"],
        phoneNumber: json["phoneNumber"],
        memberType: json["memberType"],
        phoneVerifiedBy: json["phoneVerifiedBy"],
        turnedToPremiumDate: json["turnedToPremiumDate"] == null
            ? null
            : DateTime.parse(json["turnedToPremiumDate"]),
        selectedAppLang: json["selectedAppLang"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        originCountryId: json["originCountryId"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        issuerCodeId: json["issuerCodeId"],
        referrerMemberRewarded: json["referrerMemberRewarded"],
        referrerMemberId: json["referrerMemberId"],
        whiteLabelId: json["whiteLabelId"],
        charityId: json["charityId"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
        fcmNotificationKey: json["fcmNotificationKey"],
        supporterMerchantId: json["supporterMerchantId"],
        isEmailVerified: json["isEmailVerified"],
        bulkEmailSend: json["bulkEmailSend"],
        areaRegionAssignedDate: json["areaRegionAssignedDate"],
        charity: json["__charity__"],
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
        state: json["__state__"] == null
            ? null
            : States.fromJson(json["__state__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "uniqueMemberCode": uniqueMemberCode,
        "email": email,
        "postalCode": postalCode,
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneNumber": phoneNumber,
        "memberType": memberType,
        "phoneVerifiedBy": phoneVerifiedBy,
        "turnedToPremiumDate": turnedToPremiumDate?.toIso8601String(),
        "selectedAppLang": selectedAppLang,
        "createdAt": createdAt?.toIso8601String(),
        "originCountryId": originCountryId,
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "issuerCodeId": issuerCodeId,
        "referrerMemberRewarded": referrerMemberRewarded,
        "referrerMemberId": referrerMemberId,
        "whiteLabelId": whiteLabelId,
        "charityId": charityId,
        "issuerId": issuerId,
        "issuerType": issuerType,
        "fcmNotificationKey": fcmNotificationKey,
        "supporterMerchantId": supporterMerchantId,
        "isEmailVerified": isEmailVerified,
        "bulkEmailSend": bulkEmailSend,
        "areaRegionAssignedDate": areaRegionAssignedDate,
        "__charity__": charity,
        "__country__": country?.toJson(),
        "__state__": state?.toJson(),
      };
}

class Charity {
  Charity({
    this.id,
    this.charityName,
    this.websiteUrl,
    this.logoUrl,
    this.email,
    this.isPiiinkCharity,
    this.businessRegistrationNumber,
    this.phoneNumber,
    this.address,
    this.buildingNo,
    this.streetInfo,
    this.latlon,
    this.bsb,
    this.accountName,
    this.swiftCode,
    this.bankName,
    this.bankCode,
    this.branchCode,
    this.accountNumber,
    this.notes,
    this.rejectReason,
    this.registrationStatus,
    this.agreedTermAndCondition,
    this.verifiedDate,
    this.createdAt,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.signerId,
    this.signerType,
  });

  final int? id;
  final String? charityName;
  final String? websiteUrl;
  final String? logoUrl;
  final String? email;
  final bool? isPiiinkCharity;
  final String? businessRegistrationNumber;
  final String? phoneNumber;
  final String? address;
  final String? buildingNo;
  final String? streetInfo;
  final List<double>? latlon;
  final String? bsb;
  final String? accountName;
  final String? swiftCode;
  final String? bankName;
  final String? bankCode;
  final String? branchCode;
  final String? accountNumber;
  final String? notes;
  final dynamic rejectReason;
  final String? registrationStatus;
  final bool? agreedTermAndCondition;
  final DateTime? verifiedDate;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? signerId;
  final String? signerType;

  factory Charity.fromJson(Map<String, dynamic> json) => Charity(
        id: json["id"],
        charityName: json["charityName"],
        websiteUrl: json["websiteUrl"],
        logoUrl: json["logoUrl"],
        email: json["email"],
        isPiiinkCharity: json["isPiiinkCharity"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        latlon: json["latlon"] == null
            ? null
            : List<double>.from(json["latlon"].map((x) => x.toDouble())),
        bsb: json["BSB"],
        accountName: json["accountName"],
        swiftCode: json["swiftCode"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        branchCode: json["branchCode"],
        accountNumber: json["accountNumber"],
        notes: json["notes"],
        rejectReason: json["rejectReason"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        signerId: json["signerId"],
        signerType: json["signerType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "charityName": charityName,
        "websiteUrl": websiteUrl,
        "logoUrl": logoUrl,
        "email": email,
        "isPiiinkCharity": isPiiinkCharity,
        "businessRegistrationNumber": businessRegistrationNumber,
        "phoneNumber": phoneNumber,
        "address": address,
        "buildingNo": buildingNo,
        "streetInfo": streetInfo,
        "latlon": latlon == null
            ? null
            : List<dynamic>.from(latlon!.map((x) => x.toDouble())),
        "BSB": bsb,
        "accountName": accountName,
        "swiftCode": swiftCode,
        "bankName": bankName,
        "bankCode": bankCode,
        "branchCode": branchCode,
        "accountNumber": accountNumber,
        "notes": notes,
        "rejectReason": rejectReason,
        "registrationStatus": registrationStatus,
        "agreedTermAndCondition": agreedTermAndCondition,
        "verifiedDate": verifiedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "signerId": signerId,
        "signerType": signerType,
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
  final dynamic imageUrl;
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

class States {
  States({
    this.id,
    this.stateName,
    this.stateShortName,
    this.imageUrl,
    this.isPiiinkState,
    this.isAssignedToOwner,
    this.createdAt,
    this.countryId,
  });

  final int? id;
  final String? stateName;
  final String? stateShortName;
  final dynamic imageUrl;
  final bool? isPiiinkState;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final int? countryId;

  factory States.fromJson(Map<String, dynamic> json) => States(
        id: json["id"],
        stateName: json["stateName"],
        stateShortName: json["stateShortName"],
        imageUrl: json["imageUrl"],
        isPiiinkState: json["isPiiinkState"],
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "stateName": stateName,
        "stateShortName": stateShortName,
        "imageUrl": imageUrl,
        "isPiiinkState": isPiiinkState,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
      };
}
