// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementResModel _$AgreementResModelFromJson(Map<String, dynamic> json) =>
    AgreementResModel(
      status: json['status'] as String?,
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreementResModelToJson(AgreementResModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      role: json['role'] as String?,
      countryId: json['countryId'] as int?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'slug': instance.slug,
      'description': instance.description,
      'role': instance.role,
      'countryId': instance.countryId,
    };
