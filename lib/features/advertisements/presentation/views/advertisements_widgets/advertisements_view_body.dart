import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import '../../../../../main_importants.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../view_model/advertisements_cubit.dart';
import 'add_bundle_button.dart';
import 'ads_types.dart';
import 'my_ads_list_item.dart';
import 'my_ads_loading.dart';

class AdvertisementsViewBody extends StatefulWidget {
  const AdvertisementsViewBody({super.key});

  @override
  State<AdvertisementsViewBody> createState() => _AdvertisementsViewBodyState();
}

class _AdvertisementsViewBodyState extends State<AdvertisementsViewBody> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    // Fetch the next page slightly before the user reaches the very bottom.
    if (max - current <= 300) {
      AdvertisementsCubit.get(context).fetchMyAds(loadMore: true);
    }
  }

  void _clearSearch(AdvertisementsCubit cubit) {
    _searchController.clear();
    cubit.setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    // Cubit is provided above by AdvertisementsView (shared with the FAB
    // so publishing a new ad can trigger a refresh here).
    return BlocConsumer<AdvertisementsCubit, AdvertisementsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final advertisementsCubit = AdvertisementsCubit.get(context);
        final products = advertisementsCubit.filteredAds();
        final hasSearch = advertisementsCubit.searchQuery.trim().isNotEmpty;
        return RefreshIndicator(
          color: AppColors.mainColor,
          onRefresh: () => advertisementsCubit.fetchMyAds(),
          child: ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            children: [
              // Packages/bundles are hidden with the server payment flag.
              if (context.watch<ProfileCubit>().paymentsEnabled) ...[
                const AddBundleButton(),
                const SizedBox(height: 16),
              ],
              CustomTextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                hintText: context.tr(LocaleKeys.searchAdName),
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AppImages.search),
                ),
                suffixIcon: hasSearch
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () => _clearSearch(advertisementsCubit),
                      )
                    : null,
                onChanged: advertisementsCubit.setSearchQuery,
              ),
              const SizedBox(height: 16),
              const AdsTypes(),
              const SizedBox(height: 8),
              Text(
                "${context.tr(LocaleKeys.adsCountLabel)} (${products.length})",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              if (state is GetAllMyAdsDataLoadingState)
                const MyAdsLoading()
              else if (state is GetAllMyAdsDataErrorState && products.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: CustomErrorWidget(
                    error: state.error,
                    onTap: () => advertisementsCubit.fetchMyAds(),
                  ),
                )
              else if (products.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: AppColors.border,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          context.tr(LocaleKeys.noAds),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (int i = 0; i < products.length; i++) ...[
                  if (i > 0) const SizedBox(height: 15),
                  MyAdsListItem(adsProduct: products[i]),
                ],

              /// Pagination footer: keeps loaded ads visible while the next
              /// page is fetched, with a retry action if that page fails.
              if (advertisementsCubit.isLoadingMore)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 18),
                  child: Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                )
              else if (state is GetAllMyAdsDataPaginationErrorState)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      Text(
                        state.error,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () =>
                            advertisementsCubit.fetchMyAds(loadMore: true),
                        child: Text(
                          context.tr(LocaleKeys.retry),
                          style: TextStyle(color: AppColors.mainColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
