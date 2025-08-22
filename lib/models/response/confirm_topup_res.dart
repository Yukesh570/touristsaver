// To parse this JSON data, do
//
//     final confirmTopUpResModel = confirmTopUpResModelFromJson(jsonString);

import 'dart:convert';

ConfirmTopUpResModel confirmTopUpResModelFromJson(String str) =>
    ConfirmTopUpResModel.fromJson(json.decode(str));

String confirmTopUpResModelToJson(ConfirmTopUpResModel data) =>
    json.encode(data.toJson());

class ConfirmTopUpResModel {
  final String? status;
  final String? message;
  final Data? data;

  ConfirmTopUpResModel({
    this.status,
    this.message,
    this.data,
  });

  factory ConfirmTopUpResModel.fromJson(Map<String, dynamic> json) =>
      ConfirmTopUpResModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final String? accessToken;
  final MemberInfo? memberInfo;
  final UniversalWallet? universalWallet;

  Data({
    this.accessToken,
    this.memberInfo,
    this.universalWallet,
  });

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
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? uniqueMemberCode;
  final String? email;
  final String? postalCode;
  final String? phoneNumber;
  final String? memberType;
  final DateTime? turnedToPremiumDate;
  final DateTime? createdAt;
  final int? originCountryId;
  final int? countryId;
  final int? stateId;
  final int? issuerCodeId;
  final bool? referrerMemberRewarded;
  final dynamic referrerMemberId;
  final int? whiteLabelId;
  final dynamic charityId;
  final int? issuerId;
  final String? issuerType;

  MemberInfo({
    this.id,
    this.firstname,
    this.lastname,
    this.uniqueMemberCode,
    this.email,
    this.postalCode,
    this.phoneNumber,
    this.memberType,
    this.turnedToPremiumDate,
    this.createdAt,
    this.originCountryId,
    this.countryId,
    this.stateId,
    this.issuerCodeId,
    this.referrerMemberRewarded,
    this.referrerMemberId,
    this.whiteLabelId,
    this.charityId,
    this.issuerId,
    this.issuerType,
  });

  factory MemberInfo.fromJson(Map<String, dynamic> json) => MemberInfo(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        uniqueMemberCode: json["uniqueMemberCode"],
        email: json["email"],
        postalCode: json["postalCode"],
        phoneNumber: json["phoneNumber"],
        memberType: json["memberType"],
        turnedToPremiumDate: json["turnedToPremiumDate"] == null
            ? null
            : DateTime.parse(json["turnedToPremiumDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        originCountryId: json["originCountryId"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        issuerCodeId: json["issuerCodeId"],
        referrerMemberRewarded: json["referrerMemberRewarded"],
        referrerMemberId: json["referrerMemberId"],
        whiteLabelId: json["whiteLabelId"],
        charityId: json["charityId"],
        issuerId: json["issuerId"],
        issuerType: json["issuerType"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstname": firstname,
        "lastname": lastname,
        "uniqueMemberCode": uniqueMemberCode,
        "email": email,
        "postalCode": postalCode,
        "phoneNumber": phoneNumber,
        "memberType": memberType,
        "turnedToPremiumDate": turnedToPremiumDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "originCountryId": originCountryId,
        "countryId": countryId,
        "stateId": stateId,
        "issuerCodeId": issuerCodeId,
        "referrerMemberRewarded": referrerMemberRewarded,
        "referrerMemberId": referrerMemberId,
        "whiteLabelId": whiteLabelId,
        "charityId": charityId,
        "issuerId": issuerId,
        "issuerType": issuerType,
      };
}

class UniversalWallet {
  final int? id;
  final double? balance;
  final DateTime? premiumExpiryDate;
  final DateTime? createdAt;
  final int? memberId;
  final int? countryId;

  UniversalWallet({
    this.id,
    this.balance,
    this.premiumExpiryDate,
    this.createdAt,
    this.memberId,
    this.countryId,
  });

  factory UniversalWallet.fromJson(Map<String, dynamic> json) =>
      UniversalWallet(
        id: json["id"],
        balance: json["balance"]?.toDouble(),
        premiumExpiryDate: json["premiumExpiryDate"] == null
            ? null
            : DateTime.parse(json["premiumExpiryDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        memberId: json["memberId"],
        countryId: json["countryId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "premiumExpiryDate": premiumExpiryDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "memberId": memberId,
        "countryId": countryId,
      };
}
