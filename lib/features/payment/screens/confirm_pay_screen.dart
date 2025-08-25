import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/number_formatter.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

import '../../../common/widgets/custom_loader.dart';
import 'package:new_piiink/generated/l10n.dart';

class ConfimrPaymentScreen extends StatefulWidget {
  static const String routeName = "/confirm-pay";
  final String totalAmount;
  final String qrCode;
  final String hasMerchantPiiinks;
  final String hasUniversalPiiinks;
  final String merchantName;
  final String universalPiiinkBalance;
  final String merchantPiiinkBalance;
  final String merchantRebateToMember;
  final String discountedTransactionAmount;
  final String totalPiiinkDiscount;
  final String logo;
  final String universalPiiinkOnHold;
  final String merchantPiiinkOnHold;
  final int? terminalUserId;
  final int? terminalId;
  final int? merchantId;

  const ConfimrPaymentScreen({
    super.key,
    required this.totalAmount,
    required this.qrCode,
    required this.hasMerchantPiiinks,
    required this.hasUniversalPiiinks,
    required this.merchantName,
    required this.universalPiiinkBalance,
    required this.merchantPiiinkBalance,
    required this.merchantRebateToMember,
    required this.discountedTransactionAmount,
    required this.totalPiiinkDiscount,
    required this.logo,
    required this.universalPiiinkOnHold,
    required this.merchantPiiinkOnHold,
    this.terminalUserId,
    this.terminalId,
    this.merchantId,
  });
  @override
  State<ConfimrPaymentScreen> createState() => _ConfimrPaymentScreenState();
}

class _ConfimrPaymentScreenState extends State<ConfimrPaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          text: S.of(context).chooseWallet,
          icon: Icons.arrow_back_ios,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).merchantNameP,
                      // 'Merchant Name : ',
                      style: notiHeaderTextStyle.copyWith(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      widget.merchantName,
                      style: notiHeaderTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Universal Wallet
              SameContainer(
                onTap: () {
                  if (widget.hasUniversalPiiinks == "true") {
                    context.pushNamed(
                      'accept-screen',
                      extra: {
                        'merchantId': widget.merchantId,
                        'totalAmount': widget.totalAmount,
                        'qrCode': widget.qrCode,
                        'discountedTransactionAmount':
                            widget.discountedTransactionAmount,
                        'totalPiiinkDiscount': widget.totalPiiinkDiscount,
                        'merchantRebateToMember': widget.merchantRebateToMember,
                        'walletType': 'universalWallet',
                        'terminalUserId': widget.terminalUserId,
                        'terminalId': widget.terminalId,
                      },
                    );
                  } else {
                    GlobalSnackBar.showError(
                      context,
                      S.of(context).notEnoughTouristSaverCredits,
                    );
                  }
                },
                image: Expanded(
                  flex: 4,
                  child: Image.asset(
                    'assets/images/universal.png',
                    // height: 70,
                    // width: MediaQuery.of(context).size.width / 1.3,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                textName: S.of(context).universal,
                piiinkBalance: widget.universalPiiinkBalance,
                onHoldPiiink: widget.universalPiiinkOnHold,
              ),

              // Merchant Wallet
              widget.merchantPiiinkBalance != '0.0'
                  ? SameContainer(
                      onTap: () {
                        if (widget.hasMerchantPiiinks == "true") {
                          context.pushNamed(
                            'accept-screen',
                            extra: {
                              'merchantId': widget.merchantId,
                              'totalAmount': widget.totalAmount,
                              'qrCode': widget.qrCode,
                              'discountedTransactionAmount':
                                  widget.discountedTransactionAmount,
                              'totalPiiinkDiscount': widget.totalPiiinkDiscount,
                              'merchantRebateToMember':
                                  widget.merchantRebateToMember,
                              'walletType': 'merchantWallet',
                              'terminalUserId': widget.terminalUserId,
                              'terminalId': widget.terminalId,
                            },
                          );
                        } else {
                          GlobalSnackBar.showError(
                            context,
                            S.of(context).notEnoughTouristSaverCredits,
                          );
                        }
                      },
                      image: Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              topLeft: Radius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: widget.logo == 'null'
                                  ? Image.asset(
                                      "assets/images/tourist.png",
                                      height: 40,
                                    )
                                  : widget.logo == ''
                                      ? Image.asset(
                                          "assets/images/tourist.png",
                                          height: 40,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: widget.logo,
                                          fit: BoxFit.contain,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.3,
                                          placeholder: (context, url) {
                                            return const Center(
                                              child: CustomAllLoader(),
                                            );
                                          },
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Image.asset(
                                              'assets/images/no_image.jpg',
                                            ),
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ),

                      // image: Image.asset(
                      //   "assets/images/piiink.png",
                      //   height: 40,
                      // ),
                      textName: widget.merchantName,
                      piiinkBalance: widget.merchantPiiinkBalance,
                      onHoldPiiink: widget.merchantPiiinkOnHold,
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

// Making stateless widget
class SameContainer extends StatelessWidget {
  final VoidCallback onTap;
  final Widget image;
  final String textName;
  final String piiinkBalance;
  final String? onHoldPiiink;
  const SameContainer({
    super.key,
    required this.onTap,
    required this.image,
    required this.textName,
    required this.piiinkBalance,
    this.onHoldPiiink,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width / 1.2,
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          // decoration: BoxDecoration(
          //     color: GlobalColors.appWhiteBackgroundColor,
          //     borderRadius: BorderRadius.circular(5.0),
          //     boxShadow: [
          //       BoxShadow(
          //           color: Colors.grey.withValues(alpha: 0.5),
          //           blurRadius: 4,
          //           spreadRadius: 4,
          //           offset: const Offset(0, 4))
          //     ]),
          child: OutlineGradientButton(
            padding: const EdgeInsets.all(10.0),
            strokeWidth: 1,
            radius: const Radius.circular(5.0),
            backgroundColor: GlobalColors.appWhiteBackgroundColor,
            elevation: 10,
            gradient: const LinearGradient(
              colors: [GlobalColors.appColor, GlobalColors.appColor1],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                const SizedBox(height: 20),
                // Piiinks Universal Number
                AutoSizeText(
                  textName,
                  textAlign: TextAlign.center,
                  style: topicStyle.copyWith(fontSize: 24.sp),
                ),

                const SizedBox(height: 10),

                // Piiinks Credits
                AutoSizeText.rich(
                  TextSpan(
                    text: '${S.of(context).creditRemaning}: ',
                    style: transactionTextStyle.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${numFormatter.format(double.parse(piiinkBalance))} ${S.of(context).touristSavers}',
                        style: transactionTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GlobalColors.appColor,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Piiinks Credits
                onHoldPiiink == '0.0'
                    ? const SizedBox()
                    : AutoSizeText.rich(
                        TextSpan(
                          text: '${S.of(context).touristSaversOnHold}: ',
                          style: transactionTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.sp,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${numFormatter.format(double.parse(onHoldPiiink!))} ${S.of(context).touristSavers}',
                              style: transactionTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: GlobalColors.appColor,
                                fontSize: 18.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
