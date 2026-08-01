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
      expect(referral.memberPremiumCode, isNull);
      expect(referral.campaign, 'issuer_campaign');
    });

    test('maps merchant ref_type and ref_code to issuerCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'merchant',
        'ref_code': 'MERCHANT123',
      });

      expect(referral.issuerCode, 'MERCHANT123');
      expect(referral.memberReferralCode, isNull);
      expect(referral.memberPremiumCode, isNull);
    });

    test('maps member ref_type and ref_code to memberReferralCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'member',
        'ref_code': 'MEMBER123',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.memberReferralCode, 'MEMBER123');
      expect(referral.memberPremiumCode, isNull);
    });

    test('maps member_invitation ref_type and ref_code to memberReferralCode',
        () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'member_invitation',
        'ref_code': '6114793531410125',
        'campaignId': 1,
        '~campaign': 'Bond University',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.memberReferralCode, '6114793531410125');
      expect(referral.memberPremiumCode, isNull);
      expect(referral.discoveryInvitationCode, isNull);
      expect(referral.campaign, 'Bond University');
    });

    test('maps campaign invitation only to discoveryInvitationCode', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'ref_type': 'campaign_invitation',
        'ref_code': 'GUSG2026',
        '~campaign': 'gusg_discovery',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.memberReferralCode, isNull);
      expect(referral.memberPremiumCode, isNull);
      expect(referral.discoveryInvitationCode, 'GUSG2026');
      expect(referral.campaign, 'gusg_discovery');
    });

    test('maps a direct issuer registration URL delivered by Branch', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link':
            'https://app.touristsaver.org/register?issuercode=AU0000000011',
      });

      expect(referral.issuerCode, 'AU0000000011');
      expect(referral.hasRegistrationCode, isTrue);
      expect(referral.isDirectIssuerRegistration, isTrue);
    });

    test('recognizes the issuer query key case-insensitively', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link':
            'https://app.touristsaver.org/register?IssuerCode=AU0000000011',
      });

      expect(referral.issuerCode, 'AU0000000011');
      expect(referral.isDirectIssuerRegistration, isTrue);
    });

    test('recognizes direct issuer URLs in first and later sessions', () {
      for (final isFirstSession in [true, false]) {
        final referral = BranchRegistrationReferral.fromPayload({
          '+clicked_branch_link': false,
          '+is_first_session': isFirstSession,
          '+non_branch_link':
              'https://app.touristsaver.org/register?issuercode=AU0000000011',
        });

        expect(referral.issuerCode, 'AU0000000011');
        expect(referral.isDirectIssuerRegistration, isTrue);
      }
    });

    test('does not trust issuer parameters from another host', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link':
            'https://example.com/register?issuercode=AU0000000011',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.hasRegistrationCode, isFalse);
    });

    test('does not trust a non-HTTPS direct issuer URL', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link':
            'http://app.touristsaver.org/register?issuercode=AU0000000011',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('does not trust an issuer code on another path', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link':
            'https://app.touristsaver.org/login?issuercode=AU0000000011',
      });

      expect(referral.issuerCode, isNull);
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('ignores a trusted registration URL without an issuer code', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+non_branch_link': 'https://app.touristsaver.org/register',
      });

      expect(referral.hasRegistrationCode, isFalse);
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('keeps clicked Discovery referrals on the existing path', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': true,
        '+non_branch_link':
            'https://app.touristsaver.org/register?issuercode=AU0000000011',
        'ref_type': 'campaign_invitation',
        'ref_code': 'GUSG2026',
      });

      expect(referral.discoveryInvitationCode, 'GUSG2026');
      expect(referral.issuerCode, isNull);
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('keeps clicked member referrals on the existing path', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': true,
        'ref_type': 'member_invitation',
        'ref_code': '6114793531410125',
      });

      expect(referral.memberReferralCode, '6114793531410125');
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('keeps legacy Branch Premium referrals on the existing path', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': true,
        'memberPremiumCode': 'SAVER20',
      });

      expect(referral.memberPremiumCode, 'SAVER20');
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('ordinary sessions have no registration attribution', () {
      final referral = BranchRegistrationReferral.fromPayload({
        '+clicked_branch_link': false,
        '+is_first_session': true,
      });

      expect(referral.hasRegistrationCode, isFalse);
      expect(referral.isDirectIssuerRegistration, isFalse);
    });

    test('preserves both legacy registration fields', () {
      final referral = BranchRegistrationReferral.fromPayload({
        'issuercode': 'LEGACY_ISSUER',
        'memberReferralCode': 'LEGACY_MEMBER',
      });

      expect(referral.issuerCode, 'LEGACY_ISSUER');
      expect(referral.memberReferralCode, 'LEGACY_MEMBER');
      expect(referral.memberPremiumCode, isNull);
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
        'memberPremiumCode': '',
        'discoveryInvitationCode': '',
      });
    });

    test('builds registration parameters for a member referral', () {
      const referral = BranchRegistrationReferral(
        memberReferralCode: '6123456789012345',
      );

      expect(registrationQueryParametersFor(referral), {
        'issuercode': '',
        'memberReferralCode': '6123456789012345',
        'memberPremiumCode': '',
        'discoveryInvitationCode': '',
      });
    });

    test('builds registration parameters for a campaign invitation', () {
      const referral = BranchRegistrationReferral(
        discoveryInvitationCode: 'GUSG2026',
      );

      expect(registrationQueryParametersFor(referral), {
        'issuercode': '',
        'memberReferralCode': '',
        'memberPremiumCode': '',
        'discoveryInvitationCode': 'GUSG2026',
      });
    });

    test('builds empty parameters when no referral is pending', () {
      expect(registrationQueryParametersFor(null), {
        'issuercode': '',
        'memberReferralCode': '',
        'memberPremiumCode': '',
        'discoveryInvitationCode': '',
      });
    });
  });
}
