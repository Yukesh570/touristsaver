import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/common/models/discovery_membership_context.dart';
import 'package:touristsaver/common/services/registration_access_session.dart';
import 'package:touristsaver/constants/pref.dart';
import 'package:touristsaver/constants/pref_key.dart';
import 'package:touristsaver/models/response/confirm_topup_res.dart'
    as confirmation;
import 'package:touristsaver/models/response/register_res.dart' as registration;
import 'package:touristsaver/splash_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    RegistrationAccessSession.resetForTest();
    AppVariables.accessToken = null;
  });

  tearDown(() {
    RegistrationAccessSession.resetForTest();
    AppVariables.accessToken = null;
  });

  test('ordinary registration token stays checkout-only before payment',
      () async {
    await RegistrationAccessSession.begin('registration-token');

    expect(RegistrationAccessSession.isPending, isTrue);
    expect(RegistrationAccessSession.apiToken, 'registration-token');
    expect(AppVariables.accessToken, isNull);
    expect(await Pref().readData(key: saveToken), isNull);
    expect(
      await Pref().readData(key: pendingRegistrationAccessTokenKey),
      'registration-token',
    );
  });

  test('confirmed paid membership promotes the registration token', () async {
    await RegistrationAccessSession.begin('registration-token');

    await RegistrationAccessSession.grant(
      reason: RegistrationAccessGrantReason.premiumPaymentConfirmed,
      authoritativeToken: 'confirmed-token',
    );

    expect(RegistrationAccessSession.isPending, isFalse);
    expect(AppVariables.accessToken, 'confirmed-token');
    expect(await Pref().readData(key: saveToken), 'confirmed-token');
  });

  test('closing post-OTP checkout never promotes the applicant token',
      () async {
    await RegistrationAccessSession.begin(
      'registration-token',
      phonePrefix: '+61',
      phoneNumber: '0412 345 477',
      email: 'pending@example.com',
    );

    await RegistrationAccessSession.abandon();

    expect(RegistrationAccessSession.apiToken, isNull);
    expect(AppVariables.accessToken, isNull);
    expect(await Pref().readData(key: saveToken), isNull);
    expect(
      await Pref().readData(key: pendingRegistrationAccessTokenKey),
      isNull,
    );
    expect(
      await RegistrationAccessSession.matchesPendingRegistrationCredentials(
        phonePrefix: '+61',
        phoneNumber: '0412345477',
        email: '',
      ),
      isTrue,
    );
  });

  test('confirmed entitlement clears pending registration identity', () async {
    await RegistrationAccessSession.begin(
      'registration-token',
      phonePrefix: '+61',
      phoneNumber: '0412345477',
      email: 'pending@example.com',
    );

    await RegistrationAccessSession.grant(
      reason: RegistrationAccessGrantReason.premiumPaymentConfirmed,
    );

    expect(
      await RegistrationAccessSession.matchesPendingRegistrationCredentials(
        phonePrefix: '+61',
        phoneNumber: '0412345477',
        email: 'pending@example.com',
      ),
      isFalse,
    );
  });

  test('cancelled registration clears memory and persisted access', () async {
    await RegistrationAccessSession.begin('registration-token');

    await RegistrationAccessSession.abandon();

    expect(RegistrationAccessSession.isPending, isFalse);
    expect(RegistrationAccessSession.apiToken, isNull);
    expect(AppVariables.accessToken, isNull);
    expect(await Pref().readData(key: saveToken), isNull);
  });

  test('restart after cancelled payment remains logged out', () async {
    await RegistrationAccessSession.begin('registration-token');
    await RegistrationAccessSession.abandon();

    RegistrationAccessSession.resetForTest();
    AppVariables.accessToken = 'stale-memory-value';
    final hydratedToken = await hydratePersistedAccessToken(Pref());

    expect(hydratedToken, isNull);
    expect(AppVariables.accessToken, isNull);
  });

  test('abandoned checkout cannot hydrate an authenticated restart', () async {
    await RegistrationAccessSession.begin('registration-token');

    // A process restart discards in-memory checkout state without ever having
    // written the registration token to preferences.
    RegistrationAccessSession.resetForTest();
    AppVariables.accessToken = null;
    final hydratedToken = await hydratePersistedAccessToken(Pref());

    expect(hydratedToken, isNull);
    expect(AppVariables.accessToken, isNull);
  });

  test('abandon is scoped and preserves an existing authenticated member',
      () async {
    SharedPreferences.setMockInitialValues({saveToken: 'existing-token'});
    AppVariables.accessToken = 'existing-token';

    await RegistrationAccessSession.abandon();

    expect(AppVariables.accessToken, 'existing-token');
    expect(await Pref().readData(key: saveToken), 'existing-token');
  });

  test('pending registration cannot replace an existing authenticated member',
      () async {
    SharedPreferences.setMockInitialValues({saveToken: 'existing-token'});
    AppVariables.accessToken = 'existing-token';

    expect(
      () => RegistrationAccessSession.begin('registration-token'),
      throwsStateError,
    );
    expect(AppVariables.accessToken, 'existing-token');
    expect(await Pref().readData(key: saveToken), 'existing-token');
  });

  test('pending checkout redirects protected routes and deep links', () {
    expect(
      pendingRegistrationRedirect(isPending: true, path: '/bottom-bar/0'),
      '/paid-free?checkout=1',
    );
    expect(
      pendingRegistrationRedirect(isPending: true, path: '/pay'),
      '/paid-free?checkout=1',
    );
    expect(
      pendingRegistrationRedirect(isPending: true, path: '/paid-free'),
      isNull,
    );
    expect(
      pendingRegistrationRedirect(isPending: true, path: '/video-screen'),
      isNull,
    );
  });

  test('registration decisions keep Discovery and complimentary paths', () {
    expect(
      registrationAccessDecision(
        registration.Data(
          discoveryMembership: const DiscoveryMembershipContext(periodDays: 30),
        ),
      ),
      RegistrationAccessDecision.discovery,
    );
    expect(
      registrationAccessDecision(
        registration.Data(
          memberInfo: registration.MemberInfo(memberType: 'premium'),
          premiumCodeIsApplied: true,
          premiumCodeIsPaid: false,
          discount: '100',
          isGiveaway: false,
        ),
      ),
      RegistrationAccessDecision.complimentaryPremium,
    );
    expect(
      registrationAccessDecision(
        registration.Data(
          memberInfo: registration.MemberInfo(memberType: 'free'),
        ),
      ),
      RegistrationAccessDecision.paidConfirmationRequired,
    );
    expect(
      registrationAccessDecision(
        registration.Data(
          discoveryMembership:
              const DiscoveryMembershipContext(isActive: false),
        ),
      ),
      RegistrationAccessDecision.paidConfirmationRequired,
    );
  });

  test('profile access requires Premium or active Discovery entitlement', () {
    expect(
      memberProfileAllowsAuthenticatedAccess(
        memberType: 'premium',
        discoveryMembershipActive: false,
      ),
      isTrue,
    );
    expect(
      memberProfileAllowsAuthenticatedAccess(
        memberType: 'free',
        discoveryMembershipActive: true,
      ),
      isTrue,
    );
    expect(
      memberProfileAllowsAuthenticatedAccess(
        memberType: 'free',
        discoveryMembershipActive: false,
      ),
      isFalse,
    );
  });

  test('paid access requires an authoritative Premium confirmation', () {
    final futureExpiry = DateTime.utc(2030, 1, 1);
    final now = DateTime.utc(2029, 1, 1);

    expect(
      isAuthoritativePaidMembershipConfirmation(
        confirmation.ConfirmTopUpResModel(
          status: 'success',
          data: confirmation.Data(
            memberInfo: confirmation.MemberInfo(memberType: 'premium'),
          ),
        ),
        now: now,
      ),
      isTrue,
    );
    expect(
      isAuthoritativePaidMembershipConfirmation(
        confirmation.ConfirmTopUpResModel(
          status: 'success',
          data: confirmation.Data(
            memberInfo: confirmation.MemberInfo(memberType: 'free'),
            universalWallet:
                confirmation.UniversalWallet(premiumExpiryDate: futureExpiry),
          ),
        ),
        now: now,
      ),
      isTrue,
    );
    expect(
      isAuthoritativePaidMembershipConfirmation(
        confirmation.ConfirmTopUpResModel(
          status: 'failed',
          data: confirmation.Data(
            memberInfo: confirmation.MemberInfo(memberType: 'premium'),
          ),
        ),
        now: now,
      ),
      isFalse,
    );
    expect(
      isAuthoritativePaidMembershipConfirmation(
        confirmation.ConfirmTopUpResModel(
          status: 'success',
          data: confirmation.Data(
            memberInfo: confirmation.MemberInfo(memberType: 'free'),
          ),
        ),
        now: now,
      ),
      isFalse,
    );
  });
}
