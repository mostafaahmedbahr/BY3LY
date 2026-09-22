import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
 import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/app_colors/app_colors.dart';

//ignore: must_be_immutable
class CustomSlider extends StatelessWidget {
    CustomSlider({Key? key,
 //   this.carouselController,
      this.itemCount,
      this.imageUrl,
      this.activeIndex,
      this.onPageChanged,
      this.count,
      this.height,
    }) : super(key: key);
 // CarouselController? carouselController;
    int? itemCount;
  String? imageUrl;
  dynamic Function(int, CarouselPageChangedReason)? onPageChanged;
  int? activeIndex;
  int? count;
  double? height;
  @override
  Widget build(BuildContext context) {
    return   Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
         // carouselController: carouselController,
          itemCount: itemCount,
          itemBuilder: (context,index,realIndex)
          {
            return   ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                //imageUrl: imageUrl![index] ,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(
                  color: AppColors.whiteColor,
                )),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            );
          },
          options: CarouselOptions(
            initialPage: 0,
            height: height ?? 250,
            autoPlay: true,
            reverse: true,
            viewportFraction: 1,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            pageSnapping: true,
            onPageChanged: onPageChanged,
          ),
        ),
        Positioned(
          bottom: 20,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex!,
            count:count!,
            effect: SlideEffect(
              dotWidth: 10,
              dotHeight: 10,
              activeDotColor: AppColors.yellowColor,
              dotColor: Colors.grey.withOpacity(0.4),
            ),
          ),
        ),
      ],
    );
  }
}
