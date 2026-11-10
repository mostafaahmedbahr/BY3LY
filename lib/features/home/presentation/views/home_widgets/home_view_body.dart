import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/banner_to_login.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/best_view_products.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/categories_list.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/home_banner_slider.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/home_loading_widget.dart';
import '../../../../../core/shared_widgets/container_search_widget.dart';
import '../../../../../main_importants.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      var homeCubit = context.read<HomeCubit>();
      // Show the full-page shimmer whenever there is no home data yet,
      // whatever the current state is (home loading, banners loading,
      // or init). getHome() and getBanners() run in parallel and the last
      // emitted state wins, so checking a single loading state would let
      // an empty page flash with no shimmer at all.
      final hasData = homeCubit.homeModel != null;
      if (state is GetHomeDataError && !hasData) {
        return CustomErrorWidget(
          error: state.message.toString(),
          onTap: () => context.read<HomeCubit>()
            ..getHome()
            ..getBanners(),
        );
      }
      if (!hasData) {
        return const HomeLoadingWidget();
      }
      final bestView = homeCubit.homeModel?.data?.bestView ?? [];
      final ads = homeCubit.homeModel?.data?.ads ?? [];
      return RefreshIndicator(
        color: AppColors.accent,
        backgroundColor: AppColors.surface,
        // Refresh both requests in parallel; the shimmer stays away because
        // homeModel/bannersModel keep their old data while reloading.
        onRefresh: () async {
          final cubit = context.read<HomeCubit>();
          await Future.wait([cubit.getHome(), cubit.getBanners()]);
        },
        child: ListView(
          // Always allow the drag, even when the content fits on screen.
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            /// Banners slider (above the search).
            const HomeBannerSlider(),

            /// search
            Padding(
              padding: EdgeInsets.only(top: 10.h,bottom: 10.h,right: 20.w,left: 20.w),
              child: const ContainerSearchWidget(),
            ),

            /// CategoriesList (title + horizontal, first 5).
            const CategoriesList(),

            // /// Sponsored ads strip (first image of available ads).
            // if (ads.isNotEmpty) HomeAdsStrip(ads: ads),

            ///BannerToLogin
            const BannerToLogin(),
            Gap(10.h),
            /// BestView grid (vertical scroll, all items).
            if (bestView.isNotEmpty)
              BestViewProducts(bestView: bestView),
          ],
        ),
      );
    });
  }
}
