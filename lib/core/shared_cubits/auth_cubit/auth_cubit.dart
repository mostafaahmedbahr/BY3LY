import '../../../main_importants.dart';
import '../../utils/app_consts/storage_keys.dart';
import 'auth_states.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isGuest = false;
  String? userToken;

  void checkAuthStatus() {
    userToken = CacheHelper.getData(key: StorageKeys.userToken);
    isGuest = CacheHelper.getData(key: StorageKeys.isGuest) ?? false;

    if (isGuest) {
      emit(AuthGuestState());
    } else if (userToken != null) {
      emit(AuthLoggedInState());
    } else {
      emit(AuthLoggedOutState());
    }
  }

  void loginAsGuest() {
    isGuest = true;
    userToken = null;
    CacheHelper.saveData(key: StorageKeys.isGuest, value: true);
    CacheHelper.removeData(key: StorageKeys.userToken);
    emit(AuthGuestState());
  }

  void loginWithToken(String userToken) {
    isGuest = false;
    userToken = userToken;
    CacheHelper.saveData(key: StorageKeys.isGuest, value: false);
    CacheHelper.saveData(key: StorageKeys.userToken, value: userToken);
    emit(AuthLoggedInState());
  }

  void logout() {
    isGuest = false;
    userToken = null;
    CacheHelper.removeData(key: StorageKeys.userToken);
    CacheHelper.removeData(key: StorageKeys.isGuest);
    emit(AuthLoggedOutState());
  }
}
