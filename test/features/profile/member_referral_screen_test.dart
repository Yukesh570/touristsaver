import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:touristsaver/features/profile/screens/member_referral.dart';
import 'package:touristsaver/features/profile/services/dio_membership.dart';
import 'package:touristsaver/generated/l10n.dart';
import 'package:touristsaver/models/response/member_invitation_link_res.dart';
import 'package:touristsaver/models/response/user_detail_res.dart';

class _CampaignInvitationMembershipService extends DioMemberShip {
  static const campaignUrl =
      'https://app.touristsaver.org/uNKc7wdRM4b?ref_type=member_invitation&memberReferralCode=6930048890264281&campaignId=4';

  @override
  Future<UserProfileResModel?> getUserProfile() async {
    return UserProfileResModel(
      data: Data(
        status: 'Success',
        results: Results(
          id: 101,
          firstname: 'Penny',
          lastname: 'Woh',
          uniqueMemberCode: '6930048890264281',
        ),
      ),
    );
  }

  @override
  Future<MemberInvitationLink> getMemberInvitationLink() async {
    return const MemberInvitationLink(
      url: campaignUrl,
      refType: 'member_invitation',
      memberReferralCode: '6930048890264281',
      refCode: '6930048890264281',
      campaignId: 4,
      campaignName: 'Scarlett Butterfly Effect Invitation',
      feature: 'member_invitation',
      channel: 'member_share',
    );
  }
}

void main() {
  testWidgets(
    'campaign member opens Share to a Friend and receives campaign invitation link',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(430, 932);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, __) => MaterialApp(
            localizationsDelegates: S.localizationsDelegates,
            supportedLocales: S.supportedLocales,
            home: MemberReferralScreen(
              dioMembership: _CampaignInvitationMembershipService(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Share to a Friend'), findsOneWidget);
      expect(find.text('Refer a Friend'), findsNothing);
      expect(find.text('This invitation is from'), findsOneWidget);
      expect(
        find.byKey(const Key('campaign-invitation-name')),
        findsOneWidget,
      );
      expect(
        find.text('Scarlett Butterfly Effect Invitation'),
        findsOneWidget,
      );
      expect(
        find.text('Your invitation QR code'),
        findsOneWidget,
      );
      expect(
        find.text(
          'Share this invitation with friends. They can join TouristSaver and discover their member savings.',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Your friend will join through your invitation.'),
        findsOneWidget,
      );
      expect(
        find.text('Friends can scan this code to join TouristSaver.'),
        findsOneWidget,
      );
      expect(find.textContaining('member attribution'), findsNothing);
      expect(find.textContaining('eligibility'), findsNothing);
      expect(find.textContaining('campaign invitation QR'), findsNothing);
      final copyLink = find.text('Copy Link');
      final double initialScrollNeeded =
          tester.getRect(copyLink).bottom - tester.view.physicalSize.height;
      expect(initialScrollNeeded, lessThanOrEqualTo(110));
      await tester.ensureVisible(copyLink);
      await tester.pumpAndSettle();
      expect(find.text('Copy Link').hitTestable(), findsOneWidget);
      expect(find.text('Share Link').hitTestable(), findsOneWidget);

      expect(
        find.byKey(
          const ValueKey<String>(
            'invitation-qr:${_CampaignInvitationMembershipService.campaignUrl}',
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey<String>(
            'invitation-qr:https://app.touristsaver.org/register?memberReferralCode=6930048890264281',
          ),
        ),
        findsNothing,
      );
    },
  );
}
