  import 'package:by3ly/core/shared_widgets/custom_error_widget.dart';
import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
  import '../../../../../main_importants.dart';
import '../../../data/repos/advertisements_repos_imple.dart';
import '../../view_model/advertisements_cubit.dart';
import 'add_bundle_button.dart';
import 'ads_types.dart';
import 'my_ads_list.dart';

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

    return BlocProvider(
      create: (context)=>AdvertisementsCubit(
          getIt.get<AdvertisementsRepoImpl>())..getAllMyAdsDataMethod(type: 0),
      child: BlocConsumer<AdvertisementsCubit , AdvertisementsStates>(
        listener: (context ,state){},
        builder: (context ,state){
          final advertisementsCubit = AdvertisementsCubit.get(context);
          final products = advertisementsCubit.filteredAds();
          final hasSearch =
              advertisementsCubit.searchQuery.trim().isNotEmpty;
          return   Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddBundleButton(),
                const SizedBox(height: 16,),
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
                          onPressed: () =>
                              _clearSearch(advertisementsCubit),
                        )
                      : null,
                  onChanged: advertisementsCubit.setSearchQuery,
                ),
                const SizedBox(height: 16,),
                const AdsTypes(),
                const SizedBox(height: 8,),
                Text(
                  "عدد الإعلانات (${products.length})",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff9AA0A6),
                  ),
                ),
                const SizedBox(height: 10,),
                state is GetAllMyAdsDataLoadingState ? const Expanded(child: CustomLoading()):
                    state is GetAllMyAdsDataErrorState ? Expanded(
                      child: CustomErrorWidget(
                        error: state.error,
                        onTap: () => advertisementsCubit.getAllMyAdsDataMethod(
                          type: advertisementsCubit.advertisementsTypeIndex,
                        ),
                      ),
                    ):
                    products.isEmpty ? const Expanded(child:
                    Center(child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          size: 64,
                          color: Color(0xffD9DEE3),
                        ),
                        SizedBox(height: 12),
                        Text("لا يوجد اعلانات",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xff1F2937),
                        ),),
                      ],
                    ))):
                MyAdsList(
                  products: products,
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}
