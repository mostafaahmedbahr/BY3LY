import 'package:by3ly/core/utils/app_colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';
import 'home_widgets/home_app_bar.dart';
import 'home_widgets/home_view_body.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Loaded on open instead of at app startup, so the splash/first frame is
    // not held up by two requests. The state guard avoids a duplicate call
    // when a provider or a previous screen already started the fetch.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<HomeCubit>();
      if (cubit.state is HomeInitState) {
        cubit
          ..getHome()
          ..getBanners();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const HomeAppBar(),
      body: const HomeViewBody(),
    );
  }
}
