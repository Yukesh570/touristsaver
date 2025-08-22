import 'dart:convert';

UniversalGetMyWallet universalGetMyWalletFromJson(String str) =>
    UniversalGetMyWallet.fromJson(json.decode(str));

class UniversalGetMyWallet {
  String? status;
  Data? data;

  UniversalGetMyWallet({
    this.status,
    this.data,
  });

  factory UniversalGetMyWallet.fromJson(Map<String, dynamic> json) =>
      UniversalGetMyWallet(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  int? id;
  double? balance;
  DateTime? premiumExpiryDate;
  DateTime? createdAt;
  int? memberId;
  int? countryId;
  bool? canClaimFreePiiinks;
  bool? isFreePiiinksProvided;
  bool? isTopUpOnRegister;

  Data(
      {this.id,
      this.balance,
      this.premiumExpiryDate,
      this.createdAt,
      this.memberId,
      this.countryId,
      this.canClaimFreePiiinks,
      this.isTopUpOnRegister,
      this.isFreePiiinksProvided});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        balance: json["balance"]?.toDouble(),
        canClaimFreePiiinks: json["canClaimFreePiiinks"],
        isFreePiiinksProvided: json["isFreePiiinksProvided"],
        isTopUpOnRegister: json["isTopUpOnRegister"],
        premiumExpiryDate: json["premiumExpiryDate"] == null
            ? null
            : DateTime.parse(json["premiumExpiryDate"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        memberId: json["memberId"],
        countryId: json["countryId"],
      );
}
