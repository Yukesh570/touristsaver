import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'state_get_all.g.dart';

StateGetAllResModel stateGetAllResModelFromJson(String str) =>
    StateGetAllResModel.fromJson(json.decode(str));

String stateGetAllResModelToJson(StateGetAllResModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class StateGetAllResModel {
  StateGetAllResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  factory StateGetAllResModel.fromJson(Map<String, dynamic> json) =>
      _$StateGetAllResModelFromJson(json);

  Map<String, dynamic> toJson() => _$StateGetAllResModelToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.stateName,
    this.stateShortName,
    this.imageUrl,
    this.isPiiinkState,
    this.isAssignedToOwner,
    this.createdAt,
    this.countryId,
    this.country,
  });

  final int? id;
  final String? stateName;
  final String? stateShortName;
  final dynamic imageUrl;
  final bool? isPiiinkState;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final int? countryId;
  final Country? country;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}

@JsonSerializable()
class Country {
  Country({
    this.id,
    this.countryName,
    this.phonePrefix,
  });

  final int? id;
  final String? countryName;
  final String? phonePrefix;

  factory Country.fromJson(Map<String, dynamic> json) =>
      _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);
}
