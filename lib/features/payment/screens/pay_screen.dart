import 'package:auto_size_text/auto_size_text.dart';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:intl/intl.dart';
// import 'package:new_piiink/constants/fixed_decimal.dart';
// import 'package:new_piiink/models/error_res.dart';
// import 'package:new_piiink/models/request/confirm_piiink_req.dart';
// import 'package:new_piiink/models/response/confirm_piiink_res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/connectivity/cubit/internet_cubit.dart';
import 'package:new_piiink/features/payment/services/dio_payment.dart';
import 'package:new_piiink/features/payment/widgets/num_pad.dart';
import 'package:new_piiink/models/response/is_pay_enable_res.dart';

import '../../../common/services/dio_common.dart';
import '../../../constants/fixed_decimal.dart';
import '../../../models/error_res.dart';
import '../../../models/request/confirm_piiink_req.dart';
import '../../../models/response/confirm_piiink_res.dart';
import '../../../models/response/piiink_info_res.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../connectivity/screens/connectivity_screen.dart';
import 'package:new_piiink/generated/l10n.dart';

class PayScreen extends StatefulWidget {
  static const String routeName = '/pay';
  const PayScreen({super.key, this.merchantName});

  final String? merchantName;

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  TextEditingController amountController = TextEditingController();
  bool? hideMerchantPaymentCode;

  //Flutter BarCode Scanner for QR Code
  String manualQrCode = '';
  String merchantQrCode = '';

  // For Loader
  bool isLoading = false;
  bool isMerchantQrLoading = false;

  //Checking whether the pay is enabled or not
  Future<IsPayEnableResModel?>? payE;
  Future<IsPayEnableResModel?>? payEnabled() async {
    IsPayEnableResModel? isPayEnabledResModel = await DioPay().payEnabled();
    return isPayEnabledResModel;
  }

  // _scanManualQr() async {
  //   if (amountController.text.isEmpty ||
  //       double.parse(amountController.text) <= 0) {
  //     GlobalSnackBar.valid(context, S.of(context).pleaseEnterTheRightAmount);
  //     return;
  //   }
  //   await FlutterBarcodeScanner.scanBarcode(
  //           '#EC4785', 'Cancel', true, ScanMode.QR)
  //       .then((value) async {
  //     setState(() {
  //       manualQrCode = value;
  //       isLoading = true;
  //     });
  //     // log(value);
  //     if (value == '-1') {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar(message: S.of(context).invalidQrCode);
  //     }
  //     //     }))
  //     // .then((value) async {
  //     var res = await DioPay().confirmApplyPiiink(
  //       confirmApplyPiiinkReqModel: ConfirmApplyPiiinkReqModel(
  //           totalAmount: double.parse(amountController.text),
  //           transactionQRCode: manualQrCode,
  //           hour: int.parse(DateFormat('HH ').format(DateTime.now())),
  //           week: DateTime.now().weekday % 7,
  //           lang: AppVariables.selectedLanguageNow),
  //     );
  //     // if (!mounted) return;
  //     if (res is ConfirmApplyPiiinkResModel) {
  //       if (res.status == "Success") {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         var data = res.data!;
  //         // ignore: use_build_context_synchronously
  //         context.pushNamed('confirm-pay', extra: {
  //           'merchantId': data.merchantInfo!.id,
  //           'totalAmount': amountController.text.trim(),
  //           'qrCode': manualQrCode,
  //           'hasMerchantPiiinks': data.hasMerchantPiiinks.toString(),
  //           'hasUniversalPiiinks': data.hasUniversalPiiinks.toString(),
  //           'merchantName': data.merchantInfo!.merchantName,
  //           'universalPiiinkBalance':
  //               toFixed2DecimalPlaces(data.universalPiiinkBalance!).toString(),
  //           'merchantPiiinkBalance':
  //               toFixed2DecimalPlaces(data.merchantPiiinkBalance!).toString(),
  //           'merchantRebateToMember': data.merchantRebateToMember.toString(),
  //           'discountedTransactionAmount':
  //               data.discountedTransactionAmount.toString(),
  //           'totalPiiinkDiscount': data.totalPiiinkDiscount.toString(),
  //           'logo': data.merchantInfo?.merchantImageInfo == null
  //               ? 'null'
  //               : data.merchantInfo?.merchantImageInfo?.logoUrl ??
  //                   data.merchantInfo?.merchantImageInfo?.slider1 ??
  //                   'null',
  //           'universalPiiinkOnHold':
  //               data.universalPiiinkBalanceOnHold.toString(),
  //           'merchantPiiinkOnHold': data.merchantPiiinkBalanceOnHold.toString(),
  //         });
  //       } else {
  //         setState(() {
  //           isLoading = false;
  //         });
  //         if (!mounted) return;
  //         return GlobalSnackBar.showError(
  //             context, S.of(context).notEnoughPiiinkCredits);
  //       }
  //     } else if (res is ErrorResModel) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar.showError(context, res.message!);
  //     } else {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar.showError(
  //           context, S.of(context).somethingWentWrong);
  //     }
  //   });
  // }

