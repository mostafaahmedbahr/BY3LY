import 'package:by3ly/main_importants.dart';
import '../../data/repos/login_repos_imple.dart';
import '../view_model/login_cubit.dart';
import 'login_widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt.get<LoginRepoImpl>()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.secondColor,
          elevation: 0,
          toolbarHeight: 0,
            scrolledUnderElevation: 0,
        ),
        body: const LoginViewBody(),
      ),
    );
  }
}
