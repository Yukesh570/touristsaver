import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/pref.dart';
import 'package:new_piiink/constants/pref_key.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/top_up/bloc/mem_pack_bloc.dart';
import 'package:new_piiink/features/top_up/bloc/mem_pack_event.dart';
import 'package:new_piiink/features/top_up/bloc/mem_pack_state.dart';
import 'package:new_piiink/features/top_up/services/top_up_dio.dart';
import 'package:new_piiink/features/wallet/services/dio_wallet.dart';
import 'package:new_piiink/models/request/confirm_topup_req.dart';
import 'package:new_piiink/models/response/confirm_topup_res.dart';
import 'package:new_piiink/models/response/top_up_stripe_res.dart';

import '../../constants/decimal_remove.dart';
import '../../constants/number_formatter.dart';
import '../../features/register/services/dio_register.dart';
import '../../models/error_res.dart';
import '../../models/request/reg_top_up_req.dart';
import '../../models/response/claim_piiinks_res_model.dart';
import '../../models/response/membership_package_get_one_for_tourist.dart';
import '../../models/response/membership_package_get_one_by_member_free.dart';
import 'package:new_piiink/generated/l10n.dart';

class PaidFreeScreen extends StatefulWidget {
  static const String routeName = '/paid-free';
  final String? uniCredit;
  const PaidFreeScreen({super.key, this.uniCredit});

  @override
  State<PaidFreeScreen> createState() => _PaidFreeScreenState();
}

class _PaidFreeScreenState extends State<PaidFreeScreen> {
  String? countryID;
  String? countrySym;
  getCountryIDSym() async {
    countryID = await Pref().readData(key: saveCountryID);
    countrySym = await Pref().readData(key: saveCurrency);
  }

  // For Loading part of TopUp
  var isLoading = false;

  @override
  void initState() {
    getCountryIDSym();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pushReplacementNamed('top-up');
        return false;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
            text: S.of(context).chooseOne,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),

