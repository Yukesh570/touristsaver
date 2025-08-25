// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/pref.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/connectivity/cubit/internet_cubit.dart';
import 'package:new_piiink/features/home_page/bloc/slider_blocs.dart';
import 'package:new_piiink/features/home_page/bloc/slider_events.dart';
import 'package:new_piiink/features/home_page/bloc/slider_states.dart';
// import 'package:new_piiink/features/home_page/services/home_dio.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import '../../../common/services/rate_my_app.dart';
import 'package:new_piiink/models/response/slider_res.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/utils.dart';
import '../../../common/widgets/custom_button.dart';
import '../../../common/widgets/custom_snackbar.dart';
import '../../../common/widgets/empty_data.dart';
import '../../../common/widgets/reg_log_slider.dart';
import '../../../constants/convert_to_map_of_string.dart';
// import '../../../l10n/locale_bloc.dart';
// import '../../../l10n/locales.dart';
import '../../../models/response/app_version_log_model.dart';
import '../../../models/response/category_list_res.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../connectivity/screens/connectivity_screen.dart';
import '../bloc/category_blocs.dart';
import '../bloc/category_events.dart';
import '../../../common/services/dio_common.dart';
import '../../../models/response/piiink_info_res.dart';
import 'package:new_piiink/generated/l10n.dart';

