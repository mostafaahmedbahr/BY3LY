import 'package:by3ly/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

/// Modern home banners slider shown above the search,
/// powered by the getBanners endpoint.
class HomeBannerSlider extends StatefulWidget {
  const HomeBannerSlider({super.key});

  @override
  State<HomeBannerSlider> createState() => _HomeBannerSliderState();
}

class _HomeBannerSliderState extends State<HomeBannerSlider> {
  int _activeIndex = 0;
  final CarouselSliderController _controller =
      CarouselSliderController();

  Future<void> _openLink(String? link) async {
    if (link == null || link.trim().isEmpty) return;
    var url = link.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        if (state is GetBannersLoading && cubit.banners.isEmpty) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: SimmerLoading(height: 170, raduis: 20),
          );
        }
        // Silent fail: never break the home screen over banners.
        if (cubit.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        final banners = cubit.banners;
        final single = banners.length == 1;

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider.builder(
                carouselController: _controller,
                itemCount: banners.length,
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  final hasLink = (banner.link?.trim().isNotEmpty ??
                      false);
                  return InkWell(
                    onTap: () => _openLink(banner.link),
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor
                                .withValues(alpha: 0.16),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CustomNetWorkImage(
                              raduis: 0,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              imageUrl: banner.image!,
                            ),
                            // Cinematic bottom scrim.
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(
                                        alpha: 0.65),
                                  ],
                                  stops: const [0.45, 1.0],
                                ),
                              ),
                            ),
                            if ((banner.title
                                        ?.trim()
                                        .isNotEmpty ??
                                    false) ||
                                (banner.description
                                        ?.trim()
                                        .isNotEmpty ??
                                    false))
                              Positioned(
                                left: 16,
                                right: hasLink ? 64 : 16,
                                bottom: 14,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    if ((banner.title
                                            ?.trim()
                                            .isNotEmpty ??
                                        false))
                                      Text(
                                        banner.title!,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight:
                                              FontWeight.w800,
                                          height: 1.3,
                                        ),
                                      ),
                                    if ((banner.description
                                            ?.trim()
                                            .isNotEmpty ??
                                        false))
                                      Text(
                                        banner.description!,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white
                                              .withValues(
                                                  alpha: 0.85),
                                          fontSize: 12.5,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            if (hasLink)
                              Positioned(
                                right: 14,
                                bottom: 14,
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons
                                        .arrow_forward_rounded,
                                    size: 20,
                                    color: Color(0xff1F2937),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 185,
                  viewportFraction: 0.9,
                  autoPlay: !single,
                  enableInfiniteScroll: !single,
                  autoPlayInterval:
                      const Duration(seconds: 4),
                  enlargeCenterPage: true,
                  enlargeFactor: 0.12,
                  onPageChanged: (index, reason) {
                    setState(() => _activeIndex = index);
                  },
                ),
              ),
              if (!single) ...[
                const SizedBox(height: 12),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28),
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedSmoothIndicator(
                          activeIndex: _activeIndex,
                          count: banners.length,
                          effect: WormEffect(
                            dotWidth: 8,
                            dotHeight: 8,
                            spacing: 6,
                            activeDotColor:
                                AppColors.mainColor,
                            dotColor: AppColors.mainColor
                                .withValues(alpha: 0.2),
                          ),
                          onDotClicked: (index) => _controller
                              .animateToPage(index),
                        ),
                      ),
                      Text(
                        '${(_activeIndex + 1).toString().padLeft(2, '0')} / ${banners.length.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