  // _scanMerchantQr() async {
  //   await FlutterBarcodeScanner.scanBarcode(
  //           '#EC4785', 'Cancel', true, ScanMode.QR)
  //       .then((value) async {
  //     setState(() {
  //       merchantQrCode = value;
  //       isMerchantQrLoading = true;
  //     });
  //     // log(value);
  //     if (value == '-1') {
  //       setState(() {
  //         isMerchantQrLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar(message: S.of(context).invalidQrCode);
  //     }
  //     var res = await DioPay()
  //         .confirmTerminalApplyPiiink(transactionQrCode: merchantQrCode);

  //     if (res is ConfirmApplyPiiinkResModel) {
  //       if (res.status == "Success") {
  //         setState(() {
  //           isMerchantQrLoading = false;
  //         });
  //         var data = res.data!;
  //         // ignore: use_build_context_synchronously
  //         context.pushNamed('confirm-pay', extra: {
  //           'merchantId': data.merchantInfo!.id,
  //           'totalAmount': data.totalTransactionAmount.toString(),
  //           'qrCode': data.merchantInfo!.transactionCode,
  //           'hasMerchantPiiinks': data.hasMerchantPiiinks.toString(),
  //           'hasUniversalPiiinks': data.hasUniversalPiiinks.toString(),
  //           'merchantName': data.merchantInfo!.merchantName,
  //           'universalPiiinkBalance':
  //               toFixed2DecimalPlaces(data.universalPiiinkBalance!).toString(),
  //           'merchantPiiinkBalance':
  //               toFixed2DecimalPlaces(data.merchantPiiinkBalance!).toString(),
  //           'merchantRebateToMember': data.merchantRebateToMember.toString(),
  //           'discountedTransactionAmount':
  //               data.discountedTransactionAmount.toString(),
  //           'totalPiiinkDiscount': data.totalPiiinkDiscount.toString(),
  //           'logo': data.merchantInfo?.merchantImageInfo == null
  //               ? 'null'
  //               : data.merchantInfo?.merchantImageInfo?.logoUrl ??
  //                   data.merchantInfo?.merchantImageInfo?.slider1 ??
  //                   'null',
  //           'universalPiiinkOnHold':
  //               data.universalPiiinkBalanceOnHold.toString(),
  //           'merchantPiiinkOnHold': data.merchantPiiinkBalanceOnHold.toString(),
  //           'terminalUserId': data.terminalUserId,
  //           'terminalId': data.terminalId,
  //         });
  //       } else {
  //         setState(() {
  //           isMerchantQrLoading = false;
  //         });
  //         if (!mounted) return;
  //         return GlobalSnackBar.showError(
  //             context, S.of(context).notEnoughPiiinkCredits);
  //       }
  //     } else if (res is ErrorResModel) {
  //       setState(() {
  //         isMerchantQrLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar.showError(context, res.message!);
  //     } else {
  //       setState(() {
  //         isMerchantQrLoading = false;
  //       });
  //       if (!mounted) return;
  //       return GlobalSnackBar.showError(
  //           context, S.of(context).somethingWentWrong);
  //     }
  //   });
  // }

