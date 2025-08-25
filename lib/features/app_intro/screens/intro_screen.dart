import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/generated/l10n.dart';

class IntroScreen extends StatelessWidget {
  static const String routeName = '/intro-screen';
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 80.h),
        decoration: BoxDecoration(
            color: GlobalColors.appWhiteBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(2, 2))
            ]),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: IntroductionScreen(
            globalBackgroundColor: GlobalColors.appWhiteBackgroundColor,
            pages: [
              // First
              PageViewModel(
                title: S.of(context).welcomeToTouristSaver,
                // 'Welcome to Piiink',
                body: S
                    .of(context)
                    .theMostInnovativeCommunityLifestyleProgramForYourEverydayShopping,
                // 'The most innovative Community Lifestyle Program for your everyday shopping.',
                image: piiinkBuildImage("assets/images/tourist.png", context),
                //getPageDecoration, a method to customise the page style
                decoration: getPageDecoration(),
              ),
              // //  Second
              // PageViewModel(
              //   title: S.of(context).goShopping,
              //   //'Go shopping',
              //   body:
              //       S.of(context).shopAtTouristSaverMerchantsAndGetGreatOffers,
              //   // 'Shop at Piiink merchants and get great offers.',
              //   image: buildImage("assets/images/shopping-bag.png", context),
              //   decoration: getPageDecoration(),
              // ),
              // // Third
              // PageViewModel(
              //   title: S.of(context).donateToCharity,
              //   // 'Donate to charity',
              //   body: S
              //       .of(context)
              //       .fromEveryTransactionCashGoesToYourNominatedCharity,
              //   //  'From every transaction, cash goes to your nominated charity.',
              //   image: buildImage("assets/images/charity.png", context),
              //   decoration: getPageDecoration(),
              // ),
            ],
            // onDone
            onDone: () {
              // if (kDebugMode) {
              //   print("Done Clicked");
              context.pushReplacementNamed(
                'first-choose-country',
              );
              // }
            },
            //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
            // scrollPhysics: const ClampingScrollPhysics(),

            // Done
            showDoneButton: true,
            done: Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: GlobalColors.appColor1,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: AutoSizeText(
                  S.of(context).continueL,
                  // 'Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Next
            showNextButton: true,
            next: Container(
              height: 35.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: GlobalColors.appColor1,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: AutoSizeText(
                  S.of(context).next,
                  // 'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Skip
            showSkipButton: true,
            skip: AutoSizeText(S.of(context).skip,
                //'Skip',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: GlobalColors.textColor,
                    fontSize: 15.sp)),
            // isBottomSafeArea: true,
            // dotsDecorator: getDotsDecorator(),
          ),
        ),
      ),
    );
  }

  // Widget to add the image on intro screen
  Widget piiinkBuildImage(String imagePath, context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 1.9,
      width: 200.w,
      // height: 250.h,
      color: Colors.white,
      child: Image.asset(imagePath, fit: BoxFit.fill),
    );
  }

  // Widget to add the image on intro screen
  Widget buildImage(String imagePath, context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 1.9,
      width: 100.w,
      // height: 250.h,
      color: Colors.white,
      child: Image.asset(imagePath, fit: BoxFit.fill),
    );
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return PageDecoration(
      imagePadding: const EdgeInsets.only(top: 50),
      titleTextStyle: TextStyle(
          color: GlobalColors.textColor,
          fontSize: 23.sp,
          fontWeight: FontWeight.bold),
      bodyPadding:
          const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 10),
      bodyTextStyle: TextStyle(
          color: GlobalColors.textColor,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600),
    );
  }

  //method to customize the dots style
}
