import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/features/payment/screens/confirm_pay_screen.dart';
import 'package:touristsaver/models/response/confirm_piiink_res.dart';

void main() {
  test('parses the authoritative Discovery saving adjustment', () {
    final response = ConfirmApplyPiiinkResModel.fromJson({
      'status': 'Success',
      'data': {
        'merchantInfo': null,
        'universalPiiinkBalanceOnHold': 0,
        'merchantPiiinkBalanceOnHold': 0,
        'universalPiiinkBalance': 0,
        'merchantPiiinkBalance': 0,
        'merchantDiscountPercentage': 10,
        'totalTransactionAmount': 70,
        'totalPiiinkDiscount': 5,
        'discountedTransactionAmount': 65,
        'merchantRebateToMember': 6.5,
        'hasUniversalPiiinks': true,
        'hasMerchantPiiinks': true,
        'discoverySavingsAdjustment': {
          'capped': true,
          'normalSavingAmountMinor': 700,
          'allowedSavingAmountMinor': 500,
          'remainingBeforeAmountMinor': 500,
          'remainingAfterAmountMinor': 0,
          'message': 'Limited to A\$5.00.',
        },
      },
    });

    expect(response.data!.totalPiiinkDiscount, 5);
    expect(response.data!.discountedTransactionAmount, 65);
    expect(response.data!.discoverySavingsAdjustment!.capped, isTrue);
    expect(
      response.data!.discoverySavingsAdjustment!.allowedSavingAmountMinor,
      500,
    );
    expect(
      response.data!.discoverySavingsAdjustment!.message,
      'Limited to A\$5.00.',
    );
  });

  testWidgets('presents one cashier-focused merchant discount screen',
      (tester) async {
    AppVariables.currency = r'A$';

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, child) => const MaterialApp(
          home: ConfimrPaymentScreen(
            merchantId: 42,
            merchantName: "Chrissy's Restaurant",
            totalAmount: '70.00',
            discountedTransactionAmount: '65.00',
            totalPiiinkDiscount: '5.00',
            merchantDiscountPercentage: '10',
            merchantRebateToMember: '0',
            qrCode: 'TEST-MERCHANT-QR',
            hasMerchantPiiinks: 'false',
            hasUniversalPiiinks: 'true',
            universalPiiinkBalance: '100',
            merchantPiiinkBalance: '0',
            universalPiiinkOnHold: '0',
            merchantPiiinkOnHold: '0',
            logo: null,
            discoverySavingsMessage:
                'Your Discovery Membership has A\$5.00 savings remaining. '
                'This purchase would normally save you A\$7.00, so your '
                'Discovery saving for this transaction is limited to A\$5.00.',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Member Payment'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text("Chrissy's Restaurant"), findsOneWidget);
    expect(find.text('Amount to Pay'), findsOneWidget);
    expect(find.text(r'A$65.00'), findsOneWidget);
    expect(find.text('Original Bill'), findsOneWidget);
    expect(find.text(r'A$70.00'), findsOneWidget);
    expect(find.text('Merchant offer'), findsOneWidget);
    expect(find.text('10%'), findsOneWidget);
    expect(find.text('Discovery Saving'), findsOneWidget);
    expect(find.text(r'A$5.00'), findsOneWidget);
    expect(find.text('You Save'), findsNothing);
    expect(find.text(r'A$5.00 (10%)'), findsNothing);
    expect(
      find.text('Cashier enters this amount into the EFTPOS terminal.'),
      findsNothing,
    );
    expect(find.text('Show this screen to the cashier.'), findsOneWidget);
    expect(
      find.text(
        'Your Discovery Membership has A\$5.00 savings remaining. '
        'This purchase would normally save you A\$7.00, so your '
        'Discovery saving for this transaction is limited to A\$5.00.',
      ),
      findsOneWidget,
    );
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Edit Bill Amount'), findsOneWidget);

    expect(find.textContaining('Approve'), findsNothing);
    expect(find.textContaining('Approved'), findsNothing);
    expect(find.textContaining('Merchant Savings Earned'), findsNothing);
    expect(find.byIcon(Icons.point_of_sale_rounded), findsNothing);
    expect(
      find.text(
        'The customer pays this discounted amount directly to the merchant.',
      ),
      findsNothing,
    );
  });

  testWidgets('keeps claim actions accessible with a long Discovery message',
      (tester) async {
    tester.view.physicalSize = const Size(390, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    AppVariables.currency = r'A$';

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (_, __) => const MaterialApp(
          home: ConfimrPaymentScreen(
            merchantId: 42,
            merchantName: 'A Merchant With A Longer Display Name',
            totalAmount: '200.00',
            discountedTransactionAmount: '185.00',
            totalPiiinkDiscount: '15.00',
            merchantDiscountPercentage: '10',
            merchantRebateToMember: '0',
            qrCode: 'TEST-MERCHANT-QR',
            hasMerchantPiiinks: 'false',
            hasUniversalPiiinks: 'true',
            universalPiiinkBalance: '100',
            merchantPiiinkBalance: '0',
            universalPiiinkOnHold: '0',
            merchantPiiinkOnHold: '0',
            logo: null,
            discoverySavingsMessage:
                'Your Discovery Membership had A\$15.00 savings remaining. '
                'This purchase would normally save you A\$20.00, so your '
                'Discovery saving for this transaction is limited to A\$15.00. '
                'This deliberately long explanation verifies that the content '
                'can scroll without moving the actions outside the viewport.',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.byKey(const Key('claim-completion-content-scroll')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('claim-completion-actions')), findsOneWidget);
    expect(find.text('Close').hitTestable(), findsOneWidget);
    expect(find.text('Edit Bill Amount').hitTestable(), findsOneWidget);
  });
}
