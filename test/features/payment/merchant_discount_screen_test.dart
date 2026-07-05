import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/features/payment/screens/confirm_pay_screen.dart';

void main() {
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
            totalAmount: '345.50',
            discountedTransactionAmount: '276.40',
            totalPiiinkDiscount: '69.10',
            merchantDiscountPercentage: '20',
            merchantRebateToMember: '0',
            qrCode: 'TEST-MERCHANT-QR',
            hasMerchantPiiinks: 'false',
            hasUniversalPiiinks: 'true',
            universalPiiinkBalance: '100',
            merchantPiiinkBalance: '0',
            universalPiiinkOnHold: '0',
            merchantPiiinkOnHold: '0',
            logo: null,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Member Discount'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text("Chrissy's Restaurant"), findsOneWidget);
    expect(find.text('Discount Bill Amount'), findsOneWidget);
    expect(find.text(r'A$276.40'), findsOneWidget);
    expect(find.text('Original Bill'), findsOneWidget);
    expect(find.text(r'A$345.50'), findsOneWidget);
    expect(find.text('You Save'), findsOneWidget);
    expect(find.text(r'A$69.10 (20%)'), findsOneWidget);
    expect(
      find.text('Cashier enters this amount into the EFTPOS terminal.'),
      findsOneWidget,
    );
    expect(find.text('Show this screen to the cashier.'), findsOneWidget);
    expect(find.text('Close'), findsOneWidget);
    expect(find.text('Edit Bill Amount'), findsOneWidget);
    expect(find.text('Leave a Review'), findsOneWidget);

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
