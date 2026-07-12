import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/features/register/screens/discovery_membership_welcome_screen.dart';

void main() {
  testWidgets('shows configured terms and enters existing Home experience',
      (tester) async {
    const membership = DiscoveryMembershipContext(
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

    expect(find.textContaining('Brisbane Community has invited'), findsOne);
    expect(find.text('Days to Explore'), findsOne);
    expect(find.text('Savings to Discover'), findsOne);
    expect(find.text('Invite Your Community'), findsOne);
    expect(find.textContaining('free trial'), findsNothing);

    final startButton = find.byKey(const Key('start-discovering-button'));
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(find.text('Home 0'), findsOne);
  });

  testWidgets('hides invitation inheritance copy when disabled',
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
}
