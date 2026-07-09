import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/membership_offer_code_details.dart';

void main() {
  group('MembershipOfferCodeDetails', () {
    test('reads giveaway merchant owner details', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': true,
        'codeOwnerId': 42,
        'codeOwnerType': 'merchant',
        'codeOwner': {'merchantName': 'GC Jetski'},
      });

      expect(details.isGiveaway, isTrue);
      expect(details.codeOwnerId, 42);
      expect(details.codeOwnerType, 'merchant');
      expect(details.assignedToName, 'GC Jetski');
    });

    test('falls back to the assigned-to name', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': true,
        'codeOwnerId': '42',
        'codeOwnerType': 'merchant',
        'assignedToName': 'Friendly Merchant Name',
      });

      expect(details.codeOwnerId, 42);
      expect(details.assignedToName, 'Friendly Merchant Name');
    });

    test('does not classify a normal offer code as complimentary', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': false,
        'codeOwnerId': 42,
        'codeOwnerType': 'merchant',
        'discount': '20',
        'premiumCodeIsPaid': true,
      });

      expect(details.isGiveaway, isFalse);
      expect(details.isComplimentaryMembership, isFalse);
      expect(details.effectiveDiscountPercent, 20);
    });

    test('keeps SAVER20 as a 20 percent paid discount', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'memberPremiumCode': 'SAVER20',
        'isGiveaway': false,
        'discount': '20',
        'premiumCodeIsPaid': true,
      });

      expect(details.isComplimentaryMembership, isFalse);
      expect(details.effectiveDiscountPercent, 20);
    });

    test('treats explicit giveaway as complimentary even without discount', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': true,
        'discount': null,
        'premiumCodeIsPaid': true,
      });

      expect(details.isComplimentaryMembership, isTrue);
      expect(details.effectiveDiscountPercent, 100);
    });

    test('does not let a paid non-giveaway 100 value become complimentary', () {
      final details = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': false,
        'discount': '100',
        'premiumCodeIsPaid': true,
      });

      expect(details.isComplimentaryMembership, isFalse);
      expect(details.effectiveDiscountPercent, 0);
    });

    test('recognises charity and club owners as community support sources', () {
      final charity = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': false,
        'codeOwnerType': 'charity',
      });
      final club = MembershipOfferCodeDetails.fromJson({
        'isGiveaway': false,
        'codeOwnerType': 'club',
      });

      expect(charity.proudlySupportsSource, isTrue);
      expect(club.proudlySupportsSource, isTrue);
    });
  });
}
