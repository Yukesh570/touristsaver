// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/no_merchant.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/home_page/services/home_dio.dart';
import 'package:new_piiink/models/response/search_merchant_res.dart';
import '../../../common/app_variables.dart';
import 'package:new_piiink/generated/l10n.dart';

import '../../../common/widgets/error.dart';

class SearchMerchant extends StatefulWidget {
  static const String routeName = '/search-merchant';
  const SearchMerchant({super.key});

  @override
  State<SearchMerchant> createState() => _SearchMerchantState();
}

class _SearchMerchantState extends State<SearchMerchant> {
  final searchKey = GlobalKey<FormState>();
  // bool isSearching = false;
  String searchText = '';
  //For page Loading part
  bool isSearchedChanged = false;
  String? err;
  bool recallMerchantApi = false;
  bool locationPinClicked = false;

  Future<SearchMerchantResModel?>? listOfMerchantAndCategory;
  Future<SearchMerchantResModel?> getSearchMerchantAndCategory() async {
    SearchMerchantResModel? searchMerchantResModel =
        await DioHome().getSearched(name: searchText);

    return searchMerchantResModel;
  }

  loadSearchedList() async {
    if (!mounted) return;
    setState(() {
      isSearchedChanged = true;
    });
    try {
      listOfMerchantAndCategory = getSearchMerchantAndCategory();
    } catch (e) {
      if (kDebugMode) {
        err = S.of(context).somethingWentWrong;
      }
    }
    setState(() {
      if (!mounted) return;
      isSearchedChanged = false;
    });
  }

// Declare the Timer
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(recallMerchantApi);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                color: GlobalColors.appGreyBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(2, 2))
                ]),
          ),
          elevation: 0.0,
          leading: InkWell(
              onTap: () {
                context.pop(recallMerchantApi);
              },
              child: const Icon(Icons.arrow_back_ios)),
          // automaticallyImplyLeading: false, //To remove the leading icon
          title: appBarSearch(),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: searchCategoryAndMerchant(),
          ),
        ),
      ),
    );
  }

  //AppBar Serach Section
  appBarSearch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Search Container
        Expanded(
          flex: 7,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            height: 35,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: GlobalColors.appColor.withValues(alpha: 0.5))),
            child: Row(
              children: [
                const SizedBox(width: 5),
                Icon(
                  Icons.search,
                  size: 25,
                  color: GlobalColors.gray.withValues(alpha: 0.7),
                ),
                // TextFormField
                Form(
                  key: searchKey,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.8,
                    child: TextFormField(
                      // controller: searchController,
                      autofocus: true,
                      cursorColor: GlobalColors.appColor,
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(11.0, 0.0, 11.0, 0.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.r),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          hintText:
                              S.of(context).searchForMerchantsCategoryLocation,
                          hintStyle: searchStyle,
                          suffixIcon: InkWell(
                              onTap: () {
                                // isSearching = false;
                                searchText = '';
                                err = null;
                                FocusManager.instance.primaryFocus?.unfocus();
                                context.pop(recallMerchantApi);
                              },
                              child: const Icon(Icons.clear)),
                          suffixIconColor: GlobalColors.appColor),
                      onChanged: (value) async {
                        searchText = value.trim();
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 500), () {
                          err = null;
                          if (value.trim().length >= 3) {
                            loadSearchedList();
                          } else {
                            setState(() {
                              // isSearching = false;
                              searchText = '';
                            });
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 3),
        // LocationPinClicked
        Expanded(
          flex: 1,
          child: GestureDetector(
              onTap: () {
                // locationPinClicked = true;
                context.pushNamed('location-search-merchant').then((value) {
                  if (AppVariables.locationEnabledStatus.value > 1 &&
                      value == true) {
                    AppVariables.locationEnabledStatus.value += 1;
                  }
                });
              },
              child: const Icon(Icons.pin_drop)),
        ),
      ],
    );
  }

  searchCategoryAndMerchant() {
    return searchText.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<SearchMerchantResModel?>(
                future: listOfMerchantAndCategory,
                builder: (context, state) {
                  if (state.hasError) {
                    return const Error1();
                  } else if (!state.hasData) {
                    return const Center(child: CustomAllLoader());
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          searchText.isEmpty
                              ? ''
                              : S.of(context).merchantCategories,
                          style: viewAllStyle,
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },

                          itemCount: state.data!.merchantCategories!.isEmpty
                              ? 1
                              : state.data!.merchantCategories!.length,
                          //  searchResultMerCat.isEmpty ? 1 : searchResultMerCat.length,
                          itemBuilder: (context, index) {
                            return state.data!.merchantCategories!.isEmpty
                                ? NoMerchantCard(
                                    text: S.of(context).noMerchantCategory)
                                : InkWell(
                                    borderRadius: BorderRadius.circular(5.0),
                                    onTap: () {
                                      context.pushNamed('category-screen',
                                          pathParameters: {
                                            //  'categoryName': searchResultMerCat[index].name!,
                                            'parentId': state.data!
                                                .merchantCategories![index].id
                                                .toString(),
                                          }).then((value) {
                                        if (value == true) {
                                          if (recallMerchantApi == false) {
                                            recallMerchantApi = true;
                                          }
                                          loadSearchedList();
                                        }
                                      });
                                    },
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 55,
                                      child: ListTile(
                                        tileColor: GlobalColors
                                            .appWhiteBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3.0),
                                          // Text Name
                                          child: AutoSizeText(
                                            // searchResultMerCat
                                            state
                                                .data!
                                                .merchantCategories![index]
                                                .name!,
                                            style: profileListStyle,
                                          ),
                                        ),

                                        // Arrow
                                        trailing: const Padding(
                                          padding: EdgeInsets.only(top: 3.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 21,
                                            color: GlobalColors.appColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          searchText.isEmpty ? '' : S.of(context).merchant,
                          style: viewAllStyle,
                        ),
                        const SizedBox(height: 10),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 10);
                          },
                          itemCount: state.data!.merchants!.isEmpty
                              ? 1
                              : state.data!.merchants!.length,
                          // searchResultMer.isEmpty ? 1 : searchResultMer.length,
                          itemBuilder: (context, index) {
                            return state.data!.merchants!.isEmpty
                                ? const NoMerchantCard()
                                : InkWell(
                                    borderRadius: BorderRadius.circular(5.0),
                                    onTap: () {
                                      context
                                          .pushNamed('details-screen', extra: {
                                        'merchantID': state
                                            .data!.merchants![index].id
                                            .toString(),
                                      }).then((value) {
                                        if (value == true) {
                                          if (recallMerchantApi == false) {
                                            recallMerchantApi = true;
                                          }
                                          loadSearchedList();
                                        }
                                      });
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      constraints: const BoxConstraints(
                                        maxHeight: double.infinity,
                                      ),
                                      child: ListTile(
                                        tileColor: GlobalColors
                                            .appWhiteBackgroundColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        title: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3.0),
                                          // Text Name
                                          child: AutoSizeText(
                                            // searchResultMer
                                            state.data!.merchants![index]
                                                .merchantName!,
                                            style: profileListStyle,
                                          ),
                                        ),

                                        // Arrow
                                        trailing: const Padding(
                                          padding: EdgeInsets.only(top: 3.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 21,
                                            color: GlobalColors.appColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          );
  }
}
