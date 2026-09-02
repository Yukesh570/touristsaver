import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/common/services/registration_access_session.dart';
import 'package:touristsaver/constants/app_environment.dart';
import 'package:touristsaver/constants/pref.dart';
import 'package:touristsaver/constants/pref_key.dart';
import 'package:touristsaver/splash_screen.dart';
import 'package:touristsaver/models/response/user_detail_res.dart' as profile;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    RegistrationAccessSession.resetForTest();
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

  test('a leaked persisted Free token is moved back behind checkout', () async {
    SharedPreferences.setMockInitialValues({
      saveToken: 'unconfirmed-applicant-token',
    });

    final decision = await resolvePersistedMemberAccess(
      Pref(),
      loadProfile: () async => profile.UserProfileResModel(
        data: profile.Data(
          results: profile.Results(memberType: 'free'),
        ),
      ),
    );

    expect(decision, PersistedMemberAccessDecision.checkoutRequired);
    expect(AppVariables.accessToken, isNull);
    expect(RegistrationAccessSession.apiToken, 'unconfirmed-applicant-token');
    expect(await Pref().readData(key: saveToken), isNull);
    expect(
      await Pref().readData(key: pendingRegistrationAccessTokenKey),
      'unconfirmed-applicant-token',
    );
  });

  test('startup allows only a backend-confirmed entitled profile', () async {
    SharedPreferences.setMockInitialValues({saveToken: 'premium-token'});

    final decision = await resolvePersistedMemberAccess(
      Pref(),
      loadProfile: () async => profile.UserProfileResModel(
        data: profile.Data(
          results: profile.Results(memberType: 'premium'),
        ),
      ),
    );

    expect(decision, PersistedMemberAccessDecision.allowed);
    expect(AppVariables.accessToken, 'premium-token');
    expect(
      await Pref().readBool(key: confirmedMemberEntitlementKey),
      isTrue,
    );
  });

  test('restart restores checkout-only access without hydrating Home',
      () async {
    SharedPreferences.setMockInitialValues({
      pendingRegistrationAccessTokenKey: 'checkout-token',
    });

    final decision = await resolvePersistedMemberAccess(
      Pref(),
      loadProfile: () async => throw StateError('must not load profile'),
    );

    expect(decision, PersistedMemberAccessDecision.checkoutRequired);
    expect(AppVariables.accessToken, isNull);
    expect(RegistrationAccessSession.apiToken, 'checkout-token');
  });
}
