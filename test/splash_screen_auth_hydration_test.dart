import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/constants/app_environment.dart';
import 'package:touristsaver/constants/pref.dart';
import 'package:touristsaver/constants/pref_key.dart';
import 'package:touristsaver/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    AppVariables.accessToken = null;
  });

  test('hydrates a persisted token before the bottom-bar decision', () async {
    SharedPreferences.setMockInitialValues({
      saveToken: 'persisted-production-token',
    });
    AppVariables.accessToken = null;

    final token = await hydratePersistedAccessToken(Pref());

    expect(AppEnvironment.isProduction, isTrue);
    expect(token, 'persisted-production-token');
    expect(AppVariables.accessToken, 'persisted-production-token');
  });

  test('keeps the logged-out state when no token is persisted', () async {
    SharedPreferences.setMockInitialValues({});
    AppVariables.accessToken = 'stale-token';

    final token = await hydratePersistedAccessToken(Pref());

    expect(AppEnvironment.isProduction, isTrue);
    expect(token, isNull);
    expect(AppVariables.accessToken, isNull);
  });
}
