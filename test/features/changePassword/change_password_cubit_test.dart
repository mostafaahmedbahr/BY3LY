import 'package:by3ly/features/changePassword/data/models/change_password_model.dart';
import 'package:by3ly/features/changePassword/data/repos/change_password_repo.dart';
import 'package:by3ly/features/changePassword/presentation/view_model/change_password_cubit.dart';
import 'package:by3ly/features/changePassword/presentation/view_model/change_password_states.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_cubit.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeChangePasswordRepo implements ChangePasswordRepo {
  int calls = 0;
  bool shouldFail = false;
  String? lastNewPassword;
  String? lastNewPasswordConfirmation;
  String? lastOldPassword;

  final _success = ChangePasswordModel(
    status: true,
    number: 1,
    message: 'تم تغيير كلمة المرور بنجاح',
  );

  @override
  Future<Either<Failure, ChangePasswordModel>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    calls++;
    lastOldPassword = oldPassword;
    lastNewPassword = newPassword;
    lastNewPasswordConfirmation = newPasswordConfirmation;
    if (shouldFail) {
      return Left(ServerFailure('كلمة المرور القديمة غير صحيحة'));
    }
    return Right(_success);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({'email': 'qa@example.com'});
    await CacheHelper.init();
  });

  test('initial state is ChangePasswordInitState and fields default', () {
    final cubit = ChangePasswordCubit(FakeChangePasswordRepo());
    expect(cubit.state, isA<ChangePasswordInitState>());
    expect(cubit.isOldPasswordVisible, isTrue);
    expect(cubit.isNewPasswordVisible, isTrue);
    expect(cubit.isConfirmNewPasswordVisible, isTrue);
    cubit.close();
  });

  test('changePassword success emits loading → success with model', () async {
    final repo = FakeChangePasswordRepo();
    final cubit = ChangePasswordCubit(repo);
    cubit.oldPasswordCon.text = 'OldStrongPass1!';
    cubit.newPasswordCon.text = 'NewStrongPass2!';
    cubit.confirmNewPasswordCon.text = 'NewStrongPass2!';

    await cubit.changePassword();

    expect(repo.calls, 1);
    expect(repo.lastOldPassword, 'OldStrongPass1!');
    expect(repo.lastNewPassword, 'NewStrongPass2!');
    expect(repo.lastNewPasswordConfirmation, 'NewStrongPass2!');
    expect(cubit.state, isA<ChangePasswordSuccessState>());
    final success = cubit.state as ChangePasswordSuccessState;
    expect(success.changePasswordModel.message,
        'تم تغيير كلمة المرور بنجاح');
    expect(cubit.changePasswordModel?.status, isTrue);
    await cubit.close();
  });

  test('changePassword failure emits loading → error', () async {
    final repo = FakeChangePasswordRepo()..shouldFail = true;
    final cubit = ChangePasswordCubit(repo);
    cubit.oldPasswordCon.text = 'wrong';
    cubit.newPasswordCon.text = 'x';
    cubit.confirmNewPasswordCon.text = 'x';

    await cubit.changePassword();

    expect(repo.calls, 1);
    expect(cubit.state, isA<ChangePasswordErrorState>());
    expect((cubit.state as ChangePasswordErrorState).error,
        'كلمة المرور القديمة غير صحيحة');
    await cubit.close();
  });

  test('visibility toggles flip independently', () {
    final cubit = ChangePasswordCubit(FakeChangePasswordRepo());

    cubit.changeOldPasswordVisible();
    expect(cubit.isOldPasswordVisible, isFalse);
    expect(cubit.isNewPasswordVisible, isTrue);
    expect(cubit.isConfirmNewPasswordVisible, isTrue);

    cubit.changeNewPasswordVisible();
    expect(cubit.isNewPasswordVisible, isFalse);

    cubit.changeConfirmNewPasswordVisible();
    expect(cubit.isConfirmNewPasswordVisible, isFalse);

    cubit.changeOldPasswordVisible(); // back to visible
    expect(cubit.isOldPasswordVisible, isTrue);

    cubit.close();
  });

  test('clearUserData wipes email and resets layout pageIndex', () {
    LayoutCubit.pageIndex = 4;
    final cubit = ChangePasswordCubit(FakeChangePasswordRepo());

    expect(CacheHelper.getData(key: 'email'), 'qa@example.com');
    expect(LayoutCubit.pageIndex, 4);

    cubit.clearUserData();

    expect(CacheHelper.getData(key: 'email'), isNull);
    expect(LayoutCubit.pageIndex, 0);
    cubit.close();
  });
}
