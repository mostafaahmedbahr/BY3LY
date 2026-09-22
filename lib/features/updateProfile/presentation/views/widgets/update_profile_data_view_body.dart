import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:by3ly/main_importants.dart';

import 'edit_profile_button.dart';
import 'edit_profile_image.dart';
import 'edit_profile_name_bio_email_phone_form.dart';

class UpdateProfileDataViewBody extends StatelessWidget {
  const UpdateProfileDataViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateProfileDataCubit , UpdateProfileDataStates>(
      builder: (context,state){
        return const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
                EditProfileImage(),
               EditProfileNameBioEmailPhoneForm(),
               SizedBox(height: 40,),
                EditProfileButton(),
            ],
          ),
        );
      },
    );
  }
}
