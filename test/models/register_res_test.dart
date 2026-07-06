import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/response/register_res.dart';

void main() {
  group('registration membership state', () {
    test('treats premium memberType as authoritative', () {
      final data = Data(memberInfo: MemberInfo(memberType: ' Premium '));

      expect(data.isPremiumMember, isTrue);
    });

    test('does not infer Premium status from offer response fields', () {
      final data = Data(
        memberInfo: MemberInfo(memberType: 'free'),
        premiumCodeIsApplied: true,
        premiumCodeIsPaid: true,
        packageId: 12,
        discount: '100',
      );

      expect(data.isPremiumMember, isFalse);
    });

    test('handles absent member information as non-Premium', () {
      final data = Data(
        premiumCodeIsApplied: true,
        discount: '100',
      );

      expect(data.isPremiumMember, isFalse);
    });
  });
}
