import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

class NotificationModel {
  String? status;
  List<Data>? data;
  bool? hasMore;
  int? count;
  int? totalCount;
  int? page;

  NotificationModel({
    this.status,
    this.data,
    this.hasMore,
    this.count,
    this.totalCount,
    this.page,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );
}

class Data {
  int? id;
  String? description;
  String? subject;
  String? imageUrl;
  String? title;
  String? content;
  DateTime? createdAt;
  String? fcmtoken;
  String? topic;
  String? notificationKey;
  int? merchantId;
  bool isSelected;

  Data({
    this.id,
    this.description,
    this.subject,
    this.imageUrl,
    this.title,
    this.content,
    this.createdAt,
    this.fcmtoken,
    this.topic,
    this.notificationKey,
    this.merchantId,
    this.isSelected = false,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        description: json["description"],
        subject: json["subject"],
        imageUrl: json["imageUrl"],
        title: json["title"],
        content: json["content"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        fcmtoken: json["fcmtoken"],
        topic: json["topic"],
        notificationKey: json["notificationKey"],
        merchantId: json["merchantId"],
      );
}
