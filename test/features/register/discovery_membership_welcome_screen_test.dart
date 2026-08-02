import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/register/screens/discovery_membership_welcome_screen.dart';

void main() {
  testWidgets('shows configured terms and enters existing Home experience',
      (tester) async {
    const membership = DiscoveryMembershipContext(
      campaignName: 'Blue Butterfly Launch Gold Coast',
      invitationName: 'Carrara Markets - July 2026',
      communityName: 'Brisbane Community',
      periodDays: 30,
      savingsCapAmount: 25,
      currencyCode: r'A$',
      inheritanceEnabled: true,
    );
    final router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          builder: (_, __) => const DiscoveryMembershipWelcomeScreen(
            membership: membership,
          ),
        ),
        GoRoute(
          path: '/bottom-bar/:page',
          name: 'bottom-bar',
          builder: (_, state) => Text('Home ${state.pathParameters['page']}'),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Blue Butterfly Launch Gold Coast'), findsOne);
    expect(
      find.textContaining('Carrara Markets - July 2026 has invited'),
      findsOne,
    );
    expect(find.text('Membership period'), findsOne);
    expect(find.text('30 days'), findsOne);
    expect(find.text('Savings limit'), findsOne);
    expect(find.text(r'Up to A$25'), findsOne);
    expect(find.text('Invite Your Community'), findsNothing);
    expect(find.text('Enabled by your community campaign'), findsNothing);
    expect(
      find.text(
        'Enjoy member savings on shopping, dining, attractions, tours and local experiences.',
      ),
      findsOne,
    );
    expect(find.textContaining('free trial'), findsNothing);

    final startButton = find.byKey(const Key('start-discovering-button'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('Home 0'), findsOne);
  });

  testWidgets('uses the generic welcome when source details are unavailable',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DiscoveryMembershipWelcomeScreen(
          membership: DiscoveryMembershipContext(periodDays: 10),
        ),
      ),
    );

    expect(find.text('Welcome to the TouristSaver Community'), findsOne);
    expect(find.text('Invite Your Community'), findsNothing);
  });

  testWidgets('remains balanced and scrollable on common phone sizes',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    for (final size in [const Size(320, 568), const Size(390, 844)]) {
      tester.view.physicalSize = size;
      await tester.pumpWidget(
        const MaterialApp(
          home: DiscoveryMembershipWelcomeScreen(
            membership: DiscoveryMembershipContext(
              sourceName: 'Griffith University Student Guild',
              periodDays: 30,
              savingsCapAmountMinor: 2500,
              currencyCode: 'AUD',
              inheritanceEnabled: true,
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Membership period'), findsOne);
      expect(find.text('Savings limit'), findsOne);
      expect(find.text('Invite Your Community'), findsNothing);

      await tester.ensureVisible(
        find.byKey(const Key('start-discovering-button')),
      );
      expect(tester.takeException(), isNull);
    }
  });
}
