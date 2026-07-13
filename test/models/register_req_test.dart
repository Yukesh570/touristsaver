import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/request/register_req.dart';

void main() {
  group('RegisterReqModel', () {
    test('includes campaign invitation code as memberPremiumCode', () {
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
        memberPremiumCode: 'GUSG2026',
        memberReferralCode: 'null',
        phoneNumberPrefix: '+61',
      );

      expect(request.toJson()['memberPremiumCode'], 'GUSG2026');
    });
  });
}
