import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';
import 'package:touristsaver/features/app_intro/screens/membership_country_screen.dart';
import 'package:touristsaver/features/register/screens/num_otp_screen.dart';
import 'package:touristsaver/features/register/screens/register_screen.dart';
import 'package:touristsaver/models/request/register_req.dart';

void main() {
  const issuerCode = 'AU0000000011';

  test('retains the exact direct issuer code through registration contracts',
      () {
    const referral = BranchRegistrationReferral(
      issuerCode: issuerCode,
      isDirectIssuerRegistration: true,
    );

    final membershipCountry = MembershipCountryScreen(
      registrationQueryParameters: registrationQueryParametersFor(referral),
    );
    expect(
      membershipCountry.registrationQueryParameters['issuercode'],
      issuerCode,
    );

    final register = RegisterScreen(
      issuercode: membershipCountry.registrationQueryParameters['issuercode'],
      membershipCountryId: 3,
      membershipCountryLocked: true,
    );
    expect(register.issuercode, issuerCode);

    final otp = NumberOTPScreen(
      countryID: 3,
      membershipCountryId: 3,
      stateID: 1,
      issuerCode: register.issuercode!,
      firstName: 'Issuer',
      lastName: 'Test',
      email: 'issuer-test@example.com',
      password: 'password123',
      confirmPassword: 'password123',
      phonePrefix: '+61',
      phNum: '400000000',
      residenceCountryReferenceId: 14,
      residentialPostalCode: '4000',
      premium: 'null',
      discoveryInvitationCode: 'null',
      referralCode: 'null',
      phoneVerifiedBy: 'sms',
      charityID: 0,
    );
    expect(otp.issuerCode, issuerCode);

    final request = RegisterReqModel(
      smsotp: '123456',
      charityId: null,
      phoneVerifiedBy: otp.phoneVerifiedBy,
      firstname: otp.firstName,
      lastname: otp.lastName,
      email: otp.email,
      membershipCountryId: otp.membershipCountryId,
      residenceCountryReferenceId: otp.residenceCountryReferenceId,
      residentialPostalCode: otp.residentialPostalCode,
      phoneNumber: otp.phNum,
      countryId: otp.countryID,
      stateId: otp.stateID,
      issuerCode: otp.issuerCode,
      password: otp.password,
      confirmPassword: otp.confirmPassword,
      memberPremiumCode: otp.premium,
      discoveryInvitationCode: otp.discoveryInvitationCode,
      memberReferralCode: otp.referralCode,
      phoneNumberPrefix: otp.phonePrefix,
    );

    expect(request.toJson()['issuerCode'], issuerCode);
  });
}
