import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/number_formatter.dart';
import 'package:new_piiink/constants/pref_key.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/profile/bloc/profile_wallet_blocs.dart';
import 'package:new_piiink/features/profile/bloc/profile_wallet_events.dart';
import 'package:new_piiink/features/profile/bloc/profile_wallet_states.dart';
import 'package:new_piiink/features/wallet/services/dio_wallet.dart';
import 'package:new_piiink/models/response/universal_get_my_wallet.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:new_piiink/generated/l10n.dart';

import '../../../constants/pref.dart';

class PaymentCompleted extends StatefulWidget {
  static const String routeName = "/payment-complete";
  final String discountedTransactionAmount;
  final String merchantRebateToMember;
  final String walletType;
  final int? merchantId;
  const PaymentCompleted({
    super.key,
    required this.discountedTransactionAmount,
    required this.merchantRebateToMember,
    required this.walletType,
    required this.merchantId,
  });

  @override
  State<PaymentCompleted> createState() => _PaymentCompletedState();
}

class _PaymentCompletedState extends State<PaymentCompleted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(text: S.of(context).transactionCompleted),
      ),
      body: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          // height: 530,
          width: MediaQuery.of(context).size.width / 1,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          decoration: BoxDecoration(
              // color: GlobalColors.appWhiteBackgroundColor,
              // borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(2, 2))
              ]),
          child: Center(
            child: OutlineGradientButton(
              padding: const EdgeInsets.all(10.0),
              strokeWidth: 1,
              radius: const Radius.circular(5.0),
              backgroundColor: GlobalColors.appWhiteBackgroundColor,
              elevation: 2,
              gradient: const LinearGradient(
                colors: [GlobalColors.appColor, GlobalColors.appColor1],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 15),
                  // Saving Approved
                  AutoSizeText(
                    S.of(context).savingApproved,
                    style: topicStyle,
                  ),
                  const SizedBox(height: 25),
                  // Credit Remaining
                  BlocProvider(
                    lazy: false,
                    create: (context) => ProfileWalletBloc(
                        RepositoryProvider.of<DioWallet>(context))
                      ..add(GetUniversalUserWalletEvent()),
                    child: BlocBuilder<ProfileWalletBloc, ProfileWalletState>(
                        builder: (context, state) {
                      // Loading State
                      if (state is ProfileWalletLoadingState) {
                        return AutoSizeText(
                          '${S.of(context).creditRemaning}:',
                          style: transactionTextStyle,
                        );
                      }
                      // Loaded State
                      else if (state is ProfileWalletLoadedState) {
                        UniversalGetMyWallet universalWallet =
                            state.universalWallet!;
                        return AutoSizeText.rich(
                          TextSpan(
                            text: '${S.of(context).creditRemaning}: ',
                            style: transactionTextStyle,
                            children: [
                              TextSpan(
                                text:
                                    '${numFormatter.format(universalWallet.data!.balance ?? 0)} ${S.of(context).touristSavers}',
                                style: transactionTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: GlobalColors.appColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      // Error State
                      else if (state is ProfileWalletErrorState) {
                        return const Error();
                      } else {
                        return Container();
                      }
                    }),
                  ),

                  const SizedBox(height: 25),

                  // Image
                  Image.asset(
                    'assets/images/saving-approved.png',
                    height: 100,
                    filterQuality: FilterQuality.high,
                  ),

                  const SizedBox(height: 25),
                  // Please pay Merchant
                  AutoSizeText(
                    S.of(context).pleasePayMerchant,
                    style: transactionTextStyle,
                  ),

                  const SizedBox(height: 10),

                  // Amount to be paid after discount
                  AutoSizeText(
                    '${AppVariables.currency} ${numFormatter.format(double.parse(widget.discountedTransactionAmount))}',
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: GlobalColors.appColor,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 30),

                  // Plus Piiink Point
                  AutoSizeText(
                    "+ ${numFormatter.format(double.parse(widget.merchantRebateToMember))} ${S.of(context).touristSavers}",
                    style: transactionTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.appColor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Credit Remaining
                  AutoSizeText(
                    S.of(context).withThisMerchant,
                    style: transactionTextStyle,
                  ),

                  const SizedBox(height: 25),

                  CustomButton(
                    text: S.of(context).finish,
                    onPressed: () {
                      Pref().setBool(key: showReview, value: true);
                      Pref().writeInt(
                          key: addReviewMerchantID, value: widget.merchantId!);
                      context.pushReplacementNamed('bottom-bar',
                          pathParameters: {'page': '3'});
                    },
                  ),

                  const SizedBox(height: 25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
