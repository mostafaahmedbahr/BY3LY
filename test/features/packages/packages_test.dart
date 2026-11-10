import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/packages/data/models/packages_model.dart';
import 'package:by3ly/features/packages/data/models/payment_methods_model.dart';
import 'package:by3ly/features/packages/data/models/subscribe_package_model.dart';
import 'package:by3ly/features/packages/data/repos/packages_repos.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_cubit.dart';
import 'package:by3ly/features/packages/presentation/view_model/packages_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePackagesRepos implements PackagesRepos {
  int getPackagesCalls = 0;
  int getPaymentMethodsCalls = 0;
  int checkoutCalls = 0;

  int? lastCheckoutPackageId;
  String? lastCheckoutMethod;
  String? lastCheckoutReceipt;

  bool failGetPackages = false;
  bool failCheckout = false;

  @override
  Future<Either<Failure, PackagesModel>> getPackages() async {
    getPackagesCalls++;
    if (failGetPackages) return Left(ServerFailure('offline'));
    return Right(PackagesModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'packages': [
          {
            'id': 1,
            'code': 'p1',
            'name': 'باقة مميزة',
            'description': 'الأفضل لك',
            'price': 499,
            'currency': 'EGP',
            'duration_days': 30,
            'ads_limit': 10,
            'is_free': false,
            'is_subscriped': false,
            'features': ['ميزة أ', 'ميزة ب'],
          },
          {
            'id': 2,
            'code': 'p2',
            'name': 'باقة سنوية',
            'description': '',
            'price': 5999,
            'currency': 'EGP',
            'duration_days': 360,
            'ads_limit': 50,
            'is_free': true,
            'is_subscriped': true,
            'ends_at': '2026-12-31',
            'remaining_ads': 12,
          },
        ],
      },
    }));
  }

  @override
  Future<Either<Failure, PaymentMethodsModel>> getPaymentMethods() async {
    getPaymentMethodsCalls++;
    return Right(PaymentMethodsModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': {
        'methods': [
          {'code': 'vodafone_cash', 'name': 'فودافون كاش', 'account': '01000000000'},
          {'code': 'instapay', 'name': 'انستاباي', 'account': 'instapay@by3ly'},
        ],
      },
    }));
  }

  @override
  Future<Either<Failure, SubscribePackageModel>> checkout({
    required int packageId,
    required String paymentMethod,
    String? receiptPath,
  }) async {
    checkoutCalls++;
    lastCheckoutPackageId = packageId;
    lastCheckoutMethod = paymentMethod;
    lastCheckoutReceipt = receiptPath;
    if (failCheckout) return Left(ServerFailure('rejected'));
    return Right(SubscribePackageModel.fromJson({
      'status': true,
      'message': 'تم الاشتراك بنجاح',
      'data': {'subscription_id': 100, 'package_id': packageId},
    }));
  }
}

