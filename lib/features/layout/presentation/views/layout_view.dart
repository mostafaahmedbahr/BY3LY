import 'package:flutter/services.dart';
import 'package:by3ly/core/notifications/app_notifications.dart';
import 'package:by3ly/core/utils/guest_guard.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_unread_cubit.dart';
import 'package:by3ly/features/chat/presentation/view_model/chat_states.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_states.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/support_unread_cubit.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_cubit.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_states.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_states.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_states.dart';
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
  void initState() {
    super.initState();
    // LayoutView is recreated after login, so refresh account data once the
    // new account is available. Guests have no token, skip every request.
    // Deferred here from MyApp so the splash/first frame is not delayed; the
    // guards avoid duplicate calls when LayoutView is rebuilt.
    if (!GuestGuard.isGuest) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final profile = context.read<ProfileCubit>();
        if (profile.profileModel == null && profile.state is ProfileInitState) {
          profile.getProfile();
        }

        final fav = context.read<FavCubit>();
        if (fav.favDataModel == null && fav.state is FavInitState) {
          fav.getFavData();
        }

        final notifications = context.read<NotificationsCubit>();
        if (notifications.notificationsModel == null &&
            notifications.state is NotificationsInitState) {
          notifications.getNotificationsData();
        }

        ChatUnreadCubit.get(context).refresh();
        SupportUnreadCubit.get(context).refresh();
      });
    }
    // If the app was launched by tapping a notification, open the
    // notifications screen once the layout (post-splash) is on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (AppNotifications.consumePendingNavigation()) {
        Navigator.of(context).pushNamed(Routes.notificationsView);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final inactiveNavColor = isDarkMode
        ? AppColors.textSecondary
        : AppColors.mainColor;
    return BlocBuilder<LayoutCubit, LayoutStates>(
      builder: (context, state) {
        var layoutCubit = LayoutCubit.get(context);
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) => _onPopInvoked(didPop),
          child: Scaffold(
            body: layoutCubit.screens[LayoutCubit.pageIndex],
            bottomNavigationBar: FlashyTabBar(
              selectedIndex: LayoutCubit.pageIndex,
              backgroundColor: AppColors.surface,
              items: [
                FlashyTabBarItem(
                  activeColor: AppColors.accent,
                  inactiveColor: inactiveNavColor,
                  icon: const Icon(Icons.home_filled),
                  title: Text(context.tr(LocaleKeys.home)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.accent,
                  inactiveColor: inactiveNavColor,
                  icon: BlocBuilder<ChatUnreadCubit, ChatUnreadStates>(
                    builder: (context, state) {
                      final unread = ChatUnreadCubit.get(context).count;
                      return Badge(
                        isLabelVisible: unread > 0,
                        label: Text(
                          unread > 99 ? '99+' : '$unread',
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: AppColors.redColor,
                        child: const Icon(CupertinoIcons.chat_bubble),
                      );
                    },
                  ),
                  title: Text(context.tr(LocaleKeys.chat)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.accent,
                  inactiveColor: inactiveNavColor,
                  icon: const Icon(CupertinoIcons.search),
                  title: Text(context.tr(LocaleKeys.search)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.accent,
                  inactiveColor: inactiveNavColor,
                  icon: const Icon(CupertinoIcons.square_list),
                  title: Text(context.tr(LocaleKeys.ads)),
                ),
                FlashyTabBarItem(
                  activeColor: AppColors.accent,
                  inactiveColor: inactiveNavColor,
                  icon: const Icon(CupertinoIcons.person),
                  title: Text(context.tr(LocaleKeys.account)),
                ),
              ],
              showElevation: true,
              onItemSelected: (index) {
                // Guests may only browse: home(0) and search(2) are open,
                // chat(1), ads(3) and account(4) need login.
                if (GuestGuard.isGuest &&
                    (index == 1 || index == 3 || index == 4)) {
                  GuestGuard.requireLogin(context);
                  return;
                }
                layoutCubit.changeBottomNav(index, context);
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
    if (_lastPressed == null ||
        now.difference(_lastPressed!) > const Duration(seconds: 2)) {
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
