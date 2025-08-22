import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/services/dio_common.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/common/widgets/custom_loader.dart';
import 'package:new_piiink/common/widgets/custom_snackbar.dart';
import 'package:new_piiink/common/widgets/error.dart' as error_widget;
import 'package:new_piiink/common/widgets/not_available.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/pref.dart';
import 'package:new_piiink/constants/pref_key.dart';
import 'package:new_piiink/constants/style.dart';
import 'package:new_piiink/features/connectivity/cubit/internet_cubit.dart';
import 'package:new_piiink/features/location/services/dio_location.dart';
import 'package:new_piiink/features/profile/services/dio_membership.dart';
import 'package:new_piiink/features/recommend/services/dio_recommend.dart';
import 'package:new_piiink/models/error_res.dart';
import 'package:new_piiink/models/request/recommend_mer_req.dart';
import 'package:new_piiink/models/response/piiink_info_res.dart';
import 'package:new_piiink/models/response/recommend_mer_res.dart';
import 'package:new_piiink/models/response/state_get_all.dart';

import '../../../common/widgets/dropdown_button_widget.dart';
import '../../../models/response/common_res.dart';
import '../../../models/response/location_get_all.dart';
import '../../connectivity/screens/connectivity.dart';
import '../../connectivity/screens/connectivity_screen.dart';
import '../../profile/services/dio_profile.dart';
import 'package:new_piiink/generated/l10n.dart';

class RecommendScreen extends StatefulWidget {
  static const String routeName = "/recommend";
  const RecommendScreen({super.key});

  @override
  State<RecommendScreen> createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  final recommendKey = GlobalKey<FormState>();
  // Merchant Info
  TextEditingController merchantNameController = TextEditingController();
  TextEditingController merchantEmailController = TextEditingController();
  TextEditingController merchantNumberController = TextEditingController();
  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  // Contact Info
  // TextEditingController contactPersonFirstNameController =
  //     TextEditingController();
  // TextEditingController contactPersonLastNameController =
  //     TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController cityController = TextEditingController();
  // TextEditingController usernameController = TextEditingController();
  // TextEditingController phoneNumberController = TextEditingController();
  TextEditingController countrySearchController = TextEditingController();
  TextEditingController stateSearchController = TextEditingController();
  bool isSending = false;
  bool? isEmailVerified;

  // For dropDown of selecting country
  String? selectedCountry;
  int? selectedCountryID;
  Future<LocationGetAllResModel?>? countryList;
  Future<LocationGetAllResModel?> getLocations() async {
    LocationGetAllResModel? locationGetAllResModel =
        await DioLocation().getAllLocation();
    return locationGetAllResModel;
  }

  // For dropDown of selecting state
  String? selectedState;
  int? selectedStateID;
  Future<StateGetAllResModel?>? stateList;
  Future<StateGetAllResModel?> getState() async {
    StateGetAllResModel? stateGetAllResModel =
        await DioLocation().getAllState(countryID: selectedCountryID!.toInt());
    setState(() {
      iscountryChanged = false;
    });
    return stateGetAllResModel;
  }

  //Getting Country ID and Member ID
  int? countryId;
  int? memberId;

  //For stopping selection of state when country is changed
  bool iscountryChanged = false;

  getCountryMemID() async {
    countryId = int.parse(await Pref().readData(key: saveCountryID));
    memberId = int.parse(await Pref().readData(key: saveUserID));
  }

  //To control the showing of recommend merchant form
  Future<PiiinkInfoResModel?>? displayOrNot;
  Future<PiiinkInfoResModel?> getDisplayOrNot() async {
    PiiinkInfoResModel? piiinkInfoResModel = await DioCommon().piiinkInfo();
    isEmailVerified = await getUserProfile();
    return piiinkInfoResModel;
  }

  Future<bool?> getUserProfile() async {
    final userProfile = await DioMemberShip().getUserProfile();
    return userProfile?.data?.results?.isEmailVerified;
  }

