// import 'dart:developer';
// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/number_formatter.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/connectivity/cubit/internet_cubit.dart';
import 'package:new_piiink/features/profile/widget/info_popup.dart';
import 'package:new_piiink/features/wallet/services/dio_wallet.dart';
import 'package:new_piiink/models/response/universal_get_my_wallet.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../constants/pref.dart';
import '../../../constants/pref_key.dart';
import '../../../models/error_res.dart';
import '../../../models/request/rate_merchant_req.dart';
import '../../../models/response/get_all_reviews_suggestion.dart';
import '../../../models/response/get_free_piiinks_res_model.dart';
import '../../../models/response/is_pay_enable_res.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../merchant/services/dio_reviews.dart';
import '../../payment/services/dio_payment.dart';
import '../widget/show_confirm_piiinks_bottom_sheet.dart';
import 'package:new_piiink/generated/l10n.dart';

import 'package:dartz/dartz.dart' as dartz;

class LogWalletScreen extends StatefulWidget {
  static const String routeName = '/wallet-screen';
  const LogWalletScreen({super.key});

  @override
  State<LogWalletScreen> createState() => _LogWalletScreenState();
}

class _LogWalletScreenState extends State<LogWalletScreen> {
  List<String> additionalList = [];
  buildAdditionalList() {
    additionalList.addAll([
      S.of(context).topUpUniversalTouristSaverCredits,
      S.of(context).changeCountry,
      S.of(context).transferTouristSavers,
      S.of(context).transactionHistory,
      S.of(context).topUpHistory,
    ]);
  }

  bool? isTopUpEnabled;
  bool? canClaimFreePiiinks;
  bool? isFreePiiinksProvided;
  bool? isTopUpOnRegister;
  double? universalFreePiiinks;
  // For the refresh Indicator
  final GlobalKey<RefreshIndicatorState> refreshIndicatorProfile =
      GlobalKey<RefreshIndicatorState>();

  //For Sending the universal piiink as an argument
  double? sendUniPiiink;
  bool isLoading = false;

  Future<void> getFreePiiinksInfo() async {
    GetFreePiinksResModel? getFreePiinksResModel = await DioWallet().getFree();
    universalFreePiiinks =
        getFreePiinksResModel?.data?.universalPiiinks!.toDouble();
    // log({getFreePiinksResModel?.data?.universalPiiinks}.toString());
  }

  Future<void> getPaymentInfo() async {
    IsPayEnableResModel? isPayEnabledResModel = await DioPay().payEnabled();
    if (!mounted) return;
    setState(() {
      isTopUpEnabled = isPayEnabledResModel?.data?.transactionIsEnabled;
      if (isTopUpEnabled == false) {
        additionalList.remove(S.of(context).topUpUniversalTouristSaverCredits);
      }
    });
  }

  // Calling the user wallet
  Future<UniversalGetMyWallet?>? walletLoad;
  Future<UniversalGetMyWallet?> loadWallet() async {
    setState(() {
      isLoading = false;
    });
    UniversalGetMyWallet? getWallet = await DioWallet().getUniverslUserWallet();
    setState(() {
      isTopUpOnRegister = getWallet!.data!.isTopUpOnRegister;
      canClaimFreePiiinks = getWallet.data!.canClaimFreePiiinks;
      isFreePiiinksProvided = getWallet.data!.isFreePiiinksProvided;
      isLoading = true;
    });
    return getWallet;
  }

  int? merchantId;
  bool showReviewPopUp = false;

  late double _rating;
  final int _ratingBarMode = 0;
  final double _initialRating = 0;
  IconData? _selectedIcon;
  var _defaultChoiceIndex;
  String? selectedString;
  bool reviewLoading = false;
  bool isSelected = false;

// For filling the edit form
  Future<dartz.Either<ErrorResModel, GetAllReviewSuggestionResModel>?>?
      getReviews;
  Future<dartz.Either<ErrorResModel, GetAllReviewSuggestionResModel>?>?
      getSuggestionReview() async {
    dartz.Either<ErrorResModel, GetAllReviewSuggestionResModel>?
        getSuggestionReviewRes = await DioReviews().getAllReviews();

    return getSuggestionReviewRes!
        .fold((l) => getSuggestionReviewRes, (r) => getSuggestionReviewRes);
  }

