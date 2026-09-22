import 'package:by3ly/features/changePassword/presentation/views/widgets/change_password_view_body.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../main_importants.dart';


class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key, required this.screenName});
  final String screenName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.changePassword.tr())),
      body: ChangePasswordViewBody(screenName: screenName),
    );
  }
}