  @override
  void initState() {
    countryList = getLocations();
    displayOrNot = getDisplayOrNot();
    getCountryMemID();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          text: S.of(context).recommend,
          icon: Icons.arrow_back_ios,
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<ConnectivityCubit, ConnectivityState>(
        builder: (context, state) {
          if (state == ConnectivityState.loading) {
            return const NoInternetLoader();
          } else if (state == ConnectivityState.disconnected) {
            return const NoConnectivityScreen();
          } else if (state == ConnectivityState.connected) {
            return SingleChildScrollView(
              child: FutureBuilder<PiiinkInfoResModel?>(
                  future: displayOrNot,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const error_widget.Error();
                    } else if (!snapshot.hasData) {
                      return const CustomAllLoader();
                    } else {
                      return snapshot.data?.data?.hideReferredMerchantInApp ==
                              false
                          ? isEmailVerified == true
                              ? recommendFormScreen()
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color:
                                          GlobalColors.appWhiteBackgroundColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey
                                              .withValues(alpha: 0.2),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                          offset: const Offset(2, 2),
                                        )
                                      ]),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      AutoSizeText(
                                        S.of(context).verifyEmail,
                                        style: topicStyle,
                                      ),
                                      const SizedBox(height: 15),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50.0),
                                        child: AutoSizeText(
                                          S
                                              .of(context)
                                              .yourEmailIsNotActivatedYetNPleaseVerifyYourEmailBeforeRecommendingMerchants,
                                          textAlign: TextAlign.center,
                                          style: textStyle15.copyWith(
                                              fontSize: 18.sp),
                                        ),
                                      ),
                                      const SizedBox(height: 50),
                                      SizedBox(
                                        child: Image.asset(
                                          "assets/images/mail.png",
                                          height: 130.h,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                      const SizedBox(height: 40),
                                      isSending
                                          ? const CustomButtonWithCircular()
                                          : CustomButton(
                                              text: S.of(context).verifyNow,
                                              onPressed: () async {
                                                setState(() {
                                                  isSending = true;
                                                });
                                                var result = await DioProfile()
                                                    .verifyEmail();
                                                if (!mounted) return;
                                                if (result is CommonResModel) {
                                                  context.pop();
                                                  if (result.status ==
                                                      'Success') {
                                                    GlobalSnackBar.showSuccess(
                                                        context,
                                                        result.message ??
                                                            S
                                                                .of(context)
                                                                .verificationLinkSentSuccessfully);
                                                  }
                                                } else if (result
                                                    is ErrorResModel) {
                                                  setState(() {
                                                    isSending = false;
                                                  });
                                                  GlobalSnackBar.showError(
                                                      context,
                                                      result.message ??
                                                          S
                                                              .of(context)
                                                              .someErrorOccurred);
                                                } else {
                                                  setState(() {
                                                    isSending = false;
                                                  });
                                                  GlobalSnackBar.showError(
                                                      context,
                                                      S
                                                          .of(context)
                                                          .someErrorOccurred);
                                                }
                                              },
                                            ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                )
                          : comingSoon();
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

  //Showing Recommend Screen
  recommendFormScreen() {
    return Form(
      key: recommendKey,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        constraints: const BoxConstraints(
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
            //Merchant Info
            Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                S.of(context).merchantInfo,
                style: appbarTitleStyle,
              ),
            ),

            const SizedBox(height: 15),

            // Merchant Name
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: merchantNameController,
                cursorColor: GlobalColors.appColor,
                decoration: textInputDecoration1.copyWith(
                    hintText: S.of(context).merchantName),
              ),
            ),

            const SizedBox(height: 15),
            // Select Country
            selectCountry(),
            const SizedBox(height: 15),
            // Merchant State
            selectState(),

            const SizedBox(height: 15),

            // Merchant Email
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: merchantEmailController,
                cursorColor: GlobalColors.appColor,
                decoration: textInputDecoration1.copyWith(
                    hintText: S.of(context).merchantEmail),
              ),
            ),

            const SizedBox(height: 15),

