 import 'package:by3ly/features/addAdvertisements/data/repos/add_advertisements_repos_imple.dart';
import 'package:by3ly/features/addAdvertisements/presentation/view_model/add_advertisements_states.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/add_advertisements_widgets/product_data_form.dart';
import 'package:by3ly/features/addAdvertisements/presentation/views/add_advertisements_widgets/upload_images.dart';
 import '../../../../../core/app_services/remote_services/service_locator.dart';
import '../../../../../main_importants.dart';
import '../../../../layout/presentation/views/layout_view.dart';
 import '../../view_model/add_advertisements_cubit.dart';
import 'add_advertise_button.dart';
import 'communication_method.dart';
import 'negotiable.dart';

class AddAdvertisementsViewBody extends StatelessWidget {
  const AddAdvertisementsViewBody({super.key, required this.categoryId, required this.subCategoryId});
  final int categoryId;
  final int subCategoryId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>AddAdvertisementsCubit(
          getIt.get<AddAdvertisementsRepoImpl>(),
      )..getAllCarsMarkaData()..getAllCarsModelsData()..getAllCarsTypesData(),
      child: BlocConsumer<AddAdvertisementsCubit , AddAdvertisementsStates>(
      listener:  (context , state ){
        if(state is AddProductAdvertisementsSuccessState){
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const LayoutView(),
            ),
          );
          CherryToast.success(
            title:  Text(state.addAdvertisementModel.message!,
                style: const TextStyle(color: AppColors.mainColor)),
          ).show(context);
        }
        if(state is AddProductAdvertisementsErrorState){
          CherryToast.error(
            title:  Text(state.error.toString(),
                style: const TextStyle(color: AppColors.mainColor)),
          ).show(context);
        }
      },
        builder: (context , state ){
         return Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
             children:   [
              const UploadImages(),
              const CustomSizedBox(height: 10,),
              const ProductDataForm(),
               const CommunicationMethod(),
               const Negotiable(),
              const SizedBox(height: 10,),
               AddAdvertiseButton(
                 categoryId: categoryId,
                 subCategoryId: subCategoryId,
               ),

            ],
          ),
        );
        },
      ),
    );
  }
}
