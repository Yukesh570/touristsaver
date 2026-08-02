import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/models/response/register_res.dart';
import 'package:touristsaver/models/response/user_detail_res.dart' as profile;

void main() {
  group('Discovery registration context', () {
    test('maps campaign entitlement facts from registration response', () {
      final response = RegisterResModel.fromJson({
        'status': 'Success',
        'data': {
          'accessToken': 'token',
          'memberInfo': {'memberType': 'discovery'},
          'discoveryMembership': {
            'active': true,
            'entitlementId': 123,
            'campaignId': 900,
            'executionCampaignId': 45,
            'campaignName': 'Tier 1 Community Invitation',
            'invitationName': 'Carrara Markets - July 2026',
            'communityGroupName': 'Carrara Markets',
            'sourceType': 'community',
            'sourceName': 'Brisbane Community',
            'startDate': '2026-07-12T00:00:00Z',
            'expiryDate': '2026-08-11T00:00:00Z',
            'membershipDays': 30,
            'savingsCapMinor': 2500,
            'savingsConsumedMinor': 0,
            'savingsRemainingMinor': 2500,
            'currency': 'AUD',
            'allowMemberInvitations': true,
            'maximumInvitationGeneration': null,
            'invitationGeneration': 0,
          },
        },
      });

      final membership = response.data?.discoveryMembership;
      expect(membership, isNotNull);
      expect(membership?.sourceName, 'Brisbane Community');
      expect(membership?.invitationName, 'Carrara Markets - July 2026');
      expect(membership?.communityGroupName, 'Carrara Markets');
      expect(membership?.displayCommunityName, 'Carrara Markets - July 2026');
      expect(membership?.sourceType, 'community');
      expect(membership?.periodDays, 30);
      expect(membership?.savingsCapAmountMinor, 2500);
      expect(membership?.effectiveSavingsCapAmount, 25);
      expect(membership?.currencyCode, 'AUD');
      expect(membership?.displayCurrency, r'A$');
      expect(membership?.inheritanceEnabled, isTrue);
    });

    test('does not infer Discovery from normal or Premium registration', () {
      for (final String memberType in ['free', 'premium']) {
        final data = Data.fromJson({
          'memberInfo': {'memberType': memberType},
          'premiumCodeIsApplied': memberType == 'premium',
        });
        expect(data.discoveryMembership, isNull);
      }
    });

    test('maps Discovery Membership from profile response', () {
      final response = profile.UserProfileResModel.fromJson({
        'data': {
          'status': 'Success',
          'discoveryMembership': {
            'active': true,
            'entitlementId': 5790,
            'campaignId': 1,
            'campaignName': 'Bond University',
            'expiryDate': '2026-08-14T00:00:00Z',
            'allowMemberInvitations': true,
          },
          'results': {
            'id': 5790,
            'firstname': 'Mary',
            'lastname': 'Ho',
          },
        },
      });

      final membership = response.data?.discoveryMembership;
      expect(membership, isNotNull);
      expect(membership?.isActive, isTrue);
      expect(membership?.entitlementId, 5790);
      expect(membership?.campaignName, 'Bond University');
      expect(membership?.inheritanceEnabled, isTrue);
    });

    test('round-trips safely through route extra', () {
      final original = DiscoveryMembershipContext(
        communityName: 'Local Group',
        periodDays: 14,
        savingsCapAmount: 20,
        currencyCode: 'AUD',
        inheritanceEnabled: false,
      );

      final restored = DiscoveryMembershipContext.fromRouteExtra(
        original.toRouteExtra(),
      );
      expect(restored.communityName, original.communityName);
      expect(restored.periodDays, original.periodDays);
      expect(restored.savingsCapAmount, original.savingsCapAmount);
      expect(restored.inheritanceEnabled, isFalse);
    });

    test('calculates non-negative remaining days from backend expiry', () {
      final membership = DiscoveryMembershipContext(
        entitlementExpiryDate: DateTime(2026, 7, 20),
      );
      expect(membership.daysRemaining(now: DateTime(2026, 7, 12)), 8);
      expect(membership.daysRemaining(now: DateTime(2026, 7, 21)), 0);
    });
  });
}
