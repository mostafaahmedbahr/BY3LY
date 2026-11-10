import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/privacy/data/models/settings_model.dart';
import 'package:by3ly/features/privacy/data/repos/privacy_repo.dart';
import 'package:by3ly/features/privacy/presentation/view_model/privacy_cubit.dart';
import 'package:by3ly/features/privacy/presentation/view_model/privacy_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePrivacyRepo implements PrivacyRepo {
  int getCalls = 0;
  int updateCalls = 0;

  bool failGet = false;
  bool failUpdate = false;

  Map<String, dynamic> response = {
    'status': true,
    'message': 'ok',
    'data': {
      'settings': {
        'contact_method': 'phone',
        'contact_methods': [
          {'value': 'chat', 'label': 'شات'},
          {'value': 'phone', 'label': 'تليفون'},
          {'value': 'both', 'label': 'كلاهما'},
        ],
        'can_chat': true,
        'can_call': true,
        'contact_phone': '01000000000',
        'store_name': 'متجر',
        'store_address': 'عنوان',
        'notify_new_products': true,
      },
    },
  };

  @override
  Future<Either<Failure, SettingsModel>> getSettings() async {
    getCalls++;
    if (failGet) return Left(ServerFailure('offline'));
    return Right(SettingsModel.fromJson(response));
  }

  @override
  Future<Either<Failure, SettingsModel>> updateSettings({
    required String contactMethod,
    required String contactPhone,
    required bool notifyNewProducts,
    String? storeName,
    String? storeAddress,
  }) async {
    updateCalls++;
    if (failUpdate) return Left(ServerFailure('rejected'));
    return Right(SettingsModel.fromJson(response));
  }
}

void main() {
  group('SettingsModel parsing', () {
    test('full envelope parses and tolerant flags work', () {
      final model = SettingsModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'settings': {
            'contact_method': 'both',
            'contact_phone': '01012345678',
            'store_name': 'متجري',
            'store_address': 'الإسكندرية',
            'notify_new_products': 1,
            'can_chat': 'true',
            'can_call': 0,
            'contact_methods': [
              {'value': 'chat', 'label': 'شات'},
              {'value': 'phone', 'label': 'تليفون'},
            ],
          },
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.settings?.contactMethod, 'both');
      expect(model.data?.settings?.canChat, isTrue);
      expect(model.data?.settings?.canCall, isFalse);
      expect(model.data?.settings?.notifyNewProducts, isTrue);
      expect(model.data?.settings?.contactMethods?.length, 2);
    });

    test('status variants 0/"1"/"true" parse', () {
      expect(SettingsModel.fromJson({'status': 1}).status, isTrue);
      expect(SettingsModel.fromJson({'status': '1'}).status, isTrue);
      expect(SettingsModel.fromJson({'status': 'true'}).status, isTrue);
      expect(SettingsModel.fromJson({'status': 0}).status, isFalse);
    });

    test('envelope list keeps the app alive', () {
      final model = SettingsModel.fromJson({'status': true, 'data': []});
      expect(model.status, isTrue);
      expect(model.data, isNull);
    });

    test('junk contact_methods entries are skipped', () {
      final model = SettingsModel.fromJson({
        'status': true,
        'data': {
          'settings': {
            'contact_methods': [
              {'value': 'chat', 'label': 'c'},
              'junk',
              {'value': 'phone', 'label': 'p'},
            ],
          },
        },
      });
      expect(model.data!.settings!.contactMethods!.length, 2);
    });
  });

  group('PrivacyCubit', () {
    test('getSettings applies values and selects the phone method', () async {
      final repo = FakePrivacyRepo();
      final cubit = PrivacyCubit(repo);

      await cubit.getSettings();

      expect(cubit.state, isA<GetSettingsSuccessState>());
      expect(cubit.settings?.contactMethod, 'phone');
      expect(cubit.settings?.contactPhone, '01000000000');
      expect(cubit.settings?.storeName, 'متجر');
      expect(cubit.phoneNumberCon.text, '01000000000');
      expect(cubit.notifyNewProducts, isTrue);
      expect(cubit.contactMethodValues, ['chat', 'phone', 'both']);
      expect(cubit.selectedContactMethod, 'phone');
    });

    test('getSettings error emits error with message', () async {
      final repo = FakePrivacyRepo()..failGet = true;
      final cubit = PrivacyCubit(repo);

      await cubit.getSettings();

      expect(cubit.state, isA<GetSettingsErrorState>());
      expect((cubit.state as GetSettingsErrorState).error, 'offline');
    });

    test('changeConnectionWay updates wayIndex and emits', () {
      final repo = FakePrivacyRepo();
      final cubit = PrivacyCubit(repo);

      cubit.changeConnectionWay(2);

      expect(cubit.state, isA<PrivacyChangeConnectionWayState>());
      expect(cubit.wayIndex, 2);
      expect(cubit.selectedContactMethod, 'phone');
    });

    test('saveSettings success applies the new settings', () async {
      final repo = FakePrivacyRepo();
      final cubit = PrivacyCubit(repo);

      await cubit.getSettings();
      cubit.phoneNumberCon.text = '01111111111';
      cubit.notifyNewProducts = false;

      await cubit.saveSettings();

      expect(cubit.state, isA<UpdateSettingsSuccessState>());
      expect(cubit.notifyNewProducts, isTrue); // reapplied from server response
      expect(repo.updateCalls, 1);
    });

    test('saveSettings failure emits error', () async {
      final repo = FakePrivacyRepo()..failUpdate = true;
      final cubit = PrivacyCubit(repo);

      await cubit.getSettings();
      await cubit.saveSettings();

      expect(cubit.state, isA<UpdateSettingsErrorState>());
      expect((cubit.state as UpdateSettingsErrorState).error, 'rejected');
    });

    test('changeNotifyNewProducts flips the flag', () {
      final repo = FakePrivacyRepo();
      final cubit = PrivacyCubit(repo);
      final before = cubit.notifyNewProducts;

      cubit.changeNotifyNewProducts(!before);

      expect(cubit.state, isA<PrivacyChangeNotifyNewProductsState>());
      expect(cubit.notifyNewProducts, !before);
    });
  });
}
