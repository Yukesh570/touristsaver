import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_piiink/constants/decimal_remove.dart';
import 'package:new_piiink/constants/global_colors.dart';
import 'package:new_piiink/models/response/get_all_discount.dart';

class DayTimeDis extends StatelessWidget {
  final int itemCount;
  final List<Day> day;
  final String dayText;
  const DayTimeDis({
    super.key,
    required this.itemCount,
    required this.day,
    required this.dayText,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: itemCount,
      itemBuilder: (context, index) {
        String? startTime = day[index].start.toString() == '0'
            ? '12 AM'
            : day[index].start.toString() == '1'
                ? '1 AM'
                : day[index].start.toString() == '2'
                    ? '2 AM'
                    : day[index].start.toString() == '3'
                        ? '3 AM'
                        : day[index].start.toString() == '4'
                            ? '4 AM'
                            : day[index].start.toString() == '5'
                                ? '5 AM'
                                : day[index].start.toString() == '6'
                                    ? '6 AM'
                                    : day[index].start.toString() == '7'
                                        ? '7 AM'
                                        : day[index].start.toString() == '8'
                                            ? '8 AM'
                                            : day[index].start.toString() == '9'
                                                ? '9 AM'
                                                : day[index].start.toString() ==
                                                        '10'
                                                    ? '10 AM'
                                                    : day[index]
                                                                .start
                                                                .toString() ==
                                                            '11'
                                                        ? '11 AM'
                                                        : day[index]
                                                                    .start
                                                                    .toString() ==
                                                                '12'
                                                            ? '12 PM'
                                                            : day[index]
                                                                        .start
                                                                        .toString() ==
                                                                    '13'
                                                                ? '1 PM'
                                                                : day[index]
                                                                            .start
                                                                            .toString() ==
                                                                        '14'
                                                                    ? '2 PM'
                                                                    : day[index].start.toString() ==
                                                                            '15'
                                                                        ? '3 PM'
                                                                        : day[index].start.toString() ==
                                                                                '16'
                                                                            ? '4 PM'
                                                                            : day[index].start.toString() == '17'
                                                                                ? '5 PM'
                                                                                : day[index].start.toString() == '18'
                                                                                    ? '6 PM'
                                                                                    : day[index].start.toString() == '19'
                                                                                        ? '7 PM'
                                                                                        : day[index].start.toString() == '20'
                                                                                            ? '8 PM'
                                                                                            : day[index].start.toString() == '21'
                                                                                                ? '9 PM'
                                                                                                : day[index].start.toString() == '22'
                                                                                                    ? '10 PM'
                                                                                                    : day[index].start.toString() == '23'
                                                                                                        ? '11 PM'
                                                                                                        : '12 AM';

        String? endTime = day[index].end.toString() == '0'
            ? '12 AM'
            : day[index].end.toString() == '1'
                ? '1 AM'
                : day[index].end.toString() == '2'
                    ? '2 AM'
                    : day[index].end.toString() == '3'
                        ? '3 AM'
                        : day[index].end.toString() == '4'
                            ? '4 AM'
                            : day[index].end.toString() == '5'
                                ? '5 AM'
                                : day[index].end.toString() == '6'
                                    ? '6 AM'
                                    : day[index].end.toString() == '7'
                                        ? '7 AM'
                                        : day[index].end.toString() == '8'
                                            ? '8 AM'
                                            : day[index].end.toString() == '9'
                                                ? '9 AM'
                                                : day[index].end.toString() ==
                                                        '10'
                                                    ? '10 AM'
                                                    : day[index]
                                                                .end
                                                                .toString() ==
                                                            '11'
                                                        ? '11 AM'
                                                        : day[index]
                                                                    .end
                                                                    .toString() ==
                                                                '12'
                                                            ? '12 PM'
                                                            : day[index]
                                                                        .end
                                                                        .toString() ==
                                                                    '13'
                                                                ? '1 PM'
                                                                : day[index]
                                                                            .end
                                                                            .toString() ==
                                                                        '14'
                                                                    ? '2 PM'
                                                                    : day[index].end.toString() ==
                                                                            '15'
                                                                        ? '3 PM'
                                                                        : day[index].end.toString() ==
                                                                                '16'
                                                                            ? '4 PM'
                                                                            : day[index].end.toString() == '17'
                                                                                ? '5 PM'
                                                                                : day[index].end.toString() == '18'
                                                                                    ? '6 PM'
                                                                                    : day[index].end.toString() == '19'
                                                                                        ? '7 PM'
                                                                                        : day[index].end.toString() == '20'
                                                                                            ? '8 PM'
                                                                                            : day[index].end.toString() == '21'
                                                                                                ? '9 PM'
                                                                                                : day[index].end.toString() == '22'
                                                                                                    ? '10 PM'
                                                                                                    : day[index].end.toString() == '23'
                                                                                                        ? '11 PM'
                                                                                                        : '12 AM';

        return Center(
          child: Container(
            height: 60.h,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
                color: GlobalColors.appWhiteBackgroundColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  )
                ]),
            child: Row(
              children: [
                // Day
                AutoSizeText(
                  dayText,
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),

                startTime == endTime
                    ? AutoSizeText(
                        // '(${S.of(context).allDay})',
                        '(All Day)',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoSizeText(
                            startTime,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          AutoSizeText(
                            ' -',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                          AutoSizeText(
                            endTime,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),

                const Spacer(),

                AutoSizeText(
                  '${removeTrailingZero(day[index].discount.toString())}%',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
