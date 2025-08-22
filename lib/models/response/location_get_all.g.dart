// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_get_all.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationGetAllResModel _$LocationGetAllResModelFromJson(
        Map<String, dynamic> json) =>
    LocationGetAllResModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool?,
      count: json['count'] as int?,
      totalCount: json['totalCount'] as int?,
      page: json['page'] as int?,
    );

Map<String, dynamic> _$LocationGetAllResModelToJson(
        LocationGetAllResModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'hasMore': instance.hasMore,
      'count': instance.count,
      'totalCount': instance.totalCount,
      'page': instance.page,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: json['id'] as int?,
      countryName: json['countryName'] as String?,
      countryShortName: json['countryShortName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      phonePrefix: json['phonePrefix'] as String?,
      transactionCodePrefix: json['transactionCodePrefix'],
      currencyName: json['currencyName'] as String?,
      currencySymbol: json['currencySymbol'] as String?,
      symbolIsPrefix: json['symbolIsPrefix'] as bool?,
      transactionIsEnabled: json['transactionIsEnabled'] as bool?,
      transactionEnableDate: json['transactionEnableDate'] == null
          ? null
          : DateTime.parse(json['transactionEnableDate'] as String),
      taxationUnitValue: (json['taxationUnitValue'] as num?)?.toDouble(),
      isPiiinkCountry: json['isPiiinkCountry'] as bool?,
      isAssignedToOwner: json['isAssignedToOwner'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'countryName': instance.countryName,
      'countryShortName': instance.countryShortName,
      'imageUrl': instance.imageUrl,
      'phonePrefix': instance.phonePrefix,
      'transactionCodePrefix': instance.transactionCodePrefix,
      'currencyName': instance.currencyName,
      'currencySymbol': instance.currencySymbol,
      'symbolIsPrefix': instance.symbolIsPrefix,
      'transactionIsEnabled': instance.transactionIsEnabled,
      'transactionEnableDate':
          instance.transactionEnableDate?.toIso8601String(),
      'taxationUnitValue': instance.taxationUnitValue,
      'isPiiinkCountry': instance.isPiiinkCountry,
      'isAssignedToOwner': instance.isAssignedToOwner,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
