// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'slider_res.dart';

// // **************************************************************************
// // JsonSerializableGenerator
// // **************************************************************************

// SliderResModel _$SliderResModelFromJson(Map<String, dynamic> json) =>
//     SliderResModel(
//       status: json['status'] as String?,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       hasMore: json['hasMore'] as bool?,
//       count: json['count'] as int?,
//       totalCount: json['totalCount'] as int?,
//       page: json['page'] as int?,
//     );

// Map<String, dynamic> _$SliderResModelToJson(SliderResModel instance) =>
//     <String, dynamic>{
//       'status': instance.status,
//       'data': instance.data,
//       'hasMore': instance.hasMore,
//       'count': instance.count,
//       'totalCount': instance.totalCount,
//       'page': instance.page,
//     };

// Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
//       id: json['id'] as int?,
//       sliderName: json['sliderName'] as String?,
//       url: json['url'] as String?,
//       order: json['order'] as int?,
//       countryId: json['countryId'] as int?,
//       createdAt: json['createdAt'] == null
//           ? null
//           : DateTime.parse(json['createdAt'] as String),
//       country: json['country'] == null
//           ? null
//           : Country.fromJson(json['country'] as Map<String, dynamic>),
//     );

// Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
//       'id': instance.id,
//       'sliderName': instance.sliderName,
//       'url': instance.url,
//       'order': instance.order,
//       'countryId': instance.countryId,
//       'createdAt': instance.createdAt?.toIso8601String(),
//       'country': instance.country,
//     };

// Country _$CountryFromJson(Map<String, dynamic> json) => Country(
//       id: json['id'] as int?,
//       countryName: json['countryName'] as String?,
//       phonePrefix: json['phonePrefix'] as String?,
//     );

// Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
//       'id': instance.id,
//       'countryName': instance.countryName,
//       'phonePrefix': instance.phonePrefix,
//     };