import '../bloc/category_states.dart';
import '../widget/best_offer.dart';
import '../widget/nearby_merchants.dart';
import '../widget/popular_merchant.dart';
import '../widget/tab_container.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // For the refresh Indicator
  final GlobalKey<RefreshIndicatorState> refreshIndicatorHome =
      GlobalKey<RefreshIndicatorState>();
  //late AppLocalizations lang;
  bool isLoading = false;
  bool? hideNotificationIcon;
  final GlobalKey alertKey = GlobalKey();
  late AppLifecycleState appLifecycleState;
  bool isPoop = false;
  bool? forceUpdate = false;
  String? versionApp;
  String? storeLink;
  String? featureList;
  String? platformType;
  String? _version;
  String? _build;
  bool _isUpdateDialogShown = false;
  bool _isShowing = false;

  _getAppVersion() async {
    await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = packageInfo.version;
        _build = packageInfo.buildNumber;
      });
    });
  }

  Future<void> getPiiinkInfo() async {
    PiiinkInfoResModel? piiinkInfoResModel = await DioCommon().piiinkInfo();
    if (!mounted) return;
    setState(() {
      hideNotificationIcon =
          piiinkInfoResModel?.data?.hideMerchantPaymentCodeScanOption;
    });
  }

  Future<void> getVersionLog() async {
    AppVersionLogModel? appVersionLogModel =
        await DioCommon().appVersionLog(platformType);
    if (!mounted) return;
    setState(() {
      forceUpdate = appVersionLogModel!.data![0].forceUpdate;
      versionApp = appVersionLogModel.data![0].version;
      storeLink = appVersionLogModel.data![0].storeLink;
      featureList = appVersionLogModel.data![0].featureList;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      await _getAppVersion();
      await getVersionLog();
      _checkForceUpdate();
    }
  }

  void _checkForceUpdate() {
    // if (forceUpdate == true && version!.compareTo(_version.toString()) > 0) {
    if (forceUpdate == true &&
        (Platform.isAndroid
            ? versionApp != '$_version+$_build'
            : versionApp != _version)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _isUpdateDialogShown = true;
        if (_isUpdateDialogShown == true && _isShowing == false) {
          if (!mounted) return;
          _showForceUpdateDialog();
        }
      });
    } else {
      _isUpdateDialogShown = false;
      _isShowing = false;
      if (_isShowing == true) {
        Navigator.pop(alertKey.currentContext!);
      }
    }
  }

  Future<void> _showForceUpdateDialog() async {
    // if (forceUpdate == false) {
    //   context.pop();
    //   return; // Dialog is already shown, do nothing
    // }
    _isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            key: alertKey,
            title: const Text(
              'App Update Required',
              // textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 320.h,
              width: 300.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your app version ${Platform.isAndroid ? '$_version+$_build' : _version} is outdated. Please update to the latest version $versionApp.',
                    // textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  featureList == null || featureList == ""
                      ? const SizedBox()
                      : SizedBox(
                          height: 190.h,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Html(
                                  data: featureList ?? '',
                                ),
                                const SizedBox(height: 5),
                              ],
                            ),
                          ),
                        ),
                  const SizedBox(height: 5),
                  CustomButton(
                    onPressed: () {
                      onUpdate(storeLink!);
                      context.pop();
                      _isShowing = false;
                    },
                    text: S.of(context).update,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  onUpdate(String urlz) {
    String prefixedUrl = prefixHttp(urlz);
    Uri webOpen = Uri.parse(prefixedUrl);
    launchUrl(webOpen,
        mode: Platform.isIOS
            ? LaunchMode.externalApplication
            : LaunchMode.externalNonBrowserApplication);
  }

  checkPlatform() async {
    if (Platform.isAndroid) {
      setState(() {
        platformType = "android";
      });
    } else if (Platform.isIOS) {
      setState(() {
        platformType = "ios";
      });
    }
  }

  ///--------------------------Show language button commented for Now----------------------------------------------------
  // void showLanguageBottomSheet(BuildContext context) {
  //   if (AppVariables.visibleLocaleList.isEmpty) {
  //     for (LocaleModel localeModel in L10n.all) {
  //       if (AppVariables.localeList.contains(localeModel.locale.languageCode)) {
  //         //    L10n.all.remove(localeModel);
  //         AppVariables.visibleLocaleList.add(localeModel);
  //       }
  //     }
  //   }
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: GlobalColors.paleGray,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(20.0),
  //         topRight: Radius.circular(20.0),
  //       ),
  //     ),
  //     builder: (context) {
  //       return Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text(
  //               S.of(context).chooseLanguage,
  //               style: notiHeaderTextStyle,
  //             ),
  //             const SizedBox(height: 20),
  //             BlocBuilder<LocaleCubit, LocaleState>(
  //               builder: (context, state) {
  //                 return Container(
  //                   constraints: BoxConstraints(
  //                       maxHeight: MediaQuery.of(context).size.height / 2.2),
  //                   child: ListView.separated(
  //                     shrinkWrap: true,
  //                     itemCount: AppVariables.visibleLocaleList.length,
  //                     itemBuilder: (context, index) {
  //                       LocaleModel localeModel =
  //                           AppVariables.visibleLocaleList[index];
  //                       bool isLocaleSelected =
  //                           localeModel == state.localeModel;
  //                       return ListTile(
  //                         onTap: () {
  //                           context
  //                               .read<LocaleCubit>()
  //                               .changeLocale(localeModel);
  //                           Future.delayed(const Duration(milliseconds: 300))
  //                               .then((value) => Navigator.of(context).pop());
  //                         },
  //                         leading: ClipOval(
  //                           child: Image.asset(
  //                             localeModel.imagePath,
  //                             height: 32.0,
  //                             width: 32.0,
  //                           ),
  //                         ),
  //                         title: Text(localeModel.name),
  //                         trailing: isLocaleSelected
  //                             ? const Icon(
  //                                 Icons.check_circle_rounded,
  //                                 color: GlobalColors.appColor,
  //                               )
  //                             : null,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10.0),
  //                           side: isLocaleSelected
  //                               ? const BorderSide(
  //                                   color: GlobalColors.appColor1, width: 1.5)
  //                               : BorderSide(color: Colors.grey[300]!),
  //                         ),
  //                         tileColor: isLocaleSelected
  //                             ? GlobalColors.appGreyBackgroundColor
  //                             : null,
  //                       );
  //                     },
  //                     separatorBuilder: (context, index) {
  //                       return const SizedBox(height: 16.0);
  //                     },
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // final AppRating appRating = AppRating();
  @override
  void initState() {
    getPiiinkInfo();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context
          .read<CategoryBloc>()
          .add(LoadCategoryEvent(AppVariables.selectedLanguageNow));
      context.read<SliderBloc>().add(LoadSliderEvent());
      // await appRating.rateApp(context);
      await checkPlatform();
      await _getAppVersion();
      await getVersionLog();
      _checkForceUpdate();
      bool val = await Pref().readBool(key: 'isShownRegLog') ?? false;
      if (val == false) {
        await paySlider();
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityCubit().close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> paySlider() {
    return showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width / 1.1,
        ),
        builder: (context) {
          bool isShownRegLog = true;
          Pref().setBool(key: 'isShownRegLog', value: isShownRegLog);
          return RegLogSlider(
            title: S.of(context).membership,
            body: S
                .of(context)
                .toShopAtTouristSaverMerchantsGetGreatDiscountsAndDonatToYourFavouriteCharityRegisterMembershipOrLogin,
            onregister: () {
              context.pop();
              context.pushNamed('register', queryParameters: {
                'issuercode': '',
                'memberReferralCode': ''
              });
            },
            onLogin: () {
              context.pop();
              context.pushNamed('login');
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // final localeData = context.read<LocaleCubit>().state;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 122),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Image or Logo
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    child: Image.asset(
                      "assets/images/tourist.png",
                      width: 100,
                      height: 50,
                    ),
                  ),

                  Row(
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 10,
                      //     right: 10,
                      //   ),
                      //   child: OutlinedButton(
                      //     onPressed: () {
                      //       if (AppVariables.visibleLocaleList.isEmpty) {
                      //         for (LocaleModel localeModel in L10n.all) {
                      //           if (AppVariables.localeList.contains(
                      //               localeModel.locale.languageCode)) {
                      //             //    L10n.all.remove(localeModel);
                      //             AppVariables.visibleLocaleList
                      //                 .add(localeModel);
                      //           }
                      //         }
                      //       }
                      //       showModalBottomSheet(
                      //         context: context,
                      //         isScrollControlled: true,
                      //         backgroundColor: GlobalColors.paleGray,
                      //         shape: const RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.only(
                      //             topLeft: Radius.circular(20.0),
                      //             topRight: Radius.circular(20.0),
                      //           ),
                      //         ),
                      //         builder: (context) {
                      //           return Padding(
                      //             padding: const EdgeInsets.all(16.0),
                      //             child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               children: [
                      //                 Text(
                      //                   S.of(context).chooseLanguage,
                      //                   style: notiHeaderTextStyle,
                      //                 ),
                      //                 const SizedBox(height: 20),
                      //                 BlocBuilder<LocaleCubit, LocaleState>(
                      //                   builder: (context, state) {
                      //                     return Container(
                      //                       constraints: BoxConstraints(
                      //                           maxHeight:
                      //                               MediaQuery.of(context)
                      //                                       .size
                      //                                       .height /
                      //                                   2.2),
                      //                       child: ListView.separated(
                      //                         shrinkWrap: true,
                      //                         itemCount: AppVariables
                      //                             .visibleLocaleList.length,
                      //                         itemBuilder: (context, index) {
                      //                           LocaleModel localeModel =
                      //                               AppVariables
                      //                                       .visibleLocaleList[
                      //                                   index];
                      //                           bool isLocaleSelected =
                      //                               localeModel ==
                      //                                   state.localeModel;
                      //                           return ListTile(
                      //                             onTap: () {
                      //                               context
                      //                                   .read<LocaleCubit>()
                      //                                   .changeLocale(
                      //                                       localeModel);
                      //                               Future.delayed(
                      //                                       const Duration(
                      //                                           milliseconds:
                      //                                               300))
                      //                                   .then((value) {
                      //                                 context
                      //                                     .read<CategoryBloc>()
                      //                                     .add(LoadCategoryEvent(
                      //                                         AppVariables
                      //                                             .selectedLanguageNow));
                      //                                 Navigator.of(context)
                      //                                     .pop();
                      //                               });
                      //                             },
                      //                             leading: ClipOval(
                      //                               child: Image.asset(
                      //                                 localeModel.imagePath,
                      //                                 height: 32.0,
                      //                                 width: 32.0,
                      //                               ),
                      //                             ),
                      //                             title: Text(localeModel.name),
                      //                             trailing: isLocaleSelected
                      //                                 ? const Icon(
                      //                                     Icons
                      //                                         .check_circle_rounded,
                      //                                     color: GlobalColors
                      //                                         .appColor,
                      //                                   )
                      //                                 : null,
                      //                             shape: RoundedRectangleBorder(
                      //                               borderRadius:
                      //                                   BorderRadius.circular(
                      //                                       10.0),
                      //                               side: isLocaleSelected
                      //                                   ? const BorderSide(
                      //                                       color: GlobalColors
                      //                                           .appColor1,
                      //                                       width: 1.5)
                      //                                   : BorderSide(
                      //                                       color: Colors
                      //                                           .grey[300]!),
                      //                             ),
                      //                             tileColor: isLocaleSelected
                      //                                 ? GlobalColors
                      //                                     .appGreyBackgroundColor
                      //                                 : null,
                      //                           );
                      //                         },
                      //                         separatorBuilder:
                      //                             (context, index) {
                      //                           return const SizedBox(
                      //                               height: 16.0);
                      //                         },
                      //                       ),
                      //                     );
                      //                   },
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //     //  => showLanguageBottomSheet(context),
                      //     style: OutlinedButton.styleFrom(
                      //       padding: const EdgeInsets.all(8.0),
                      //       foregroundColor: GlobalColors.paleGray,
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         ClipOval(
                      //           child: BlocBuilder<LocaleCubit, LocaleState>(
                      //             builder: (context, state) {
                      //               return Image.asset(
                      //                 state.localeModel.imagePath,
                      //                 height: 32.0,
                      //                 width: 32.0,
                      //               );
                      //             },
                      //           ),
                      //         ),
                      //         const Icon(
                      //           Icons.arrow_drop_down_rounded,
                      //           color: GlobalColors.gray,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Notification Icon
                      if (AppVariables.accessToken != null &&
                          hideNotificationIcon == false)
                        InkWell(
                          onTap: () async {
                            // log('home log notification ${AppVariables.notificationLabel.value}');
                            AppVariables.notificationLabel.value = 0;
                            await Pref().writeInt(
                                key: 'notificationsCount',
                                value: AppVariables.notificationLabel.value);
                            if (!mounted) return;
                            context.pushNamed('notification');
                          },
                          child: SizedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, right: 10),
                              child: ValueListenableBuilder(
                                valueListenable: AppVariables.notificationLabel,
                                builder: (context, value, child) {
                                  // log(value.toString());
                                  return Badge(
                                    backgroundColor: GlobalColors.appColor1,
                                    smallSize: 10,
                                    isLabelVisible: value == 0 ? false : true,
                                    child: const Icon(
                                      Icons.notifications_outlined,
                                      color: GlobalColors.appColor,
                                      size: 30,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Search For Merchants
              GestureDetector(
                onTap: () {
                  context.pushNamed('search-merchant').then((value) {
                    if (AppVariables.locationEnabledStatus.value > 1 &&
                        value == true) {
                      AppVariables.locationEnabledStatus.value += 1;
                    }
                  });
                },
                child: Container(
                  height: 45,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: GlobalColors.appColor.withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          blurRadius: 4,
                          spreadRadius: 1,
                          offset: const Offset(2, 2),
                        )
                      ]),
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/images/search.png',
                          height: 20,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        flex: 9,
                        child: Text(
                          S.of(context).searchForMerchantsCategoryLocation,
                          overflow: TextOverflow.ellipsis,
                          style: searchStyle.copyWith(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        key: refreshIndicatorHome,
        color: GlobalColors.appColor,
        onRefresh: () async {
          context.read<SliderBloc>().add(LoadSliderEvent());
          context
              .read<CategoryBloc>()
              .add(LoadCategoryEvent(AppVariables.selectedLanguageNow));
          if (!mounted) return;
          setState(() {
            if (AppVariables.locationEnabledStatus.value > 1) {
              AppVariables.locationEnabledStatus.value++;
            }
          });
        },
        child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, state) {
            if (state == ConnectivityState.loading) {
              return const NoInternetLoader();
            } else if (state == ConnectivityState.disconnected) {
              return const NoConnectivityScreen();
            } else if (state == ConnectivityState.connected) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    adSlider(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: AutoSizeText(
                        S.of(context).whatAreYouLookingFor,
                        style: topicStyle,
                      ),
                    ),
                    const SizedBox(height: 15),
                    categoryWidget(),
                    ValueListenableBuilder(
                      valueListenable: AppVariables.locationEnabledStatus,
                      builder: (context, value, child) {
                        // log(value.toString());
                        bool isLoading = value == 0 ? true : false;
                        return Column(
                          children: [
                            BestOffer(
                                key: ValueKey(value), isLoading: isLoading),
                            const SizedBox(height: 20),
                            NearbyMerchants(
                                key: ValueKey(value + 1), isLoading: isLoading),
                            const SizedBox(height: 20),
                            PopularMerchant(
                                key: ValueKey(value + 2), isLoading: isLoading),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

//Category Widget
  categoryWidget() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoadingState) {
          return SizedBox(
            height: 125,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 20);
                },
                itemCount: 10,
                itemBuilder: (context, index) {
                  return const TabContainer(icon: '', text: '...');
                }),
          );
        } else if (state is CategoryLoadedState) {
          CategoryListResModel categoryList = state.categoryList;
          return SizedBox(
            height: categoryList.data!.data!.isEmpty ? 50 : 125,
            child: categoryList.data!.data!.isEmpty
                ? EmptyData(text: S.of(context).noCategoryFound)
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    separatorBuilder: (context, index) {
                      return const SizedBox(width: 20);
                    },
                    itemCount: categoryList.data!.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          context.pushNamed('category-screen', pathParameters: {
                            // 'categoryName': categoryList
                            //     .data!.data![index].name!,
                            'parentId':
                                categoryList.data!.data![index].id.toString(),
                          }).then((value) {
                            if (value == true) {
                              if (AppVariables.locationEnabledStatus.value >
                                      1 &&
                                  value == true) {
                                AppVariables.locationEnabledStatus.value += 1;
                              }
                            }
                          });
                        },
                        child: TabContainer(
                          icon: categoryList.data!.data![index].imageName!,
                          text: categoryList.data!.data![index].name!,
                        ),
                      );
                    }),
          );
        } else if (state is CategoryErrorState) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Error(),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  //AD Slider
  adSlider() {
    return BlocBuilder<SliderBloc, SliderState>(builder: (context, state) {
      //Loading State
      if (state is SliderLoadingState) {
        return const SliderLoader();
      }
      //Loaded State
      else if (state is SliderLoadedState) {
        SliderResModel sliderList = state.sliderList;
        return sliderList.data!.isEmpty
            ? emptySliderData()
            : CarouselSlider(
                options: CarouselOptions(
                  height: 230.h,
                  autoPlay: true,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.95,
                ),
                items: sliderList.data!.map<Widget>((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        height: 230.h,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: GlobalColors.appWhiteBackgroundColor,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: kElevationToShadow[2],
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (i.hasLink == true) {
                              if (i.externalLink != null) {
                                //To open the website link
                                String prefixedUrl =
                                    prefixHttp(i.externalLink.toString());
                                Uri webOpen = Uri.parse(prefixedUrl);
                                launchUrl(webOpen,
                                    mode: Platform.isIOS
                                        ? LaunchMode.externalApplication
                                        : LaunchMode
                                            .externalNonBrowserApplication);
                                return;
                              } else if (i.screenValue != null &&
                                  i.internalLink == 'login') {
                                if (AppVariables.accessToken == null) {
                                  GlobalSnackBar.valid(
                                      context, S.of(context).youAreNotLoggedIn);

                                  context.pushNamed('login');
                                  return;
                                } else {
                                  Map<String, dynamic> extras =
                                      jsonDecode(i.screenValue!);
                                  if (extras.keys.first == "extra") {
                                    context.pushNamed('${i.screenName}',
                                        extra: extras.values.first);
                                    return;
                                  } else if (extras.keys.first ==
                                      "pathParameters") {
                                    //converting Map<String,dynamic> to Map<String,String> from convert to map of String from constants folder.
                                    Map<String, String> pathParams =
                                        convertToMapOfStrings(
                                            extras.values.first);

                                    context.pushNamed('${i.screenName}',
                                        pathParameters: pathParams);
                                    return;
                                  }
                                }
                              } else if (i.screenValue != null &&
                                  i.internalLink != 'login') {
                                Map<String, dynamic> extras =
                                    jsonDecode(i.screenValue!);
                                if (extras.keys.first == "extra") {
                                  context.pushNamed('${i.screenName}',
                                      extra: extras.values.first);
                                  return;
                                } else if (extras.keys.first ==
                                    "pathParameters") {
                                  //converting Map<String,dynamic> to Map<String,String> from convert to map of String from constants folder.
                                  Map<String, String> pathParams =
                                      convertToMapOfStrings(
                                          extras.values.first);

                                  context.pushNamed('${i.screenName}',
                                      pathParameters: pathParams);
                                  return;
                                }
                              } else if (i.screenValue == null &&
                                  i.internalLink == 'login') {
                                if (AppVariables.accessToken == null) {
                                  GlobalSnackBar.valid(
                                      context, S.of(context).youAreNotLoggedIn);

                                  context.pushNamed('login');
                                  return;
                                } else {
                                  context.pushNamed('${i.screenName}');
                                  return;
                                }
                              } else {
                                context.pushNamed('${i.screenName}');
                                return;
                              }
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              imageUrl: i.url!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) {
                                return const Center(
                                    child:
                                        FittedBox(child: CustomAllLoader1()));
                              },
                              errorWidget: (context, url, error) => Center(
                                  child: Image.asset(
                                      'assets/images/no_image.jpg')),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
      }
      //Error State
      else if (state is SliderErrorState) {
        return const SliderError();
      } else {
        return const SizedBox();
      }
    });
  }

  // If slider data is empty
  emptySliderData() {
    return CarouselSlider(
        options: CarouselOptions(
          height: 230,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          viewportFraction: 0.95,
        ),
        items: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 230,
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: GlobalColors.appWhiteBackgroundColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: kElevationToShadow[2],
            ),
            child: Center(
                child: AutoSizeText(
              S.of(context).noSliderImageAdded,
              style: locationStyle,
            )),
          ),
        ]);
  }
}
