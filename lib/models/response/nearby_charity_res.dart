import 'dart:convert';

NearByCharityListResModel nearByCharityListResModelFromJson(String str) =>
    NearByCharityListResModel.fromJson(json.decode(str));

String nearByCharityListResModelToJson(NearByCharityListResModel data) =>
    json.encode(data.toJson());

class NearByCharityListResModel {
  NearByCharityListResModel({
    this.status,
    this.data,
  });

  final String? status;
  final List<Datum>? data;

  factory NearByCharityListResModel.fromJson(Map<String, dynamic> json) =>
      NearByCharityListResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.charityName,
    this.websiteUrl,
    this.logoUrl,
    this.email,
    this.password,
    this.businessRegistrationNumber,
    this.phoneNumber,
    this.address,
    this.buildingNo,
    this.streetInfo,
    this.bankName,
    this.bankCode,
    this.branchCode,
    this.accountNumber,
    this.notes,
    this.rejectReason,
    this.registrationStatus,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.countryId,
    this.stateId,
    this.regionId,
    this.areaId,
    this.signerId,
    this.signerType,
    this.latlon,
    this.isPending,
    this.bsb,
    this.accountName,
    this.swiftCode,
    this.isPiiinkCharity,
    this.verifiedDate,
    this.agreedTermAndCondition,
    this.priorityOrder,
    this.whiteLabelId,
    this.distance,
  });

  final int? id;
  final String? charityName;
  final String? websiteUrl;
  final String? logoUrl;
  final String? email;
  final String? password;
  final String? businessRegistrationNumber;
  final String? phoneNumber;
  final String? address;
  final String? buildingNo;
  final String? streetInfo;
  final String? bankName;
  final String? bankCode;
  final String? branchCode;
  final String? accountNumber;
  final String? notes;
  final dynamic rejectReason;
  final String? registrationStatus;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? signerId;
  final String? signerType;
  final String? latlon;
  final bool? isPending;
  final String? bsb;
  final String? accountName;
  final String? swiftCode;
  final bool? isPiiinkCharity;
  final DateTime? verifiedDate;
  final bool? agreedTermAndCondition;
  final int? priorityOrder;
  final dynamic whiteLabelId;
  final double? distance;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        charityName: json["charityName"],
        websiteUrl: json["websiteUrl"],
        logoUrl: json["logoUrl"],
        email: json["email"],
        password: json["password"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        bankName: json["bankName"],
        bankCode: json["bankCode"],
        branchCode: json["branchCode"],
        accountNumber: json["accountNumber"],
        notes: json["notes"],
        rejectReason: json["rejectReason"],
        registrationStatus: json["registrationStatus"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        regionId: json["regionId"],
        areaId: json["areaId"],
        signerId: json["signerId"],
        signerType: json["signerType"],
        latlon: json["latlon"],
        isPending: json["isPending"],
        bsb: json["BSB"],
        accountName: json["accountName"],
        swiftCode: json["swiftCode"],
        isPiiinkCharity: json["isPiiinkCharity"],
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
        agreedTermAndCondition: json["agreedTermAndCondition"],
        priorityOrder: json["priorityOrder"],
        whiteLabelId: json["whiteLabelId"],
        distance: json["distance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "charityName": charityName,
        "websiteUrl": websiteUrl,
        "logoUrl": logoUrl,
        "email": email,
        "password": password,
        "businessRegistrationNumber": businessRegistrationNumber,
        "phoneNumber": phoneNumber,
        "address": address,
        "buildingNo": buildingNo,
        "streetInfo": streetInfo,
        "bankName": bankName,
        "bankCode": bankCode,
        "branchCode": branchCode,
        "accountNumber": accountNumber,
        "notes": notes,
        "rejectReason": rejectReason,
        "registrationStatus": registrationStatus,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "signerId": signerId,
        "signerType": signerType,
        "latlon": latlon,
        "isPending": isPending,
        "BSB": bsb,
        "accountName": accountName,
        "swiftCode": swiftCode,
        "isPiiinkCharity": isPiiinkCharity,
        "verifiedDate": verifiedDate?.toIso8601String(),
        "agreedTermAndCondition": agreedTermAndCondition,
        "priorityOrder": priorityOrder,
        "whiteLabelId": whiteLabelId,
        "distance": distance,
      };
}