            // Merchant Number
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.2,
              child: TextFormField(
                controller: merchantNumberController,
                cursorColor: GlobalColors.appColor,
                decoration: textInputDecoration1.copyWith(
                    hintText: S.of(context).merchantPhoneNumber),
                keyboardType: TextInputType.number,
              ),
            ),

            // const SizedBox(height: 15),

            // //Contact Info
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: AutoSizeText(
            //     'Contact Info',
            //     style: appbarTitleStyle,
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // Name of Contact person First Name
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: contactPersonFirstNameController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration: textInputDecoration1.copyWith(
            //         hintText: 'Contact Person First Name *'),
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // Name of Contact person First Name
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: contactPersonLastNameController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration: textInputDecoration1.copyWith(
            //         hintText: 'Contact Person Last Name *'),
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // email
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: emailController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration: textInputDecoration1.copyWith(hintText: 'Email *'),
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // phoneNumber
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: phoneNumberController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration:
            //         textInputDecoration1.copyWith(hintText: 'Phone Number *'),
            //     keyboardType: TextInputType.number,
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // City
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: cityController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration: textInputDecoration1.copyWith(hintText: 'City *'),
            //   ),
            // ),

            // const SizedBox(height: 15),

            // // Username
            // SizedBox(
            //   width: MediaQuery.of(context).size.width / 1.2,
            //   child: TextFormField(
            //     controller: usernameController,
            //     cursorColor: GlobalColors.appColor,
            //     decoration:
            //         textInputDecoration1.copyWith(hintText: 'Username *'),
            //   ),
            // ),

            const SizedBox(height: 20),

            // Send Button
            isSending == true
                ? const CustomButtonWithCircular()
                : CustomButton(
                    text: S.of(context).send,
                    onPressed: () {
                      setState(() {
                        isSending = true;
                      });
                      sendButton();
                    },
                  )
          ],
        ),
      ),
    );
  }

  // Selecting or Changing the Country
  selectCountry() {
    return FutureBuilder<LocationGetAllResModel?>(
        future: countryList,
        builder: (context, snapshot) {
          return DropdownButtonWidget(
            label: S.of(context).selectCountryA.replaceAll("Prefix", ""),
            lPadding: 15,
            searchController: countrySearchController,
            items: snapshot.data?.data!.map((e) {
              return DropdownMenuItem(
                value: e.countryName,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: AutoSizeText(
                    e.countryName!,
                    style: dopdownTextStyle,
                  ),
                ),
              );
            }).toList(),
            onChanged: (newVal) async {
              setState(() {
                selectedCountry = newVal as String;
                selectedState = null;
                iscountryChanged = true;
              });
              final locationID = snapshot.data?.data!.firstWhere(
                  (element) => element.countryName == selectedCountry);
              selectedCountryID = locationID!.id!;
              //calling the state api
              setState(() {
                stateList = getState();
              });
            },
            value: selectedCountry,
          );
        });
  }

  // Selecting or Changing the state
  selectState() {
    return FutureBuilder<StateGetAllResModel?>(
        future: stateList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              padding:
                  const EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0),
              height: 50,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                color: GlobalColors.paleGray,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: AutoSizeText(
                S.of(context).selectStateProvince,
                style: TextStyle(
                    color: GlobalColors.gray.withValues(alpha: 0.8),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
            );
          } else {
            return Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 1.2,
              decoration: BoxDecoration(
                color: GlobalColors.paleGray,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: snapshot.data!.data!.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 15, left: 25, right: 25),
                      child: AutoSizeText(
                        S.of(context).noStateAvailable,
                        style:
                            locationStyle.copyWith(fontWeight: FontWeight.w500),
                      ),
                    )
                  : iscountryChanged == true
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 15, left: 25, right: 25),
                          child: AutoSizeText(
                            S.of(context).pleaseWait,
                            style: locationStyle.copyWith(
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      : DropdownButtonWidget(
                          label: S.of(context).selectStateProvince,
                          lPadding: 15,
                          searchController: stateSearchController,
                          items: snapshot.data!.data!.map((e) {
                            return DropdownMenuItem(
                              value: e.stateName,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: AutoSizeText(
                                  e.stateName!,
                                  style: dopdownTextStyle,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (newVal) async {
                            setState(() {
                              selectedState = newVal as String;
                            });
                            final stateID = snapshot.data!.data!.firstWhere(
                                (element) =>
                                    element.stateName == selectedState);
                            selectedStateID = stateID.id;
                          },
                          value: selectedState,
                        ),
            );
          }
        });
  }

  //Send Button
  sendButton() async {
    if (recommendKey.currentState!.validate()) {
      if (merchantNameController.text.isEmpty) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(context, S.of(context).pleaseEnterMerchantName);
        return;
      } else if (selectedCountry == null || selectedCountryID == null) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(context, S.of(context).pleaseSelectCountry);
        return;
      } else if (selectedState == null || selectedStateID == null) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(context, S.of(context).pleaseSelectTheState);
        return;
      } else if (merchantEmailController.text.isNotEmpty &&
          !reg.hasMatch(merchantEmailController.text)) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(
            context, S.of(context).pleaseEnterValidMerchantEmail);
        return;
      } else if (merchantNumberController.text.isEmpty) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(context, S.of(context).pleaseEnterMerchantNumber);
        return;
      } else if (merchantNumberController.text.length < 7) {
        setState(() {
          isSending = false;
        });
        GlobalSnackBar.valid(
            context, S.of(context).phoneNumberShouldBeAtLeast7Digits);
        return;
      }
      // else if (contactPersonFirstNameController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter contact person first name');
      //   return;
      // }
      //else if (contactPersonLastNameController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter contact person last name');
      //   return;
      // } else if (!reg.hasMatch(emailController.text) ||
      //     emailController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter valid email');
      //   return;
      // } else if (phoneNumberController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter phone number');
      //   return;
      // } else if (phoneNumberController.text.length < 7) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(
      //       context, 'Phone number should be at least 7 digits');
      //   return;
      // } else if (cityController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter city');
      //   return;
      // } else if (usernameController.text.isEmpty) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Please enter username');
      //   return;
      // } else if (usernameController.text.trim().length < 6) {
      //   setState(() {
      //     isSending = false;
      //   });
      //   GlobalSnackBar.valid(context, 'Username must be atleast 6 characters.');
      //   return;
      // }
      else {
        var sendRes = await DioRecommend().createRecommedMer(
            recommendMerchantReqModel: RecommendMerchantReqModel(
                merchantName: merchantNameController.text.trim(),
                merchantEmail: merchantEmailController.text.trim().isNotEmpty
                    ? merchantEmailController.text.trim()
                    : " ",
                merchantPhoneNumber: merchantNumberController.text.trim(),
                countryId: selectedCountryID,
                stateId: selectedStateID,
                memberId: memberId,
                username: " ",
                contactPersonFirstName: " ",
                contactPersonLastName: " ",
                phoneNumber: " ",
                email: " ",
                city: " "));
        if (!mounted) return;
        if (sendRes is RecommendMerchantResModel) {
          setState(() {
            isSending = false;
            merchantNameController.clear();
            merchantEmailController.clear();
            merchantNumberController.clear();
            // contactPersonFirstNameController.clear();
            // contactPersonLastNameController.clear();
            // emailController.clear();
            // phoneNumberController.clear();
            // cityController.clear();
            // usernameController.clear();
            selectedState = null;
            selectedStateID = null;
            selectedCountry = null;
            selectedCountryID = null;
          });
          GlobalSnackBar.showSuccess(
              context, S.of(context).merchantRecommendedSuccessfully);
        } else if (sendRes is ErrorResModel) {
          GlobalSnackBar.showError(
              context, sendRes.message ?? S.of(context).serverError);
          setState(() {
            isSending = false;
          });
          return;
        } else {
          setState(() {
            isSending = false;
          });
          GlobalSnackBar.showError(
              context, S.of(context).couldnTRecommendMerchant);
          return;
        }
      }
    }
  }

  //Coming Soon
  comingSoon() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: NotAvailable(
        titleText: S.of(context).comingSoon,
        bodyText: S.of(context).weAreCurrentlyWorkingOnThisWeWillKeepYouUpdated,
      ),
    );
  }

  @override
  void dispose() {
    ConnectivityCubit().close();
    merchantNameController.dispose();
    merchantEmailController.dispose();
    merchantNumberController.dispose();
    // contactPersonFirstNameController.dispose();
    // contactPersonLastNameController.dispose();
    // emailController.dispose();
    // cityController.dispose();
    // usernameController.dispose();
    // phoneNumberController.dispose();
    super.dispose();
  }
}
