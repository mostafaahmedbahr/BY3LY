import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:by3ly/core/utils/app_theme/app_theme.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/compare/data/repos/compare_repos_imple.dart';
import 'package:by3ly/features/compare/presentation/view_model/compare_cubit.dart';
import 'package:by3ly/features/notifications/data/repos/notifications_repos_imple.dart';
import 'package:by3ly/features/notifications/presentation/view_model/notifications_cubit.dart';
import 'package:by3ly/features/productDetails/data/repos/product_details_repo_imple.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'features/chooseLocation/data/repos/choose_location_repos_imple.dart';
import 'main_importants.dart';
import 'features/changeLang/presentation/view_model/change_lang_cubit.dart';
import 'features/chat/presentation/view_model/chat_unread_cubit.dart';
import 'features/deleteAccount/data/repos/delete_account_repos_imple.dart';
import 'features/deleteAccount/presentation/view_model/delete_account_cubit.dart';
import 'features/fav/data/repos/fav_repos_imple.dart';
import 'features/helpSupport/presentation/view-model/help_support_cubit.dart';
import 'features/layout/presentation/view_model/layout_cubit.dart';
import 'features/privacy/data/repos/privacy_repo_imple.dart';
import 'features/privacy/presentation/view_model/privacy_cubit.dart';
import 'features/reportProduct/presentation/view_model/report_product_cubit.dart';
import 'features/search/data/repos/search_repos_imple.dart';
import 'features/seeAllBestView/data/repos/sell_all_best_view_repo_imple.dart';
import 'features/seeAllBestView/presentation/view_model/sell_all_best_view_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:by3ly/features/addBalance/presentation/view_model/add_balance_cubit.dart';
import 'package:by3ly/features/confirmPayment/presentation/view_model/confirm_payment_cubit.dart';
import 'package:by3ly/features/fav/presentation/view_model/fav_cubit.dart';
import 'package:by3ly/features/helpSupportChat/presentation/view_model/help_support_chat_cubit.dart';
import 'package:by3ly/features/home/data/repos/home_repo_imple.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos_imple.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos_imple.dart';
import 'package:by3ly/features/search/presentation/view_model/search_cubit.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo_imple.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/core/utils/guest_guard.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(
          create: (context) {
            // Guests have no token: skip account-only requests (they 401).
            final cubit = ProfileCubit(getIt.get<ProfileRepoImpl>());
            if (!GuestGuard.isGuest) cubit.getProfile();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) =>
              ReportProductCubit(getIt.get<ReportProductsReposImpl>())
                ..getAllComplaintsTypesData(),
        ),
        BlocProvider(
          create: (context) {
            final cubit = PrivacyCubit(getIt.get<PrivacyRepoImpl>());
            // Settings are account-scoped: guests would get a 401.
            if (!GuestGuard.isGuest) cubit.getSettings();
            return cubit;
          },
        ),
        BlocProvider(create: (context) => HelpSupportCubit()),
        BlocProvider(create: (context) => AddBalanceCubit()),
        BlocProvider(create: (context) => HelpSupportChatCubit()),
        BlocProvider(create: (context) => ConfirmPaymentCubit()),
        BlocProvider(
          create: (context) {
            final cubit = FavCubit(getIt.get<FavDataRepoImpl>());
            if (!GuestGuard.isGuest) cubit.getFavData();
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) =>
              SearchCubit(getIt.get<SearchReposImpl>())
                ..getAllProductsForSearch(),
        ),
        BlocProvider(
          create: (context) =>
              ChooseLocationCubit(getIt.get<ChooseLocationReposImpl>())
                ..getAllCitiesAndCenters(),
        ),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(
          create: (context) =>
              DeleteAccountCubit(getIt.get<DeleteAccountReposImple>()),
        ),
        BlocProvider(
          create: (context) =>
              UpdateProfileDataCubit(getIt.get<UpdateProfileDataRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              SellAllBestViewCubit(getIt.get<SellAllBestViewRepoImpl>())
                ..getSellAllBestView(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(getIt.get<HomeRepoImpl>())
            ..getHome()
            ..getBanners(),
        ),
        BlocProvider(
          create: (context) => CompareCubit(
            getIt.get<CompareReposImpl>(),
            getIt.get<ProductDetailsRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) {
            final cubit = NotificationsCubit(
              getIt.get<NotificationsDataRepoImpl>(),
            );
            if (!GuestGuard.isGuest) {
              cubit.getNotificationsData(type: "general");
            }
            return cubit;
          },
        ),
        BlocProvider<ChatUnreadCubit>.value(
          value: () {
            // Shared singleton: the badge stays in sync with the chat screens.
            final cubit = getIt.get<ChatUnreadCubit>();
            if (!GuestGuard.isGuest) cubit.refresh();
            return cubit;
          }(),
        ),
      ],
      child: ThemeProvider(
        initTheme: AppThemes.initial,
        duration: const Duration(milliseconds: 500),
        builder: (_, theme) {
          AppThemes.sync(theme);
          return ScreenUtilInit(
            designSize: const Size(390, 844),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (_, child) {
              return MaterialApp(
                home: child,
                onGenerateRoute: AppRouter().generateRoute,
                initialRoute: Routes.splashView,
                navigatorKey: navigatorKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                debugShowCheckedModeBanner: false,
                title: "BY3LY",
                theme: theme,
                builder: (context, child) => ThemeSwitchingArea(
                  child: ResponsiveBreakpoints.builder(
                    child: child!,
                    breakpoints: [
                      const Breakpoint(start: 0, end: 450, name: MOBILE),
                      const Breakpoint(start: 451, end: 800, name: TABLET),
                      const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                      const Breakpoint(
                        start: 1921,
                        end: double.infinity,
                        name: '4K',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
