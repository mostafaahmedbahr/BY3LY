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
import 'features/helpSupportChat/presentation/view_model/help_support_chat_cubit.dart';
import 'features/helpSupportChat/presentation/view_model/support_unread_cubit.dart';
import 'features/helpSupportChat/data/repos/support_chat_repository_impl.dart';
import 'package:by3ly/features/home/data/repos/home_repo_imple.dart';
import 'package:by3ly/features/home/presentation/view_model/home_cubit.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos_imple.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/features/reportProduct/data/report_product_repos/report_product_repos_imple.dart';
import 'package:by3ly/features/search/presentation/view_model/search_cubit.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo_imple.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Providers only — no page/network work here. Account-wide fetches run
      // once LayoutView is on screen; screen-specific fetches run on open.
      providers: [
        BlocProvider(create: (context) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(
          create: (context) => ProfileCubit(getIt.get<ProfileRepoImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              ReportProductCubit(getIt.get<ReportProductsReposImpl>()),
        ),
        BlocProvider(
          create: (context) => PrivacyCubit(getIt.get<PrivacyRepoImpl>()),
        ),
        BlocProvider(create: (context) => HelpSupportCubit()),
        BlocProvider(create: (context) => AddBalanceCubit()),
        BlocProvider(
          create: (context) => HelpSupportChatCubit(
            getIt.get<SupportChatRepositoryImpl>(),
            getIt.get<SupportUnreadCubit>(),
          ),
        ),
        BlocProvider(create: (context) => ConfirmPaymentCubit()),
        BlocProvider(
          create: (context) => FavCubit(getIt.get<FavDataRepoImpl>()),
        ),
        BlocProvider(
          create: (context) => SearchCubit(getIt.get<SearchReposImpl>()),
        ),
        BlocProvider(
          create: (context) =>
              ChooseLocationCubit(getIt.get<ChooseLocationReposImpl>()),
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
              SellAllBestViewCubit(getIt.get<SellAllBestViewRepoImpl>()),
        ),
        BlocProvider(create: (context) => HomeCubit(getIt.get<HomeRepoImpl>())),
        BlocProvider(
          create: (context) => CompareCubit(
            getIt.get<CompareReposImpl>(),
            getIt.get<ProductDetailsRepoImpl>(),
          ),
        ),
        BlocProvider(
          create: (context) =>
              NotificationsCubit(getIt.get<NotificationsDataRepoImpl>()),
        ),
        // Shared singletons: badges are refreshed from LayoutView once the
        // first frame is on screen, and after chat actions/lifecycle resumes.
        BlocProvider<ChatUnreadCubit>.value(
          value: getIt.get<ChatUnreadCubit>(),
        ),
        BlocProvider<SupportUnreadCubit>.value(
          value: getIt.get<SupportUnreadCubit>(),
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