  //Checking whether merchant payment code is enabled
  Future<void> getPiiinkInfo() async {
    PiiinkInfoResModel? piiinkInfoResModel = await DioCommon().piiinkInfo();
    if (!mounted) return;
    setState(() {
      hideMerchantPaymentCode =
          piiinkInfoResModel?.data?.hideMerchantPaymentCodeScanOption;
    });
  }

  _scanManualQr(String manualQrCode) async {
    // log('Merchant enter amount QR pay');
    var res = await DioPay().confirmApplyPiiink(
      confirmApplyPiiinkReqModel: ConfirmApplyPiiinkReqModel(
          totalAmount: double.parse(amountController.text.trim()),
          transactionQRCode: manualQrCode,
          hour: int.parse(DateFormat('HH ').format(DateTime.now())),
          week: DateTime.now().weekday % 7,
          lang: AppVariables.selectedLanguageNow),
    );
    // if (!mounted) return;
    if (res is ConfirmApplyPiiinkResModel) {
      if (res.status == "Success") {
        setState(() {
          isLoading = false;
        });
        var data = res.data!;
        context.pushNamed('confirm-pay', extra: {
          'merchantId': data.merchantInfo!.id,
          'totalAmount': amountController.text.trim(),
          'qrCode': manualQrCode,
          'hasMerchantPiiinks': data.hasMerchantPiiinks.toString(),
          'hasUniversalPiiinks': data.hasUniversalPiiinks.toString(),
          'merchantName': data.merchantInfo!.merchantName,
          'universalPiiinkBalance':
              toFixed2DecimalPlaces(data.universalPiiinkBalance!).toString(),
          'merchantPiiinkBalance':
              toFixed2DecimalPlaces(data.merchantPiiinkBalance!).toString(),
          'merchantRebateToMember': data.merchantRebateToMember.toString(),
          'discountedTransactionAmount':
              data.discountedTransactionAmount.toString(),
          'totalPiiinkDiscount': data.totalPiiinkDiscount.toString(),
          'logo': data.merchantInfo?.merchantImageInfo == null
              ? 'null'
              : data.merchantInfo?.merchantImageInfo?.logoUrl ??
                  data.merchantInfo?.merchantImageInfo?.slider1 ??
                  'null',
          'universalPiiinkOnHold': data.universalPiiinkBalanceOnHold.toString(),
          'merchantPiiinkOnHold': data.merchantPiiinkBalanceOnHold.toString(),
        });
      } else {
        setState(() {
          isLoading = false;
        });
        if (!mounted) return;
        // context.pop();
        return GlobalSnackBar.showError(
            context, S.of(context).notEnoughTouristSaverCredits);
      }
    } else if (res is ErrorResModel) {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      // context.pop();
      return GlobalSnackBar.showError(context, res.message.toString());
    } else {
      setState(() {
        isLoading = false;
      });
      if (!mounted) return;
      // context.pop();
      return GlobalSnackBar.showError(
          context, S.of(context).somethingWentWrong);
    }
  }

