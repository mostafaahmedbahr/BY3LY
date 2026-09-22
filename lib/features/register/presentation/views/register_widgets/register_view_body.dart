import 'package:by3ly/features/register/presentation/views/register_widgets/register_buttons_widget.dart';
import 'package:by3ly/features/register/presentation/views/register_widgets/register_form_widget.dart';
import 'package:by3ly/main_importants.dart';
import 'app_bar_with_upload_image_widget.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Column(
      children: [
        const AppBarWithUploadImage(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(20.0.r),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  Gap(20.h),
                  const RegisterForm(),
                  Gap(20.h),
                  RegisterButtons(
                    formKey: formKey,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
