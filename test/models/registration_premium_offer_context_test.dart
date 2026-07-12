import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/registration_premium_offer_context.dart';
import 'package:touristsaver/models/response/register_res.dart';

void main() {
  group('registration premium offer payment handoff', () {
    test('97% code produces AUD 2.97 and sends original code', () {
      final context = RegistrationPremiumOfferContext.fromRegistrationResponse(
        memberPremiumCode: 'chrest1234',
        data: Data(
          premiumCodeIsApplied: true,
          premiumCodeIsPaid: true,
          packageId: 9,
          discount: '97',
          isGiveaway: false,
        ),
      );

      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: context.toPremiumData(),
      );

      expect(preview.discountPercent, 97);
      expect(preview.discountAmount, closeTo(96.03, 0.001));
      expect(preview.payableAmount, closeTo(2.97, 0.001));
      expect(preview.memberPremiumCodeForPaymentIntent, 'CHREST1234');
      expect(context.packageId, 9);
    });

    test('20% code produces AUD 79.20 and sends original code', () {
      final context = RegistrationPremiumOfferContext.fromRegistrationResponse(
        memberPremiumCode: 'saver20',
        data: Data(
          premiumCodeIsApplied: true,
          premiumCodeIsPaid: true,
          packageId: 9,
          discount: '20',
          isGiveaway: false,
        ),
      );

      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: context.toPremiumData(),
      );

      expect(preview.discountPercent, 20);
      expect(preview.discountAmount, closeTo(19.80, 0.001));
      expect(preview.payableAmount, closeTo(79.20, 0.001));
      expect(preview.memberPremiumCodeForPaymentIntent, 'SAVER20');
    });

    test('100% complimentary code does not enter paid PaymentIntent path', () {
      final context = RegistrationPremiumOfferContext.fromRegistrationResponse(
        memberPremiumCode: 'FREE100',
        data: Data(
          memberInfo: MemberInfo(memberType: 'premium'),
          premiumCodeIsApplied: true,
          premiumCodeIsPaid: false,
          packageId: 9,
          discount: '100',
          isGiveaway: false,
        ),
      );

      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: context.toPremiumData(),
      );

      expect(preview.isComplimentary, isTrue);
      expect(preview.payableAmount, 0);
      expect(preview.memberPremiumCodeForPaymentIntent, isNull);
    });

    test('no code keeps full AUD 99 and sends no code', () {
      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: null,
      );

      expect(preview.discountPercent, 0);
      expect(preview.discountAmount, 0);
      expect(preview.payableAmount, 99);
      expect(preview.memberPremiumCodeForPaymentIntent, isNull);
    });

    test('invalid or expired code has no registration context and no discount',
        () {
      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: <String, dynamic>{},
      );

      expect(preview.discountPercent, 0);
      expect(preview.payableAmount, 99);
      expect(preview.memberPremiumCodeForPaymentIntent, isNull);
    });
  });
}
