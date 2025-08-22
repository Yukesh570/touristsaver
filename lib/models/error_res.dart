// To parse this JSON data, do
//
//     final errorResModel = errorResModelFromJson(jsonString);

import 'dart:convert';

ErrorResModel errorResModelFromJson(String str) =>
    ErrorResModel.fromJson(json.decode(str));

String errorResModelToJson(ErrorResModel data) => json.encode(data.toJson());

class ErrorResModel {
  ErrorResModel({
    this.status,
    this.error,
    this.message,
    this.stack,
  });

  final dynamic status;
  final Error? error;
  final String? message;
  final String? stack;

  factory ErrorResModel.fromJson(Map<String, dynamic> json) => ErrorResModel(
        status: json["status"],
        error: json["error"] == null ? null : Error.fromJson(json["error"]),
        message: json["message"],
        stack: json["stack"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error?.toJson(),
        "message": message,
        "stack": stack,
      };
}

class Error {
  Error({
    this.statusCode,
    this.status,
    this.isOperational,
  });

  final int? statusCode;
  final dynamic status;
  final bool? isOperational;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
        statusCode: json["statusCode"],
        status: json["status"],
        isOperational: json["isOperational"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "status": status,
        "isOperational": isOperational,
      };
}
