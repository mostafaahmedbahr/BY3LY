import 'dart:io';

import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/deleteAccount/data/models/delete_account_model.dart';
import 'package:by3ly/features/profile/data/models/logout_model.dart';
import 'package:by3ly/features/profile/data/models/profile_data_model.dart';
import 'package:by3ly/features/profile/data/repos/profile_repos.dart';
import 'package:by3ly/features/updateProfile/data/models/update_profile_data_model.dart';
import 'package:by3ly/features/updateProfile/data/repos/update_profile_data_repo.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_cubit.dart';
import 'package:by3ly/features/updateProfile/presentation/view_model/update_profile_data_states.dart';
import 'package:by3ly/features/updateProfile/presentation/views/update_profile_data_view.dart';
import 'package:by3ly/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:by3ly/lang/codegen_loader.g.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, dynamic> _profileJson = {
  'status': true,
  'message': 'ok',
  'data': {
    'isActive': true,
    'requires_otp': false,
    'user': {
      'id': '7',
      'name': 'أحمد محمود',
      'email': 'ahmed@mail.com',
      'phone': '01012345678',
      'image': 'u.png',
      'wallet_balance': 0,
      'center_id': 1,
      'city_id': 1,
      'cityName': 'القاهرة',
      'created_at': '2026-01-01',
    },
  },
};

final Map<String, dynamic> _updateJson = {
  'status': true,
  'message': 'تم حفظ التغييرات',
  'data': {
    'user': {
      'id': '7',
      'name': 'أحمد محمود',
      'email': 'ahmed@mail.com',
    },
  },
};

class FakeUpdateProfileDataRepos implements UpdateProfileDataRepos {
  int calls = 0;
  bool shouldFail = false;

  @override
  Future<Either<Failure, UpdateProfileDataModel>> updateProfileData({
    required dynamic data,
  }) async {
    calls++;
    if (shouldFail) return Left(ServerFailure('update failed'));
    return Right(UpdateProfileDataModel.fromJson(
      Map<String, dynamic>.from(_updateJson),
    ));
  }
}

class FakeProfileRepos implements ProfileRepos {
  @override
  Future<Either<Failure, ProfileModel>> getProfileData() async =>
      Right(ProfileModel.fromJson(
        Map<String, dynamic>.from(_profileJson),
      ));

  @override
  Future<Either<Failure, LogoutModel>> logout() async =>
      Right(LogoutModel.fromJson({'status': true, 'message': 'ok'}));

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async =>
      Right(DeleteAccountModel.fromJson(
          {'status': true, 'number': 1, 'message': 'ok'}));
}

