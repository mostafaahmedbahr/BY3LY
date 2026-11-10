import 'package:by3ly/core/shared_widgets/custom_global_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'login_buttons_widget.dart';
import 'login_message_text_widget.dart';
import 'login_terms_widget.dart';
import 'login_text_form_field_widget.dart';

/// Same composition as the original screen — hero on top, form below —
/// with denser spacing and a refined hero placement.
class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return ListView(
      physics: const ClampingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      children: [
        // Same wave hero used by the rest of the auth flow (shared widget),
        // but let it crop nicely instead of clipping-over.
        const CustomGlobalAppbarWidget(),
        Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r),
            child: Column(
              children: [
                const LoginMessageTextWidget(),
                const LoginTextFormFieldWidget(),
                Gap(28.h),
                LoginButtonsWidget(formKey: formKey),
                Gap(10.h),
                const LoginTermsWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
