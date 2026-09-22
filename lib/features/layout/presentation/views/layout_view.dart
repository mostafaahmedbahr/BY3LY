import 'package:flutter/services.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_cubit.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_states.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
 import '../../../../main_importants.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});

  @override
  LayoutViewState createState() => LayoutViewState();
}

class LayoutViewState extends State<LayoutView> {
  // Variable to track the time of the last back press
  DateTime? _lastPressed;

  @override
  Widget build(BuildContext context) {
    debugPrint(CacheTokenManger.userToken);
    debugPrint("LayoutView");
    return BlocBuilder<LayoutCubit, LayoutStates>(
      builder: (context, state) {
        var layoutCubit = LayoutCubit.get(context);
        return PopScope(
          canPop: false,
          onPopInvoked: _onPopInvoked, // Pass the method as the callback
          child: Scaffold(
            body: layoutCubit.screens[LayoutCubit.pageIndex],
            bottomNavigationBar: FlashyTabBar(
              selectedIndex: LayoutCubit.pageIndex,
              items: [
                FlashyTabBarItem(
                  activeColor: AppColors.mainColor,
                  icon: const Icon(Icons.home_filled, color: AppColors.mainColor),
                  title: Text(context.tr(LocaleKeys.home)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.mainColor,
                  icon: const Icon(CupertinoIcons.chat_bubble, color: AppColors.mainColor),
                  title: Text(context.tr(LocaleKeys.notifications)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.mainColor,
                  icon: const Icon(CupertinoIcons.search, color: AppColors.mainColor),
                  title: Text(context.tr(LocaleKeys.search)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.mainColor,
                  icon: const Icon(CupertinoIcons.square_list, color: AppColors.mainColor),
                  title: Text(context.tr(LocaleKeys.ads)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.mainColor,
                  icon: const Icon(CupertinoIcons.person, color: AppColors.mainColor),
                  title: Text(context.tr(LocaleKeys.account)),
                ),
              ],
              showElevation: true,
              onItemSelected: (index) {
                layoutCubit.changeBottomNav(index,context);
              },
            ),
          ),
        );
      },
    );
  }

  // Handle back press and exit the app
  void _onPopInvoked(bool didPop) {
    if (didPop) {
      return; // Exit the app if the back button was pressed a second time
    }

    DateTime now = DateTime.now();
    if (_lastPressed == null || now.difference(_lastPressed!) > const Duration(seconds: 2)) {
      // First press: show a message and update the time
      _lastPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr(LocaleKeys.goBackExit)),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Second press within 2 seconds: close the app
      SystemNavigator.pop(); // Close the app
    }
  }
}
