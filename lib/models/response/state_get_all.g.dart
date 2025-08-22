// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_get_all.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateGetAllResModel _$StateGetAllResModelFromJson(Map<String, dynamic> json) =>
    StateGetAllResModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool?,
      count: json['count'] as int?,
      totalCount: json['totalCount'] as int?,
      page: json['page'] as int?,
    );

Map<String, dynamic> _$StateGetAllResModelToJson(
        StateGetAllResModel instance) =>
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
      stateName: json['stateName'] as String?,
      stateShortName: json['stateShortName'] as String?,
      imageUrl: json['imageUrl'],
      isPiiinkState: json['isPiiinkState'] as bool?,
      isAssignedToOwner: json['isAssignedToOwner'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      countryId: json['countryId'] as int?,
      country: json['country'] == null
          ? null
          : Country.fromJson(json['country'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'stateName': instance.stateName,
      'stateShortName': instance.stateShortName,
      'imageUrl': instance.imageUrl,
      'isPiiinkState': instance.isPiiinkState,
      'isAssignedToOwner': instance.isAssignedToOwner,
      'createdAt': instance.createdAt?.toIso8601String(),
      'countryId': instance.countryId,
      'country': instance.country,
    };

Country _$CountryFromJson(Map<String, dynamic> json) => Country(
      id: json['id'] as int?,
      countryName: json['countryName'] as String?,
      phonePrefix: json['phonePrefix'] as String?,
    );

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'countryName': instance.countryName,
      'phonePrefix': instance.phonePrefix,
    };
