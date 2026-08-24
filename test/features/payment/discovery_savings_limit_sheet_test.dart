import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/discovery_membership/services/discovery_premium_continuation_flow.dart';
import 'package:touristsaver/features/discovery_membership/widgets/discovery_savings_limit_sheet.dart';
import 'package:touristsaver/models/error_res.dart';

class _SuccessfulContinuationFlow extends DiscoveryPremiumContinuationFlow {
  _SuccessfulContinuationFlow(this.onContinue);

  final VoidCallback onContinue;

  @override
  Future<DiscoveryContinuationResult> continueWith(
    DiscoveryMembershipContext membership,
  ) async {
    onContinue();
    return const DiscoveryContinuationResult(
      DiscoveryContinuationStatus.activated,
    );
  }
}

void main() {
  final membership = DiscoveryMembershipContext.fromJson({
    'active': false,
    'entitlementId': 51,
    'status': 'consumed',
    'endReason': 'savings_cap_reached',
    'savingsConsumedAmountMinor': 2375,
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

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('recognises only the backend Discovery cap code', () {
    expect(
      isDiscoverySavingsCapResponse(
        ErrorResModel(
          status: 'FAIL',
          code: discoverySavingsCapErrorCode,
          message: 'Localised backend message',
        ),
      ),
      isTrue,
    );
    expect(
      isDiscoverySavingsCapResponse(
        ErrorResModel(status: 'FAIL', code: 'GENUINE_PAYMENT_ERROR'),
      ),
      isFalse,
    );
  });

  test('excludes Premium and active Discovery memberships', () {
    expect(
      canPresentDiscoverySavingsLimit(
        memberType: 'premium',
        membership: membership,
      ),
      isFalse,
    );
    expect(
      canPresentDiscoverySavingsLimit(
        memberType: 'free',
        membership: const DiscoveryMembershipContext(isActive: true),
      ),
      isFalse,
    );
    expect(
      canPresentDiscoverySavingsLimit(
        memberType: 'free',
        membership: membership,
      ),
      isTrue,
    );
  });

  testWidgets('shows backend amounts and dismisses cleanly', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      DiscoverySavingsLimitSheet(membership: membership),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(
      find.text('You’ve reached your Discovery savings limit'),
      findsOneWidget,
    );
    expect(find.textContaining(r'A$23.75'), findsOneWidget);
    expect(find.text(r'Continue with Premium for A$59.00'), findsOneWidget);
    expect(find.byKey(const Key('discovery-savings-limit-sheet')), findsOne);

    await tester.ensureVisible(find.text('Not now'));
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(
        find.byKey(const Key('discovery-savings-limit-sheet')), findsNothing);
  });

  testWidgets('primary CTA starts the shared continuation flow',
      (tester) async {
    var continuationCalls = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DiscoverySavingsLimitSheet(
                    membership: membership,
                    continuationFlow: _SuccessfulContinuationFlow(
                      () => continuationCalls += 1,
                    ),
                  ),
                ),
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.text(r'Continue with Premium for A$59.00'),
    );
    await tester.tap(find.text(r'Continue with Premium for A$59.00'));
    await tester.pumpAndSettle();

    expect(continuationCalls, 1);
    expect(
        find.byKey(const Key('discovery-savings-limit-sheet')), findsNothing);
    final saved = await const DiscoveryMembershipStore().read();
    expect(saved?.continuation?.accepted, isTrue);
  });
}
