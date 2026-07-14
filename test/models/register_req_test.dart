import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/request/register_req.dart';
import 'package:touristsaver/models/response/country_wise_prefix_res_model.dart';
import 'package:touristsaver/models/response/residence_country_res_model.dart';

void main() {
  group('RegisterReqModel', () {
    test('keeps Discovery invitation separate from Premium code', () {
      final request = RegisterReqModel(
        smsotp: '123456',
        charityId: null,
        phoneVerifiedBy: 'sms',
        firstname: 'Gus',
        lastname: 'Guest',
        email: 'gus@example.com',
        membershipCountryId: 3,
        residenceCountryReferenceId: 14,
        residentialPostalCode: '0400',
        phoneNumber: '400000000',
        countryId: 3,
        stateId: 1,
        issuerCode: 'null',
        password: 'password123',
        confirmPassword: 'password123',
        memberPremiumCode: 'null',
        discoveryInvitationCode: 'GUSG2026',
        memberReferralCode: 'null',
        phoneNumberPrefix: '+61',
      );

      expect(request.toJson()['memberPremiumCode'], isNull);
      expect(request.toJson()['discoveryInvitationCode'], 'GUSG2026');
      expect(request.toJson()['membershipCountryId'], 3);
      expect(request.toJson()['residenceCountryReferenceId'], 14);
      expect(request.toJson()['residentialPostalCode'], '0400');
      expect(request.toJson().containsKey('postalCode'), isFalse);
    });

    test('keeps legacy Premium and issuer fields unchanged', () {
      final request = RegisterReqModel(
        smsotp: '123456',
        charityId: null,
        phoneVerifiedBy: 'sms',
        firstname: 'Premium',
        lastname: 'Member',
        email: 'premium@example.com',
        membershipCountryId: 3,
        residenceCountryReferenceId: 14,
        residentialPostalCode: null,
        phoneNumber: '400000001',
        countryId: 3,
        stateId: 1,
        issuerCode: 'EXPLICIT-ISSUER',
        password: 'password123',
        confirmPassword: 'password123',
        memberPremiumCode: 'SAVER20',
        discoveryInvitationCode: 'null',
        memberReferralCode: 'null',
        phoneNumberPrefix: '+61',
      );

      expect(request.toJson()['issuerCode'], 'EXPLICIT-ISSUER');
      expect(request.toJson()['memberPremiumCode'], 'SAVER20');
      expect(request.toJson()['discoveryInvitationCode'], isNull);
      expect(request.toJson()['residentialPostalCode'], isNull);
    });
  });

  group('Country options', () {
    test('parses global ISO residence country configuration separately', () {
      final response = ResidenceCountryResModel.fromJson({
        'status': 'Success',
        'data': [
          {
            'id': 14,
            'countryName': 'Australia',
            'isoAlpha2': 'AU',
            'isoAlpha3': 'AUS',
            'collectResidentialPostalCode': true,
            'residentialPostalCodeRequired': true,
            'residentialPostalCodeLabel': 'Postcode',
            'residentialPostalCodeMaxLength': 4,
          }
        ],
      });

      final australia = response.data.single;
      expect(australia.id, 14);
      expect(australia.isoAlpha2, 'AU');
      expect(australia.isoAlpha3, 'AUS');
      expect(australia.collectResidentialPostalCode, isTrue);
      expect(australia.residentialPostalCodeRequired, isTrue);
      expect(australia.residentialPostalCodeLabel, 'Postcode');
      expect(australia.residentialPostalCodeMaxLength, 4);
    });

    test('parses backend membership status without inventing local markets',
        () {
      final response = CountryWisePrefixResModel.fromJson({
        'status': 'Success',
        'data': [
          {
            'id': 3,
            'countryName': 'Australia',
            'countryShortName': 'AU',
            'membershipStatus': 'available',
            'membershipRegistrationEnabled': true,
          },
          {
            'id': 1,
            'countryName': 'Singapore',
            'countryShortName': 'SG',
            'membershipStatus': 'opening_soon',
            'membershipRegistrationEnabled': false,
          },
        ],
      });

      expect(response.data!.map((country) => country.countryName),
          ['Australia', 'Singapore']);
      expect(response.data!.map((country) => country.membershipStatus),
          ['available', 'opening_soon']);
    });
  });
}
