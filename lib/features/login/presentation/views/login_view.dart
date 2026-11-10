import 'package:by3ly/core/app_services/remote_services/service_locator.dart';
import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:by3ly/features/login/data/repos/login_repos_imple.dart';
import 'package:by3ly/features/login/presentation/view_model/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(getIt.get<LoginRepoImpl>()),
      child: Scaffold(
        backgroundColor: AppColors.surface,
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
