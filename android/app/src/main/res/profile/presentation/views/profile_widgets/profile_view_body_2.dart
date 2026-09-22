import 'package:by3ly_app/features/profile/presentation/views/profile_widgets/profile_data_widget.dart';
import 'package:by3ly_app/features/profile/presentation/views/profile_widgets/profile_list_items_widgets.dart';
import 'package:by3ly_app/features/profile/presentation/views/profile_widgets/settings_list_widget.dart';
import 'package:by3ly_app/main_importants.dart';

class ProfileViewBody2 extends StatelessWidget {
  const ProfileViewBody2({super.key});

  @override
  Widget build(BuildContext context) {
    return   Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children:   [
          const ProfileDataWidget(),
          Gap(10.h),
          const ProfileListItemsWidgets(),
         Gap(10.h),
          const SettingsListWidget(),
        ],
      ),
    );
  }
}
