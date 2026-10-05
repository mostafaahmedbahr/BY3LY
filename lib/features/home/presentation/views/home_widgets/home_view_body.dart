import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/home/presentation/view_model/home_states.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/best_view_products.dart';
import 'package:by3ly/features/home/presentation/views/home_widgets/categories_list.dart';
import 'package:by3ly/main_importants.dart';
import '../../../../../core/shared_widgets/container_search_widget.dart';
import 'banner_to_login.dart';
import 'home_banner_slider.dart';
import 'home_loading_widget.dart';

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
      return ListView(
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

          ///BannerToLogin
          const BannerToLogin(),

          /// BestView grid (vertical scroll, all items).
          if (bestView.isNotEmpty)
            BestViewProducts(bestView: bestView),
        ],
      );
    });
  }
}
