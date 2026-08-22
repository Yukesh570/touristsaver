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
    expect(find.text('You Save'), findsOneWidget);
    expect(find.text(r'A$5.00 (10%)'), findsOneWidget);
    expect(
      find.text('Cashier enters this amount into the EFTPOS terminal.'),
      findsOneWidget,
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
}
