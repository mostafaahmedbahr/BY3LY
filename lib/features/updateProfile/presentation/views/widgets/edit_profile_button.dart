

import  'package:by3ly/core/utils/app_nav/new_app_nav.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:easy_localization/easy_localization.dart';

 import '../../../../../main_importants.dart';
import '../../../../layout/presentation/views/layout_view.dart';
import '../../../../profile/presentation/view_model/profile_cubit.dart';

class EditProfileButton extends StatelessWidget {
  const EditProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateProfileDataCubit,UpdateProfileDataStates>(
      listener: (context,state){
        if (state is UpdateProfileDataErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.toString())),
          );
        }
        if (state is UpdateProfileDataSuccessState){
          NewAppNav.customNavigator(context: context,
            screen: const LayoutView(),
            finish: true,
          );
          Toast.showSuccessToast(msg: state.updateProfileDataModel.message.toString(), context: context);
          context.read<ProfileCubit>().getProfile();
        }
      },
      builder: (context,state){
        var updateProfileDataCubit = context.read<UpdateProfileDataCubit>();
        return ConditionalBuilder(
          condition: state is ! UpdateProfileDataLoadingState,
          fallback: (context)=>const CustomLoading(),
          builder: (context){
            return CustomButton(
              btnColor: AppColors.mainColor,
              borderColor: AppColors.mainColor,
              btnText: Text(LocaleKeys.save.tr(),
                style: AppStyles.textStyle14W500White,),
              onPressed: (){
                updateProfileDataCubit.updateProfileData(
                  image: updateProfileDataCubit.profileImage,
                   email: updateProfileDataCubit.emailCon.text.isNotEmpty
                      ? updateProfileDataCubit.emailCon.text
                      : null,
                  fullName: updateProfileDataCubit.nameCon.text.isNotEmpty
                      ? updateProfileDataCubit.nameCon.text
                      : null,
                  phoneNumber: updateProfileDataCubit.phoneCon.text.isNotEmpty
                      ? updateProfileDataCubit.phoneCon.text
                      : null,

                );


              },
            );
          },

        );
      },

    );
  }
}
