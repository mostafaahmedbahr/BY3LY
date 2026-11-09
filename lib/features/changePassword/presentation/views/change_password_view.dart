import 'package:flutter/material.dart';

import 'widgets/change_password_view_body.dart';
import 'widgets/premium_app_bar.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: premiumAppBar(context),
      body: const ChangePasswordViewBody(),
    );
  }
}
