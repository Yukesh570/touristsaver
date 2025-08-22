import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/app_variables.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/error.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/pref.dart';
import 'package:new_piiink/constants/pref_key.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/connectivity/cubit/internet_cubit.dart';
import 'package:new_piiink/features/home_page/widget/new_merchant.dart';
import '../../../common/widgets/empty_data.dart';
import '../../../models/response/category_list_res.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../connectivity/screens/connectivity_screen.dart';
import '../../home_page/bloc/category_blocs.dart';
import '../../home_page/bloc/category_events.dart';
import '../../home_page/bloc/category_states.dart';
import '../../home_page/widget/tab_container.dart';
import '../bloc/merchant_bloc.dart';
import 'package:new_piiink/generated/l10n.dart';

class MerchantScreen extends StatefulWidget {
  static const String routeName = '/merchant-screen';
  const MerchantScreen({super.key});

  @override
  State<MerchantScreen> createState() => _MerchantScreenState();
}

class _MerchantScreenState extends State<MerchantScreen> {
  // For the refresh Indicator
  final GlobalKey<RefreshIndicatorState> refreshIndicatorMerchant =
      GlobalKey<RefreshIndicatorState>();
  // For reading the country ID and countryName
  String? counName;
  String? counID;
  int reloadValue = 0;

  gettingLocation() async {
    counName = await Pref().readData(key: userChosenCountryStateName);
    // counName = await Pref().readData(key: userChosenLocationName);
    counID = await Pref().readData(key: userChosenLocationID);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context
          .read<CategoryBloc>()
          .add(LoadCategoryEvent(AppVariables.selectedLanguageNow));
      await gettingLocation();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    ConnectivityCubit().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MerchantBloc(),
        ),
      ],
      child: Scaffold(
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
                    // Location
                    InkWell(
                      onTap: () {
                        context
                            .pushNamed('location')
                            .then((value) => setState(() {
                                  gettingLocation();
                                }));
                      },
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: GlobalColors.appColor,
                              ),
                              AutoSizeText(
                                counName ?? '...',
                                style: textStyle15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Search For Merchants
                GestureDetector(
                  onTap: () {
                    context.pushNamed('search-merchant').then((value) {
                      if (value == true) {
                        reloadValue++;
                      }
                    });
                  },
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            color:
                                GlobalColors.appColor.withValues(alpha: 0.5)),
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
        body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
          builder: (context, state) {
            if (state == ConnectivityState.loading) {
              return const NoInternetLoader();
            } else if (state == ConnectivityState.disconnected) {
              return const NoConnectivityScreen();
            } else if (state == ConnectivityState.connected) {
              return RefreshIndicator(
                key: refreshIndicatorMerchant,
                color: GlobalColors.appColor,
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                  if (!mounted) return;
                  context
                      .read<CategoryBloc>()
                      .add(LoadCategoryEvent(AppVariables.selectedLanguageNow));
                  setState(() {
                    reloadValue++;
                  });
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: AutoSizeText(
                              S.of(context).whatAreYouLookingFor,
                              style: topicStyle,
                            ),
                          ),
                          const SizedBox(height: 15),
                          BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryLoadingState) {
                                return SizedBox(
                                  height: 125,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      separatorBuilder: (context, index) {
                                        return const SizedBox(width: 20);
                                      },
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return const TabContainer(
                                            icon: '', text: '...');
                                      }),
                                );
                              } else if (state is CategoryLoadedState) {
                                CategoryListResModel categoryList =
                                    state.categoryList;
                                return SizedBox(
                                  height: categoryList.data!.data!.isEmpty
                                      ? 50
                                      : 125,
                                  child: categoryList.data!.data!.isEmpty
                                      ? EmptyData(
                                          text: S.of(context).noCategoryFound)
                                      : ListView.separated(
                                          scrollDirection: Axis.horizontal,
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          separatorBuilder: (context, index) {
                                            return const SizedBox(width: 20);
                                          },
                                          itemCount:
                                              categoryList.data!.data!.length,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                context.pushNamed(
                                                    'category-screen',
                                                    pathParameters: {
                                                      // 'categoryName': categoryList
                                                      //     .data!.data![index].name!,
                                                      'parentId': categoryList
                                                          .data!.data![index].id
                                                          .toString(),
                                                    }).then((value) {
                                                  if (value == true) {
                                                    setState(() {
                                                      reloadValue++;
                                                    });
                                                  }
                                                });
                                              },
                                              child: TabContainer(
                                                icon: categoryList.data!
                                                    .data![index].imageName!,
                                                text: categoryList
                                                    .data!.data![index].name!,
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
                          ),
                          NewMerchant(key: ValueKey(reloadValue)),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    BlocBuilder<MerchantBloc, MerchantState>(
                      builder: (context, state) {
                        if (state is FavoriteLoadingState) {
                          return Positioned(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                color: GlobalColors.gray.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const CustomAllLoader1(),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
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
}
