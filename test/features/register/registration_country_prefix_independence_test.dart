import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/common/models/registration_code_resolution.dart';
import 'package:touristsaver/features/register/screens/register_screen.dart';

void main() {
  test('phone structure is independent of country of residence', () {
    // A UK prefix and structurally valid mobile remain valid regardless of
    // whether the separately selected residence is Australia or elsewhere.
    expect(
      isRegistrationPhoneStructurallyValid(
        phonePrefix: '+44',
        phoneNumber: '7700900123',
      ),
      isTrue,
    );
    expect(
      isRegistrationPhoneStructurallyValid(
        phonePrefix: null,
        phoneNumber: '7700900123',
      ),
      isFalse,
    );
    expect(
      isRegistrationPhoneStructurallyValid(
        phonePrefix: '+61',
        phoneNumber: '123',
      ),
      isFalse,
    );
  });

  test('recognised Discovery invitation hides the promo panel', () {
    expect(
      shouldShowRegistrationPromoCodePanel(
        recognizedDiscoveryInvitation: true,
        resolution: null,
        validationFailed: false,
      ),
      isFalse,
    );
    expect(
      shouldShowRegistrationPromoCodePanel(
        recognizedDiscoveryInvitation: false,
        resolution: const RegistrationCodeResolution(
          valid: true,
          category: RegistrationCodeCategory.discoveryInvitation,
        ),
        validationFailed: false,
      ),
      isFalse,
    );
    expect(
      shouldShowRegistrationPromoCodePanel(
        recognizedDiscoveryInvitation: false,
        resolution: null,
        validationFailed: false,
      ),
      isTrue,
    );
  });

  test('unavailable linked invitation recovers inline on the same form', () {
    expect(
      shouldRecoverUnavailableInvitationOnRegistrationForm('/register'),
      isTrue,
    );
    expect(
      shouldShowRegistrationPromoCodePanel(
        recognizedDiscoveryInvitation: false,
        resolution: null,
        validationFailed: false,
      ),
      isTrue,
    );
    expect(unavailableInvitationRecoveryMessage, contains('details are safe'));
    expect(
      unavailableInvitationRecoveryMessage,
      contains('another promo or invitation code'),
    );
  });
}
