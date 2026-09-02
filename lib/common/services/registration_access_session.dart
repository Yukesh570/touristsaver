import 'package:touristsaver/common/app_variables.dart';
import 'package:touristsaver/constants/pref.dart';
import 'package:touristsaver/constants/pref_key.dart';
import 'package:touristsaver/models/response/confirm_topup_res.dart';
import 'package:touristsaver/models/response/register_res.dart' as registration;

enum RegistrationAccessDecision {
  discovery,
  complimentaryPremium,
  paidConfirmationRequired,
}

RegistrationAccessDecision registrationAccessDecision(
  registration.Data data,
) {
  if (data.discoveryMembership?.isActive == true) {
    return RegistrationAccessDecision.discovery;
  }
  if (data.shouldShowPremiumWelcomeAfterRegistration) {
    return RegistrationAccessDecision.complimentaryPremium;
  }
  return RegistrationAccessDecision.paidConfirmationRequired;
}

bool memberProfileAllowsAuthenticatedAccess({
  required String? memberType,
  required bool discoveryMembershipActive,
}) {
  return memberType?.trim().toLowerCase() == 'premium' ||
      discoveryMembershipActive;
}

enum PersistedMemberAccessDecision { loggedOut, checkoutRequired, allowed }

enum RegistrationAccessGrantReason {
  backendProfileConfirmed,
  premiumPaymentConfirmed,
  complimentaryPremiumConfirmed,
  discoveryConfirmed,
}

class RegistrationAccessSession {
  RegistrationAccessSession._();

  static String? _pendingToken;

  static bool get isPending => _pendingToken != null;

  static String? get apiToken => _pendingToken ?? AppVariables.accessToken;

  static Future<void> begin(
    String token, {
    String? phonePrefix,
    String? phoneNumber,
    String? email,
    Pref? pref,
  }) async {
    final normalized = token.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(token, 'token', 'Registration token is empty');
    }