  _scanMerchantQr(String merchantQrCode) async {
    // log('Merchant QR pay');
    var res = await DioPay()
        .confirmTerminalApplyPiiink(transactionQrCode: merchantQrCode);

    if (res is ConfirmApplyPiiinkResModel) {
      if (res.status == "Success") {
        setState(() {
          isMerchantQrLoading = false;
        });
        var data = res.data!;
        context.pushNamed('confirm-pay', extra: {
          'merchantId': data.merchantInfo!.id,
          'totalAmount': data.totalTransactionAmount.toString(),
          'qrCode': data.merchantInfo!.transactionCode,
          'hasMerchantPiiinks': data.hasMerchantPiiinks.toString(),
          'hasUniversalPiiinks': data.hasUniversalPiiinks.toString(),
          'merchantName': data.merchantInfo!.merchantName,
          'universalPiiinkBalance':
              toFixed2DecimalPlaces(data.universalPiiinkBalance!).toString(),
          'merchantPiiinkBalance':
              toFixed2DecimalPlaces(data.merchantPiiinkBalance!).toString(),
          'merchantRebateToMember': data.merchantRebateToMember.toString(),
          'discountedTransactionAmount':
              data.discountedTransactionAmount.toString(),
          'totalPiiinkDiscount': data.totalPiiinkDiscount.toString(),
          'logo': data.merchantInfo?.merchantImageInfo == null
              ? 'null'
              : data.merchantInfo?.merchantImageInfo?.logoUrl ??
                  data.merchantInfo?.merchantImageInfo?.slider1 ??
                  'null',
          'universalPiiinkOnHold': data.universalPiiinkBalanceOnHold.toString(),
          'merchantPiiinkOnHold': data.merchantPiiinkBalanceOnHold.toString(),
          'terminalUserId': data.terminalUserId,
          'terminalId': data.terminalId,
        });
      } else {
        setState(() {
          isMerchantQrLoading = false;
        });
        if (!mounted) return;
        // context.pop();
        return GlobalSnackBar.showError(
            context, S.of(context).notEnoughTouristSaverCredits);
      }
    } else if (res is ErrorResModel) {
      setState(() {
        isMerchantQrLoading = false;
      });
      if (!mounted) return;
      // context.pop();
      return GlobalSnackBar.showError(context, res.message.toString());
    } else {
      setState(() {
        isMerchantQrLoading = false;
      });
      if (!mounted) return;
      // context.pop();
      return GlobalSnackBar.showError(
          context, S.of(context).somethingWentWrong);
    }
  }

