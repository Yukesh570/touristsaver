// To parse this JSON data, do
//
//     final getAllCharitiesResModel = getAllCharitiesResModelFromJson(jsonString);

import 'dart:convert';

GetAllCharitiesResModel getAllCharitiesResModelFromJson(String str) =>
    GetAllCharitiesResModel.fromJson(json.decode(str));

String getAllCharitiesResModelToJson(GetAllCharitiesResModel data) =>
    json.encode(data.toJson());

class GetAllCharitiesResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  GetAllCharitiesResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory GetAllCharitiesResModel.fromJson(Map<String, dynamic> json) =>
      GetAllCharitiesResModel(
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
  final String? swiftCode;
  final String? bankName;
  final String? bankCode;
  final String? branchCode;
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
  final DateTime? verifiedDate;
  final int? priorityOrder;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? signerId;
  final bool? isCreatedByAdmin;
  final String? signerType;
  final int? whiteLabelId;
  final bool? canCreateMerchant;
  final Country? country;
  final Signer? signer;
  final String? issuerCode;

  Datum({
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
    this.signer,
    this.issuerCode,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
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
        signer: json["__signer__"] == null
            ? null
            : Signer.fromJson(json["__signer__"]),
        issuerCode: json["issuerCode"],
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
        "verifiedDate": verifiedDate?.toIso8601String(),
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
        "__signer__": signer?.toJson(),
        "issuerCode": issuerCode,
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

class Signer {
  final int? id;
  final bool? isCompany;
  final String? companyName;
  final String? companyEmail;
  final String? address;
  final String? businessRegistrationNumber;
  final String? companyPhonePrefix;
  final String? companyPhoneNumber;
  final String? primaryContactName;
  final String? primaryContactPhonePrefix;
  final String? primaryContactPhoneNumber;
  final String? email;
  final String? bsb;
  final String? accountName;
  final String? swiftCode;
  final String? bankName;
  final String? bankCode;
  final String? branchCode;
  final String? accountNumber;
  final String? notes;
  final String? rejectReason;
  final String? agreementUrl;
  final String? registrationStatus;
  final bool? agreedTermAndCondition;
  final DateTime? verifiedDate;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateOwnerAllocationPercentage;
  final int? stateId;
  final dynamic requestedAreaName;
  final int? areaOwnerAllocationPercentage;
  final int? regionId;
  final int? areaId;
  final String? requestedRegionName;
  final int? regionOwnerAllocationPercentage;
  final bool? canIssueMember;
  final bool? canSignMerchant;
  final bool? canReferCollaborationPartner;
  final String? name;
  final String? username;
  final String? contactPhonePrefix;
  final String? contactPhoneNumber;
  final bool? isImported;
  final bool? emailSent;
  final int? whiteLabelId;
  final int? whiteLabelPositionId;
  final int? userSignerId;
  final int? parentId;
  final bool? bulkEmailSend;
  final String? salesAgentName;
  final String? phonePrefix;
  final String? phoneNumber;
  final String? postalCode;
  final String? salesAgentType;
  final String? partnerType;
  final bool? paymentAwaiting;
  final String? cpPaymentMethod;
  final bool? isReferredAsCp;
  final int? referredBy;
  final String? refererType;
  final DateTime? referredDate;
  final DateTime? paymentDate;
  final DateTime? upgradedToCpDate;
  final bool? isUpgradedToCp;
  final dynamic upgradedToAssociateDate;
  final int? collaborationPackageId;

  Signer({
    this.id,
    this.isCompany,
    this.companyName,
    this.companyEmail,
    this.address,
    this.businessRegistrationNumber,
    this.companyPhonePrefix,
    this.companyPhoneNumber,
    this.primaryContactName,
    this.primaryContactPhonePrefix,
    this.primaryContactPhoneNumber,
    this.email,
    this.bsb,
    this.accountName,
    this.swiftCode,
    this.bankName,
    this.bankCode,
    this.branchCode,
    this.accountNumber,
    this.notes,
    this.rejectReason,
    this.agreementUrl,
    this.registrationStatus,
    this.agreedTermAndCondition,
    this.verifiedDate,
    this.createdAt,
    this.countryId,
    this.stateOwnerAllocationPercentage,
    this.stateId,
    this.requestedAreaName,
    this.areaOwnerAllocationPercentage,
    this.regionId,
    this.areaId,
    this.requestedRegionName,
    this.regionOwnerAllocationPercentage,
    this.canIssueMember,
    this.canSignMerchant,
    this.canReferCollaborationPartner,
    this.name,
    this.username,
    this.contactPhonePrefix,
    this.contactPhoneNumber,
    this.isImported,
    this.emailSent,
    this.whiteLabelId,
    this.whiteLabelPositionId,
    this.userSignerId,
    this.parentId,
    this.bulkEmailSend,
    this.salesAgentName,
    this.phonePrefix,
    this.phoneNumber,
    this.postalCode,
    this.salesAgentType,
    this.partnerType,
    this.paymentAwaiting,
    this.cpPaymentMethod,
    this.isReferredAsCp,
    this.referredBy,
    this.refererType,
    this.referredDate,
    this.paymentDate,
    this.upgradedToCpDate,
    this.isUpgradedToCp,
    this.upgradedToAssociateDate,
    this.collaborationPackageId,
  });

  factory Signer.fromJson(Map<String, dynamic> json) => Signer(
        id: json["id"],
        isCompany: json["isCompany"],
        companyName: json["companyName"],
        companyEmail: json["companyEmail"],
        address: json["address"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        companyPhonePrefix: json["companyPhonePrefix"],
        companyPhoneNumber: json["companyPhoneNumber"],
        primaryContactName: json["primaryContactName"],
        primaryContactPhonePrefix: json["primaryContactPhonePrefix"],
        primaryContactPhoneNumber: json["primaryContactPhoneNumber"],
        email: json["email"],
        bsb: json["BSB"],
        accountName: json["accountName"],
        swiftCode: json["swiftCode"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        branchCode: json["branchCode"],
        accountNumber: json["accountNumber"],
        notes: json["notes"],
        rejectReason: json["rejectReason"],
        agreementUrl: json["agreementUrl"],
        registrationStatus: json["registrationStatus"],
        agreedTermAndCondition: json["agreedTermAndCondition"],
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateOwnerAllocationPercentage: json["stateOwnerAllocationPercentage"],
        stateId: json["stateId"],
        requestedAreaName: json["requestedAreaName"],
        areaOwnerAllocationPercentage: json["areaOwnerAllocationPercentage"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        requestedRegionName: json["requestedRegionName"],
        regionOwnerAllocationPercentage:
            json["regionOwnerAllocationPercentage"],
        canIssueMember: json["canIssueMember"],
        canSignMerchant: json["canSignMerchant"],
        canReferCollaborationPartner: json["canReferCollaborationPartner"],
        name: json["name"],
        username: json["username"],
        contactPhonePrefix: json["contactPhonePrefix"],
        contactPhoneNumber: json["contactPhoneNumber"],
        isImported: json["isImported"],
        emailSent: json["emailSent"],
        whiteLabelId: json["whiteLabelId"],
        whiteLabelPositionId: json["whiteLabelPositionId"],
        userSignerId: json["userSignerId"],
        parentId: json["parentId"],
        bulkEmailSend: json["bulkEmailSend"],
        salesAgentName: json["salesAgentName"],
        phonePrefix: json["phonePrefix"],
        phoneNumber: json["phoneNumber"],
        postalCode: json["postalCode"],
        salesAgentType: json["salesAgentType"],
        partnerType: json["partnerType"],
        paymentAwaiting: json["paymentAwaiting"],
        cpPaymentMethod: json["cpPaymentMethod"],
        isReferredAsCp: json["isReferredAsCP"],
        referredBy: json["referredBy"],
        refererType: json["refererType"],
        referredDate: json["referredDate"] == null
            ? null
            : DateTime.parse(json["referredDate"]),
        paymentDate: json["paymentDate"] == null
            ? null
            : DateTime.parse(json["paymentDate"]),
        upgradedToCpDate: json["upgradedToCPDate"] == null
            ? null
            : DateTime.parse(json["upgradedToCPDate"]),
        isUpgradedToCp: json["isUpgradedToCP"],
        upgradedToAssociateDate: json["upgradedToAssociateDate"],
        collaborationPackageId: json["collaborationPackageId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isCompany": isCompany,
        "companyName": companyName,
        "companyEmail": companyEmail,
        "address": address,
        "businessRegistrationNumber": businessRegistrationNumber,
        "companyPhonePrefix": companyPhonePrefix,
        "companyPhoneNumber": companyPhoneNumber,
        "primaryContactName": primaryContactName,
        "primaryContactPhonePrefix": primaryContactPhonePrefix,
        "primaryContactPhoneNumber": primaryContactPhoneNumber,
        "email": email,
        "BSB": bsb,
        "accountName": accountName,
        "swiftCode": swiftCode,
        "bankName": bankName,
        "bankCode": bankCode,
        "branchCode": branchCode,
        "accountNumber": accountNumber,
        "notes": notes,
        "rejectReason": rejectReason,
        "agreementUrl": agreementUrl,
        "registrationStatus": registrationStatus,
        "agreedTermAndCondition": agreedTermAndCondition,
        "verifiedDate": verifiedDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateOwnerAllocationPercentage": stateOwnerAllocationPercentage,
        "stateId": stateId,
        "requestedAreaName": requestedAreaName,
        "areaOwnerAllocationPercentage": areaOwnerAllocationPercentage,
        "regionId": regionId,
        "areaId": areaId,
        "requestedRegionName": requestedRegionName,
        "regionOwnerAllocationPercentage": regionOwnerAllocationPercentage,
        "canIssueMember": canIssueMember,
        "canSignMerchant": canSignMerchant,
        "canReferCollaborationPartner": canReferCollaborationPartner,
        "name": name,
        "username": username,
        "contactPhonePrefix": contactPhonePrefix,
        "contactPhoneNumber": contactPhoneNumber,
        "isImported": isImported,
        "emailSent": emailSent,
        "whiteLabelId": whiteLabelId,
        "whiteLabelPositionId": whiteLabelPositionId,
        "userSignerId": userSignerId,
        "parentId": parentId,
        "bulkEmailSend": bulkEmailSend,
        "salesAgentName": salesAgentName,
        "phonePrefix": phonePrefix,
        "phoneNumber": phoneNumber,
        "postalCode": postalCode,
        "salesAgentType": salesAgentType,
        "partnerType": partnerType,
        "paymentAwaiting": paymentAwaiting,
        "cpPaymentMethod": cpPaymentMethod,
        "isReferredAsCP": isReferredAsCp,
        "referredBy": referredBy,
        "refererType": refererType,
        "referredDate": referredDate?.toIso8601String(),
        "paymentDate": paymentDate?.toIso8601String(),
        "upgradedToCPDate": upgradedToCpDate?.toIso8601String(),
        "isUpgradedToCP": isUpgradedToCp,
        "upgradedToAssociateDate": upgradedToAssociateDate,
        "collaborationPackageId": collaborationPackageId,
      };
}
