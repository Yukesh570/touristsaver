import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../../common/widgets/custom_container_box.dart';
import '../../../constants/global_colors.dart';
import '../../../constants/style.dart';

class CustomHorizontalTable extends StatelessWidget {
  final double leftHandSideColumnWidth;
  final double rightHandSideColumnWidth;
  final List<Widget>? headerWidgets;

  final int itemCount;
  final Widget Function(BuildContext context, int) leftSideItemBuilder;
  final Widget Function(BuildContext context, int) rightSideItemBuilder;
  final ScrollPhysics? scrollPhysics;
  const CustomHorizontalTable({
    super.key,
    required this.leftHandSideColumnWidth,
    required this.rightHandSideColumnWidth,
    required this.headerWidgets,
    required this.itemCount,
    required this.leftSideItemBuilder,
    required this.rightSideItemBuilder,
    required this.scrollPhysics,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: Expanded(
        child: CustomContainerBox(
          padVer: 0,
          padHorizon: 0,
          child: HorizontalDataTable(
            scrollPhysics: scrollPhysics,
            leftHandSideColBackgroundColor: Colors.transparent,
            rightHandSideColBackgroundColor: Colors.transparent,
            leftHandSideColumnWidth: leftHandSideColumnWidth,
            rightHandSideColumnWidth: rightHandSideColumnWidth,
            isFixedHeader: true,

            headerWidgets: headerWidgets,
            // rowSeparatorWidget: const Divider(
            //   color: GlobalColors.gray,
            //   height: 1,
            //   thickness: 1,
            // ),
            elevation: 0.0,
            verticalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: false,
              thickness: 0.0,
            ),
            horizontalScrollbarStyle: const ScrollbarStyle(
              isAlwaysShown: false,
              thickness: 0.0,
            ),

            itemCount: itemCount,
            leftSideItemBuilder: leftSideItemBuilder,
            rightSideItemBuilder: rightSideItemBuilder,
          ),
        ),
      ),
    );
  }
}

class TableHeader extends StatelessWidget {
  final String? label;
  final Color? color;
  final double? width;
  const TableHeader({super.key, this.label, this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? GlobalColors.appColor1,
      width: width ?? 75.w,
      height: 60,
      padding: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            label ?? '',
            style: tableHeaderTextStyle.copyWith(
                overflow: TextOverflow.ellipsis,
                color: GlobalColors.appWhiteBackgroundColor),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class TableBody extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Color? color;
  final int sendIndex;
  final TextStyle? style;
  const TableBody(
      {super.key,
      required this.text,
      this.width,
      this.height,
      this.alignment,
      this.color,
      required this.sendIndex,
      this.style});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: sendIndex % 2 == 0
          ? GlobalColors.appGreyBackgroundColor
          : GlobalColors.appColor1.withValues(alpha: 0.2),
      width: width ?? 75.w,
      height: height ?? 40.h,
      alignment: alignment ?? Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 10),
      child: Text(
        text,
        style: style ?? tableBodyTextStyle,
      ),
    );
  }
}
