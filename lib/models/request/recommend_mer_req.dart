// To parse this JSON data, do
//
//     final recommendMerchantReqModel = recommendMerchantReqModelFromJson(jsonString);

import 'dart:convert';

RecommendMerchantReqModel recommendMerchantReqModelFromJson(String str) =>
    RecommendMerchantReqModel.fromJson(json.decode(str));

String recommendMerchantReqModelToJson(RecommendMerchantReqModel data) =>
    json.encode(data.toJson());

class RecommendMerchantReqModel {
  final String? username;
  final String? merchantName;
  final String? contactPersonFirstName;
  final String? contactPersonLastName;
  final String? merchantEmail;
  final String? merchantPhoneNumber;
  final String? phoneNumber;
  final String? email;
  final String? city;
  final int? countryId;
  final int? memberId;
  final int? stateId;

  RecommendMerchantReqModel({
    this.username,
    this.merchantName,
    this.contactPersonFirstName,
    this.contactPersonLastName,
    this.merchantEmail,
    this.merchantPhoneNumber,
    this.phoneNumber,
    this.email,
    this.city,
    this.countryId,
    this.memberId,
    this.stateId,
  });

  factory RecommendMerchantReqModel.fromJson(Map<String, dynamic> json) =>
      RecommendMerchantReqModel(
        username: json["username"],
        merchantName: json["merchantName"],
        contactPersonFirstName: json["contactPersonFirstName"],
        contactPersonLastName: json["contactPersonLastName"],
        merchantEmail: json["merchantEmail"],
        merchantPhoneNumber: json["merchantPhoneNumber"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
        city: json["city"],
        countryId: json["countryId"],
        memberId: json["memberId"],
        stateId: json["stateId"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "merchantName": merchantName,
        "contactPersonFirstName": contactPersonFirstName,
        "contactPersonLastName": contactPersonLastName,
        "merchantEmail": merchantEmail,
        "merchantPhoneNumber": merchantPhoneNumber,
        "phoneNumber": phoneNumber,
        "email": email,
        "city": city,
        "countryId": countryId,
        "memberId": memberId,
        "stateId": stateId,
      };
}
