// To parse this JSON data, do
//
//     final checkIssuerCodeResModel = checkIssuerCodeResModelFromJson(jsonString);

import 'dart:convert';

CheckIssuerCodeResModel checkIssuerCodeResModelFromJson(String str) =>
    CheckIssuerCodeResModel.fromJson(json.decode(str));

String checkIssuerCodeResModelToJson(CheckIssuerCodeResModel data) =>
    json.encode(data.toJson());

class CheckIssuerCodeResModel {
  CheckIssuerCodeResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory CheckIssuerCodeResModel.fromJson(Map<String, dynamic> json) =>
      CheckIssuerCodeResModel(
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
    this.id,
    this.requestedRegionName,
    this.isCompany,
    this.companyName,
    this.companyEmail,
    this.companyPhonePrefix,
    this.companyPhoneNumber,
    this.email,
    this.primaryContactName,
    this.primaryContactPhonePrefix,
    this.primaryContactPhoneNumber,
    this.businessRegistrationNumber,
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
    this.createdAt,
    this.countryId,
    this.stateId,
    this.regionId,
  });

  final int? id;
  final String? requestedRegionName;
  final bool? isCompany;
  final String? companyName;
  final String? companyEmail;
  final dynamic companyPhonePrefix;
  final dynamic companyPhoneNumber;
  final String? email;
  final String? primaryContactName;
  final dynamic primaryContactPhonePrefix;
  final dynamic primaryContactPhoneNumber;
  final String? businessRegistrationNumber;
  final String? bsb;
  final String? accountName;
  final dynamic swiftCode;
  final String? bankName;
  final String? bankCode;
  final String? branchCode;
  final String? accountNumber;
  final String? notes;
  final String? rejectReason;
  final String? registrationStatus;
  final bool? agreedTermAndCondition;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        requestedRegionName: json["requestedRegionName"],
        isCompany: json["isCompany"],
        companyName: json["companyName"],
        companyEmail: json["companyEmail"],
        companyPhonePrefix: json["companyPhonePrefix"],
        companyPhoneNumber: json["companyPhoneNumber"],
        email: json["email"],
        primaryContactName: json["primaryContactName"],
        primaryContactPhonePrefix: json["primaryContactPhonePrefix"],
        primaryContactPhoneNumber: json["primaryContactPhoneNumber"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
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
        agreedTermAndCondition: json["agreedTermAndCondition"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "requestedRegionName": requestedRegionName,
        "isCompany": isCompany,
        "companyName": companyName,
        "companyEmail": companyEmail,
        "companyPhonePrefix": companyPhonePrefix,
        "companyPhoneNumber": companyPhoneNumber,
        "email": email,
        "primaryContactName": primaryContactName,
        "primaryContactPhonePrefix": primaryContactPhonePrefix,
        "primaryContactPhoneNumber": primaryContactPhoneNumber,
        "businessRegistrationNumber": businessRegistrationNumber,
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
        "createdAt": createdAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
      };
}
