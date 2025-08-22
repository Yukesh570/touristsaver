// To parse this JSON data, do
//
//     final getAllDiscountResModel = getAllDiscountResModelFromJson(jsonString);

import 'dart:convert';

GetAllDiscountResModel getAllDiscountResModelFromJson(String str) =>
    GetAllDiscountResModel.fromJson(json.decode(str));

String getAllDiscountResModelToJson(GetAllDiscountResModel data) =>
    json.encode(data.toJson());

class GetAllDiscountResModel {
  String? status;
  Data? data;

  GetAllDiscountResModel({
    this.status,
    this.data,
  });

  factory GetAllDiscountResModel.fromJson(Map<String, dynamic> json) =>
      GetAllDiscountResModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class Data {
  List<Day>? friday;
  List<Day>? monday;
  List<Day>? sunday;
  List<Day>? tuesday;
  List<Day>? saturday;
  List<Day>? thursday;
  List<Day>? wednesday;

  Data({
    this.friday,
    this.monday,
    this.sunday,
    this.tuesday,
    this.saturday,
    this.thursday,
    this.wednesday,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        friday: json["Friday"] == null
            ? []
            : List<Day>.from(json["Friday"]!.map((x) => Day.fromJson(x))),
        monday: json["Monday"] == null
            ? []
            : List<Day>.from(json["Monday"]!.map((x) => Day.fromJson(x))),
        sunday: json["Sunday"] == null
            ? []
            : List<Day>.from(json["Sunday"]!.map((x) => Day.fromJson(x))),
        tuesday: json["Tuesday"] == null
            ? []
            : List<Day>.from(json["Tuesday"]!.map((x) => Day.fromJson(x))),
        saturday: json["Saturday"] == null
            ? []
            : List<Day>.from(json["Saturday"]!.map((x) => Day.fromJson(x))),
        thursday: json["Thursday"] == null
            ? []
            : List<Day>.from(json["Thursday"]!.map((x) => Day.fromJson(x))),
        wednesday: json["Wednesday"] == null
            ? []
            : List<Day>.from(json["Wednesday"]!.map((x) => Day.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Friday": friday == null
            ? []
            : List<dynamic>.from(friday!.map((x) => x.toJson())),
        "Monday": monday == null
            ? []
            : List<dynamic>.from(monday!.map((x) => x.toJson())),
        "Sunday": sunday == null
            ? []
            : List<dynamic>.from(sunday!.map((x) => x.toJson())),
        "Tuesday": tuesday == null
            ? []
            : List<dynamic>.from(tuesday!.map((x) => x.toJson())),
        "Saturday": saturday == null
            ? []
            : List<dynamic>.from(saturday!.map((x) => x.toJson())),
        "Thursday": thursday == null
            ? []
            : List<dynamic>.from(thursday!.map((x) => x.toJson())),
        "Wednesday": wednesday == null
            ? []
            : List<dynamic>.from(wednesday!.map((x) => x.toJson())),
      };
}

class Day {
  int? start;
  int? end;
  double? discount;

  Day({
    this.start,
    this.end,
    this.discount,
  });

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        start: json["start"],
        end: json["end"],
        discount: json["discount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
        "discount": discount,
      };
}
