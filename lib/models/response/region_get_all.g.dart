// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_get_all.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegionGetAllResModel _$RegionGetAllResModelFromJson(
        Map<String, dynamic> json) =>
    RegionGetAllResModel(
      status: json['status'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool?,
      count: json['count'] as int?,
      totalCount: json['totalCount'] as int?,
      page: json['page'] as int?,
    );

Map<String, dynamic> _$RegionGetAllResModelToJson(
        RegionGetAllResModel instance) =>
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
      isPiiinkRegion: json['isPiiinkRegion'] as bool?,
      regionName: json['regionName'] as String?,
      imageUrl: json['imageUrl'],
      isAssignedToOwner: json['isAssignedToOwner'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      countryId: json['countryId'] as int?,
      stateId: json['stateId'] as int?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'isPiiinkRegion': instance.isPiiinkRegion,
      'regionName': instance.regionName,
      'imageUrl': instance.imageUrl,
      'isAssignedToOwner': instance.isAssignedToOwner,
      'createdAt': instance.createdAt?.toIso8601String(),
      'countryId': instance.countryId,
      'stateId': instance.stateId,
    };