            // Top Up
            BlocProvider(
              lazy: false,
              create: (context) =>
                  MemPackAllBloc(RepositoryProvider.of<DioTopUpStripe>(context))
                    ..add(LoadMemPackAllEvent()),
              child: BlocBuilder<MemPackAllBloc, MemPackAllState>(
                builder: (context, state) {
                  //loaded state
                  if (state is MemPackAllLoadingState) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 20.0),
                      width: MediaQuery.of(context).size.width / 1,
                      constraints: const BoxConstraints(
                        //To make height expandable according to the text
                        maxHeight: double.infinity,
                      ),
                      decoration: BoxDecoration(
                          color: GlobalColors.appWhiteBackgroundColor,
                          borderRadius: BorderRadius.circular(5),
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
                          AutoSizeText(
                            S
                                .of(context)
                                .buyXUniversalTouristSaverCredits
                                .replaceAll('&X', '...'),
                            style: locationStyle,
                          ),
                          const SizedBox(height: 10),
                          const CustomButton(text: '....')
                        ],
                      ),
                    );
                  }
                  // loading state
                  else if (state is MemPackAllLoadedState) {
                    // MemberShipPackageResModel memPackAll = state.memPackAll;
                    MembershipGetOneForFreeByMember memPackAll2 =
                        state.memPackAll2;
                    MembershipGetOneForTouristByMember memPackAll3 =
                        state.memPackAll3;
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 20.0),
                          width: MediaQuery.of(context).size.width / 1,
                          constraints: const BoxConstraints(
                            //To make height expandable according to the text
                            maxHeight: double.infinity,
                          ),
                          decoration: BoxDecoration(
                              color: GlobalColors.appWhiteBackgroundColor,
                              borderRadius: BorderRadius.circular(5),
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
                              AutoSizeText(
                                S
                                    .of(context)
                                    .buyXUniversalTouristSaverCredits
                                    .replaceAll(
                                        '&X',
                                        removeTrailingZero(numFormatter
                                            .format(memPackAll3
                                                .data!.universalPiiinks)
                                            .toString())),
                                // 'Buy ${memPackAll.data![0].universalPiiinks} Universal Piiink Credits',
                                // 'Buy ${memPackAll3.data!.universalPiiinks} Universal Piiink Credits',
                                style: locationStyle,
                              ),
                              const SizedBox(height: 10),
                              memPackAll3.data!.packageFee == 0
                                  ? CustomButton(
                                      text: S.of(context).noTopUpAvailable,
                                      onPressed: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         const CongratsScreen(
                                        //       piiinkCredit: '20',
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                    )
                                  : isLoading == true
                                      ? const CustomButtonWithCircular()
                                      : CustomButton(
                                          text: S
                                              .of(context)
                                              .topUpAndPayXY
                                              .replaceAll('&XY',
                                                  ' ${memPackAll3.data!.packageCurrencySymbol}${removeTrailingZero(numFormatter.format(memPackAll3.data!.packageFee))}'),
                                          //   text:
                                          //      'Top-up and Pay ${memPackAll3.data!.packageCurrencySymbol}${memPackAll3.data!.packageFee.toString()}',
                                          onPressed: () async {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            var res = await DioRegister()
                                                .regTopUpStripe(
                                              registerTopUpStripeReqModel:
                                                  RegisterTopUpStripeReqModel(
                                                paymentGateway: 'stripe',
                                                membershipPackageId: memPackAll3
                                                    .data!.id
                                                    .toString(),
                                                countryId: countryID,
                                                //   memberPremiumCode: widget.premium,
                                                isTopupUponRegistration: true,
                                              ),
                                            );

                                            if (!mounted) return;
                                            if (res is TopUpStripeResModel) {
                                              await Stripe.instance
                                                  .initPaymentSheet(
                                                      paymentSheetParameters:
                                                          SetupPaymentSheetParameters(
                                                paymentIntentClientSecret:
                                                    res.clientSecret,
                                                // applePay: const PaymentSheetApplePay(
                                                //     merchantCountryCode: 'DE'),
                                                // googlePay: const PaymentSheetGooglePay(
                                                //     merchantCountryCode: 'DE', testEnv: true),
                                                merchantDisplayName:
                                                    'Prospects',
                                                style: ThemeMode.dark,
                                                // returnURL:
                                                //     'https://piiink-backend.demo-4u.net/api/$stripePayConfirm',
                                              ));
                                              setState(() {
                                                isLoading = false;
                                              });
                                              await displayPaymentSheet(
                                                  res.clientSecret);
                                            } else {
                                              GlobalSnackBar.showError(context,
                                                  S.of(context).serverError);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          },
                                        ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // OR
                        AppVariables.showFreePiiinks == true
                            ? AutoSizeText(
                                S.of(context).or,
                                style: topicStyle,
                              )
                            : const SizedBox(),
                        const SizedBox(height: 15),

                        // Free
                        AppVariables.showFreePiiinks == true
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 20.0),
                                width: MediaQuery.of(context).size.width / 1,
                                constraints: const BoxConstraints(
                                  //To make height expandable according to the text
                                  maxHeight: double.infinity,
                                ),
                                decoration: BoxDecoration(
                                    color: GlobalColors.appWhiteBackgroundColor,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.grey.withValues(alpha: 0.2),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                        offset: const Offset(2, 2),
                                      )
                                    ]),
                                child: Column(
                                  children: [
                                    // Free
                                    AutoSizeText(
                                      S
                                          .of(context)
                                          .getFree20UniversalFreeCredits
                                          .replaceAll(
                                              '20',
                                              removeTrailingZero(numFormatter
                                                  .format(memPackAll2.data!
                                                      .universalPiiinks))),
                                      // 'Get Free ${memPackAll2.data!.universalPiiinks} Universal Free Credits',
                                      style: locationStyle,
                                    ),
                                    const SizedBox(height: 10),
                                    CustomButton(
                                      text: S.of(context).free,
                                      onPressed: () async {
                                        // Navigating to the Next Screen
                                        var result =
                                            await DioWallet().confirmPiiinks();
                                        if (result is ClaimPiiinksResModel) {
                                          if (result.status == 'success') {
                                            if (!mounted) return;
                                            context.pushReplacementNamed(
                                                'congrats-screen',
                                                pathParameters: {
                                                  'piiinkCredit': result
                                                      .universalPiiinks
                                                      .toString(),
                                                });
                                            GlobalSnackBar.showSuccess(
                                                context,
                                                S
                                                    .of(context)
                                                    .freeTouristSaversClaimedSuccessfully);
                                          }
                                        } else if (result is ErrorResModel) {
                                          if (!mounted) return;
                                          GlobalSnackBar.showError(context,
                                              S.of(context).someErrorOccurred);
                                        } else {
                                          if (!mounted) return;
                                          GlobalSnackBar.showError(context,
                                              S.of(context).someErrorOccurred);
                                        }
                                        // log(res.toString());
                                        // if (!mounted) return;
                                        // context.pushReplacementNamed(
                                        //     'congrats-screen',
                                        //     pathParameters: {
                                        //       'piiinkCredit': widget.uniCredit!,
                                        //     });
                                      },
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    );
                  } else if (state is MemPackAllErrorState) {
                    return Center(
                      child: AutoSizeText(S.of(context).error),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> displayPaymentSheet(String? clientSecret) async {
    try {
      //this shows the stripe pay form
      await Stripe.instance.presentPaymentSheet().then((value) async {
        //Retreiving the response after stripe sheet pay button is clicked
        var res = await Stripe.instance.retrievePaymentIntent(clientSecret!);
        if (res.status == PaymentIntentsStatus.Succeeded) {
          // Confirming the stripe payment in backend
          var confirm = await DioTopUpStripe().confirmTopUp(
              confirmTopUpReqModel: ConfirmTopUpReqModel(
                  paymentIntent: res.id,
                  paymentIntentClientSecret: res.clientSecret));
          if (!mounted) return;
          if (confirm is ConfirmTopUpResModel) {
            if (confirm.status == 'success') {
              // Navigating
              context.pushReplacementNamed('congrats-screen', pathParameters: {
                'piiinkCredit': '${confirm.data!.universalWallet!.balance}',
              });

              // Message
              GlobalSnackBar.showSuccess(
                  context, S.of(context).paymentSuccessful);
            } else {
              GlobalSnackBar.showError(context, S.of(context).paymentFailed);
            }
          } else {
            GlobalSnackBar.showError(context, S.of(context).serverError);
          }
        } else {
          if (!mounted) return;
          GlobalSnackBar.showError(context, S.of(context).stripePaymentFail);
        }
      });
    } on Exception catch (e) {
      if (e is StripeException) {
        var res = await Stripe.instance.retrievePaymentIntent(clientSecret!);
        // print(res);

        // Confirming the stripe payment in backend
        var confirm = await DioTopUpStripe().confirmTopUp(
            confirmTopUpReqModel: ConfirmTopUpReqModel(
                paymentIntent: res.id,
                paymentIntentClientSecret: res.clientSecret));
        if (!mounted) return;
        if (confirm is ConfirmTopUpResModel) {
          if (confirm.status == 'failed') {
            GlobalSnackBar.showError(context, S.of(context).paymentFailed);
          } else {
            GlobalSnackBar.showError(context, S.of(context).paymentFailed);
          }
        } else {
          GlobalSnackBar.showError(
              context, S.of(context).thePaymentHasBeenCanceled);
        }
        // print("Error from Stripe: ${e.error.localizedMessage}");
      } else {
        // print("Unforeseen error: ${e}");
        return;
      }
    } catch (e) {
      // print("exception:$e");
      return;
    }
  }
}
