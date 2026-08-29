import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/constants/member_otp.dart';

void main() {
  test('registration OTP expiry is consistently five minutes', () {
    expect(memberRegistrationOtpExpiryMinutes, 5);
  });
}