    final storage = pref ?? Pref();
    final existingToken = (await storage.readData(key: saveToken))?.trim();
    if (existingToken?.isNotEmpty == true) {
      throw StateError(
        'An authenticated session already exists; registration checkout was not started.',
      );
    }
    await storage.removeData(confirmedMemberEntitlementKey);
    await storage.writeData(
      key: pendingRegistrationAccessTokenKey,
      value: normalized,
    );
    await _rememberPendingIdentity(
      storage,
      phonePrefix: phonePrefix,
      phoneNumber: phoneNumber,
      email: email,
    );
    AppVariables.accessToken = null;
    _pendingToken = normalized;
  }

  static Future<bool> restorePending({Pref? pref}) async {
    if (_pendingToken?.isNotEmpty == true) return true;
    final storage = pref ?? Pref();
    final token =
        (await storage.readData(key: pendingRegistrationAccessTokenKey))
            ?.trim();
    if (token == null || token.isEmpty) return false;
    _pendingToken = token;
    AppVariables.accessToken = null;
    return true;
  }

  static Future<void> requireCheckoutForPersistedToken(
    String token, {
    Pref? pref,
  }) async {
    final normalized = token.trim();
    if (normalized.isEmpty) return;
    final storage = pref ?? Pref();
    await storage.removeData(saveToken);
    await storage.removeData(confirmedMemberEntitlementKey);
    await storage.writeData(
      key: pendingRegistrationAccessTokenKey,
      value: normalized,
    );
    AppVariables.accessToken = null;
    _pendingToken = normalized;
  }

  static Future<void> confirmPersistedAccess(
    String token, {
    Pref? pref,
  }) async {
    final normalized = token.trim();
    if (normalized.isEmpty) return;
    final storage = pref ?? Pref();
    await storage.writeData(key: saveToken, value: normalized);
    await storage.setBool(key: confirmedMemberEntitlementKey, value: true);
    await storage.removeData(pendingRegistrationAccessTokenKey);
    await _clearPendingIdentity(storage);
    AppVariables.accessToken = normalized;
    _pendingToken = null;
  }

  static Future<void> grant({
    required RegistrationAccessGrantReason reason,
    String? authoritativeToken,
    Pref? pref,
  }) async {
    if (!isPending) return;

    final normalizedAuthoritativeToken = authoritativeToken?.trim();
    final token = normalizedAuthoritativeToken?.isNotEmpty == true
        ? normalizedAuthoritativeToken!
        : _pendingToken!;
    final storage = pref ?? Pref();
    await storage.writeData(key: saveToken, value: token);
    await storage.setBool(key: confirmedMemberEntitlementKey, value: true);
    await storage.removeData(pendingRegistrationAccessTokenKey);
    await _clearPendingIdentity(storage);
    AppVariables.accessToken = token;
    _pendingToken = null;
  }

  static Future<void> abandon({Pref? pref}) async {
    final pendingToken = _pendingToken;
    _pendingToken = null;
    final storage = pref ?? Pref();
    await storage.removeData(pendingRegistrationAccessTokenKey);
    if (pendingToken != null) {
      AppVariables.accessToken = null;
    }
  }

  static Future<bool> matchesPendingRegistrationCredentials({
    required String phonePrefix,
    required String phoneNumber,
    required String email,
    Pref? pref,
  }) async {
    final storage = pref ?? Pref();
    final savedPhonePrefix =
        await storage.readData(key: pendingRegistrationPhonePrefixKey);
    final savedPhoneNumber =
        await storage.readData(key: pendingRegistrationPhoneNumberKey);
    final savedEmail = await storage.readData(key: pendingRegistrationEmailKey);
    final normalizedPhone = _normalizePhone(phoneNumber);
    final phoneMatches = normalizedPhone.isNotEmpty &&
        _normalizePhone(savedPhoneNumber?.toString() ?? '') ==
            normalizedPhone &&
        (savedPhonePrefix?.toString().trim() ?? '') == phonePrefix.trim();
    final normalizedEmail = email.trim().toLowerCase();
    final emailMatches = normalizedEmail.isNotEmpty &&
        (savedEmail?.toString().trim().toLowerCase() ?? '') == normalizedEmail;
    return phoneMatches || emailMatches;
  }

  static Future<void> _rememberPendingIdentity(
    Pref storage, {
    String? phonePrefix,
    String? phoneNumber,
    String? email,
  }) async {
    final normalizedPhone = _normalizePhone(phoneNumber ?? '');
    final normalizedEmail = email?.trim().toLowerCase() ?? '';
    if (normalizedPhone.isNotEmpty) {
      await storage.writeData(
        key: pendingRegistrationPhonePrefixKey,
        value: phonePrefix?.trim() ?? '',
      );
      await storage.writeData(
        key: pendingRegistrationPhoneNumberKey,
        value: normalizedPhone,
      );
    }
    if (normalizedEmail.isNotEmpty) {
      await storage.writeData(
        key: pendingRegistrationEmailKey,
        value: normalizedEmail,
      );
    }
  }

  static Future<void> _clearPendingIdentity(Pref storage) async {
    await storage.removeData(pendingRegistrationPhonePrefixKey);
    await storage.removeData(pendingRegistrationPhoneNumberKey);
    await storage.removeData(pendingRegistrationEmailKey);
  }

  static String _normalizePhone(String value) =>
      value.replaceAll(RegExp(r'\D'), '');

  static void resetForTest() {
    _pendingToken = null;
  }
}

bool isRegistrationCheckoutPath(String path) =>
    path == PaidRegistrationRoutes.checkout ||
    path == PaidRegistrationRoutes.checkoutVideo;

String? pendingRegistrationRedirect({
  required bool isPending,
  required String path,
}) {
  if (!isPending || isRegistrationCheckoutPath(path)) return null;
  return Uri(
    path: PaidRegistrationRoutes.checkout,
    queryParameters: const {'checkout': '1'},
  ).toString();
}

abstract final class PaidRegistrationRoutes {
  static const checkout = '/paid-free';
  static const checkoutVideo = '/video-screen';
}

bool isAuthoritativePaidMembershipConfirmation(
  ConfirmTopUpResModel? confirmation, {
  DateTime? now,
}) {
  if (confirmation?.status?.trim().toLowerCase() != 'success') return false;

  final data = confirmation?.data;
  if (data == null) return false;
  final isPremium =
      data.memberInfo?.memberType?.trim().toLowerCase() == 'premium';
  final premiumExpiry = data.universalWallet?.premiumExpiryDate;
  final hasActivePremiumExpiry =
      premiumExpiry != null && premiumExpiry.isAfter(now ?? DateTime.now());

  return isPremium || hasActivePremiumExpiry;
}
