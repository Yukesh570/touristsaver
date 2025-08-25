import 'package:auto_size_text/auto_size_text.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/decimal_remove.dart';
import 'package:new_piiink/features/profile/services/dio_membership.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../../common/services/dio_common.dart';
import '../../../common/widgets/custom_app_bar.dart';
import '../../../constants/number_formatter.dart';
import '../../../models/response/piiink_info_res.dart';
import '../../../models/response/user_detail_res.dart';
import '../bloc/user_profile_blocs.dart';
import '../bloc/user_profile_events.dart';
import '../bloc/user_profile_states.dart';
import 'package:new_piiink/generated/l10n.dart';

class MemberReferralScreen extends StatefulWidget {
  static const String routeName = "/memberReferral";
  const MemberReferralScreen({super.key});

  @override
  State<MemberReferralScreen> createState() => _MemberReferralScreenState();
}

class _MemberReferralScreenState extends State<MemberReferralScreen> {
  bool shareLoad = false;
  bool copyLoad = false;
  int? memRefKPI;
  int? piiinkUponMemberReferral;

  Future<void> getPiiinkInfo() async {
    PiiinkInfoResModel? piiinkInfoResModel = await DioCommon().piiinkInfo();
    setState(() {
      memRefKPI = piiinkInfoResModel?.data?.memberReferTransactionKpi;
      piiinkUponMemberReferral =
          piiinkInfoResModel?.data?.piiinkUponMemberReferral;
    });
  }

  @override
  void initState() {
    getPiiinkInfo();
    super.initState();
  }

  final DioMemberShip _dioMembership = DioMemberShip();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          text: S.of(context).referAFriend,
          icon: Icons.arrow_back_ios,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocProvider(
        lazy: false,
        create: (context) =>
            UserProfileBloc(_dioMembership)..add(LoadUserProfileEvent()),
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            //loading state
            if (state is UserProfileLoadingState) {
              return const Column(
                children: [
                  CustomAllLoader(),
                ],
              );
            } else if (state is UserProfileLoadedState) {
              UserProfileResModel userProfile = state.userProfile;
              return userProfile.data!.results!.uniqueMemberCode == null
                  ? const Error1()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(height: 15.h),
                          // Grey Line
                          Container(
                            width: 65.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                          SizedBox(height: 20.h),

                          // title Text
                          AutoSizeText(
                            textAlign: TextAlign.center,
                            memRefKPI == 0
                                ? S
                                    .of(context)
                                    .referTouristSaverAppToYourFriendsAndEarnPUniversalTouristSavers
                                    .replaceAll(
                                        '*P',
                                        removeTrailingZero(numFormatter
                                            .format(piiinkUponMemberReferral)))
                                : S
                                    .of(context)
                                    .referTouristSaverAppToYourFriendsAndEarnAUniversalTouristSaversAsTheyPerformTransactionEqualsToB
                                    .replaceAll(
                                        '*A',
                                        removeTrailingZero(numFormatter
                                            .format(piiinkUponMemberReferral)))
                                    .replaceAll('*B',
                                        '${AppVariables.currency}$memRefKPI'),
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                                decoration: TextDecoration.none,
                                color: Colors.black.withValues(alpha: 0.8),
                                fontFamily: 'Sans'),
                          ),
                          SizedBox(height: 20.h),
                          AutoSizeText(
                            textAlign: TextAlign.center,
                            S.of(context).yourQrCode,
                            // 'Your QR Code',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                decoration: TextDecoration.none,
                                color: Colors.black.withValues(alpha: 0.8),
                                fontFamily: 'Sans'),
                          ),
                          SizedBox(height: 20.h),
                          // Image
                          SizedBox(
                            // color: Colors.orange,
                            child: QrImageView(
                              data:
                                  'https://app.piiink.org/register?memberReferralCode=${userProfile.data!.results!.uniqueMemberCode}',
                              size: 200,
                              version: QrVersions.auto,
                              backgroundColor: Colors.white,
                            ),
                          ),

                          SizedBox(height: 15.h),

                          //QR Code
                          Text(
                            userProfile.data!.results!.uniqueMemberCode ?? '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                color: Colors.black.withValues(alpha: 0.5),
                                fontFamily: 'Sans'),
                          ),
                          SizedBox(height: 30.h),
                          // title Text
                          AutoSizeText(
                            S.of(context).shareThisQRToYourFriend,
                            // "Share this QR to your friends",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                decoration: TextDecoration.none,
                                color: Colors.black.withValues(alpha: 0.8),
                                fontFamily: 'Sans'),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: copyLoad
                                        ? const CustomButtonWithCircular()
                                        : CustomButton(
                                            onPressed: () {
                                              setState(() {
                                                copyLoad = true;
                                              });
                                              copyToClipboard(
                                                  'https://app.piiink.org/register?memberReferralCode=${userProfile.data!.results!.uniqueMemberCode}');
                                            },
                                            text: S.of(context).copyLink)),
                                SizedBox(width: 10.w),
                                Expanded(
                                    child: shareLoad
                                        ? const CustomButtonWithCircular()
                                        : CustomButton(
                                            onPressed: () {
                                              setState(() {
                                                shareLoad = true;
                                              });
                                              _onShare(context,
                                                  'https://app.piiink.org/register?memberReferralCode=${userProfile.data!.results!.uniqueMemberCode}');
                                            },
                                            text: S.of(context).shareLink))
                              ],
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      ),
                    );
            } else if (state is UserProfileErrorState) {
              return const Error1();
            } else {
              return Text(S.of(context).somethingWentWrong,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: Colors.black.withValues(alpha: 0.5),
                      fontFamily: 'Sans'));
            }
          },
        ),
      ),
    );
  }

  void copyToClipboard(String link) {
    FlutterClipboard.copy(link).then((value) async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        copyLoad = false;
      });
      GlobalSnackBar.showSuccess(context, S.of(context).linkCopiedToClipboard);
    });
  }

  void _onShare(BuildContext context, String link) async {
    await Future.delayed(const Duration(seconds: 2));
    final box = context.findRenderObject() as RenderBox?;
    await Share.share(link,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    setState(() {
      shareLoad = false;
    });
  }
}
