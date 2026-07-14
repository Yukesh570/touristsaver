import 'dart:convert';

ResidenceCountryResModel residenceCountryResModelFromJson(String source) =>
    ResidenceCountryResModel.fromJson(json.decode(source));

class ResidenceCountryResModel {
  const ResidenceCountryResModel({required this.status, required this.data});

  final String status;
  final List<ResidenceCountry> data;

  factory ResidenceCountryResModel.fromJson(Map<String, dynamic> json) =>
      ResidenceCountryResModel(
        status: json['status']?.toString() ?? '',
        data: (json['data'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ResidenceCountry.fromJson)
            .toList(growable: false),
      );
}

class ResidenceCountry {
  const ResidenceCountry({
    required this.id,
    required this.countryName,
    required this.isoAlpha2,
    required this.isoAlpha3,
    required this.collectResidentialPostalCode,
    required this.residentialPostalCodeRequired,
    this.residentialPostalCodeLabel,
    this.residentialPostalCodeMaxLength,
  });

  final int id;
  final String countryName;
  final String isoAlpha2;
  final String isoAlpha3;
  final bool collectResidentialPostalCode;
  final bool residentialPostalCodeRequired;
  final String? residentialPostalCodeLabel;
  final int? residentialPostalCodeMaxLength;

  factory ResidenceCountry.fromJson(Map<String, dynamic> json) {
    return ResidenceCountry(
      id: int.parse(json['id'].toString()),
      countryName: json['countryName']?.toString() ?? '',
      isoAlpha2: json['isoAlpha2']?.toString().toUpperCase() ?? '',
      isoAlpha3: json['isoAlpha3']?.toString().toUpperCase() ?? '',
      collectResidentialPostalCode:
          json['collectResidentialPostalCode'] == true,
      residentialPostalCodeRequired:
          json['residentialPostalCodeRequired'] == true,
      residentialPostalCodeLabel:
          json['residentialPostalCodeLabel']?.toString(),
      residentialPostalCodeMaxLength: int.tryParse(
          json['residentialPostalCodeMaxLength']?.toString() ?? ''),
    );
  }
}