  @override
  void initState() {
    getPaymentInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      buildAdditionalList();
      showReviewPopUp = await Pref().readBool(key: showReview) ?? false;
      merchantId = await Pref().readInt(key: addReviewMerchantID);
      getReviews = getSuggestionReview();
      _rating = _initialRating;
      if (showReviewPopUp == true) {
        _showAddReviewDialog();
      }
    });

    getFreePiiinksInfo();
    walletLoad = loadWallet();
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
        child: CustomAppBar(text: S.of(context).myWallet),
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          return RefreshIndicator(
            key: refreshIndicatorProfile,
            onRefresh: () => walletLoad = loadWallet(),
            color: GlobalColors.appColor,
            child: ScrollConfiguration(
              behavior: const ScrollBehavior(),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (state == ConnectivityState.loading)
                          ? const NoInternetLoader()
                          : (state == ConnectivityState.disconnected)
                              ? const NoInternetWidget()
                              : (state == ConnectivityState.connected)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: AutoSizeText(
                                            S
                                                .of(context)
                                                .yourUniversalTouristSaverCredits,
                                            style: topicStyle,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        FutureBuilder<UniversalGetMyWallet?>(
                                            future: walletLoad,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const ProfileError();
                                              } else if (!snapshot.hasData) {
                                                return const ProfileLoader();
                                              } else {
                                                // Full Container
                                                sendUniPiiink = snapshot
                                                    .data!.data!.balance;
                                                return isLoading == false
                                                    ? const ProfileLoader()
                                                    : uniCredit(snapshot.data!);
                                              }
                                            }),

                                        const SizedBox(height: 20),
                                        // show modal for piiinks claim according to the isClaimPiiinks from api
                                        // isTopUpOnRegister == false &&
                                        canClaimFreePiiinks == true &&
                                                isFreePiiinksProvided == false
                                            ? Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 0, top: 0),
                                                    // child: Align(
                                                    //   alignment:
                                                    //       Alignment.center,
                                                    //   child: InkWell(
                                                    //     onTap: () {
                                                    //       showConfirmPiiinksBottomSheet(
                                                    //           context,
                                                    //           universalFreePiiinks);
                                                    //     },
                                                    //     child: AutoSizeText(
                                                    //       S
                                                    //           .of(context)
                                                    //           .claimFreeTouristSavers,
                                                    //       //     'Claim Free Piiinks',
                                                    //       style:
                                                    //           notiHeaderTextStyle
                                                    //               .copyWith(
                                                    //         fontSize: 16.sp,
                                                    //         decoration:
                                                    //             TextDecoration
                                                    //                 .underline,
                                                    //       ),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                ],
                                              )
                                            : const SizedBox(),

                                        //  "Your Active Merchant Wallets",
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: AutoSizeText(
                                            S
                                                .of(context)
                                                .yourActiveMerchantWallets,
                                            style: topicStyle,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        activeMerchantButton(),

                                        const SizedBox(height: 20),
                                      ],
                                    )
                                  : const SizedBox(),
                      // Additionals
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: AutoSizeText(
                          S.of(context).additional,
                          style: topicStyle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      walletAdditionalList(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Universal Wallet
  uniCredit(UniversalGetMyWallet universalWallet) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 1,
          height: 200,
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  GlobalColors.appColor1,
                  GlobalColors.appColor,
                ],
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                    offset: const Offset(2, 2))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Piiinks Universal Number
              AutoSizeText(
                numFormatter.format(universalWallet.data?.balance),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50.sp,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontFamily: 'Sans'),
              ),

              const SizedBox(height: 5),

              // Piiinks
              AutoSizeText(
                S.of(context).touristSavers,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35.sp,
                    decoration: TextDecoration.none,
                    color: Colors.white,
                    fontFamily: 'Sans'),
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),

        //  info Button
        Positioned(
          right: -5.0,
          top: -7.0,
          child: GestureDetector(
            onTap: () {
              showGeneralDialog(
                barrierLabel: 'Label',
                barrierDismissible:
                    false, //to dismiss the container once opened
                barrierColor: Colors.black.withValues(
                    alpha:
                        0.5), //to change the background color once the container is opened
                transitionDuration: const Duration(milliseconds: 300),
                context: context,
                pageBuilder: (context, anim1, anim2) {
                  return Align(
                    alignment: Alignment.center,
                    child: InfoPopUp(
                      title: S.of(context).touristSaverCreditsInfo,
                      body: S.of(context).touristSaverCreditsInfoD,
                      onOk: () {
                        context.pop();
                      },
                    ),
                  );
                },
                transitionBuilder: (context, anim1, anim2, child) {
                  return SlideTransition(
                    position: Tween(
                            begin: const Offset(0, 1), end: const Offset(0, 0))
                        .animate(anim1),
                    child: child,
                  );
                },
              );
            },
            child: Container(
              width: 25,
              height: 25,
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: GlobalColors.appColor),
              child: Image.asset(
                "assets/images/info.png",
              ),
            ),
          ),
        ),
      ],
    );
  }

  // View active mechant button
  activeMerchantButton() {
    return InkWell(
      onTap: () {
        context.pushNamed('merchant-wallet');
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1,
        height: 50.h,
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: OutlineGradientButton(
          strokeWidth: 3,
          radius: const Radius.circular(5.0),
          backgroundColor: GlobalColors.appGreyBackgroundColor,
          elevation: 4,
          gradient: const LinearGradient(
            colors: [GlobalColors.appColor, GlobalColors.appColor1],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          child: Center(
            child: AutoSizeText(
              S.of(context).viewAll,
              style: merchantNameStyle,
            ),
          ),
        ),
      ),
    );
  }

  // Additional List
  walletAdditionalList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      separatorBuilder: (context, index) {
        return const SizedBox(height: 10);
      },
      itemCount: additionalList.length,
      itemBuilder: (context, index) {
        return InkWell(
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            additionalList[index] ==
                    S.of(context).topUpUniversalTouristSaverCredits
                ? context.pushNamed('top-up').then((value) => setState(() {
                      walletLoad = loadWallet();
                    }))
                : additionalList[index] == S.of(context).changeCountry
                    ? context
                        .pushNamed('change-country')
                        .then((value) => setState(() {
                              walletLoad = loadWallet();
                            }))
                    : additionalList[index] ==
                            S.of(context).transferTouristSavers
                        ? context
                            .pushNamed('transfer-piiinks')
                            .then((value) => setState(() {
                                  walletLoad = loadWallet();
                                }))
                        : additionalList[index] == S.of(context).topUpHistory
                            ? context.pushNamed('top_up_history')
                            : context.pushNamed('statement', pathParameters: {
                                'uniBalance': sendUniPiiink.toString() != 'null'
                                    ? sendUniPiiink.toString()
                                    : '0'
                              });
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 55.h,
            child: ListTile(
              tileColor: GlobalColors.appWhiteBackgroundColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              title: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                // Text Name
                child: AutoSizeText(
                  additionalList[index],
                  style: profileListStyle,
                ),
              ),
              // Arrow
              trailing: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 25,
                  color: GlobalColors.gray.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddReviewDialog() {
    Pref().setBool(key: showReview, value: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(S.of(context).addReview),
          content: StatefulBuilder(builder: (context, stateMode) {
            return SingleChildScrollView(
              child: SizedBox(
                height: 320,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).rateThisMerchant,
                      style: topicStyle.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 15),
                    Center(child: _ratingBar(_ratingBarMode)),
                    const SizedBox(height: 15),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(height: 15),
                    Text(S.of(context).yourFeedback,
                        style: topicStyle.copyWith(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    choiceChips(stateMode),
                  ],
                ),
              ),
            );
          }),
          actions: [
            reviewLoading == true
                ? Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 7.0),
                    child: const CustomButtonWithCircular(),
                  )
                : Padding(
                    padding: const EdgeInsets.only(
                        right: 15.0, left: 15.0, bottom: 7.0),
                    child: CustomButton(
                        onPressed: () {
                          onSendReview();
                        },
                        text: S.of(context).sendReview),
                  ),
          ],
        );
      },
    );
  }

  Widget choiceChips(stateMode) {
    return FutureBuilder<
            dartz.Either<ErrorResModel, GetAllReviewSuggestionResModel>?>(
        future: getReviews,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Error1();
          } else if (!snapshot.hasData) {
            return const Column(
              children: [
                CustomAllLoader(),
              ],
            );
          } else {
            return snapshot.data!.fold((l) {
              return ErrorData(text: l.message!);
            }, (r) {
              var realData = r.data?.where((x) => x.isActive == true).toList();
              return r.data!.isNotEmpty
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: realData!.map((item) {
                            // log("Chip item: ${item.reviewText}");
                            return ChoiceChip(
                              padding: EdgeInsets.all(10.sp),
                              selectedColor: Colors.orange.shade300,
                              label: Text(
                                item.reviewText ?? '',
                                overflow: TextOverflow.ellipsis,
                              ),
                              selected:
                                  _defaultChoiceIndex == realData.indexOf(item),
                              shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: GlobalColors.appColor1),
                                  borderRadius: BorderRadius.circular(15)),
                              backgroundColor:
                                  GlobalColors.appWhiteBackgroundColor,
                              labelStyle: _defaultChoiceIndex ==
                                          realData.indexOf(item) &&
                                      isSelected
                                  ? const TextStyle(
                                      color:
                                          GlobalColors.appWhiteBackgroundColor)
                                  : const TextStyle(
                                      color: GlobalColors.appColor1),
                              onSelected: (bool selected) {
                                stateMode(() {
                                  _defaultChoiceIndex =
                                      selected ? realData.indexOf(item) : 0;
                                  isSelected = true;
                                  selectedString = item.reviewText ?? '';
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : SizedBox();
            });
          }
        });
  }

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 0,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: Colors.orange.withAlpha(50),
      itemCount: 5,
      itemSize: 30.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: Colors.orange,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  onSendReview() async {
    setState(() {
      reviewLoading = true;
    });

    if (_rating == 0.0 && selectedString == null) {
      GlobalSnackBar.valid(
          context, S.of(context).pleaseRateThisMerchantOrProvideFeedback);
      setState(() {
        reviewLoading = false;
      });
    } else {
      var rez = await DioReviews().createMerchantReviews(
          rateMerchantReqModel: RateMerchantReqModel(
              rating: _rating, merchantId: merchantId, review: selectedString));
      rez?.fold((l) {
        GlobalSnackBar.showError(context, l.message!);
        setState(() {
          reviewLoading = false;
        });
        return;
      }, (r) {
        if (r.status == 'Success') {
          GlobalSnackBar.showSuccess(
              context, S.of(context).reviewAddedSuccessfully);
          setState(() {
            reviewLoading = false;
          });
          context.pop();
        }
      });
    }
  }
}
