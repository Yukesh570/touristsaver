// To parse this JSON data, do
//
//     final premiumTopUpFreeResModel = premiumTopUpFreeResModelFromJson(jsonString);

import 'dart:convert';

PremiumTopUpFreeResModel premiumTopUpFreeResModelFromJson(String str) =>
    PremiumTopUpFreeResModel.fromJson(json.decode(str));

String premiumTopUpFreeResModelToJson(PremiumTopUpFreeResModel data) =>
    json.encode(data.toJson());

class PremiumTopUpFreeResModel {
  final String? status;
  final String? message;
  final Data? data;

  PremiumTopUpFreeResModel({
    this.status,
    this.message,
    this.data,
  });

  factory PremiumTopUpFreeResModel.fromJson(Map<String, dynamic> json) =>
      PremiumTopUpFreeResModel(
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
  final UniversalWallet? universalWallet;
  final bool? premiumCodeIsPaid;
  final int? membershipPackageId;
  final int? piiinksAmount;

  Data({
    this.universalWallet,
    this.premiumCodeIsPaid,
    this.membershipPackageId,
    this.piiinksAmount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        universalWallet: json["universalWallet"] == null
            ? null
            : UniversalWallet.fromJson(json["universalWallet"]),
        premiumCodeIsPaid: json["premiumCodeIsPaid"],
        membershipPackageId: json["membershipPackageId"],
        piiinksAmount: json["piiinksAmount"],
      );

  Map<String, dynamic> toJson() => {
        "universalWallet": universalWallet?.toJson(),
        "premiumCodeIsPaid": premiumCodeIsPaid,
        "membershipPackageId": membershipPackageId,
        "piiinksAmount": piiinksAmount,
      };
}

class UniversalWallet {
  final int? id;
  final double? balance;
  final DateTime? premiumExpiryDate;
  final DateTime? createdAt;
  final int? memberId;
  final int? countryId;
  final bool? canClaimFreePiiinks;
  final bool? isFreePiiinksProvided;
  final bool? isTopUpOnRegister;

  UniversalWallet({
    this.id,
    this.balance,
    this.premiumExpiryDate,
    this.createdAt,
    this.memberId,
    this.countryId,
    this.canClaimFreePiiinks,
    this.isFreePiiinksProvided,
    this.isTopUpOnRegister,
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
        canClaimFreePiiinks: json["canClaimFreePiiinks"],
        isFreePiiinksProvided: json["isFreePiiinksProvided"],
        isTopUpOnRegister: json["isTopUpOnRegister"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "balance": balance,
        "premiumExpiryDate": premiumExpiryDate?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "memberId": memberId,
        "countryId": countryId,
        "canClaimFreePiiinks": canClaimFreePiiinks,
        "isFreePiiinksProvided": isFreePiiinksProvided,
        "isTopUpOnRegister": isTopUpOnRegister,
      };
}

// import 'dart:convert';

// PremiumTopUpFreeResModel premiumTopUpFreeResModelFromJson(String str) =>
//     PremiumTopUpFreeResModel.fromJson(json.decode(str));

// String premiumTopUpFreeResModelToJson(PremiumTopUpFreeResModel data) =>
//     json.encode(data.toJson());

// class PremiumTopUpFreeResModel {
//   PremiumTopUpFreeResModel({
//     this.status,
//     this.message,
//     this.data,
//   });

//   final String? status;
//   final String? message;
//   final Data? data;

//   factory PremiumTopUpFreeResModel.fromJson(Map<String, dynamic> json) =>
//       PremiumTopUpFreeResModel(
//         status: json["status"],
//         message: json["message"],
//         data: json["data"] == null ? null : Data.fromJson(json["data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "message": message,
//         "data": data?.toJson(),
//       };
// }

// class Data {
//   Data({
//     this.universalWallet,
//     this.premiumCodeIsPaid,
//     this.membershipPackageId,
//     this.piiinksAmount,
//   });

//   final UniversalWallet? universalWallet;
//   final bool? premiumCodeIsPaid;
//   final int? membershipPackageId;
//   final double? piiinksAmount;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         universalWallet: json["universalWallet"] == null
//             ? null
//             : UniversalWallet.fromJson(json["universalWallet"]),
//         premiumCodeIsPaid: json["premiumCodeIsPaid"],
//         membershipPackageId: json["membershipPackageId"],
//         piiinksAmount: json["piiinksAmount"],
//       );

//   Map<String, dynamic> toJson() => {
//         "universalWallet": universalWallet?.toJson(),
//         "premiumCodeIsPaid": premiumCodeIsPaid,
//         "membershipPackageId": membershipPackageId,
//         "piiinksAmount": piiinksAmount,
//       };
// }

// class UniversalWallet {
//   UniversalWallet({
//     this.id,
//     this.balance,
//     this.premiumExpiryDate,
//     this.createdAt,
//     this.memberId,
//     this.countryId,
//   });

//   final int? id;
//   final double? balance;
//   final DateTime? premiumExpiryDate;
//   final DateTime? createdAt;
//   final int? memberId;
//   final int? countryId;

//   factory UniversalWallet.fromJson(Map<String, dynamic> json) =>
//       UniversalWallet(
//         id: json["id"],
//         balance: json["balance"] == null
//             ? null
//             : double.tryParse(json["balance"].toString()),
//         premiumExpiryDate: json["premiumExpiryDate"] == null
//             ? null
//             : DateTime.parse(json["premiumExpiryDate"]),
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         memberId: json["memberId"],
//         countryId: json["countryId"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "balance": balance,
//         "premiumExpiryDate": premiumExpiryDate?.toIso8601String(),
//         "createdAt": createdAt?.toIso8601String(),
//         "memberId": memberId,
//         "countryId": countryId,
//       };
// }
