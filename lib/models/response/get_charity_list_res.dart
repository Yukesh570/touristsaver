import 'dart:convert';

AllCharityListResModel allCharityListResModelFromJson(String str) =>
    AllCharityListResModel.fromJson(json.decode(str));

String allCharityListResModelToJson(AllCharityListResModel data) =>
    json.encode(data.toJson());

class AllCharityListResModel {
  AllCharityListResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  factory AllCharityListResModel.fromJson(Map<String, dynamic> json) =>
      AllCharityListResModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  Datum({
    this.id,
    this.charityName,
    this.websiteUrl,
    this.logoUrl,
    this.email,
    this.businessRegistrationNumber,
    this.phonePrefix,
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
  final String? businessRegistrationNumber;
  final String? phonePrefix;
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
  final String? rejectReason;
  final String? registrationStatus;
  final DateTime? verifiedDate;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;
  final int? regionId;
  final int? areaId;
  final int? signerId;
  final String? signerType;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        charityName: json["charityName"],
        websiteUrl: json["websiteUrl"],
        logoUrl: json["logoUrl"],
        email: json["email"],
        businessRegistrationNumber: json["businessRegistrationNumber"],
        phonePrefix: json["phonePrefix"],
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
        verifiedDate: json["verifiedDate"] == null
            ? null
            : DateTime.parse(json["verifiedDate"]),
        createdAt: DateTime.parse(json["createdAt"]),
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
        "businessRegistrationNumber": businessRegistrationNumber,
        "phonePrefix": phonePrefix,
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
        "verifiedDate": verifiedDate?.toIso8601String(),
        "createdAt": createdAt!.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "regionId": regionId,
        "areaId": areaId,
        "signerId": signerId,
        "signerType": signerType,
      };
}
