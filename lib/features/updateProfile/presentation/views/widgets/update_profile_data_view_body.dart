import 'package:flutter/material.dart';
import 'edit_profile_button.dart';
import 'edit_profile_image.dart';
import 'edit_profile_name_bio_email_phone_form.dart';

/// Scrollable update-profile form: avatar editor, personal details fields,
/// then the Save CTA pinned at the bottom of the scroll.
class UpdateProfileDataViewBody extends StatelessWidget {
  const UpdateProfileDataViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EditProfileImage(),
            const SizedBox(height: 24),
            const EditProfileNameBioEmailPhoneForm(),
            const SizedBox(height: 32),
            EditProfileButton(formKey: formKey),
          ],
        ),
      ),
    );
  }
}