  @override
  void initState() {
    getPiiinkInfo();
    payE = payEnabled();
    // log(AppVariables.currency!);
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityCubit().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
            text: widget.merchantName ?? S.of(context).pay,
            icon: widget.merchantName == null ? null : Icons.arrow_back_ios,
            onPressed: widget.merchantName == null
                ? null
                : () {
                    context.pop();
                  }),
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          if (state == ConnectivityState.loading) {
            return const NoInternetLoader();
          } else if (state == ConnectivityState.disconnected) {
            return const NoConnectivityScreen();
          } else if (state == ConnectivityState.connected) {
            return SingleChildScrollView(
              child: FutureBuilder<IsPayEnableResModel?>(
                  future: payE,
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return const Error1();
                    } else if (!snapShot.hasData) {
                      return const CustomAllLoader();
                    } else {
                      return snapShot.data!.data!.transactionIsEnabled == true
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20.h),
                              width: MediaQuery.of(context).size.width / 1,
                              constraints: const BoxConstraints(
                                //To make height expandable according to the text
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                  color: GlobalColors.appWhiteBackgroundColor,
                                  borderRadius: BorderRadius.circular(5.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                      offset: const Offset(2, 2),
                                    )
                                  ]),
                              child: Column(
                                children: [
                                  // 'Scan Merchant Payment Code Button'
                                  hideMerchantPaymentCode == false
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            isMerchantQrLoading == true
                                                ? const CustomButtonWithCircular()
                                                : CustomButton(
                                                    text: S
                                                        .of(context)
                                                        .scanMerchantPaymentCode,
                                                    onPressed: isLoading
                                                        ? () {}
                                                        : () {
                                                            context.pushNamed(
                                                                'qr_screen',
                                                                extra: {
                                                                  'title': S
                                                                      .of(context)
                                                                      .pay
                                                                }).then((vlz) {
                                                              // log("${vlz.toString()} 1");
                                                              if (vlz.toString() !=
                                                                  'null') {
                                                                // log("${vlz.toString()} 2");
                                                                if (vlz !=
                                                                        null &&
                                                                    vlz
                                                                        .toString()
                                                                        .isNotEmpty) {
                                                                  // log("${vlz.toString()} 3");
                                                                  _scanMerchantQr(
                                                                      vlz.toString());
                                                                }
                                                              }
                                                            });
                                                          }
                                                    //  _scanMerchantQr,
                                                    ),
                                            SizedBox(height: 15.h),
                                            Text(
                                              S.of(context).or,
                                              style: merchantNameStyle,
                                            ),
                                            SizedBox(height: 15.h),
                                          ],
                                        )
                                      : const SizedBox(),
                                  AutoSizeText(
                                    S.of(context).enterAmountOfTransaction,
                                    style: topicStyle,
                                  ),
                                  SizedBox(height: 15.h),
                                  Container(
                                    height: 75,
                                    color: GlobalColors.paleGray,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 32,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  color: GlobalColors.paleGray),
                                              child: AutoSizeText(
                                                "\$",
                                                style: const TextStyle(
                                                    fontSize: 60,
                                                    color:
                                                        GlobalColors.textColor),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              color: GlobalColors
                                                  .appWhiteBackgroundColor,
                                              width: 2),
                                          Expanded(
                                            flex: 8,
                                            child: AutoSizeTextField(
                                              controller: amountController,
                                              style:
                                                  const TextStyle(fontSize: 60),
                                              enabled: false,
                                              readOnly: true,
                                              textAlign: TextAlign.end,
                                              decoration: const InputDecoration(
                                                filled: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2,
                                                        vertical: 0),
                                                fillColor:
                                                    GlobalColors.paleGray,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // implement the custom NumPad
                                  NumPad(
                                    buttonSize: 70,
                                    buttonColor: Colors.white,
                                    iconColor: GlobalColors.appColor,
                                    controller: amountController,
                                    delete: () {
                                      amountController.text.isEmpty
                                          ? null
                                          : amountController.text =
                                              amountController.text.substring(
                                                  0,
                                                  amountController.text.length -
                                                      1);
                                    },
                                  ),

                                  SizedBox(height: 20.h),

                                  isLoading == true
                                      ? const CustomButtonWithCircular()
                                      : CustomButton(
                                          text: S.of(context).scan,
                                          onPressed: isMerchantQrLoading
                                              ? () {}
                                              : () {
                                                  if (amountController
                                                          .text.isEmpty ||
                                                      double.parse(
                                                              amountController
                                                                  .text) <=
                                                          0) {
                                                    GlobalSnackBar.valid(
                                                        context,
                                                        S
                                                            .of(context)
                                                            .pleaseEnterTheRightAmount);
                                                    return;
                                                  }
                                                  context.pushNamed(
                                                    'qr_screen',
                                                    extra: {
                                                      'title':
                                                          S.of(context).pay,
                                                    },
                                                  ).then((result) async {
                                                    if (result != null &&
                                                        result
                                                            .toString()
                                                            .isNotEmpty) {
                                                      setState(() {
                                                        isLoading =
                                                            true; // show loading right after scanning QR
                                                      });

                                                      await _scanManualQr(result
                                                          .toString()); // wait for API + navigation to complete
                                                      setState(() {
                                                        isLoading =
                                                            false; // hide loading (if _scanManualQr does not already do it)
                                                      });
                                                    }
                                                  });
                                                }
                                          //  _scanManualQr,
                                          ),

                                  SizedBox(height: 15.h),

                                  Text.rich(
                                    TextSpan(
                                      text: S
                                          .of(context)
                                          .ifYourCameraIsNotWorkingProperly,
                                      style: merchantNameStyle,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: S.of(context).enterCodeManually,
                                          style: merchantNameStyle.copyWith(
                                            decoration:
                                                TextDecoration.underline,
                                            color: GlobalColors.appColor1,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () async {
                                              if (amountController
                                                      .text.isEmpty ||
                                                  double.parse(amountController
                                                          .text) <=
                                                      0) {
                                                GlobalSnackBar.valid(
                                                    context,
                                                    S
                                                        .of(context)
                                                        .pleaseEnterTheRightAmount);
                                                return;
                                              }
                                              context.pushNamed('manual-code',
                                                  pathParameters: {
                                                    'totalAmount':
                                                        amountController.text
                                                            .trim()
                                                  });
                                            },
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : daysMoreToGo(snapShot.data!);
                    }
                  }),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  //Showing how many more days to go for a pay section
  daysMoreToGo(IsPayEnableResModel? getData) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      width: MediaQuery.of(context).size.width / 1,
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          SizedBox(
            child: Image.asset(
              "assets/images/coming-soon-icon.png",
              height: 200.h,
              width: MediaQuery.of(context).size.width / 2,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
