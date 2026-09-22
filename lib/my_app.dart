import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
 import 'core/shared_cubits/auth_cubit/auth_cubit.dart';
import 'features/chooseLocation/data/repos/choose_location_repos_imple.dart';
import 'main_importants.dart';
import 'features/changeLang/presentation/view_model/change_lang_cubit.dart';
import 'features/deleteAccount/data/repos/delete_account_repos_imple.dart';
import 'features/deleteAccount/presentation/view_model/delete_account_cubit.dart';
import 'features/fav/data/repos/fav_repos_imple.dart';
import 'features/helpSupport/presentation/view-model/help_support_cubit.dart';
import 'features/layout/presentation/view_model/layout_cubit.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit()..checkAuthStatus(),
        ),
        BlocProvider(create: (context) => LayoutCubit()),
        BlocProvider(create: (context) => ProfileCubit(getIt.get<ProfileRepoImpl>())..getProfile()),
        BlocProvider(create: (context) => ReportProductCubit(getIt.get<ReportProductsReposImpl>())..getAllComplaintsTypesData()),
        BlocProvider(create: (context) => PrivacyCubit()),
        BlocProvider(create: (context) => HelpSupportCubit()),
        BlocProvider(create: (context) => AddBalanceCubit()),
        BlocProvider(create: (context) => HelpSupportChatCubit()),
        BlocProvider(create: (context) => ConfirmPaymentCubit()),
        BlocProvider(create: (context) => FavCubit(getIt.get<FavDataRepoImpl>())..getFavData()),
        BlocProvider(create: (context) => SearchCubit (getIt.get<SearchReposImpl>())..getAllProductsForSearch()),
        BlocProvider(create: (context) => ChooseLocationCubit (getIt.get<ChooseLocationReposImpl>())..getAllCitiesAndCenters()),
        BlocProvider(create: (context) => LanguageCubit () ),
        BlocProvider(create: (context) => DeleteAccountCubit (getIt.get<DeleteAccountReposImple>()) ),
        BlocProvider(create: (context) => UpdateProfileDataCubit (getIt.get<UpdateProfileDataRepoImpl>()) ),
        BlocProvider(create: (context) => SellAllBestViewCubit(getIt.get<SellAllBestViewRepoImpl>())..getSellAllBestView() ),
        BlocProvider(create: (context) => HomeCubit (getIt.get<HomeRepoImpl>())..getHome()),
       ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_,child){
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
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.whiteColor,
                shadowColor: AppColors.mainColor,
                surfaceTintColor:  AppColors.mainColor,
              ),
              scaffoldBackgroundColor: AppColors.whiteColor,
              fontFamily: 'Cairo',
              primarySwatch: Colors.blue,
            ),
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
                const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
              ],
            ),
          );
        },
      ),
    );
  }
}