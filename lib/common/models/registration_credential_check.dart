class RegistrationCredentialCheckResult {
  const RegistrationCredentialCheckResult({
    required this.exists,
    required this.registrationIncomplete,
  });

  final bool exists;
  final bool registrationIncomplete;

  factory RegistrationCredentialCheckResult.fromApiData(dynamic data) {
    if (data is bool) {
      return RegistrationCredentialCheckResult(
        exists: data,
        registrationIncomplete: false,
      );
    }

    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final state =
          (map['accountState'] ?? map['registrationState'] ?? map['status'])
              ?.toString()
              .trim()
              .toLowerCase();
      final isIncomplete = map['registrationIncomplete'] == true ||
          map['pendingRegistration'] == true ||
          map['pendingCheckout'] == true ||
          map['requiresPremiumCheckout'] == true ||
          state == 'pending_registration' ||
          state == 'pending_checkout' ||
          state == 'pending_entitlement';
      final exists =
          map['exists'] == true || map['alreadyExists'] == true || isIncomplete;
      return RegistrationCredentialCheckResult(
        exists: exists,
        registrationIncomplete: exists && isIncomplete,
      );
    }

    return const RegistrationCredentialCheckResult(
      exists: false,
      registrationIncomplete: false,
    );
  }
}

String maskRegistrationMobile(String mobile) {
  final digits = mobile.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return 'your saved mobile';
  final visibleDigits =
      digits.length <= 3 ? digits : digits.substring(digits.length - 3);
  return '•••$visibleDigits';
}
