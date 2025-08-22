import 'dart:convert';

GetAllMerchantReviewsResModel getAllMerchantReviewsResModelFromJson(
        String str) =>
    GetAllMerchantReviewsResModel.fromJson(json.decode(str));

class GetAllMerchantReviewsResModel {
  final String? status;
  final List<Datum>? data;
  final bool? hasMore;
  final int? count;
  final int? totalCount;
  final int? page;

  GetAllMerchantReviewsResModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory GetAllMerchantReviewsResModel.fromJson(Map<String, dynamic> json) =>
      GetAllMerchantReviewsResModel(
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
  final String? review;
  final String? rating;
  final bool? isActive;
  final DateTime? createdAt;
  final int? merchantId;
  final int? memberId;
  final Member? member;

  Datum({
    this.id,
    this.review,
    this.rating,
    this.isActive,
    this.createdAt,
    this.merchantId,
    this.memberId,
    this.member,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        review: json["review"],
        rating: json["rating"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        merchantId: json["merchantId"],
        memberId: json["memberId"],
        member: json["__member__"] == null
            ? null
            : Member.fromJson(json["__member__"]),
      );
}

class Member {
  final int? id;
  final String? firstname;
  final String? lastname;

  Member({
    this.id,
    this.firstname,
    this.lastname,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
      );
}
