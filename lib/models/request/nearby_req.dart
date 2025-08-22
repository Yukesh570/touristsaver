class NearByLocationReqModel {
  NearByLocationReqModel({
    this.latitude,
    this.longitude,
    this.countryCode,
    this.radius,
    this.orderBy,
    this.page,
    this.lang,
    this.countryId,
  });

  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final double? radius;
  final String? orderBy;
  final int? page;
  final String? lang;
  final int? countryId;

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "countryCode": countryCode,
        "radius": radius,
        "order_by": orderBy,
        "lang": lang,
        "countryId": countryId,
      };
}
