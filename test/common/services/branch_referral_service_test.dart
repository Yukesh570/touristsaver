import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';

void main() {
  group('BranchRegistrationReferral', () {
    test('maps issuer ref_type and ref_code to issuerCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'issuer',
        'ref_code': 'ISSUER123',
        '~campaign': 'issuer_campaign',
      });

      expect(referral.issuerCode, 'ISSUER123');
      expect(referral.memberReferralCode, isNull);
      expect(referral.campaign, 'issuer_campaign');
    });

    test('maps merchant ref_type and ref_code to issuerCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'merchant',
        'ref_code': 'MERCHANT123',
      });

      expect(referral.issuerCode, 'MERCHANT123');
      expect(referral.memberReferralCode, isNull);
    });

    test('maps member ref_type and ref_code to memberReferralCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'member',
        'ref_code': 'MEMBER123',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.memberReferralCode, 'MEMBER123');
    });

    test('preserves both legacy registration fields', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'issuercode': 'LEGACY_ISSUER',
        'memberReferralCode': 'LEGACY_MEMBER',
      });

      expect(referral.issuerCode, 'LEGACY_ISSUER');
      expect(referral.memberReferralCode, 'LEGACY_MEMBER');
    });

    test('recognized ref_type takes precedence over legacy fields', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'member',
        'ref_code': 'NEW_MEMBER',
        'issuercode': 'LEGACY_ISSUER',
        'memberReferralCode': 'LEGACY_MEMBER',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.memberReferralCode, 'NEW_MEMBER');
    });

    test('builds registration parameters for an issuer referral', () {
      const referral = BranchRegistrationReferral(
        issuerCode: 'AU0000000011',
      );

      expect(registrationQueryParametersFor(referral), {
        'issuercode': 'AU0000000011',
        'memberReferralCode': '',
      });
    });

    test('builds registration parameters for a member referral', () {
      const referral = BranchRegistrationReferral(
        memberReferralCode: '6123456789012345',
      );

      expect(registrationQueryParametersFor(referral), {
        'issuercode': '',
        'memberReferralCode': '6123456789012345',
      });
    });

    test('builds empty parameters when no referral is pending', () {
      expect(registrationQueryParametersFor(null), {
        'issuercode': '',
        'memberReferralCode': '',
      });
    });
  });
}
