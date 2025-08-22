import 'dart:convert';

//part 'slider_res.g.dart';

SliderResModel sliderResModelFromJson(String str) =>
    SliderResModel.fromJson(json.decode(str));

String sliderResModelToJson(SliderResModel data) => json.encode(data.toJson());

class SliderResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  SliderResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory SliderResModel.fromJson(Map<String, dynamic> json) => SliderResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  final int? id;
  final String? sliderName;
  final String? url;
  final int? order;
  final String? screenName;
  final String? screenValue;
  final bool? hasLink;
  final dynamic externalLink;
  final String? internalLink;
  final int? countryId;
  final DateTime? createdAt;
  final Country? country;

  Datum({
    this.id,
    this.sliderName,
    this.url,
    this.order,
    this.screenName,
    this.screenValue,
    this.hasLink,
    this.externalLink,
    this.internalLink,
    this.countryId,
    this.createdAt,
    this.country,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        sliderName: json["sliderName"],
        url: json["url"],
        order: json["order"],
        screenName: json["screenName"],
        screenValue: json["screenValue"],
        hasLink: json["hasLink"],
        externalLink: json["externalLink"],
        internalLink: json["internalLink"],
        countryId: json["countryId"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        country: json["__country__"] == null
            ? null
            : Country.fromJson(json["__country__"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sliderName": sliderName,
        "url": url,
        "order": order,
        "screenName": screenName,
        "screenValue": screenValue,
        "hasLink": hasLink,
        "externalLink": externalLink,
        "internalLink": internalLink,
        "countryId": countryId,
        "createdAt": createdAt?.toIso8601String(),
        "__country__": country?.toJson(),
      };
}

class Country {
  final int? id;
  final String? countryName;

  Country({
    this.id,
    this.countryName,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        countryName: json["countryName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "countryName": countryName,
      };
}


////

// SliderResModel sliderResModelFromJson(String str) =>
//     SliderResModel.fromJson(json.decode(str));

// String sliderResModelToJson(SliderResModel data) => json.encode(data.toJson());

// @JsonSerializable()
// class SliderResModel {
//   SliderResModel({
//     this.status,
//     this.data,
//     this.hasMore,
//     this.count,
//     this.totalCount,
//     this.page,
//   });

//   final String? status;
//   final List<Datum>? data;
//   final bool? hasMore;
//   final int? count;
//   final int? totalCount;
//   final int? page;

//   factory SliderResModel.fromJson(Map<String, dynamic> json) =>
//       _$SliderResModelFromJson(json);

//   Map<String, dynamic> toJson() => _$SliderResModelToJson(this);
// }

// @JsonSerializable()
// class Datum {
//   Datum({
//     this.id,
//     this.sliderName,
//     this.url,
//     this.order,
//     this.countryId,
//     this.createdAt,
//     this.country,
//   });

//   final int? id;
//   final String? sliderName;
//   final String? url;
//   final int? order;
//   final int? countryId;
//   final DateTime? createdAt;
//   final Country? country;

//   factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

//   Map<String, dynamic> toJson() => _$DatumToJson(this);
// }

// @JsonSerializable()
// class Country {
//   Country({
//     this.id,
//     this.countryName,
//     this.phonePrefix,
//   });

//   final int? id;
//   final String? countryName;
//   final String? phonePrefix;

//   factory Country.fromJson(Map<String, dynamic> json) =>
//       _$CountryFromJson(json);

//   Map<String, dynamic> toJson() => _$CountryToJson(this);
// }
