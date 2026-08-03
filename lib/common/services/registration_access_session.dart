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
  if (data.discoveryMembership != null) {
    return RegistrationAccessDecision.discovery;
  }
  if (data.shouldShowPremiumWelcomeAfterRegistration) {
    return RegistrationAccessDecision.complimentaryPremium;
  }
  return RegistrationAccessDecision.paidConfirmationRequired;
}

bool memberProfileAllowsAuthenticatedAccess({
  required String? memberType,
  required bool discoveryIsActive,
}) {
  return memberType?.trim().toLowerCase() == 'premium' || discoveryIsActive;
}

class RegistrationAccessSession {
  RegistrationAccessSession._();

  static String? _pendingToken;

  static bool get isPending => _pendingToken != null;

  static String? get apiToken => _pendingToken ?? AppVariables.accessToken;

  static Future<void> begin(
    String token, {
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
    _pendingToken = normalized;
  }

  static Future<void> grant({
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
    AppVariables.accessToken = token;
    _pendingToken = null;
  }

  static Future<void> abandon({Pref? pref}) async {
    final pendingToken = _pendingToken;
    if (pendingToken == null) return;

    _pendingToken = null;
    await (pref ?? Pref()).removeData(saveToken);
  }

  static void resetForTest() {
    _pendingToken = null;
  }
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
