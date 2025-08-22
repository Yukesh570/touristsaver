import 'package:flutter/material.dart';

import '../../constants/global_colors.dart';

class CustomContainerBox extends StatelessWidget {
  final double? width;
  final Widget? child;
  final Color? color;
  final double? padVer;
  final double? padHorizon;
  final double? marginVer;
  final double? marginHorizon;
  const CustomContainerBox({
    super.key,
    this.width,
    this.child,
    this.color,
    this.padVer,
    this.padHorizon,
    this.marginVer,
    this.marginHorizon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.of(context).size.width,
      constraints: const BoxConstraints(
        //To make height expandable according to the text
        maxHeight: double.infinity,
      ),
      padding: EdgeInsets.symmetric(
          vertical: padVer ?? 40, horizontal: padHorizon ?? 10),
      margin: EdgeInsets.symmetric(
          vertical: marginVer ?? 10, horizontal: marginHorizon ?? 10),
      decoration: BoxDecoration(
          color: color ?? GlobalColors.appWhiteBackgroundColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 4,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            )
          ]),
      child: child,
    );
  }
}
