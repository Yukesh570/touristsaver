import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/services/membership_offer_recognition.dart';

void main() {
  group('Welcome Attribution preference', () {
    test('keeps backend attribution for Merchant codes', () {
      expect(
        shouldLoadLegacyMerchantAttribution(
          codeOwnerType: 'merchant',
          codeOwnerId: 41,
          assignedToName: 'Gold Coast Tourist Magazine',
        ),
        isFalse,
      );
    });

    test('retains legacy Merchant lookup as a fallback', () {
      expect(
        shouldLoadLegacyMerchantAttribution(
          codeOwnerType: 'merchant',
          codeOwnerId: 41,
          assignedToName: null,
        ),
        isTrue,
      );
    });

    test('does not perform Merchant lookup for other issuer types', () {
      expect(
        shouldLoadLegacyMerchantAttribution(
          codeOwnerType: 'areaOwner',
          codeOwnerId: 51,
          assignedToName: 'Gold Coast Tourist Magazine',
        ),
        isFalse,
      );
    });
  });
}
