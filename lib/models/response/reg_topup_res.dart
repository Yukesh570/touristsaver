// To parse this JSON data, do
//
//     final regTopUpResModel = regTopUpResModelFromJson(jsonString);

import 'dart:convert';

RegTopUpResModel regTopUpResModelFromJson(String str) =>
    RegTopUpResModel.fromJson(json.decode(str));

String regTopUpResModelToJson(RegTopUpResModel data) =>
    json.encode(data.toJson());

class RegTopUpResModel {
  RegTopUpResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory RegTopUpResModel.fromJson(Map<String, dynamic> json) =>
      RegTopUpResModel(
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
    this.accessToken,
    this.memberInfo,
    this.universalWallet,
  });

  final String? accessToken;
  final MemberInfo? memberInfo;
  final UniversalWallet? universalWallet;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        accessToken: json["accessToken"],
        memberInfo: json["memberInfo"] == null
            ? null
            : MemberInfo.fromJson(json["memberInfo"]),
        universalWallet: json["universalWallet"] == null
            ? null
            : UniversalWallet.fromJson(json["universalWallet"]),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "memberInfo": memberInfo?.toJson(),
        "universalWallet": universalWallet?.toJson(),
      };
}

class MemberInfo {
  MemberInfo({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.postalCode,
    this.phoneNumber,
    this.memberType,
    this.turnedToPremiumDate,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.countryId,
    this.stateId,
    this.issuerCodeId,
    this.whiteLabelId,
    this.issuerId,
    this.issuerType,
    this.charityId,
    this.originCountryId,
    this.password,
    this.passwordResetOtp,
  });

  final int? id;
  final String? firstname;
  final String? lastname;
  final String? email;
  final String? postalCode;
  final String? phoneNumber;
  final String? memberType;
  final DateTime? turnedToPremiumDate;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? countryId;
  final int? stateId;
  final int? issuerCodeId;
  final dynamic whiteLabelId;
  final int? issuerId;
  final String? issuerType;
  final dynamic charityId;
  final int? originCountryId;
  final String? password;
  final dynamic passwordResetOtp;

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        email: json["email"],
        postalCode: json["postalCode"],
        phoneNumber: json["phoneNumber"],
        memberType: json["memberType"],
        turnedToPremiumDate: json["turnedToPremiumDate"] == null
            ? null
            : DateTime.parse(json["turnedToPremiumDate"]),
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        countryId: json["countryId"],
        stateId: json["stateId"],
        issuerCodeId: json["issuerCodeId"],
        whiteLabelId: json["whiteLabelId"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
        charityId: json["charityId"],
        originCountryId: json["originCountryId"],
        password: json["password"],
        passwordResetOtp: json["passwordResetOTP"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "postalCode": postalCode,
        "phoneNumber": phoneNumber,
        "memberType": memberType,
        "turnedToPremiumDate": turnedToPremiumDate?.toIso8601String(),
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "countryId": countryId,
        "stateId": stateId,
        "issuerCodeId": issuerCodeId,
        "whiteLabelId": whiteLabelId,
        "issuerId": issuerId,
        "issuerType": issuerType,
        "charityId": charityId,
        "originCountryId": originCountryId,
        "password": password,
        "passwordResetOTP": passwordResetOtp,
      };
}

class UniversalWallet {
  UniversalWallet({
    this.id,
    this.balance,
    this.createdAt,
    this.updatedAt,
    this.memberId,
    this.countryId,
    this.deletedAt,
    this.premiumExpiryDate,
  });

  final int? id;
  final double? balance;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? memberId;
  final int? countryId;
  final DateTime? deletedAt;
  final DateTime? premiumExpiryDate;

  factory UniversalWallet.fromJson(Map<String, dynamic> json) =>
      UniversalWallet(
        id: json["id"],
        balance: json["balance"].toDouble(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        memberId: json["memberId"],
        countryId: json["countryId"],
        deletedAt: json["deletedAt"] == null
            ? null
            : DateTime.parse(json["deletedAt"]),
        premiumExpiryDate: json["premiumExpiryDate"] == null
            ? null
            : DateTime.parse(json["premiumExpiryDate"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "memberId": memberId,
        "countryId": countryId,
        "deletedAt": deletedAt?.toIso8601String(),
        "premiumExpiryDate": premiumExpiryDate?.toIso8601String(),
      };
}
