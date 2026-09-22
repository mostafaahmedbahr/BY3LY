import 'package:by3ly/main_importants.dart';
import '../../../../../core/shared_widgets/custom_global_app_bar.dart';
import 'login_buttons_widget.dart';
import 'login_message_text_widget.dart';
import 'login_terms_widget.dart';
import 'login_text_form_field_widget.dart';

class LoginViewBody extends StatelessWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return ListView(
      children:    [
        Form(
          key:  formKey,
          child:   Column(
            children: [
              const CustomGlobalAppbarWidget(),
              Padding(
                padding:   EdgeInsets.all(20.0.r),
                child: Column(
                  children: [
                    Gap(20.h),
                    const LoginMessageTextWidget(),
                    const LoginTextFormFieldWidget(),
                    Gap(40.h),
                    LoginButtonsWidget(
                      formKey : formKey,
                    ),
                    Gap(10.h),
                    const LoginTermsWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
