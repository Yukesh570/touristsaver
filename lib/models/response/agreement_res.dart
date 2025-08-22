import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'agreement_res.g.dart';

AgreementResModel agreementResModelFromJson(String str) =>
    AgreementResModel.fromJson(json.decode(str));

String agreementResModelToJson(AgreementResModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AgreementResModel {
  AgreementResModel({
    this.status,
    this.data,
  });

  final String? status;
  final Data? data;

  factory AgreementResModel.fromJson(Map<String, dynamic> json) =>
      _$AgreementResModelFromJson(json);

  Map<String, dynamic> toJson() => _$AgreementResModelToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    this.id,
    this.title,
    this.slug,
    this.description,
    this.role,
    this.countryId,
  });

  final int? id;
  final String? title;
  final String? slug;
  final String? description;
  final String? role;
  final int? countryId;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}
