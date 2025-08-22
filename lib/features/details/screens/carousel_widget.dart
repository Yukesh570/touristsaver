import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/custom_loader.dart';
import '../../../constants/global_colors.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key, required this.imageList});

  final List<dynamic> imageList;

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int currentIndex = 0;

  showImageDialog(String i) {
    return showGeneralDialog(
      barrierLabel: 'Label',
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.vertical,
            onDismissed: (_) => context.pop(),
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1.05,
                child: CachedNetworkImage(
                  imageUrl: i,
                  fit: BoxFit.contain,
                  placeholder: (context, url) {
                    return const Center(child: CustomAllLoader1());
                  },
                  errorWidget: (context, url, error) =>
                      Center(child: Image.asset('assets/images/no_image.jpg')),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1.04,
          height: 180.h,
          padding: const EdgeInsets.symmetric(vertical: 10),
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
          child: widget.imageList.isEmpty
              ? Image.asset(
                  'assets/images/no_image.jpg',
                  fit: BoxFit.contain,
                )
              : CarouselSlider(
                  options: CarouselOptions(
                    height: 180.h,
                    autoPlay: true,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.95,
                    onPageChanged: (index, ok) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  items: widget.imageList.map<Widget>((i) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: GestureDetector(
                          onTap: () {
                            showImageDialog(i);
                          },
                          child: CachedNetworkImage(
                            imageUrl: i,
                            fit: BoxFit.fitHeight,
                            placeholder: (context, url) {
                              return const Center(
                                  child: FittedBox(child: CustomAllLoader1()));
                            },
                            errorWidget: (context, url, error) => Center(
                                child:
                                    Image.asset('assets/images/no_image.jpg')),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),

        //Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageList.map<Widget>(
            (image) {
              int index = widget.imageList.indexOf(image);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.only(top: 10.0, left: 2.0, right: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? GlobalColors.appColor
                      : GlobalColors.appColor1,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}
