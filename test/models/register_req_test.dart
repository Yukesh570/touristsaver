import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/request/register_req.dart';

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
        postalCode: '4000',
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
    });

    test('keeps legacy Premium and issuer fields unchanged', () {
      final request = RegisterReqModel(
        smsotp: '123456',
        charityId: null,
        phoneVerifiedBy: 'sms',
        firstname: 'Premium',
        lastname: 'Member',
        email: 'premium@example.com',
        postalCode: '4000',
        phoneNumber: '400000001',
        countryId: 3,
        stateId: 1,
        issuerCode: 'AU0000000001',
        password: 'password123',
        confirmPassword: 'password123',
        memberPremiumCode: 'SAVER20',
        discoveryInvitationCode: 'null',
        memberReferralCode: 'null',
        phoneNumberPrefix: '+61',
      );

      expect(request.toJson()['issuerCode'], 'AU0000000001');
      expect(request.toJson()['memberPremiumCode'], 'SAVER20');
      expect(request.toJson()['discoveryInvitationCode'], isNull);
    });
  });
}
