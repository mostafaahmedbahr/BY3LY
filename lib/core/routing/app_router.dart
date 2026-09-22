import 'package:by3ly/features/allSubCategories/presentation/views/all_sub_categories_view.dart';
import 'package:by3ly/features/chooseLocation/presentation/view_model/choose_location_cubit.dart';
import 'package:by3ly/features/chooseLocation/presentation/views/choose_location_view.dart';
import 'package:by3ly/features/layout/presentation/views/layout_view.dart';
import 'package:by3ly/features/login/presentation/views/login_view.dart';
import 'package:by3ly/features/register/presentation/views/register_view.dart';
import 'package:by3ly/features/splash/presentation/views/splash_view.dart';
import '../../features/allCategories/data/repositories/all_categories_repo_imple.dart';
import '../../features/allCategories/presentation/view_model/cubit.dart';
import '../../features/allCategories/presentation/views/all_categories_view.dart';
import '../../features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import '../../features/allSubCategories/presentation/view_model/all_sub_categories_cubit.dart';
import '../../features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos_imple.dart';
import '../../features/allSubCategoriesProducts/presentation/view_model/all_sub_categories_products_cubit.dart';
import '../../features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_view.dart';
import '../../features/changePassword/data/repos/change_password_repo_imple.dart';
import '../../features/changePassword/presentation/view_model/change_password_cubit.dart';
import '../../features/changePassword/presentation/views/change_password_view.dart';
import '../../features/chooseLocation/data/repos/choose_location_repos_imple.dart';
import '../../features/otp/data/repos/otp_repos_imple.dart';
import '../../features/otp/presentation/view_model/otp_cubit.dart';
import '../../features/otp/presentation/views/otp_view.dart';
import '../../features/productDetails/data/repos/product_details_repo_imple.dart';
import '../../features/productDetails/presentation/view_model/product_details_cubit.dart';
import '../../features/productDetails/presentation/views/product_details_view.dart';
import '../../features/register/data/repos/register_repo_imple.dart';
import '../../features/register/presentation/view_model/register_cubit.dart';
import '../../main_importants.dart';

class AppRouter {
  final navigatorKey = GlobalKey<NavigatorState>();
  Route? generateRoute(RouteSettings settings) {
    //this arguments to be passed in any screen like this ( arguments as ClassName )
    final arguments = settings.arguments;

    switch (settings.name) {
      case Routes.splashView:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.loginView:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );
      case Routes.layoutView:
        return MaterialPageRoute(builder: (context) => const LayoutView());
      case Routes.otpView:
        final String email = arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OtpCubit(getIt.get<OtpReposImpl>()),
            child: OtpView(email: email),
          ),
        );
      case Routes.chooseLocationView:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChooseLocationCubit(getIt.get<ChooseLocationReposImpl>())..getAllCitiesAndCenters(),
            child: const ChooseLocationView(),
          ),
        );
      case Routes.registerView:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterCubit(getIt.get<RegisterRepoImpl>()),
            child: const RegisterView(),
          ),
        );
      case Routes.changePasswordView:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ChangePasswordCubit(getIt.get<ChangePasswordRepoImpl>()),
            child:   const ChangePasswordView(screenName: "",),
          ),
        );
      case Routes.allSubCategoriesView:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSubCategoriesCubit(getIt.get<AllSubCategoriesRepoImpl>()),
            child:     AllSubCategoriesView(
                mainCategoryName: args["mainCategoryName"],
                mainCategoryId: args["mainCategoryId"],
                mainCategoryImage: args["mainCategoryImage"],
            ),
          ),
        );
      case Routes.allSubCategoriesProductsView:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllSubCategoriesProductsCubit(getIt.get<AllSubCategoriesProductsReposImpl>()),
            child:     AllSubCategoriesProductsView(
              subCategoryId: args["subCategoryId"],
              subCategoryName: args["subCategoryName"],
            ),
          ),
        );
      case Routes.productDetailsView:
        final args = arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProductDetailsCubit(getIt.get<ProductDetailsRepoImpl>())..getProductDetailsData(
                productId: args["productId"],
                type: args["type"],
            ),
            child:     ProductDetailsView(
              productId: args["productId"],
              type: args["type"],
            ),
          ),
        );
      case Routes.allCategoriesView:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AllCategoriesCubit(getIt.get<AllCategoriesRepoImpl>())..getAllCategories(
            ),
            child:     const AllCategoriesView(),
          ),
        );
        default:
        return null;
    }
  }
}
