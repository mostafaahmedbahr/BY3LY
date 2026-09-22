import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo_imple.dart';
import 'package:by3ly/features/fav/data/repos/fav_repos_imple.dart';
import 'package:by3ly/features/home/data/repos/home_repo_imple.dart';
import 'package:by3ly/features/login/data/repos/login_repos_imple.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos_imple.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../../../../features/addAdvertisements/data/repos/add_advertisements_repos_imple.dart';
import '../../../../features/advertisements/data/repos/advertisements_repos_imple.dart';
import '../../../../features/allSubCategories/data/repos/all_sub_categories_repos_imple.dart';
import '../../../../features/allSubCategoriesProducts/data/repos/all_sub_categories_products_repos_imple.dart';
import '../../../../features/chooseLocation/data/repos/choose_location_repos_imple.dart';
import '../../../../features/deleteAccount/data/repos/delete_account_repos_imple.dart';
import '../../../../features/howToMakePurchase/data/repos/how_to_make_purchase_repos_imple.dart';
import '../../../../features/notifications/data/repos/notifications_repos_imple.dart';
import '../../../../features/productDetails/data/repos/product_details_repo_imple.dart';
import '../../../../features/productSeller/data/repos/product_seller_repos_imple.dart';
import '../../../../features/reportProduct/data/report_product_repos/report_product_repos_imple.dart';
import '../../../../features/search/data/repos/search_repos_imple.dart';
import '../../../../features/seeAllBestView/data/repos/sell_all_best_view_repo_imple.dart';
import '../../../../features/updateProfile/data/repos/update_profile_data_repo_imple.dart';
import '../../../features/changePassword/data/repos/change_password_repo_imple.dart';
import '../../../features/otp/data/repos/otp_repos_imple.dart';
import '../../../features/register/data/repos/register_repo_imple.dart';
import 'api_service.dart';
//dependency Injection

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<ApiService>(ApiService(Dio()));
  getIt.registerSingleton<AllCategoriesRepoImpl>(AllCategoriesRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<RegisterRepoImpl>(RegisterRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<HomeRepoImpl>(HomeRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<SellAllBestViewRepoImpl>(SellAllBestViewRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<LoginRepoImpl>(LoginRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<ProfileRepoImpl>(ProfileRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<OtpReposImpl>(OtpReposImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<ChooseLocationReposImpl>(ChooseLocationReposImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<FavDataRepoImpl>(FavDataRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<SearchReposImpl>(SearchReposImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<DeleteAccountReposImple>(DeleteAccountReposImple(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<ProductDetailsRepoImpl>(ProductDetailsRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<AddAdvertisementsRepoImpl>(AddAdvertisementsRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<AdvertisementsRepoImpl>(AdvertisementsRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<AllSubCategoriesRepoImpl>(AllSubCategoriesRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<AllSubCategoriesProductsReposImpl>(AllSubCategoriesProductsReposImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<ProductSellerRepoImpl>(ProductSellerRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<HowToMakePurchaseRepoImpl>(HowToMakePurchaseRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<NotificationsDataRepoImpl>(NotificationsDataRepoImpl(
    getIt.get<ApiService>(),
  ));

  getIt.registerSingleton<ReportProductsReposImpl>(ReportProductsReposImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<UpdateProfileDataRepoImpl>(UpdateProfileDataRepoImpl(
    getIt.get<ApiService>(),
  ));
  getIt.registerSingleton<ChangePasswordRepoImpl>(ChangePasswordRepoImpl(
    getIt.get<ApiService>(),
  ));


}