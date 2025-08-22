import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'region_get_all.g.dart';

RegionGetAllResModel regionGetAllResModelFromJson(String str) =>
    RegionGetAllResModel.fromJson(json.decode(str));

String regionGetAllResModelToJson(RegionGetAllResModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class RegionGetAllResModel {
  RegionGetAllResModel({
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

  factory RegionGetAllResModel.fromJson(Map<String, dynamic> json) =>
      _$RegionGetAllResModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegionGetAllResModelToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.isPiiinkRegion,
    this.regionName,
    this.imageUrl,
    this.isAssignedToOwner,
    this.createdAt,
    this.countryId,
    this.stateId,
  });

  final int? id;
  final bool? isPiiinkRegion;
  final String? regionName;
  final dynamic imageUrl;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;
  final int? countryId;
  final int? stateId;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
