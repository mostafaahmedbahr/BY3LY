import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/shared_widgets/custom_cached_network_image.dart';
import '../../view_model/home_cubit.dart';
import '../../view_model/home_states.dart';

class BannerAds extends StatelessWidget {
  const BannerAds({super.key,   this.images});
  final List? images;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit , HomeStates>(
        listener:(context ,state){} ,
    builder: (context ,state) {
      var homeCubit = context.read<HomeCubit>();
      return SizedBox(
        height: 140,
        child: Stack(
          children: [
            Swiper(
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child:    CustomNetWorkImage(
                    raduis: 10,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageUrl: "${images![index].image}",
                  ),
                );
              },
              itemCount: images!.length,
              viewportFraction: 0.8,
              scale: 0.9,
              pagination: const SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  activeColor: AppColors.mainColor, // Change this to your desired active color
                ),
                margin: EdgeInsets.all(10.0),
              ),
              autoplay: true,
            ),
            // SizedBox(
            //   width: MediaQuery.of(context).size.width*0.8,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
            //     child: Text(
            //       "${homeCubit.homeModel!.data!.ads![0].desc}",
            //       style: const TextStyle(
            //         fontWeight: FontWeight.w600,
            //         fontSize: 12,
            //         color: AppColors.whiteColor,
            //       ),
            //       maxLines: 3,
            //       overflow: TextOverflow.ellipsis,
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }

    );
  }
}
