import 'package:by3ly/features/register/presentation/views/register_widgets/register_view_body.dart';
import 'package:by3ly/main_importants.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondColor,
        elevation: 0,
        toolbarHeight: 0,
          scrolledUnderElevation: 0,
      ),
      body: const RegisterViewBody(),
    );
  }
}
