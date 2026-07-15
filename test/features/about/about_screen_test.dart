import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:touristsaver/features/about/screens/about_screen.dart';
import 'package:touristsaver/generated/l10n.dart';

void main() {
  testWidgets('shows package version and build number on separate lines', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'TouristSaver',
      packageName: 'com.touristsaver.app',
      version: '1.3.4',
      buildNumber: '57',
      buildSignature: '',
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, __) => const MaterialApp(
          localizationsDelegates: S.localizationsDelegates,
          supportedLocales: S.supportedLocales,
          home: AboutScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Version 1.3.4'), findsOneWidget);
    expect(find.text('Build 57'), findsOneWidget);
    expect(find.textContaining('1.3.4 (57)'), findsNothing);
  });
}
