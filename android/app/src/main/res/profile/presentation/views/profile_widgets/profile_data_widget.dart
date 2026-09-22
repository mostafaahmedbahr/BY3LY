import 'package:by3ly_app/core/shared_widgets/custom_cached_network_image.dart';
import 'package:by3ly_app/core/shared_widgets/shimmer_loading.dart';
import 'package:by3ly_app/core/utils/app_nav/new_app_nav.dart';
  import 'package:by3ly_app/features/profile/presentation/view_model/profile_states.dart';
 import 'package:easy_localization/easy_localization.dart';

  import '../../../../../main_importants.dart';
import '../../../../updateProfile/presentation/views/update_profile_data_view.dart';
import '../../view_model/profile_cubit.dart';

class ProfileDataWidget extends StatelessWidget {
  const ProfileDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit , ProfileStates>(
      listener: (context , state ){},
      builder: (context , state ){
        debugPrint(CacheTokenManger.userToken);
        debugPrint("ProfileDataWidget");
        var profileCubit = ProfileCubit.get(context);
        if(state is GetProfileDataLoadingState){
          return const SimmerLoading(
            height: 44,
          );
        }
        if(state is GetProfileDataSuccessState && state.profileModel.status==false){
          return const SimmerLoading(
            height: 44,
          );
        }
        else if(state is GetProfileDataErrorState ){
          return const Text("Error");
        }
        return  Row(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                profileCubit.file != null && profileCubit.file!.path !="" ?
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.file(
                        profileCubit.file!,
                        fit: BoxFit.cover,
                        height: 44,
                        width: 44,
                      ),
                    )):
                Container(
                  //padding: const EdgeInsets.all(20),
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xffEFEFEF),
                      border: Border.all(
                        color: const Color(0xffEFEFEF),
                      )
                  ),
                 child:CustomNetWorkImage(
                   imageUrl: profileCubit.profileModel!.data!.user!.image!,
                   raduis: 50,
                   fit: BoxFit.cover,
                 ),
                )  ,
                InkWell(
                  onTap: () {
                    profileCubit.uploadOnlyImage();
                  }, child: const CircleAvatar(
                  backgroundColor: AppColors.mainColor,
                  radius: 10,
                  child: Icon(
                    size : 14,
                    Icons.camera_alt, color: AppColors.whiteColor,),
                ),
                ),
              ],
            ),
            const SizedBox(width: 10,),
              Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${profileCubit.profileModel!.data!.user!.name!} - ( ${profileCubit.profileModel!.data!.user!.phone!} )",style: AppStyles.textStyle16W600Black,),
                Text(" ${context.tr(LocaleKeys.memberFrom)} ${profileCubit.profileModel!.data!.user!.createdAt}",style: AppStyles.textStyle10W400Gray,),
              ],
            ),
            IconButton(
              onPressed: (){
                NewAppNav.customNavigator(context: context, screen: const UpdateProfileDataView());
              },
              icon: const Icon(Icons.update,color: AppColors.yellowColor,),
            ),
          ],
        );
      },

    );
  }
}
