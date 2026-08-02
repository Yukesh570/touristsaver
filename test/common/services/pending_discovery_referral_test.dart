import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:touristsaver/common/services/branch_referral_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    BranchReferralService.resetPendingDiscoveryInMemory();
    await BranchReferralService.clearPendingDiscoveryReferral();
  });

  test('restores a pending canonical Discovery invitation after restart',
      () async {
    const referral = BranchRegistrationReferral(
      discoveryInvitationCode: '333BUTTERFLY',
      campaign: 'Blue Butterfly Launch Gold Coast',
      invitationName: 'Carrara Markets - July 2026',
      type: BranchReferralType.discoveryInvitation,
    );
    await BranchReferralService.replacePendingDiscoveryReferral(referral);

    BranchReferralService.resetPendingDiscoveryInMemory();
    await BranchReferralService.restorePendingDiscoveryReferral();

    expect(
      BranchReferralService.pendingDiscoveryReferral?.discoveryInvitationCode,
      '333BUTTERFLY',
    );
    expect(
      BranchReferralService.pendingDiscoveryReferral?.campaign,
      'Blue Butterfly Launch Gold Coast',
    );
  });

  test('a mismatched clear cannot destroy a valid pending invitation',
      () async {
    const referral = BranchRegistrationReferral(
      discoveryInvitationCode: '333BUTTERFLY',
      type: BranchReferralType.discoveryInvitation,
    );
    await BranchReferralService.replacePendingDiscoveryReferral(referral);

    await BranchReferralService.clearPendingDiscoveryReferral(
      code: 'INVALID-MANUAL-CODE',
    );

    expect(
      BranchReferralService.pendingDiscoveryReferral?.discoveryInvitationCode,
      '333BUTTERFLY',
    );
  });

  test('confirmed replacement stores only the replacement invitation',
      () async {
    await BranchReferralService.replacePendingDiscoveryReferral(
      const BranchRegistrationReferral(
        discoveryInvitationCode: '333BUTTERFLY',
        type: BranchReferralType.discoveryInvitation,
      ),
    );
    await BranchReferralService.replacePendingDiscoveryReferral(
      const BranchRegistrationReferral(
        discoveryInvitationCode: 'NEW-DISCOVERY',
        type: BranchReferralType.discoveryInvitation,
      ),
    );

    BranchReferralService.resetPendingDiscoveryInMemory();
    await BranchReferralService.restorePendingDiscoveryReferral();

    expect(
      BranchReferralService.pendingDiscoveryReferral?.discoveryInvitationCode,
      'NEW-DISCOVERY',
    );
  });

  test('matching successful registration clears the pending invitation',
      () async {
    await BranchReferralService.replacePendingDiscoveryReferral(
      const BranchRegistrationReferral(
        discoveryInvitationCode: '333BUTTERFLY',
        type: BranchReferralType.discoveryInvitation,
      ),
    );

    await BranchReferralService.clearPendingDiscoveryReferral(
      code: '333butterfly',
    );
    BranchReferralService.resetPendingDiscoveryInMemory();
    await BranchReferralService.restorePendingDiscoveryReferral();

    expect(BranchReferralService.pendingDiscoveryReferral, isNull);
  });
}
