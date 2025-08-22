import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'location_get_all.g.dart';

LocationGetAllResModel locationGetAllResModelFromJson(String str) =>
    LocationGetAllResModel.fromJson(json.decode(str));

String locationGetAllResModelToJson(LocationGetAllResModel data) =>
    json.encode(data.toJson());

@JsonSerializable()
class LocationGetAllResModel {
  LocationGetAllResModel({
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

  factory LocationGetAllResModel.fromJson(Map<String, dynamic> json) =>
      _$LocationGetAllResModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationGetAllResModelToJson(this);
}

@JsonSerializable()
class Datum {
  Datum({
    this.id,
    this.countryName,
    this.countryShortName,
    this.imageUrl,
    this.phonePrefix,
    this.transactionCodePrefix,
    this.currencyName,
    this.currencySymbol,
    this.symbolIsPrefix,
    this.transactionIsEnabled,
    this.transactionEnableDate,
    this.taxationUnitValue,
    this.isPiiinkCountry,
    this.isAssignedToOwner,
    this.createdAt,
  });

  final int? id;
  final String? countryName;
  final String? countryShortName;
  final String? imageUrl;
  final String? phonePrefix;
  final dynamic transactionCodePrefix;
  final String? currencyName;
  final String? currencySymbol;
  final bool? symbolIsPrefix;
  final bool? transactionIsEnabled;
  final DateTime? transactionEnableDate;
  final double? taxationUnitValue;
  final bool? isPiiinkCountry;
  final bool? isAssignedToOwner;
  final DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);
}
