// To parse this JSON data, do
//
//     final memberSelectedCharityResModel = memberSelectedCharityResModelFromJson(jsonString);

import 'dart:convert';

MemberSelectedCharityResModel memberSelectedCharityResModelFromJson(
        String str) =>
    MemberSelectedCharityResModel.fromJson(json.decode(str));

String memberSelectedCharityResModelToJson(
        MemberSelectedCharityResModel data) =>
    json.encode(data.toJson());

class MemberSelectedCharityResModel {
  final String? status;
  final Data? data;

  MemberSelectedCharityResModel({
    this.status,
    this.data,
  });

  factory MemberSelectedCharityResModel.fromJson(Map<String, dynamic> json) =>
      MemberSelectedCharityResModel(
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
  final String? charityName;
  final String? websiteUrl;
  final String? logoUrl;
  final String? email;
  final bool? isPiiinkCharity;
  final String? businessRegistrationNumber;
  final String? charityRegistrationNo;
  final String? phoneNumber;
  final String? address;
  final String? buildingNo;
  final String? streetInfo;
  final List<double>? latlon;
  final String? bsb;
  final String? accountName;
  final dynamic swiftCode;
  final String? bankName;
  final dynamic bankCode;
  final dynamic branchCode;
  final String? accountNumber;
  final String? facebookLink;
  final String? instagramLink;
  final String? others;
  final String? contactPersonFirstName;
  final String? contactPersonLastName;
  final String? contactEmail;
  final String? contactPhoneNumber;
  final String? postCode;
  final String? townOrCity;
  final String? notes;
  final dynamic rejectReason;
  final String? registrationStatus;
  final bool? agreedTermAndCondition;
  final dynamic verifiedDate;
  final int? priorityOrder;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final dynamic regionId;
  final dynamic areaId;
  final int? signerId;
  final bool? isCreatedByAdmin;
  final String? signerType;
  final dynamic whiteLabelId;
  final bool? canCreateMerchant;
  final Country? country;
  final State? state;
  final dynamic region;
  final dynamic area;

  Data({
    this.id,
    this.charityName,
    this.websiteUrl,
    this.logoUrl,
    this.email,
    this.isPiiinkCharity,
    this.businessRegistrationNumber,
    this.charityRegistrationNo,
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
    this.facebookLink,
    this.instagramLink,
    this.others,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.contactEmail,
    this.contactPhoneNumber,
    this.postCode,
    this.townOrCity,
    this.notes,
    this.rejectReason,
    this.registrationStatus,
    this.agreedTermAndCondition,
    this.verifiedDate,
    this.priorityOrder,
    this.createdAt,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.signerId,
    this.isCreatedByAdmin,
    this.signerType,
    this.whiteLabelId,
    this.canCreateMerchant,
    this.country,
    this.state,
    this.region,
    this.area,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        charityName: json["charityName"],
        websiteUrl: json["websiteUrl"],
        logoUrl: json["logoUrl"],
        email: json["email"],
        isPiiinkCharity: json["isPiiinkCharity"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        charityRegistrationNo: json["charityRegistrationNo"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        latlon: json["latlon"] == null
            ? []
            : List<double>.from(json["latlon"]!.map((x) => x?.toDouble())),
        bsb: json["BSB"],
        accountName: json["accountName"],
        swiftCode: json["swiftCode"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        branchCode: json["branchCode"],
        accountNumber: json["accountNumber"],
        facebookLink: json["facebookLink"],
        instagramLink: json["instagramLink"],
        others: json["others"],
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        contactEmail: json["contactEmail"],
        contactPhoneNumber: json["contactPhoneNumber"],
        postCode: json["postCode"],
        townOrCity: json["townOrCity"],
        notes: json["notes"],
        rejectReason: json["rejectReason"],
        registrationStatus: json["registrationStatus"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        verifiedDate: json["verifiedDate"],
        priorityOrder: json["priorityOrder"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        signerId: json["signerId"],
        isCreatedByAdmin: json["isCreatedByAdmin"],
        signerType: json["signerType"],
        whiteLabelId: json["whiteLabelId"],
        canCreateMerchant: json["canCreateMerchant"],
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
        state: json["__state__"] == null
            ? null
            : State.fromJson(json["__state__"]),
        region: json["__region__"],
        area: json["__area__"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "charityName": charityName,
        "websiteUrl": websiteUrl,
        "logoUrl": logoUrl,
        "email": email,
        "isPiiinkCharity": isPiiinkCharity,
        "businessRegistrationNumber": businessRegistrationNumber,
        "charityRegistrationNo": charityRegistrationNo,
        "phoneNumber": phoneNumber,
        "address": address,
        "buildingNo": buildingNo,
        "streetInfo": streetInfo,
        "latlon":
            latlon == null ? [] : List<dynamic>.from(latlon!.map((x) => x)),
        "BSB": bsb,
        "accountName": accountName,
        "swiftCode": swiftCode,
        "bankName": bankName,
        "bankCode": bankCode,
        "branchCode": branchCode,
        "accountNumber": accountNumber,
        "facebookLink": facebookLink,
        "instagramLink": instagramLink,
        "others": others,
        "contactPersonFirstName": contactPersonFirstName,
        "contactPersonLastName": contactPersonLastName,
        "contactEmail": contactEmail,
        "contactPhoneNumber": contactPhoneNumber,
        "postCode": postCode,
        "townOrCity": townOrCity,
        "notes": notes,
        "rejectReason": rejectReason,
        "registrationStatus": registrationStatus,
        "agreedTermAndCondition": agreedTermAndCondition,
        "verifiedDate": verifiedDate,
        "priorityOrder": priorityOrder,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "signerId": signerId,
        "isCreatedByAdmin": isCreatedByAdmin,
        "signerType": signerType,
        "whiteLabelId": whiteLabelId,
        "canCreateMerchant": canCreateMerchant,
        "__country__": country?.toJson(),
        "__state__": state?.toJson(),
        "__region__": region,
        "__area__": area,
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
  final String? gstDisplayText;
  final bool? isPiiinkCountry;
  final bool? isActive;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final String? lang;
  final bool? langEnable;
  final String? countryLanguage;
  final String? timeZone;
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
    this.gstDisplayText,
    this.isPiiinkCountry,
    this.isActive,
    this.isAssignedToOwner,
    this.createdAt,
    this.lang,
    this.langEnable,
    this.countryLanguage,
    this.timeZone,
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
        gstDisplayText: json["gstDisplayText"],
        isPiiinkCountry: json["isPiiinkCountry"],
        isActive: json["isActive"],
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        lang: json["lang"],
        langEnable: json["langEnable"],
        countryLanguage: json["countryLanguage"],
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
        "gstDisplayText": gstDisplayText,
        "isPiiinkCountry": isPiiinkCountry,
        "isActive": isActive,
        "isAssignedToOwner": isAssignedToOwner,
        "createdAt": createdAt?.toIso8601String(),
        "lang": lang,
        "langEnable": langEnable,
        "countryLanguage": countryLanguage,
        "timeZone": timeZone,
        "stripeSecretKey": stripeSecretKey,
        "stripeWebhookSecret": stripeWebhookSecret,
      };
}

class State {
  final int? id;
  final String? stateName;
  final String? stateShortName;
  final String? imageUrl;
  final bool? isPiiinkState;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final double? taxationUnitValue;
  final int? countryId;

  State({
    this.id,
    this.stateName,
    this.stateShortName,
    this.imageUrl,
    this.isPiiinkState,
    this.isAssignedToOwner,
    this.createdAt,
    this.taxationUnitValue,
    this.countryId,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        stateName: json["stateName"],
        stateShortName: json["stateShortName"],
        imageUrl: json["imageUrl"],
        isPiiinkState: json["isPiiinkState"],
        isAssignedToOwner: json["isAssignedToOwner"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        taxationUnitValue: json["taxationUnitValue"]?.toDouble(),
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
        "taxationUnitValue": taxationUnitValue,
        "countryId": countryId,
      };
}

// // To parse this JSON data, do
// //
// //     final memberSelectedCharityResModel = memberSelectedCharityResModelFromJson(jsonString);

// import 'dart:convert';

// MemberSelectedCharityResModel memberSelectedCharityResModelFromJson(
//         String str) =>
//     MemberSelectedCharityResModel.fromJson(json.decode(str));

// String memberSelectedCharityResModelToJson(
//         MemberSelectedCharityResModel data) =>
//     json.encode(data.toJson());

// class MemberSelectedCharityResModel {
//   final String? status;
//   final Data? data;

//   MemberSelectedCharityResModel({
//     this.status,
//     this.data,
//   });

//   factory MemberSelectedCharityResModel.fromJson(Map<String, dynamic> json) =>
//       MemberSelectedCharityResModel(
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
//   final String? charityName;
//   final String? websiteUrl;
//   final String? logoUrl;
//   final String? email;
//   final bool? isPiiinkCharity;
//   final String? businessRegistrationNumber;
//   final String? charityRegistrationNo;
//   final String? phoneNumber;
//   final String? address;
//   final String? buildingNo;
//   final String? streetInfo;
//   final List<double>? latlon;
//   final String? bsb;
//   final String? accountName;
//   final dynamic swiftCode;
//   final String? bankName;
//   final String? bankCode;
//   final String? branchCode;
//   final String? accountNumber;
//   final String? facebookLink;
//   final String? instagramLink;
//   final String? others;
//   final String? contactPersonFirstName;
//   final String? contactPersonLastName;
//   final String? contactEmail;
//   final String? contactPhoneNumber;
//   final String? postCode;
//   final String? townOrCity;
//   final String? notes;
//   final dynamic rejectReason;
//   final String? registrationStatus;
//   final bool? agreedTermAndCondition;
//   final DateTime? verifiedDate;
//   final int? priorityOrder;
//   final DateTime? createdAt;
//   final int? countryId;
//   final int? stateId;
//   final int? regionId;
//   final int? areaId;
//   final int? signerId;
//   final bool? isCreatedByAdmin;
//   final String? signerType;
//   final dynamic whiteLabelId;
//   final bool? canCreateMerchant;
//   final Country? country;
//   final State? state;
//   final Region? region;
//   final Area? area;
//   // final List<CharityMultilinguals>? charityMultilinguals;

//   Data({
//     this.id,
//     this.charityName,
//     this.websiteUrl,
//     this.logoUrl,
//     this.email,
//     this.isPiiinkCharity,
//     this.businessRegistrationNumber,
//     this.charityRegistrationNo,
//     this.phoneNumber,
//     this.address,
//     this.buildingNo,
//     this.streetInfo,
//     this.latlon,
//     this.bsb,
//     this.accountName,
//     this.swiftCode,
//     this.bankName,
//     this.bankCode,
//     this.branchCode,
//     this.accountNumber,
//     this.facebookLink,
//     this.instagramLink,
//     this.others,
//     this.contactPersonFirstName,
//     this.contactPersonLastName,
//     this.contactEmail,
//     this.contactPhoneNumber,
//     this.postCode,
//     this.townOrCity,
//     this.notes,
//     this.rejectReason,
//     this.registrationStatus,
//     this.agreedTermAndCondition,
//     this.verifiedDate,
//     this.priorityOrder,
//     this.createdAt,
//     this.countryId,
//     this.stateId,
//     this.regionId,
//     this.areaId,
//     this.signerId,
//     this.isCreatedByAdmin,
//     this.signerType,
//     this.whiteLabelId,
//     this.canCreateMerchant,
//     this.country,
//     this.state,
//     this.region,
//     this.area,
//     // this.charityMultilinguals,
//   });

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         charityName: json["charityName"],
//         websiteUrl: json["websiteUrl"],
//         logoUrl: json["logoUrl"],
//         email: json["email"],
//         isPiiinkCharity: json["isPiiinkCharity"],
//         businessRegistrationNumber: json["businessRegistrationNumber"],
//         charityRegistrationNo: json["charityRegistrationNo"],
//         phoneNumber: json["phoneNumber"],
//         address: json["address"],
//         buildingNo: json["buildingNo"],
//         streetInfo: json["streetInfo"],
//         latlon: json["latlon"] == null
//             ? []
//             : List<double>.from(json["latlon"]!.map((x) => x?.toDouble())),
//         bsb: json["BSB"],
//         accountName: json["accountName"],
//         swiftCode: json["swiftCode"],
//         bankName: json["bankName"],
//         bankCode: json["bankCode"],
//         branchCode: json["branchCode"],
//         accountNumber: json["accountNumber"],
//         facebookLink: json["facebookLink"],
//         instagramLink: json["instagramLink"],
//         others: json["others"],
//         contactPersonFirstName: json["contactPersonFirstName"],
//         contactPersonLastName: json["contactPersonLastName"],
//         contactEmail: json["contactEmail"],
//         contactPhoneNumber: json["contactPhoneNumber"],
//         postCode: json["postCode"],
//         townOrCity: json["townOrCity"],
//         notes: json["notes"],
//         rejectReason: json["rejectReason"],
//         registrationStatus: json["registrationStatus"],
//         agreedTermAndCondition: json["agreedTermAndCondition"],
//         verifiedDate: json["verifiedDate"] == null
//             ? null
//             : DateTime.parse(json["verifiedDate"]),
//         priorityOrder: json["priorityOrder"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         countryId: json["countryId"],
//         stateId: json["stateId"],
//         regionId: json["regionId"],
//         areaId: json["areaId"],
//         signerId: json["signerId"],
//         isCreatedByAdmin: json["isCreatedByAdmin"],
//         signerType: json["signerType"],
//         whiteLabelId: json["whiteLabelId"],
//         canCreateMerchant: json["canCreateMerchant"],
//         country: json["__country__"] == null
//             ? null
//             : Country.fromJson(json["__country__"]),
//         state: json["__state__"] == null
//             ? null
//             : State.fromJson(json["__state__"]),
//         region: json["__region__"] == null
//             ? null
//             : Region.fromJson(json["__region__"]),
//         area: json["__area__"] == null ? null : Area.fromJson(json["__area__"]),
//         // charityMultilinguals: json["__charityMultilinguals__"] == null
//         //     ? []
//         //     : List<CharityMultilinguals>.from(json["__charityMultilinguals__"]!
//         //         .map((x) => CharityMultilinguals.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "charityName": charityName,
//         "websiteUrl": websiteUrl,
//         "logoUrl": logoUrl,
//         "email": email,
//         "isPiiinkCharity": isPiiinkCharity,
//         "businessRegistrationNumber": businessRegistrationNumber,
//         "charityRegistrationNo": charityRegistrationNo,
//         "phoneNumber": phoneNumber,
//         "address": address,
//         "buildingNo": buildingNo,
//         "streetInfo": streetInfo,
//         "latlon":
//             latlon == null ? [] : List<dynamic>.from(latlon!.map((x) => x)),
//         "BSB": bsb,
//         "accountName": accountName,
//         "swiftCode": swiftCode,
//         "bankName": bankName,
//         "bankCode": bankCode,
//         "branchCode": branchCode,
//         "accountNumber": accountNumber,
//         "facebookLink": facebookLink,
//         "instagramLink": instagramLink,
//         "others": others,
//         "contactPersonFirstName": contactPersonFirstName,
//         "contactPersonLastName": contactPersonLastName,
//         "contactEmail": contactEmail,
//         "contactPhoneNumber": contactPhoneNumber,
//         "postCode": postCode,
//         "townOrCity": townOrCity,
//         "notes": notes,
//         "rejectReason": rejectReason,
//         "registrationStatus": registrationStatus,
//         "agreedTermAndCondition": agreedTermAndCondition,
//         "verifiedDate": verifiedDate?.toIso8601String(),
//         "priorityOrder": priorityOrder,
//         "createdAt": createdAt?.toIso8601String(),
//         "countryId": countryId,
//         "stateId": stateId,
//         "regionId": regionId,
//         "areaId": areaId,
//         "signerId": signerId,
//         "isCreatedByAdmin": isCreatedByAdmin,
//         "signerType": signerType,
//         "whiteLabelId": whiteLabelId,
//         "canCreateMerchant": canCreateMerchant,
//         "__country__": country?.toJson(),
//         "__state__": state?.toJson(),
//         "__region__": region?.toJson(),
//         "__area__": area?.toJson(),
//         // "__charityMultilinguals__": charityMultilinguals == null
//         //     ? []
//         //     : List<dynamic>.from(charityMultilinguals!.map((x) => x.toJson())),
//       };
// }

// class Area {
//   final int? id;
//   final bool? isPiiinkArea;
//   final String? areaName;
//   final dynamic imageUrl;
//   final bool? isAssignedToOwner;
//   final DateTime? createdAt;
//   final int? countryId;
//   final int? regionId;
//   final int? stateId;

//   Area({
//     this.id,
//     this.isPiiinkArea,
//     this.areaName,
//     this.imageUrl,
//     this.isAssignedToOwner,
//     this.createdAt,
//     this.countryId,
//     this.regionId,
//     this.stateId,
//   });

//   factory Area.fromJson(Map<String, dynamic> json) => Area(
//         id: json["id"],
//         isPiiinkArea: json["isPiiinkArea"],
//         areaName: json["areaName"],
//         imageUrl: json["imageUrl"],
//         isAssignedToOwner: json["isAssignedToOwner"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         countryId: json["countryId"],
//         regionId: json["regionId"],
//         stateId: json["stateId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "isPiiinkArea": isPiiinkArea,
//         "areaName": areaName,
//         "imageUrl": imageUrl,
//         "isAssignedToOwner": isAssignedToOwner,
//         "createdAt": createdAt?.toIso8601String(),
//         "countryId": countryId,
//         "regionId": regionId,
//         "stateId": stateId,
//       };
// }

// // class CharityMultilinguals {
// //   final int? id;
// //   final String? charityName;
// //   final String? lang;
// //   final String? countryLanguage;
// //   final DateTime? createdAt;
// //   final int? charityId;

// //   CharityMultilinguals({
// //     this.id,
// //     this.charityName,
// //     this.lang,
// //     this.countryLanguage,
// //     this.createdAt,
// //     this.charityId,
// //   });

// //   factory CharityMultilinguals.fromJson(Map<String, dynamic> json) =>
// //       CharityMultilinguals(
// //         id: json["id"],
// //         charityName: json["charityName"],
// //         lang: json["lang"],
// //         countryLanguage: json["countryLanguage"],
// //         createdAt: json["createdAt"] == null
// //             ? null
// //             : DateTime.parse(json["createdAt"]),
// //         charityId: json["charityId"],
// //       );

// //   Map<String, dynamic> toJson() => {
// //         "id": id,
// //         "charityName": charityName,
// //         "lang": lang,
// //         "countryLanguage": countryLanguage,
// //         "createdAt": createdAt?.toIso8601String(),
// //         "charityId": charityId,
// //       };
// // }

// class Country {
//   final int? id;
//   final String? countryName;
//   final String? countryShortName;
//   final String? imageUrl;
//   final String? phonePrefix;
//   final String? transactionCodePrefix;
//   final String? currencyName;
//   final String? currencySymbol;
//   final bool? symbolIsPrefix;
//   final bool? transactionIsEnabled;
//   final dynamic transactionEnableDate;
//   final int? taxationUnitValue;
//   final String? gstDisplayText;
//   final bool? isPiiinkCountry;
//   final bool? isActive;
//   final bool? isAssignedToOwner;
//   final DateTime? createdAt;
//   final String? lang;
//   final bool? langEnable;
//   final String? countryLanguage;
//   final String? timeZone;
//   final String? stripeSecretKey;
//   final String? stripeWebhookSecret;

//   Country({
//     this.id,
//     this.countryName,
//     this.countryShortName,
//     this.imageUrl,
//     this.phonePrefix,
//     this.transactionCodePrefix,
//     this.currencyName,
//     this.currencySymbol,
//     this.symbolIsPrefix,
//     this.transactionIsEnabled,
//     this.transactionEnableDate,
//     this.taxationUnitValue,
//     this.gstDisplayText,
//     this.isPiiinkCountry,
//     this.isActive,
//     this.isAssignedToOwner,
//     this.createdAt,
//     this.lang,
//     this.langEnable,
//     this.countryLanguage,
//     this.timeZone,
//     this.stripeSecretKey,
//     this.stripeWebhookSecret,
//   });

//   factory Country.fromJson(Map<String, dynamic> json) => Country(
//         id: json["id"],
//         countryName: json["countryName"],
//         countryShortName: json["countryShortName"],
//         imageUrl: json["imageUrl"],
//         phonePrefix: json["phonePrefix"],
//         transactionCodePrefix: json["transactionCodePrefix"],
//         currencyName: json["currencyName"],
//         currencySymbol: json["currencySymbol"],
//         symbolIsPrefix: json["symbolIsPrefix"],
//         transactionIsEnabled: json["transactionIsEnabled"],
//         transactionEnableDate: json["transactionEnableDate"],
//         taxationUnitValue: json["taxationUnitValue"],
//         gstDisplayText: json["gstDisplayText"],
//         isPiiinkCountry: json["isPiiinkCountry"],
//         isActive: json["isActive"],
//         isAssignedToOwner: json["isAssignedToOwner"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         lang: json["lang"],
//         langEnable: json["langEnable"],
//         countryLanguage: json["countryLanguage"],
//         timeZone: json["timeZone"],
//         stripeSecretKey: json["stripeSecretKey"],
//         stripeWebhookSecret: json["stripeWebhookSecret"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "countryName": countryName,
//         "countryShortName": countryShortName,
//         "imageUrl": imageUrl,
//         "phonePrefix": phonePrefix,
//         "transactionCodePrefix": transactionCodePrefix,
//         "currencyName": currencyName,
//         "currencySymbol": currencySymbol,
//         "symbolIsPrefix": symbolIsPrefix,
//         "transactionIsEnabled": transactionIsEnabled,
//         "transactionEnableDate": transactionEnableDate,
//         "taxationUnitValue": taxationUnitValue,
//         "gstDisplayText": gstDisplayText,
//         "isPiiinkCountry": isPiiinkCountry,
//         "isActive": isActive,
//         "isAssignedToOwner": isAssignedToOwner,
//         "createdAt": createdAt?.toIso8601String(),
//         "lang": lang,
//         "langEnable": langEnable,
//         "countryLanguage": countryLanguage,
//         "timeZone": timeZone,
//         "stripeSecretKey": stripeSecretKey,
//         "stripeWebhookSecret": stripeWebhookSecret,
//       };
// }

// class Region {
//   final int? id;
//   final bool? isPiiinkRegion;
//   final String? regionName;
//   final dynamic imageUrl;
//   final bool? isAssignedToOwner;
//   final DateTime? createdAt;
//   final int? countryId;
//   final int? stateId;

//   Region({
//     this.id,
//     this.isPiiinkRegion,
//     this.regionName,
//     this.imageUrl,
//     this.isAssignedToOwner,
//     this.createdAt,
//     this.countryId,
//     this.stateId,
//   });

//   factory Region.fromJson(Map<String, dynamic> json) => Region(
//         id: json["id"],
//         isPiiinkRegion: json["isPiiinkRegion"],
//         regionName: json["regionName"],
//         imageUrl: json["imageUrl"],
//         isAssignedToOwner: json["isAssignedToOwner"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         countryId: json["countryId"],
//         stateId: json["stateId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "isPiiinkRegion": isPiiinkRegion,
//         "regionName": regionName,
//         "imageUrl": imageUrl,
//         "isAssignedToOwner": isAssignedToOwner,
//         "createdAt": createdAt?.toIso8601String(),
//         "countryId": countryId,
//         "stateId": stateId,
//       };
// }

// class State {
//   final int? id;
//   final String? stateName;
//   final dynamic stateShortName;
//   final dynamic imageUrl;
//   final bool? isPiiinkState;
//   final bool? isAssignedToOwner;
//   final DateTime? createdAt;
//   final int? taxationUnitValue;
//   final int? countryId;

//   State({
//     this.id,
//     this.stateName,
//     this.stateShortName,
//     this.imageUrl,
//     this.isPiiinkState,
//     this.isAssignedToOwner,
//     this.createdAt,
//     this.taxationUnitValue,
//     this.countryId,
//   });

//   factory State.fromJson(Map<String, dynamic> json) => State(
//         id: json["id"],
//         stateName: json["stateName"],
//         stateShortName: json["stateShortName"],
//         imageUrl: json["imageUrl"],
//         isPiiinkState: json["isPiiinkState"],
//         isAssignedToOwner: json["isAssignedToOwner"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         taxationUnitValue: json["taxationUnitValue"],
//         countryId: json["countryId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "stateName": stateName,
//         "stateShortName": stateShortName,
//         "imageUrl": imageUrl,
//         "isPiiinkState": isPiiinkState,
//         "isAssignedToOwner": isAssignedToOwner,
//         "createdAt": createdAt?.toIso8601String(),
//         "taxationUnitValue": taxationUnitValue,
//         "countryId": countryId,
//       };
// }
