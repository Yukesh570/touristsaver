import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/number_formatter.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/payment/services/dio_payment.dart';
import 'package:new_piiink/models/request/sure_apply_piiink_req.dart';
import 'package:new_piiink/models/response/sure_apply_piiink_res.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:new_piiink/generated/l10n.dart';

class AcceptScreen extends StatefulWidget {
  static const String routeName = '/accept-screen';
  final String totalAmount;
  final String qrCode;
  final String discountedTransactionAmount;
  final String totalPiiinkDiscount;
  final String merchantRebateToMember;
  final String walletType;
  final int? terminalUserId;
  final int? terminalId;
  final int? merchantId;

  const AcceptScreen({
    super.key,
    required this.totalAmount,
    required this.qrCode,
    required this.discountedTransactionAmount,
    required this.totalPiiinkDiscount,
    required this.merchantRebateToMember,
    required this.walletType,
    this.terminalUserId,
    this.terminalId,
    this.merchantId,
  });

  @override
  State<AcceptScreen> createState() => _AcceptScreenState();
}

class _AcceptScreenState extends State<AcceptScreen> {
  // For Loading part
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    List arr = S
        .of(context)
        .weWillDeductCPiinksFromYourCredit
        .replaceAll(
            '&X', numFormatter.format(double.parse(widget.totalPiiinkDiscount)))
        .split(" ");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          text: S.of(context).confirmWallet,
          icon: Icons.arrow_back_ios,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: FittedBox(
        fit: BoxFit.fill,
        child: Container(
            // height: 500,
            width: MediaQuery.of(context).size.width / 1,
            margin:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                children: [
                  const SizedBox(height: 15),
                  AutoSizeText(
                    S.of(context).acceptToUseTouristSavers,
                    style: topicStyle,
                  ),

                  const SizedBox(height: 15),
                  const SizedBox(height: 15),
                  FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var item in arr)
                          if (item.indexOf('&C') != -1)
                            AutoSizeText(
                              ' $item'.replaceAll('&C', ""),
                              style: transactionTextStyle.copyWith(
                                  color: GlobalColors.appColor),
                            )
                          else
                            AutoSizeText(
                              ' $item'.replaceAll('&C', ""),
                              style: transactionTextStyle,
                            ),
                      ],
                    ),
                  ),

                  // The Piiink point to be cut
                  // AutoSizeText.rich(
                  //   TextSpan(
                  //       text: 'We will deduct ',
                  //       style: transactionTextStyle,
                  //       children: [
                  //         TextSpan(
                  //           text:
                  //               '${toFixed2DecimalPlaces(double.parse(widget.totalPiiinkDiscount))} Piiinks',
                  //           style: transactionTextStyle.copyWith(
                  //             fontWeight: FontWeight.w600,
                  //             color: GlobalColors.appColor,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: ' from your credit',
                  //           style: transactionTextStyle,
                  //         )
                  //       ]),
                  // ),

                  const SizedBox(height: 20),

                  // Image
                  Image.asset(
                    'assets/images/percentage.png',
                    height: 100,
                    filterQuality: FilterQuality.high,
                  ),

                  const SizedBox(height: 20),

                  // Total Amount to be paid
                  AutoSizeText(
                    AppVariables.currency! +
                        numFormatter.format(double.parse(widget.totalAmount)),
                    style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontSize: 20.sp),
                  ),

                  const SizedBox(height: 20),

                  // Amount to be paid after discount
                  AutoSizeText(
                    AppVariables.currency! +
                        numFormatter.format(
                            double.parse(widget.discountedTransactionAmount)),
                    style: TextStyle(
                        fontSize: 30.sp,
                        color: GlobalColors.appColor,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  // Accept Button
                  isLoading == true
                      ? const CustomButtonWithCircular()
                      : CustomButton(
                          text: S.of(context).accept,
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            var res = await DioPay().sureApplyPiiink(
                              payToMainMerchant:
                                  widget.terminalUserId == null ? true : false,
                              sureApplyPiiinkReqModel: SureApplyPiiinkReqModel(
                                totalAmount: double.parse(widget.totalAmount),
                                piiinkWalletType: widget.walletType,
                                transactionQrCode: widget.qrCode,
                                hour: int.parse(
                                    DateFormat('HH ').format(DateTime.now())),
                                week: DateTime.now().weekday % 7,
                                terminalUserId: widget.terminalUserId,
                                terminalId: widget.terminalId,
                              ),
                            );
                            if (!mounted) return;
                            if (res is SureApplyPiiinkResModel) {
                              if (res.status == "Success") {
                                setState(() {
                                  isLoading = false;
                                });
                                context.pop();
                                context.pushNamed('payment-complete', extra: {
                                  'merchantId': widget.merchantId,
                                  'discountedTransactionAmount':
                                      widget.discountedTransactionAmount,
                                  'merchantRebateToMember':
                                      widget.merchantRebateToMember,
                                  'walletType': widget.walletType,
                                });
                              } else {
                                GlobalSnackBar.showError(
                                    context, S.of(context).somethingWentWrong);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            } else {
                              GlobalSnackBar.showError(
                                  context, S.of(context).serverError);
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                        ),

                  const SizedBox(height: 10),

                  // Try Again Button
                  CustomButton(
                    text: S.of(context).tryAgain,
                    onPressed: () {
                      context.pop();
                      // isLoading == true ? null : context.pop();
                    },
                  ),

                  const SizedBox(height: 10),

                  //Cancel Button
                  CustomButton1(
                    text: S.of(context).cancel,
                    onPressed: () {
                      context.pushReplacementNamed('bottom-bar',
                          pathParameters: {'page': '3'});
                    },
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            )),
      ),
    );
  }
}
