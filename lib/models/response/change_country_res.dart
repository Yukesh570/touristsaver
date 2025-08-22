// To parse this JSON data, do
//
//     final changeCountryResModel = changeCountryResModelFromJson(jsonString);

import 'dart:convert';

ChangeCountryResModel changeCountryResModelFromJson(String str) =>
    ChangeCountryResModel.fromJson(json.decode(str));

String changeCountryResModelToJson(ChangeCountryResModel data) =>
    json.encode(data.toJson());

class ChangeCountryResModel {
  ChangeCountryResModel({
    this.status,
    this.member,
    this.smsotpRequired,
  });

  final String? status;
  final Member? member;
  final bool? smsotpRequired;

  factory ChangeCountryResModel.fromJson(Map<String, dynamic> json) =>
      ChangeCountryResModel(
        status: json["status"],
        member: json["member"] == null ? null : Member.fromJson(json["member"]),
        smsotpRequired: json["SMSOTPRequired"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "member": member?.toJson(),
        "SMSOTPRequired": smsotpRequired,
      };
}

class Member {
  Member({
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

  factory Member.fromJson(Map<String, dynamic> json) => Member(
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
      };
}
