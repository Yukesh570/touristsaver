import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:new_piiink/common/widgets/custom_app_bar.dart';
import 'package:new_piiink/common/widgets/custom_button.dart';
import 'package:new_piiink/constants/decimal_remove.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/constants/number_formatter.dart';
import 'package:new_piiink/constants/style.dart';

import '../app_variables.dart';
import 'package:new_piiink/generated/l10n.dart';

class CongratsScreen extends StatefulWidget {
  static const String routeName = '/congrats-screen';
  final String piiinkCredit;

  const CongratsScreen({super.key, required this.piiinkCredit});

  @override
  State<CongratsScreen> createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {
  @override
  Widget build(BuildContext context) {
    List arr = S.of(context).congratulationNowYouHaveXPiiinks.split(" ");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(text: S.of(context).registrationCompleted),
      ),
      body: Container(
        height: 320,
        width: MediaQuery.of(context).size.width / 1,
        margin: const EdgeInsets.all(10.0),
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
          children: [
            const SizedBox(height: 15),
            // Congratulation
            AutoSizeText(
              S.of(context).congratulations,
              style: topicStyle,
            ),
            const SizedBox(height: 25),
            FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var item in arr)
                      if (item.indexOf('&X') != -1)
                        AutoSizeText(
                          ' $item '.replaceAll(
                              '&X',
                              removeTrailingZero(numFormatter
                                  .format(double.parse(widget.piiinkCredit)))),
                          style: transactionTextStyle.copyWith(
                              color: GlobalColors.appColor),
                        )
                      else
                        AutoSizeText(
                          ' $item'.replaceAll(
                              '&X',
                              removeTrailingZero(numFormatter
                                  .format(double.parse(widget.piiinkCredit)))),
                          style: transactionTextStyle,
                        ),
                    // Piiink Credit
                    // AutoSizeText.rich(
                    //   TextSpan(
                    //     text: 'You now have ',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w500,
                    //         fontSize: 18.sp,
                    //         decoration: TextDecoration.none,
                    //         color: Colors.black,
                    //         fontFamily: 'Sans'),
                    //     children: [
                    //       TextSpan(
                    //         text: widget.piiinkCredit,
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 18.sp,
                    //             decoration: TextDecoration.none,
                    //             color: GlobalColors.appColor,
                    //             fontFamily: 'Sans'),
                    //       ),
                    //       TextSpan(
                    //         text: ' Piiink Credits',
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w500,
                    //             fontSize: 18.sp,
                    //             decoration: TextDecoration.none,
                    //             color: Colors.black,
                    //             fontFamily: 'Sans'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Text(
                    //   'You now have ${piiinkCredit} Piiink Credits',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.w500,
                    //       fontSize: 18.sp,
                    //       decoration: TextDecoration.none,
                    //       color: Colors.black,
                    //       fontFamily: 'Sans'),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Image
            Image.asset(
              'assets/images/saving-approved.png',
              height: 100,
              filterQuality: FilterQuality.high,
            ),

            const SizedBox(height: 25),

            CustomButton(
              text: S.of(context).continueL,
              onPressed: () {
                AppVariables.initNotifications = true;
                context.pushReplacementNamed('bottom-bar',
                    pathParameters: {'page': '3'});
              },
            )
          ],
        ),
      ),
    );
  }
}
