import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
import '../../../../../main_importants.dart';
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
          onRefresh: () => advertisementsCubit.getAllMyAdsDataMethod(
            type: advertisementsCubit.advertisementsTypeIndex,
          ),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            children: [
              const AddBundleButton(),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                hintText: "ابحث باسم الإعلان...",
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
                "عدد الإعلانات (${products.length})",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              if (state is GetAllMyAdsDataLoadingState)
                const MyAdsLoading()
              else if (state is GetAllMyAdsDataErrorState)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: CustomErrorWidget(
                    error: state.error,
                    onTap: () => advertisementsCubit.getAllMyAdsDataMethod(
                      type: advertisementsCubit.advertisementsTypeIndex,
                    ),
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
                          "لا يوجد اعلانات",
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
            ],
          ),
        );
      },
    );
  }
}
