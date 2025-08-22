import 'dart:convert';

String editProfileReqModelNumberToJson(EditProfileReqModelNumber data) =>
    json.encode(data.toJson());

class EditProfileReqModelNumber {
  EditProfileReqModelNumber({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.postalCode,
    required this.phoneNumberPrefix,
    required this.phoneVerifiedBy,
    this.email,
    this.appSign,
  });

  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String postalCode;
  final String? appSign;
  final String? email;
  final String phoneNumberPrefix;
  final String phoneVerifiedBy;

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "postalCode": postalCode,
        "phoneNumber": phoneNumber,
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneVerifiedBy": phoneVerifiedBy,
        "email": email,
        "appSign": appSign,
      };
}

String editProfileReqModelToJson(EditProfileReqModel data) =>
    json.encode(data.toJson());

class EditProfileReqModel {
  EditProfileReqModel({
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    required this.postalCode,
    required this.phoneNumberPrefix,
    required this.phoneVerifiedBy,
    this.email,
  });

  final String firstname;
  final String lastname;
  final String phoneNumber;
  final String postalCode;
  final String? email;
  final String phoneNumberPrefix;
  final String phoneVerifiedBy;

  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "postalCode": postalCode,
        "phoneNumber": phoneNumber,
        "phoneNumberPrefix": phoneNumberPrefix,
        "phoneVerifiedBy": phoneVerifiedBy,
        "email": email,
      };
}
