import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_states.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({super.key, required this.imageUrls});
  final List<String> imageUrls;

  @override
  State<BannerAds> createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final imageUrls = widget.imageUrls
            .where((u) => u.trim().isNotEmpty)
            .toList();
        if (imageUrls.isEmpty) {
          return const SizedBox.shrink();
        }
        // If only one image, no need for infinite scroll / autoplay.
        final bool singleItem = imageUrls.length == 1;
        return SizedBox(
          height: 140,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CarouselSlider.builder(
                itemCount: imageUrls.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomNetWorkImage(
                      raduis: 10,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: imageUrls[index],
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 140,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale,
                  // card_swiper `scale: 0.9` equivalent is roughly enlargeFactor 0.1-0.2
                  // in carousel_slider v5, but keep default to avoid distortion.
                  autoPlay: !singleItem,
                  enableInfiniteScroll: !singleItem,
                  autoPlayInterval: const Duration(seconds: 3),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _activeIndex = index;
                    });
                  },
                ),
              ),
              // Dots (replaces SwiperPagination DotSwiperPaginationBuilder)
              Positioned(
                bottom: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    imageUrls.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _activeIndex == index
                            ? AppColors.mainColor
                            : Colors.grey.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
