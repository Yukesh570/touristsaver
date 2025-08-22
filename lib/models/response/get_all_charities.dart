// To parse this JSON data, do
//
//     final getAllCharities = getAllCharitiesFromJson(jsonString);

import 'dart:convert';

GetAllCharities getAllCharitiesFromJson(String str) =>
    GetAllCharities.fromJson(json.decode(str));

String getAllCharitiesToJson(GetAllCharities data) =>
    json.encode(data.toJson());

class GetAllCharities {
  String status;
  List<Datum> data;
  bool hasMore;
  int count;
  int totalCount;
  int page;

  GetAllCharities({
    required this.status,
    required this.data,
    required this.hasMore,
    required this.count,
    required this.totalCount,
    required this.page,
  });

  factory GetAllCharities.fromJson(Map<String, dynamic> json) =>
      GetAllCharities(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        hasMore: json["hasMore"],
        count: json["count"],
        totalCount: json["totalCount"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "hasMore": hasMore,
        "count": count,
        "totalCount": totalCount,
        "page": page,
      };
}

class Datum {
  int id;
  String charityName;
  String websiteUrl;
  String logoUrl;
  String email;
  String phoneNumber;
  String address;
  String buildingNo;
  String streetInfo;
  List<double> latlon;
  RegistrationStatus registrationStatus;
  DateTime createdAt;

  Datum({
    required this.id,
    required this.charityName,
    required this.websiteUrl,
    required this.logoUrl,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.buildingNo,
    required this.streetInfo,
    required this.latlon,
    required this.registrationStatus,
    required this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        charityName: json["charityName"],
        websiteUrl: json["websiteUrl"],
        logoUrl: json["logoUrl"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        address: json["address"],
        buildingNo: json["buildingNo"],
        streetInfo: json["streetInfo"],
        latlon: List<double>.from(json["latlon"].map((x) => x?.toDouble())),
        registrationStatus:
            registrationStatusValues.map[json["registrationStatus"]]!,
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "charityName": charityName,
        "websiteUrl": websiteUrl,
        "logoUrl": logoUrl,
        "email": email,
        "phoneNumber": phoneNumber,
        "address": address,
        "buildingNo": buildingNo,
        "streetInfo": streetInfo,
        "latlon": List<dynamic>.from(latlon.map((x) => x)),
        "registrationStatus":
            registrationStatusValues.reverse[registrationStatus],
        "createdAt": createdAt.toIso8601String(),
      };
}

enum RegistrationStatus { EXPRESSION_OF_INTEREST, PENDING, REJECTED, VERIFIED }

final registrationStatusValues = EnumValues({
  "expressionOfInterest": RegistrationStatus.EXPRESSION_OF_INTEREST,
  "pending": RegistrationStatus.PENDING,
  "rejected": RegistrationStatus.REJECTED,
  "verified": RegistrationStatus.VERIFIED
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
