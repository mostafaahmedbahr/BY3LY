import 'package:by3ly/features/profile/presentation/views/profile_widgets/profile_data_widget.dart';
import 'package:by3ly/features/profile/presentation/views/profile_widgets/profile_list_items_widgets.dart';
import 'package:by3ly/features/profile/presentation/views/profile_widgets/settings_list_widget.dart';
import 'package:by3ly/main_importants.dart';

class ProfileViewBody2 extends StatelessWidget {
  const ProfileViewBody2({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
      children: const [
        ProfileDataWidget(),
        SizedBox(height: 12),
        ProfileListItemsWidgets(),
        SizedBox(height: 16),
        SettingsListWidget(),
      ],
    );
  }
}
