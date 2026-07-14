import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/models/request/premium_validity_req.dart';

void main() {
  test('premium validation sends membership country without a default issuer',
      () {
    final request = PremiumValidityReqModel(
      memberPremiumCode: 'SAVER20',
      membershipCountryId: 3,
    );

    expect(request.toJson(), {
      'memberPremiumCode': 'SAVER20',
      'issuerCode': null,
      'membershipCountryId': 3,
    });
  });

  test('explicit legacy issuer attribution remains supported', () {
    final request = PremiumValidityReqModel(
      memberPremiumCode: 'SAVER20',
      issuerCode: 'EXPLICIT-ISSUER',
      membershipCountryId: 3,
    );

    expect(request.toJson()['issuerCode'], 'EXPLICIT-ISSUER');
  });
}
