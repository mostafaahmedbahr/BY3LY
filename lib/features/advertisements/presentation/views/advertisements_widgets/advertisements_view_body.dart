 import 'package:by3ly/features/advertisements/presentation/view_model/advertisements_states.dart';
  import '../../../../../main_importants.dart';
import '../../../data/repos/advertisements_repos_imple.dart';
import '../../view_model/advertisements_cubit.dart';
import 'add_bundle_button.dart';
import 'ads_types.dart';
import 'my_ads_list.dart';

class AdvertisementsViewBody extends StatelessWidget {
  const AdvertisementsViewBody({super.key});


  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=>AdvertisementsCubit(
          getIt.get<AdvertisementsRepoImpl>())..getAllMyAdsDataMethod(type: 0),
      child: BlocConsumer<AdvertisementsCubit , AdvertisementsStates>(
        listener: (context ,state){},
        builder: (context ,state){
          return   Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AddBundleButton(),
                const SizedBox(height: 20,),
                const AdsTypes(),
                const SizedBox(height: 20,),
                state is GetAllMyAdsDataLoadingState ? const Expanded(child: CustomLoading()):
                    state is GetAllMyAdsDataErrorState ? Expanded(child: Text(state.error)):
                    AdvertisementsCubit.get(context).allMyAdsList.isEmpty ? const Expanded(child:
                    Center(child: Text("لا يوجد اعلانات سابقة",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),))):
                MyAdsList(
                  products: AdvertisementsCubit.get(context).allMyAdsList,
                ),
              ],
            ),
          );
        },

      ),
    );
  }
}
