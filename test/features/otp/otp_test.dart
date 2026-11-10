import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/otp/data/models/otp_model.dart';
import 'package:by3ly/features/otp/data/models/resend_otp_model.dart';
import 'package:by3ly/features/otp/data/repos/otp_repos.dart';
import 'package:by3ly/features/otp/presentation/view_model/otp_cubit.dart';
import 'package:by3ly/features/otp/presentation/view_model/otp_states.dart';
import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeOtpRepos implements OtpRepos {
  FakeOtpRepos({this.verifyStatus = true, this.resendStatus = true});

  final bool verifyStatus;
  final bool resendStatus;

  int verifyCalls = 0;
  int resendCalls = 0;

  @override
  Future<Either<Failure, OtpModel>> verifyOtp({
    required String otp,
    required String email,
    required String deviceToken,
  }) async {
    verifyCalls++;
    return Right(OtpModel.fromJson({
      'status': verifyStatus,
      'message': verifyStatus ? 'تم التفعيل' : 'كود غير صحيح',
      'data': {
        'user': {'id': 7, 'name': 'Ahmed', 'token': 'tok-7'},
        'isActive': true,
      },
    }));
  }

  @override
  Future<Either<Failure, ResendOtpModel>> resendOtp({
    required String email,
  }) async {
    resendCalls++;
    return Right(ResendOtpModel.fromJson({
      'status': resendStatus,
      'message': resendStatus ? 'تم إعادة الإرسال' : 'فشل',
      'data': {'phone': '01000000000', 'code': 123456},
    }));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await CacheHelper.init();
  });

  group('OtpModel parsing', () {
    test('full envelope with user + token parses', () {
      final model = OtpModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'user': {'id': 7, 'name': 'Ahmed', 'token': 'tok-7'},
          'isActive': true,
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.user?.token, 'tok-7');
      expect(model.data?.resolvedToken, 'tok-7');
      expect(model.data?.user?.id, 7);
    });

    test('status variants 1/"true"/"1" all parse', () {
      expect(OtpModel.fromJson({'status': 1}).status, isTrue);
      expect(OtpModel.fromJson({'status': '1'}).status, isTrue);
      expect(OtpModel.fromJson({'status': 0}).status, isFalse);
    });

    test('non-map data envelope produces null', () {
      final model = OtpModel.fromJson({'status': true, 'data': []});
      expect(model.data, isNull);
    });
  });

  group('ResendOtpModel parsing', () {
    test('code arriving as int and as string parses', () {
      final a = ResendOtpModel.fromJson({
        'status': true,
        'data': {'phone': 'x', 'code': 123456},
      });
      final b = ResendOtpModel.fromJson({
        'status': true,
        'data': {'phone': 'x', 'code': '123457'},
      });
      expect(a.data?.code, 123456);
      expect(b.data?.code, 123457);
    });
  });

  group('OtpCubit', () {
    test('verify success stores token and emits success', () async {
      final repo = FakeOtpRepos();
      final cubit = OtpCubit(repo);

      await cubit.verifyOtp(
        otp: '123456',
        email: 'a@b.com',
        deviceToken: 'dev',
      );

      expect(cubit.state, isA<VerifyOtpSuccessState>());
      expect(repo.verifyCalls, 1);
      expect(CacheTokenManger.userToken, 'tok-7');
    });

    test('verify status false surfaces server message', () async {
      final repo = FakeOtpRepos(verifyStatus: false);
      final cubit = OtpCubit(repo);

      await cubit.verifyOtp(
        otp: '000000',
        email: 'a@b.com',
        deviceToken: 'dev',
      );

      expect(cubit.state, isA<VerifyOtpErrorState>());
      expect((cubit.state as VerifyOtpErrorState).error, 'كود غير صحيح');
    });

    test('resend success emits success with the code', () async {
      final repo = FakeOtpRepos();
      final cubit = OtpCubit(repo);

      await cubit.resendOtp(email: 'a@b.com');

      expect(cubit.state, isA<ResendOtpSuccessState>());
      expect(cubit.resendOtpModel?.data?.code, 123456);
      expect(repo.resendCalls, 1);
    });

    test('resend failure surfaces server message', () async {
      final repo = FakeOtpRepos(resendStatus: false);
      final cubit = OtpCubit(repo);

      await cubit.resendOtp(email: 'a@b.com');

      expect(cubit.state, isA<ResendOtpErrorState>());
      expect((cubit.state as ResendOtpErrorState).error, 'فشل');
    });
  });
}
