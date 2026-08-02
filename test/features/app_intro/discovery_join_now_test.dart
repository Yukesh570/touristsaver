import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';
import 'package:touristsaver/features/app_intro/screens/intro_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Join Now carries pending Discovery code without clearing it',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    BranchReferralService.resetPendingDiscoveryInMemory();
    await BranchReferralService.replacePendingDiscoveryReferral(
      const BranchRegistrationReferral(
        discoveryInvitationCode: '333BUTTERFLY',
        type: BranchReferralType.discoveryInvitation,
      ),
    );

    final router = GoRouter(
      initialLocation: '/intro-screen',
      routes: [
        GoRoute(
          path: '/intro-screen',
          name: 'intro-screen',
          builder: (_, __) => const IntroScreen(),
        ),
        GoRoute(
          path: '/membership-country',
          name: 'membership-country',
          builder: (_, state) => Scaffold(
            body: Text(
              state.uri.queryParameters['registrationCode'] ?? 'missing',
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 786),
        builder: (_, __) => MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Join Now'), findsOneWidget);
    await tester.ensureVisible(find.text('Join Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join Now'));
    await tester.pumpAndSettle();

    expect(find.text('333BUTTERFLY'), findsOneWidget);
    expect(
      BranchReferralService.pendingDiscoveryReferral?.discoveryInvitationCode,
      '333BUTTERFLY',
    );
  });
}
