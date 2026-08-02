import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';
import 'package:touristsaver/features/app_intro/screens/membership_country_screen.dart';
import 'package:touristsaver/features/register/screens/num_otp_screen.dart';
import 'package:touristsaver/features/register/screens/register_screen.dart';
import 'package:touristsaver/models/request/register_req.dart';

void main() {
  const registrationCode = '333BUTTERFLY';

  test('retains one canonical Discovery code through registration contracts',
      () {
    final referral = BranchRegistrationReferral.fromPayload({
      '+clicked_branch_link': true,
      'feature': 'discovery-membership',
      'ref_type': 'campaign_invitation',
      'registrationCode': registrationCode,
      'ref_code': registrationCode,
      'campaign': 'Blue Butterfly Launch Gold Coast',
      'invitationName': 'Carrara Markets - July 2026',
    });

    final membershipCountry = MembershipCountryScreen(
      registrationQueryParameters: registrationQueryParametersFor(referral),
    );
    expect(
      membershipCountry.registrationQueryParameters['registrationCode'],
      registrationCode,
    );
    expect(
      membershipCountry.registrationQueryParameters['discoveryInvitationCode'],
      isEmpty,
    );

    final register = RegisterScreen(
      registrationCode:
          membershipCountry.registrationQueryParameters['registrationCode'],
      membershipCountryId: 3,
      membershipCountryLocked: true,
    );
    expect(register.registrationCode, registrationCode);

    final otp = NumberOTPScreen(
      countryID: 3,
      membershipCountryId: 3,
      stateID: 1,
      issuerCode: 'null',
      firstName: 'Discovery',
      lastName: 'Test',
      email: 'discovery-test@example.com',
      password: 'password123',
      confirmPassword: 'password123',
      phonePrefix: '+61',
      phNum: '400000000',
      residenceCountryReferenceId: 14,
      residentialPostalCode: '4000',
      premium: 'null',
      discoveryInvitationCode: 'null',
      registrationCode: register.registrationCode!,
      referralCode: 'null',
      phoneVerifiedBy: 'sms',
      charityID: 0,
    );
    expect(otp.registrationCode, registrationCode);

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
      registrationCode: otp.registrationCode,
      memberReferralCode: otp.referralCode,
      phoneNumberPrefix: otp.phonePrefix,
    );

    final json = request.toJson();
    expect(json['registrationCode'], registrationCode);
    expect(json['discoveryInvitationCode'], isNull);
    expect(json['memberPremiumCode'], isNull);
  });
}