void main() {
  group('PackagesModel parsing', () {
    test('full envelope parses and features split correctly', () {
      final model = PackagesModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': {
          'packages': [
            {
              'id': 1,
              'name': 'x',
              'price': '100',
              'duration_days': 30,
              'is_free': 1,
              'is_subscriped': 0,
              'features': 'ميزة 1\nميزة 2',
            },
          ],
        },
      });
      expect(model.status, isTrue);
      final p = model.data!.packages!.single;
      expect(p.price, 100);
      expect(p.isFree, isTrue);
      expect(p.isSubscriped, isFalse);
      expect(p.features!.length, 2);
      expect(p.durationMonths, 1);
    });

    test('non-map data envelope produces null data', () {
      final model = PackagesModel.fromJson({'status': true, 'data': []});
      expect(model.data, isNull);
    });

    test('durationMonths maps 90→3, 180→6, 365→12', () {
      final mk = (int d) => Packages.fromJson({'duration_days': d});
      expect(mk(30).durationMonths, 1);
      expect(mk(90).durationMonths, 3);
      expect(mk(180).durationMonths, 6);
      expect(mk(360).durationMonths, 12);
      expect(mk(365).durationMonths, 12);
    });

    test('features as a list of mixed maps/strings keeps strings only', () {
      final p = Packages.fromJson({
        'features': [
          'نقطة أولى',
          {'title': 'عنوان'},
          {'name': 'اسم'},
          42,
        ],
      });
      expect(p.features!.length, 4); // non-strings are stringified by the tolerant parser
      expect(p.features!.first, 'نقطة أولى');
    });
  });

  group('PaymentMethodsModel parsing', () {
    test('methods list parses correctly', () {
      final model = PaymentMethodsModel.fromJson({
        'status': 1,
        'data': {
          'methods': [
            {'code': 'vodafone_cash', 'name': 'فودافون كاش', 'account': '01'},
            'junk entry',
            {'code': 'instapay', 'name': 'انستاباي'},
          ],
        },
      });
      expect(model.data?.methods?.length, 2);
      expect(model.data?.methods?[0].code, 'vodafone_cash');
    });

    test('methods list as string produces null methods', () {
      final model = PaymentMethodsModel.fromJson({
        'status': true,
        'data': {'methods': 'not a list'},
      });
      expect(model.data?.methods, isNull);
    });

    test('status variants 0/"true"/1 all parse', () {
      expect(PaymentMethodsModel.fromJson({'status': 1}).status, isTrue);
      expect(PaymentMethodsModel.fromJson({'status': '1'}).status, isTrue);
      expect(PaymentMethodsModel.fromJson({'status': 'true'}).status, isTrue);
      expect(PaymentMethodsModel.fromJson({'status': 0}).status, isFalse);
    });
  });

  group('PackagesCubit', () {
    test('getPackages success fetches and stores model', () async {
      final repo = FakePackagesRepos();
      final cubit = PackagesCubit(repo);

      await cubit.getPackages();

      expect(cubit.state, isA<GetPackagesSuccessState>());
      expect(repo.getPackagesCalls, 1);
      expect(cubit.allPackages.length, 2);

      // Monthly tab index 0 filters to only the 30-day package
      expect(cubit.selectedDurationIndex, 0);
      expect(cubit.filteredPackages.map((p) => p.id), [1]);

      // Yearly tab shows the 360-day package
      cubit.changeDuration(3);
      expect(cubit.filteredPackages.map((p) => p.id), [2]);
    });

    test('getPackages failure surfaces error message', () async {
      final repo = FakePackagesRepos()..failGetPackages = true;
      final cubit = PackagesCubit(repo);

      await cubit.getPackages();

      expect(cubit.state, isA<GetPackagesErrorState>());
      expect((cubit.state as GetPackagesErrorState).error, 'offline');
    });

    test('checkoutWithWallet posts wallet payload', () async {
      final repo = FakePackagesRepos();
      final cubit = PackagesCubit(repo);
      await cubit.getPackages();

      await cubit.checkoutWithWallet(packageId: 1);

      expect(cubit.state, isA<SubscribePackageSuccessState>());
      expect(repo.lastCheckoutPackageId, 1);
      expect(repo.lastCheckoutMethod, 'wallet');
      expect(repo.lastCheckoutReceipt, isNull);
    });

    test('checkoutWithTransfer without receipt is a no-op (guard)', () async {
      final repo = FakePackagesRepos();
      final cubit = PackagesCubit(repo);

      await cubit.getPaymentMethods();
      // No receipt picked yet — the cubit must bail without calling the repo.
      expect(cubit.receiptImage, isNull);

      await cubit.checkoutWithTransfer(packageId: 1);
      expect(repo.checkoutCalls, 0);
    });

    test('paymentMethods endpoints fetched once and selected automatically', () async {
      PackagesCubit.cachedMethods = null;
      final repo = FakePackagesRepos();
      final cubit = PackagesCubit(repo);

      await cubit.getPaymentMethods();

      expect(repo.getPaymentMethodsCalls, 1);
      expect(cubit.paymentMethods.length, 2);
      expect(cubit.selectedMethod?.code, 'vodafone_cash');

      PackagesCubit.cachedMethods = null;
    });

    test('checkout failure emits error state with package id', () async {
      final repo = FakePackagesRepos()..failCheckout = true;
      final cubit = PackagesCubit(repo);

      await cubit.checkoutWithWallet(packageId: 42);

      expect(cubit.state, isA<SubscribePackageErrorState>());
      expect((cubit.state as SubscribePackageErrorState).error, 'rejected');
      expect(cubit.subscribingPackageId, isNull);
    });

    test('paymentMethods cached across cubits (session cache)', () async {
      PackagesCubit.cachedMethods = null;
      final repo = FakePackagesRepos();
      final c1 = PackagesCubit(repo);
      final c2 = PackagesCubit(repo);

      await c1.getPaymentMethods();
      await c2.getPaymentMethods();

      // Second call serves from cache (only one repo call).
      expect(repo.getPaymentMethodsCalls, 1);

      PackagesCubit.cachedMethods = null;
    });
  });
}
