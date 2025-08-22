import 'dart:convert';

GetAllReviewSuggestionResModel getAllReviewSuggestionResModelFromJson(
        String str) =>
    GetAllReviewSuggestionResModel.fromJson(json.decode(str));

class GetAllReviewSuggestionResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  GetAllReviewSuggestionResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory GetAllReviewSuggestionResModel.fromJson(Map<String, dynamic> json) =>
      GetAllReviewSuggestionResModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );
}

class Datum {
  final int? id;
  final String? reviewText;
  final bool? isActive;
  final DateTime? createdAt;

  Datum({
    this.id,
    this.reviewText,
    this.isActive,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        reviewText: json["reviewText"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
      );
}