Widget _harness({
  required Widget child,
  List<BlocProvider> providers = const [],
}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => EasyLocalization(
      startLocale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: Builder(
        builder: (context) => MultiBlocProvider(
          providers: [...providers],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            home: child,
          ),
        ),
      ),
    ),
  );
}

Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 1));
  await tester.pump(const Duration(seconds: 1));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('UpdateProfileDataModel parsing', () {
    test('full envelope parses with coercion', () {
      final model = UpdateProfileDataModel.fromJson(_updateJson);
      expect(model.status, isTrue);
      expect(model.message, 'تم حفظ التغييرات');
      expect(model.data!.user!.id, 7);
      expect(model.data!.user!.name, 'أحمد محمود');
    });

    test('tolerates stringy scalars and garbage payloads', () {
      final model = UpdateProfileDataModel.fromJson({
        'status': '1',
        'data': {
          'user': {
            'id': '13',
            'center_id': '2',
            'city_id': '4',
            'name': 'x',
          },
        },
      });
      expect(model.status, isTrue);
      expect(model.data!.user!.id, 13);
      expect(model.data!.user!.centerId, 2);
      expect(model.data!.user!.cityId, 4);

      final broken = UpdateProfileDataModel.fromJson({
        'status': '1',
        'data': 'oops',
      });
      expect(broken.status, isTrue);
      expect(broken.data, isNull);
    });
  });

  group('UpdateProfileDataCubit', () {
    test('initControllers seeds from the profile cache', () {
      final cubit = UpdateProfileDataCubit(FakeUpdateProfileDataRepos());
      cubit.initControllers(ProfileModel.fromJson(_profileJson));
      expect(cubit.nameCon.text, 'أحمد محمود');
      expect(cubit.emailCon.text, 'ahmed@mail.com');
      expect(cubit.phoneCon.text, '01012345678');
      cubit.close();
    });

    test('initControllers tolerates empty profile/user data', () {
      final cubit = UpdateProfileDataCubit(FakeUpdateProfileDataRepos());
      final empty = ProfileModel.fromJson({'status': true, 'data': 'junk'});
      cubit.initControllers(empty); // must not throw
      expect(cubit.nameCon.text, isEmpty);
      cubit.close();
    });

    test('updateProfileData emits Loading then Success', () async {
      final repo = FakeUpdateProfileDataRepos();
      final cubit = UpdateProfileDataCubit(repo);
      final events = <UpdateProfileDataStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.updateProfileData(
        image: null,
        fullName: 'أحمد',
        email: 'a@b.com',
        phoneNumber: null,
      );
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 1);
      expect(events.first, isA<UpdateProfileDataLoadingState>());
      expect(events.last, isA<UpdateProfileDataSuccessState>());
      expect(cubit.updateProfileDataModel?.message, 'تم حفظ التغييرات');
      await sub.cancel();
      await cubit.close();
    });

    test('updateProfileData emits Error on repo failure', () async {
      final repo = FakeUpdateProfileDataRepos()..shouldFail = true;
      final cubit = UpdateProfileDataCubit(repo);
      final events = <UpdateProfileDataStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.updateProfileData(
        image: null,
        fullName: 'أحمد',
        email: null,
        phoneNumber: null,
      );
      await Future<void>.delayed(Duration.zero);

      expect((events.last as UpdateProfileDataErrorState).error,
          'update failed');
      await sub.cancel();
      await cubit.close();
    });

    test('updateProfileData with nothing to change emits Error without hitting the repo', () async {
      final repo = FakeUpdateProfileDataRepos();
      final cubit = UpdateProfileDataCubit(repo);
      final events = <UpdateProfileDataStates>[];
      final sub = cubit.stream.listen(events.add);

      await cubit.updateProfileData(
        image: null,
        fullName: null,
        email: null,
        phoneNumber: null,
      );
      await Future<void>.delayed(Duration.zero);

      expect(repo.calls, 0);
      expect((events.last as UpdateProfileDataErrorState).error,
          'nothingToSend');
      await sub.cancel();
      await cubit.close();
    });

    test('clearProfileImage clears the picked image and emits', () async {
      final cubit = UpdateProfileDataCubit(FakeUpdateProfileDataRepos());
      cubit.profileImage = File('fake.jpg');
      final events = <UpdateProfileDataStates>[];
      final sub = cubit.stream.listen(events.add);

      cubit.clearProfileImage();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.profileImage, isNull);
      expect(events.single, isA<ClearImageSuccessState>());
      await sub.cancel();
      await cubit.close();
    });
  });

  group('Widgets', () {
    Future<ProfileCubit> seededProfile() async {
      final cubit = ProfileCubit(FakeProfileRepos());
      await cubit.getProfile();
      return cubit;
    }

    testWidgets('screen renders the premium AppBar and gold Save CTA',
        (tester) async {
      tester.view.physicalSize = const Size(390, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final profileCubit = await seededProfile();
      final updateCubit = UpdateProfileDataCubit(FakeUpdateProfileDataRepos());

      await tester.pumpWidget(_harness(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<UpdateProfileDataCubit>.value(value: updateCubit),
        ],
        child: const UpdateProfileDataView(),
      ));
      await _settle(tester);

      expect(find.text('تعديل بيانات الملف الشخصي'), findsOneWidget);
      expect(find.text('حفظ'), findsOneWidget);
      expect(find.text('صورة الحساب').evaluate().isNotEmpty ||
          find.text('الصورة الشخصية').evaluate().isNotEmpty ||
          find.textContaining('صورة').evaluate().isNotEmpty,
          isTrue);
    });

    testWidgets('form is pre-filled from the profile cache',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final profileCubit = await seededProfile();
      final updateCubit = UpdateProfileDataCubit(FakeUpdateProfileDataRepos());

      await tester.pumpWidget(_harness(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<UpdateProfileDataCubit>.value(value: updateCubit),
        ],
        child: const UpdateProfileDataView(),
      ));
      await _settle(tester);

      expect(find.text('أحمد محمود'), findsOneWidget);
      expect(find.text('ahmed@mail.com'), findsOneWidget);
      expect(find.text('01012345678'), findsOneWidget);
    });

    testWidgets('tapping Save with an empty payload does nothing (no crash, no repo call)',
        (tester) async {
      tester.view.physicalSize = const Size(390, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final repo = FakeUpdateProfileDataRepos();
      final updateCubit = UpdateProfileDataCubit(repo);
      final profileCubit = await seededProfile();

      await tester.pumpWidget(_harness(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<UpdateProfileDataCubit>.value(value: updateCubit),
        ],
        child: const UpdateProfileDataView(),
      ));
      await _settle(tester);

      // Clear pre-filled fields so the payload is empty.
      updateCubit.nameCon.clear();
      updateCubit.emailCon.clear();
      updateCubit.phoneCon.clear();

      await tester.tap(find.text('حفظ'));
      await _settle(tester);

      expect(repo.calls, 0);
    });
  });
}
