import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/constants/fixed_decimal.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/payment/services/dio_payment.dart';
import 'package:new_piiink/models/error_res.dart';
import 'package:new_piiink/models/request/confirm_piiink_req.dart';
import 'package:new_piiink/models/response/confirm_piiink_res.dart';
import 'package:new_piiink/generated/l10n.dart';

class ManualCode extends StatefulWidget {
  static const String routeName = '/manual-code';
  final String totalAmount;
  const ManualCode({super.key, required this.totalAmount});

  @override
  State<ManualCode> createState() => _ManualCodeState();
}

class _ManualCodeState extends State<ManualCode> {
  final merchantCodeKey = GlobalKey<FormState>();
  TextEditingController qrCodeController = TextEditingController();

  // For Loading part
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          text: S.of(context).merchantCode,
          icon: Icons.arrow_back_ios,
          onPressed: (() {
            context.pop();
          }),
        ),
      ),
      body: Form(
        key: merchantCodeKey,
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
              color: GlobalColors.appWhiteBackgroundColor,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(2, 2))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // const SizedBox(height: 30),

              Center(
                child: AutoSizeText(
                  S.of(context).enterTheMerchantTransactionCode,
                  style: topicStyle,
                ),
              ),

              const SizedBox(height: 30),

              // OTP Text Form Field
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Otp 1
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: TextFormField(
                      controller: qrCodeController,
                      cursorColor: GlobalColors.appColor,
                      decoration: textInputDecoration1.copyWith(
                        hintText: S.of(context).transactionCode,
                      ),
                    ),
                  ),

                  // SizedBox(
                  //   width: MediaQuery.of(context).size.width / 2,
                  //   child: TextFormField(
                  //     controller: qrCodeController,
                  //     cursorColor: GlobalColors.appColor,
                  //     textAlign: TextAlign.center,
                  //     cursorHeight: 35,
                  //     // onChanged: (value) {
                  //     //   if (value.length == 1) {
                  //     //     FocusScope.of(context).nextFocus();
                  //     //   }
                  //     // },
                  //     decoration: const InputDecoration(
                  //       focusedBorder: UnderlineInputBorder(
                  //         borderSide: BorderSide(color: GlobalColors.appColor),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),

              const SizedBox(height: 30),

              // Send Button
              isLoading == true
                  ? const CustomButtonWithCircular()
                  : CustomButton(
                      text: S.of(context).send,
                      onPressed: () async {
                        if (merchantCodeKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          if (qrCodeController.text.isEmpty) {
                            GlobalSnackBar.valid(
                                context, S.of(context).pleaseEnterTheCode);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          var res = await DioPay().confirmApplyPiiink(
                            confirmApplyPiiinkReqModel:
                                ConfirmApplyPiiinkReqModel(
                              totalAmount: double.parse(widget.totalAmount),
                              transactionQRCode: qrCodeController.text.trim(),
                              hour: int.parse(
                                  DateFormat('HH ').format(DateTime.now())),
                              week: DateTime.now().weekday % 7,
                              lang: AppVariables.selectedLanguageNow,
                              // hour: 12,
                              // week: 2,
                            ),
                          );
                          if (!mounted) return;
                          if (res is ConfirmApplyPiiinkResModel) {
                            if (res.status == "Success") {
                              context.pushNamed('confirm-pay', extra: {
                                'merchantId': res.data!.merchantInfo!.id,
                                'totalAmount': widget.totalAmount,
                                'qrCode': qrCodeController.text.trim(),
                                'hasMerchantPiiinks':
                                    res.data!.hasMerchantPiiinks.toString(),
                                'hasUniversalPiiinks':
                                    res.data!.hasUniversalPiiinks.toString(),
                                'merchantName':
                                    res.data!.merchantInfo!.merchantName,
                                'universalPiiinkBalance': toFixed2DecimalPlaces(
                                        res.data!.universalPiiinkBalance!)
                                    .toString(),
                                'merchantPiiinkBalance': toFixed2DecimalPlaces(
                                        res.data!.merchantPiiinkBalance!)
                                    .toString(),
                                'merchantRebateToMember':
                                    res.data!.merchantRebateToMember.toString(),
                                'discountedTransactionAmount': res
                                    .data!.discountedTransactionAmount
                                    .toString(),
                                'totalPiiinkDiscount':
                                    res.data!.totalPiiinkDiscount.toString(),
                                'logo':
                                    res.data!.merchantInfo?.merchantImageInfo ==
                                            null
                                        ? 'null'
                                        : res.data!.merchantInfo
                                                ?.merchantImageInfo?.logoUrl ??
                                            res.data!.merchantInfo
                                                ?.merchantImageInfo?.slider1 ??
                                            'null',
                                'universalPiiinkOnHold': res
                                    .data!.universalPiiinkBalanceOnHold
                                    .toString(),
                                'merchantPiiinkOnHold': res
                                    .data!.merchantPiiinkBalanceOnHold
                                    .toString(),
                              });
                              setState(() {
                                isLoading = false;
                              });
                            } // else {
                            //   // GlobalSnackBar.showError(
                            //   //     context, S.of(context).notEnoughPiiink);
                            //   // setState(() {
                            //   //   isLoading = false;
                            //   // });
                            // }
                          } else if (res is ErrorResModel) {
                            GlobalSnackBar.showError(context, res.message!);
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          } else {
                            // GlobalSnackBar.showError(context,
                            //     S.of(context).invalidCodeOrServerError);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      },
                    )
            ],
          ),
        ),
      ),
    );
  }
}
