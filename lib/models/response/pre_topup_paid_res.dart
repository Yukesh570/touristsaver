import 'dart:convert';

PremiumTopUpPaidResModel premiumTopUpPaidResModelFromJson(String str) =>
    PremiumTopUpPaidResModel.fromJson(json.decode(str));

String premiumTopUpPaidResModelToJson(PremiumTopUpPaidResModel data) =>
    json.encode(data.toJson());

class PremiumTopUpPaidResModel {
  PremiumTopUpPaidResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory PremiumTopUpPaidResModel.fromJson(Map<String, dynamic> json) =>
      PremiumTopUpPaidResModel(
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
    this.premiumCodeIsPaid,
    this.membershipPackageId,
    this.piiinksAmount,
  });

  final bool? premiumCodeIsPaid;
  final int? membershipPackageId;
  final double? piiinksAmount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        premiumCodeIsPaid: json["premiumCodeIsPaid"],
        membershipPackageId: json["membershipPackageId"],
        piiinksAmount: json["piiinksAmount"],
      );

  Map<String, dynamic> toJson() => {
        "premiumCodeIsPaid": premiumCodeIsPaid,
        "membershipPackageId": membershipPackageId,
        "piiinksAmount": piiinksAmount,
      };
}
