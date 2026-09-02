import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/registration_credential_check.dart';

void main() {
  group('registration credential check', () {
    test('keeps the legacy boolean response compatible', () {
      final result = RegistrationCredentialCheckResult.fromApiData(true);

      expect(result.exists, isTrue);
      expect(result.registrationIncomplete, isFalse);
    });

    test('recognizes a richer pending-checkout response', () {
      final result = RegistrationCredentialCheckResult.fromApiData({
        'exists': true,
        'registrationState': 'pending_checkout',
      });

      expect(result.exists, isTrue);
      expect(result.registrationIncomplete, isTrue);
    });

    test('does not infer pending registration from existence alone', () {
      final result = RegistrationCredentialCheckResult.fromApiData({
        'exists': true,
      });

      expect(result.exists, isTrue);
      expect(result.registrationIncomplete, isFalse);
    });

    test('masks all identifying mobile content except the last 3 digits', () {
      expect(maskRegistrationMobile('0412 345 477'), '•••477');
      expect(maskRegistrationMobile('+61 (0) 412 345 477'), '•••477');
    });
  });
}
