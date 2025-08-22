// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_list_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryListResModel _$CategoryListResModelFromJson(
        Map<String, dynamic> json) =>
    CategoryListResModel(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CategoryListResModelToJson(
        CategoryListResModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool?,
      count: json['count'] as int?,
      totalCount: json['totalCount'] as int?,
      page: json['page'] as int?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'data': instance.data,
      'hasMore': instance.hasMore,
      'count': instance.count,
      'totalCount': instance.totalCount,
      'page': instance.page,
    };

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: json['id'] as int?,
      name: json['name'] as String?,
      imageName: json['imageName'] as String?,
      slug: json['slug'] as String?,
      priorityOrder: json['priorityOrder'] as int?,
      isVisibleOnApp: json['isVisibleOnApp'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      parentId: json['parentId'],
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageName': instance.imageName,
      'slug': instance.slug,
      'priorityOrder': instance.priorityOrder,
      'isVisibleOnApp': instance.isVisibleOnApp,
      'createdAt': instance.createdAt?.toIso8601String(),
      'parentId': instance.parentId,
    };
