import 'dart:convert';

VerifyChangedNumberReqModel verifyChangedNumberReqModelFromJson(String str) =>
    VerifyChangedNumberReqModel.fromJson(json.decode(str));

String verifyChangedNumberReqModelToJson(VerifyChangedNumberReqModel data) =>
    json.encode(data.toJson());

class VerifyChangedNumberReqModel {
  VerifyChangedNumberReqModel({
    required this.phoneNumberPrefix,
    required this.phoneNumber,
    required this.smsotp,
  });

  final String phoneNumber;
  final String phoneNumberPrefix;
  final String smsotp;

  factory VerifyChangedNumberReqModel.fromJson(Map<String, dynamic> json) =>
      VerifyChangedNumberReqModel(
        phoneNumber: json["phoneNumber"],
        phoneNumberPrefix: json["phoneNumberPrefix"],
        smsotp: json["SMSOTP"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneNumber": phoneNumber,
        "SMSOTP": smsotp,
      };
}
