import 'dart:convert';

CommonResModel commonResModelFromJson(String str) =>
    CommonResModel.fromJson(json.decode(str));

String commonResModelToJson(CommonResModel data) => json.encode(data.toJson());

class CommonResModel {
  final String? status;
  final String? message;

  CommonResModel({
    this.status,
    this.message,
  });

  factory CommonResModel.fromJson(Map<String, dynamic> json) => CommonResModel(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}

SecondCommonResModel secondCommonResModelFromJson(String str) =>
    SecondCommonResModel.fromJson(json.decode(str));

String secondCommonResModelToJson(SecondCommonResModel data) =>
    json.encode(data.toJson());

class SecondCommonResModel {
  final String? status;

  SecondCommonResModel({
    this.status,
  });

  factory SecondCommonResModel.fromJson(Map<String, dynamic> json) =>
      SecondCommonResModel(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
