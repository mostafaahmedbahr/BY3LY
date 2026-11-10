import 'package:by3ly/features/login/presentation/view_model/login_states.dart';
import 'package:by3ly/lang/locale_keys.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/app_services/local_services/cache_helper.dart';
import '../../../../core/app_services/local_services/cache_token.dart';
import '../../data/models/login_model.dart';
import '../../data/repos/login_repos.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this.loginRepo) : super(LoginInitState());

  static LoginCubit get(BuildContext context) =>
      BlocProvider.of<LoginCubit>(context);

  final TextEditingController phoneCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final LoginRepo loginRepo;
  LoginModel? loginModel;
  bool isPasswordVisible = true;

  void changePasswordVisible() {
    isPasswordVisible = !isPasswordVisible;
    emit(ChangePasswordVisibleState());
  }

  Future<void> login({
    required String phone,
    required String password,
    required String deviceToken,
  }) async {
    if (state is LoginLoadingState) return; // debounce double taps
    emit(LoginLoadingState());
    final result = await loginRepo.login(
      phone: phone,
      password: password,
      deviceToken: deviceToken,
    );
    return result.fold(
      (failure) => emit(LoginErrorState(failure.errMessage)),
      (data) async {
        final envelopeData = data.data;
        if (data.status == true && envelopeData != null) {
          if (envelopeData.isActive == true) {
            loginModel = data;
            final user = envelopeData.user;
            try {
              await CacheTokenManger.saveUserToken(user?.token?.toString() ?? '');
            } catch (e) {
              // Secure storage is best-effort — a failing keychain must not
              // block login. In-memory token above still authenticates.
              debugPrint('LoginCubit: token persist failed — $e');
            }
            await CacheHelper.saveData(
              key: 'email',
              value: user?.email,
            );
            await CacheHelper.saveData(
              key: 'isActive',
              value: envelopeData.isActive,
            );
            emit(LoginSuccessState(data));
          } else {
            // Account exists but is not activated yet — the UI routes to
            // the OTP screen instead of hanging on the loading spinner.
            await CacheHelper.saveData(
              key: 'email',
              value: envelopeData.user?.email,
            );
            await CacheHelper.saveData(
              key: 'requiresOtp',
              value: envelopeData.requiresOtp,
            );
            await CacheHelper.saveData(
              key: 'isActive',
              value: envelopeData.isActive,
            );
            emit(LoginSuccessWithNoActiveState());
          }
        } else {
          final message = data.message?.trim();
          emit(LoginErrorState(
            (message == null || message.isEmpty)
                ? trFallback()
                : message,
          ));
        }
      },
    );
  }

  /// Server rejected the sign in without a message — use the localized
  /// fallback string from the caller's locale if available.
  String trFallback() => LocaleKeys.loginFailed.tr();

  @override
  Future<void> close() {
    phoneCon.dispose();
    emailCon.dispose();
    passwordCon.dispose();
    return super.close();
  }
}
