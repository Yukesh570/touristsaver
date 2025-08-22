import 'dart:convert';

MerchantGetAllResModel merchantGetAllResModelFromJson(String str) =>
    MerchantGetAllResModel.fromJson(json.decode(str));

class MerchantGetAllResModel {
  MerchantGetAllResModel({
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

  factory MerchantGetAllResModel.fromJson(Map<String, dynamic> json) =>
      MerchantGetAllResModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );
}

class Datum {
  Datum({
    this.id,
    this.merchantName,
    this.maxDiscount,
    this.latlon,
    this.isPopularFlag,
    this.popularOrder,
    this.createdAt,
    this.merchantImageInfo,
    this.favoriteMerchant,
  });

  int? id;
  String? merchantName;
  double? maxDiscount;
  List<double>? latlon;
  bool? isPopularFlag;
  int? popularOrder;
  DateTime? createdAt;
  MerchantImageInfo? merchantImageInfo;
  FavoriteMerchant? favoriteMerchant;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        merchantName: json["merchantName"],
        maxDiscount: json["maxDiscount"]?.toDouble(),
        latlon: json["latlon"] == null
            ? []
            : List<double>.from(json["latlon"]!.map((x) => x?.toDouble())),
        isPopularFlag: json["isPopularFlag"],
        popularOrder: json["popularOrder"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        merchantImageInfo: json["__merchantImageInfo__"] == null
            ? null
            : MerchantImageInfo.fromJson(json["__merchantImageInfo__"]),
        favoriteMerchant: json["favoriteMerchant"] == null
            ? null
            : FavoriteMerchant.fromJson(json["favoriteMerchant"]),
      );

  Datum copyWith({
    int? id,
    String? merchantName,
    double? maxDisount,
    bool? isPopularFlag,
    int? popularOrder,
    DateTime? createdAt,
    MerchantImageInfo? merchantImageInfo,
    FavoriteMerchant? favoriteMerchant,
  }) =>
      Datum(
        id: id ?? this.id,
        merchantName: merchantName ?? this.merchantName,
        maxDiscount: maxDiscount ?? maxDiscount,
        isPopularFlag: isPopularFlag ?? this.isPopularFlag,
        popularOrder: popularOrder ?? this.popularOrder,
        createdAt: createdAt ?? this.createdAt,
        merchantImageInfo: merchantImageInfo ?? this.merchantImageInfo,
        favoriteMerchant: favoriteMerchant ?? this.favoriteMerchant,
      );
}

class MerchantImageInfo {
  MerchantImageInfo({
    this.id,
    this.logoUrl,
    this.slider1,
    this.slider2,
    this.slider3,
    this.slider4,
    this.slider5,
    this.slider6,
    this.createdAt,
    this.merchantId,
  });

  final int? id;
  final String? logoUrl;
  final String? slider1;
  final String? slider2;
  final String? slider3;
  final String? slider4;
  final String? slider5;
  final String? slider6;
  final DateTime? createdAt;
  final int? merchantId;

  factory MerchantImageInfo.fromJson(Map<String, dynamic> json) =>
      MerchantImageInfo(
        id: json["id"],
        logoUrl: json["logoUrl"],
        slider1: json["slider1"],
        slider2: json["slider2"],
        slider3: json["slider3"],
        slider4: json["slider4"],
        slider5: json["slider5"],
        slider6: json["slider6"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        merchantId: json["merchantId"],
      );
}

class FavoriteMerchant {
  final int? id;

  FavoriteMerchant({
    this.id,
  });

  factory FavoriteMerchant.fromJson(Map<String, dynamic> json) =>
      FavoriteMerchant(
        id: json["id"],
      );
}
