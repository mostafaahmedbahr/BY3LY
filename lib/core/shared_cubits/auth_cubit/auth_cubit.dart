import 'dart:async';

import '../../../main_importants.dart';
import '../../utils/app_consts/storage_keys.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  bool isGuest = false;
  String? userToken;

  /// The secure, in-memory-backed token manager is the single source of truth.
  void checkAuthStatus() {
    userToken = CacheTokenManger.userToken;
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
    // The secure token is intentionally kept so an existing session survives.
    emit(AuthGuestState());
  }

  /// [CacheTokenManger.saveUserToken] already persists the token securely
  /// (login/OTP cubits), so only the local state flags are updated here.
  void loginWithToken(String userToken) {
    isGuest = false;
    this.userToken = userToken;
    CacheHelper.saveData(key: StorageKeys.isGuest, value: false);
    emit(AuthLoggedInState());
  }

  void logout() {
    isGuest = false;
    userToken = null;
    unawaited(CacheTokenManger.clearUserToken());
    CacheHelper.removeData(key: StorageKeys.isGuest);
    emit(AuthLoggedOutState());
  }
}
