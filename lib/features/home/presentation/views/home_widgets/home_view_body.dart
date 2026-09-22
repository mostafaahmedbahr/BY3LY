import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/categories_list.dart';
import 'package:by3ly/main_importants.dart';
import '../../../../../core/shared_widgets/container_search_widget.dart';
import 'banner_ads.dart';
import 'banner_to_login.dart';
import 'best_view_products.dart';
import 'home_loading_widget.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      var homeCubit = context.read<HomeCubit>();
      return state is GetHomeDataLoading
          ? const HomeLoadingWidget()
          : state is GetHomeDataError
              ? CustomErrorWidget(error: state.message.toString(), onTap: () {})
              : ListView(
                  children: [
                    /// search
                    Padding(
                      padding: EdgeInsets.only(top: 20.h,bottom: 10.h,right: 20.w,left: 20.w),
                      child: const ContainerSearchWidget(),
                    ),

                    /// CategoriesList
                    const CategoriesList(),

                    ///BannerToLogin
                    const BannerToLogin(),

                    /// BannerAds1
                    if(homeCubit.homeModel!.data.ads[0].images.isNotEmpty)...[
                      BannerAds(
                        images: homeCubit.homeModel!.data.ads[0].images,
                      ),
                      Gap(10.h),
                    ],
                    /// bestView
                    BestViewProducts(
                      bestView: homeCubit.homeModel!.data.bestView,
                    ),
                    Gap(10.h),

                    /// BannerAds2
                    if(homeCubit.homeModel!.data.ads[1].images.isNotEmpty)...[
                      BannerAds(
                        images: homeCubit.homeModel!.data.ads[1].images,
                      ),
                      Gap(10.h),
                    ],

                    /// BannerAds3
                    if(homeCubit.homeModel!.data.ads[2].images.isNotEmpty)...[
                      BannerAds(
                        images: homeCubit.homeModel!.data.ads[2].images,
                      ),
                      Gap(10.h),
                    ],
                  ],
                );
    });
  }
}
