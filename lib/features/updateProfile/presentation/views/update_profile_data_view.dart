import 'package:by3ly/features/updateProfile/presentation/views/widgets/update_profile_data_view_body.dart';
import 'package:by3ly/main_importants.dart';
import 'package:easy_localization/easy_localization.dart';

class UpdateProfileDataView extends StatelessWidget {
  const UpdateProfileDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.updateProfileData.tr()),
      ),
      body: const UpdateProfileDataViewBody(),
    );
  }
}
