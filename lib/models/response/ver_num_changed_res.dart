// To parse this JSON data, do
//
//     final verifyChangedNumberResModel = verifyChangedNumberResModelFromJson(jsonString);

import 'dart:convert';

VerifyChangedNumberResModel verifyChangedNumberResModelFromJson(String str) =>
    VerifyChangedNumberResModel.fromJson(json.decode(str));

String verifyChangedNumberResModelToJson(VerifyChangedNumberResModel data) =>
    json.encode(data.toJson());

class VerifyChangedNumberResModel {
  VerifyChangedNumberResModel({
    this.status,
    this.updateResult,
  });

  final String? status;
  final UpdateResult? updateResult;

  factory VerifyChangedNumberResModel.fromJson(Map<String, dynamic> json) =>
      VerifyChangedNumberResModel(
        status: json["status"],
        updateResult: json["updateResult"] == null
            ? null
            : UpdateResult.fromJson(json["updateResult"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "updateResult": updateResult?.toJson(),
      };
}

class UpdateResult {
  UpdateResult({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.password,
    this.postalCode,
    this.phoneNumber,
    this.memberType,
    this.turnedToPremiumDate,
    this.createdAt,
    this.originCountryId,
    this.countryId,
    this.stateId,
    this.issuerCodeId,
    this.whiteLabelId,
    this.charityId,
    this.issuerId,
    this.issuerType,
    this.charity,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? password;
  final String? postalCode;
  final String? phoneNumber;
  final String? memberType;
  final dynamic turnedToPremiumDate;
  final DateTime? createdAt;
  final int? originCountryId;
  final int? countryId;
  final int? stateId;
  final dynamic issuerCodeId;
  final dynamic whiteLabelId;
  final int? charityId;
  final int? issuerId;
  final String? issuerType;
  final Charity? charity;

  factory UpdateResult.fromJson(Map<String, dynamic> json) => UpdateResult(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        password: json["password"],
        postalCode: json["postalCode"],
        phoneNumber: json["phoneNumber"],
        memberType: json["memberType"],
        turnedToPremiumDate: json["turnedToPremiumDate"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        originCountryId: json["originCountryId"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        issuerCodeId: json["issuerCodeId"],
        whiteLabelId: json["whiteLabelId"],
        charityId: json["charityId"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
        charity: json["__charity__"] == null
            ? null
            : Charity.fromJson(json["__charity__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "password": password,
        "postalCode": postalCode,
        "phoneNumber": phoneNumber,
        "memberType": memberType,
        "turnedToPremiumDate": turnedToPremiumDate,
        "createdAt": createdAt?.toIso8601String(),
        "originCountryId": originCountryId,
        "countryId": countryId,
        "stateId": stateId,
        "issuerCodeId": issuerCodeId,
        "whiteLabelId": whiteLabelId,
        "charityId": charityId,
        "issuerId": issuerId,
        "issuerType": issuerType,
        "__charity__": charity?.toJson(),
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
  final dynamic verifiedDate;
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
        registrationStatus: json["registrationStatus"],
        verifiedDate: json["verifiedDate"],
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
        "verifiedDate": verifiedDate,
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "signerId": signerId,
        "signerType": signerType,
      };
}
