import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/profile/screens/log_profile_screen.dart';

void main() {
  test('confirmed continuation overrides stale Free profile state', () {
    final discovery = DiscoveryMembershipContext.fromJson({
      'active': false,
      'status': 'consumed',
      'continuation': {
        'eligible': true,
        'status': 'offered',
        'complimentary': false,
        'membershipPackageId': 9,
        'priceAmountMinor': 4900,
        'currency': 'AUD',
      },
    });

    expect(
      profileMembershipStatus(
        loadedStatus: 'free',
        premiumContinuationConfirmed: true,
      ),
      'premium',
    );
    final refreshed = profileDiscoveryMembership(
      loadedMembership: discovery,
      premiumContinuationConfirmed: true,
    );
    expect(refreshed?.continuation?.accepted, isTrue);
    expect(refreshed?.continuation?.eligible, isFalse);
  });

  testWidgets('continuation CTA uses the TouristSaver blue gradient',
      (tester) async {
    var presses = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => MaterialApp(
          home: Scaffold(
            body: DiscoveryPremiumContinuationButton(
              label: r'Continue with Premium for A$49.00',
              loading: false,
              onPressed: () => presses += 1,
            ),
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(DiscoveryPremiumContinuationButton),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoration = container.decoration! as BoxDecoration;
    final gradient = decoration.gradient! as LinearGradient;
    expect(gradient.colors, const [Color(0xFF0009FE), Color(0xFF18C6FF)]);
    expect(find.text(r'Continue with Premium for A$49.00'), findsOneWidget);

    await tester.tap(find.text(r'Continue with Premium for A$49.00'));
    expect(presses, 1);
  });
}
