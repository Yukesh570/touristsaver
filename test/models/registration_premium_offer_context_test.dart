import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/registration_premium_offer_context.dart';
import 'package:touristsaver/models/response/register_res.dart';
import 'package:touristsaver/models/response/pre_topup_paid_res.dart'
    as checkout;

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
      expect(context.pendingRegistrationAccess, isTrue);
      expect(
        RegistrationPremiumOfferContext.fromRouteExtra(context.toRouteExtra())
            .pendingRegistrationAccess,
        isTrue,
      );
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

    test('checkout Premium response retains discount and package details', () {
      final response = checkout.PremiumTopUpPaidResModel.fromJson({
        'status': 'success',
        'data': {
          'premiumCodeIsPaid': true,
          'membershipPackageId': 9,
          'piiinksAmount': 0,
          'discount': 20,
          'isGiveaway': false,
        },
      });

      expect(response.data?.premiumCodeIsPaid, isTrue);
      expect(response.data?.membershipPackageId, 9);
      expect(response.data?.discount, 20);
      expect(response.data?.isGiveaway, isFalse);
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

  group('checkout promo presentation state', () {
    test('restores the applied code from authenticated checkout context', () {
      expect(
        restoredAppliedPromoCode(const {
          'memberPremiumCode': ' saver50 ',
          'discount': '50.50505051',
          'membershipPackageId': 9,
        }),
        'SAVER50',
      );
      expect(restoredAppliedPromoCode(null), isEmpty);
    });

    test('registration promo is already applied and cannot be reapplied', () {
      const state = CheckoutPromoState(
        enteredPromoCode: ' SAVER50 ',
        appliedPromoCode: 'saver50',
        regularPrice: 99,
        discountAmount: 50,
        finalPayableAmount: 49,
      );

      expect(state.hasEnteredCode, isTrue);
      expect(state.hasAppliedPromo, isTrue);
      expect(state.promoChanged, isFalse);
      expect(state.enableApply, isFalse);
    });

    test('editing enables Apply and restoring the code disables it', () {
      const changed = CheckoutPromoState(
        enteredPromoCode: 'NEWCODE',
        appliedPromoCode: 'SAVER50',
        regularPrice: 99,
        discountAmount: 50,
        finalPayableAmount: 49,
      );
      const restored = CheckoutPromoState(
        enteredPromoCode: ' saver50 ',
        appliedPromoCode: 'SAVER50',
        regularPrice: 99,
        discountAmount: 50,
        finalPayableAmount: 49,
      );

      expect(changed.enableApply, isTrue);
      expect(restored.enableApply, isFalse);
    });

    test('empty input disables Apply and a first code enables it', () {
      const empty = CheckoutPromoState(
        enteredPromoCode: '  ',
        appliedPromoCode: '',
        regularPrice: 99,
        discountAmount: 0,
        finalPayableAmount: 99,
      );
      const firstCode = CheckoutPromoState(
        enteredPromoCode: 'SAVER50',
        appliedPromoCode: '',
        regularPrice: 99,
        discountAmount: 0,
        finalPayableAmount: 99,
      );

      expect(empty.enableApply, isFalse);
      expect(firstCode.enableApply, isTrue);
    });

    test('raw percentage precision renders as customer-facing money', () {
      final preview = membershipOfferPaymentPreview(
        originalAmount: 99,
        premiumData: const {
          'memberPremiumCode': 'SAVER50',
          'premiumCodeIsPaid': true,
          'isGiveaway': false,
          'discount': '50.50505051',
        },
      );

      expect(
        formatCheckoutMembershipAmount(
          amount: preview.originalAmount,
          currencySymbol: r'A$',
          currencyName: 'AUD',
        ),
        r'A$99.00 AUD',
      );
      expect(
        formatCheckoutMembershipAmount(
          amount: preview.discountAmount,
          currencySymbol: r'A$',
          currencyName: 'AUD',
        ),
        r'A$50.00 AUD',
      );
      expect(
        formatCheckoutMembershipAmount(
          amount: preview.payableAmount,
          currencySymbol: r'A$',
          currencyName: 'AUD',
        ),
        r'A$49.00 AUD',
      );
    });
  });
}
