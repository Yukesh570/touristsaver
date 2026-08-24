import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/wallet/screens/log_wallet_screen.dart';

void main() {
  final membership = DiscoveryMembershipContext.fromJson({
    'active': false,
    'status': 'consumed',
    'endReason': 'savings_cap_reached',
    'savingsConsumedAmountMinor': 1875,
    'currency': 'AUD',
    'continuation': {
      'eligible': true,
      'status': 'offered',
      'complimentary': false,
      'membershipPackageId': 9,
      'priceAmountMinor': 5900,
      'currency': 'AUD',
    },
  });

  test('uses Discovery wording until conversion and neutral generic wording',
      () {
    expect(
      savingsHeadline(usesDiscoveryWording: true),
      'Discovery Savings',
    );
    expect(
      savingsProgressDescription(usesDiscoveryWording: true),
      'Your TouristSaver Discovery Membership savings achieved so far.',
    );
    expect(
      savingsHeadline(usesDiscoveryWording: false),
      'TouristSaver Savings',
    );
    expect(
      savingsProgressDescription(usesDiscoveryWording: false),
      isNot(contains('Premium Savings')),
    );
  });

  testWidgets('completion card uses backend savings and continuation price',
      (tester) async {
    var continuationCalls = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: DiscoveryMembershipCompletionCard(
                membership: membership,
                loading: false,
                onContinue: () => continuationCalls += 1,
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      find.text('You’ve completed your Discovery Membership'),
      findsOneWidget,
    );
    expect(find.textContaining(r'A$18.75'), findsOneWidget);
    expect(find.text(r'Continue with Premium for A$59.00'), findsOneWidget);

    await tester.tap(find.text(r'Continue with Premium for A$59.00'));
    expect(continuationCalls, 1);
  });

  testWidgets('completion state remains clear without a continuation offer',
      (tester) async {
    final noOffer = DiscoveryMembershipContext.fromJson({
      ...membership.toJson(),
      'continuation': null,
    });
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: DiscoveryMembershipCompletionCard(
              membership: noOffer,
              loading: false,
            ),
          ),
        ),
      ),
    );

    expect(
      find.text('You’ve completed your Discovery Membership'),
      findsOneWidget,
    );
    expect(find.textContaining('Continue with Premium'), findsNothing);
  });
}
