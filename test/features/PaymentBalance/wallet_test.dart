import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/core/general_models/general_model.dart';
import 'package:by3ly/features/PaymentBalance/data/models/wallet_history_model.dart';
import 'package:by3ly/features/PaymentBalance/data/repos/wallet_repos.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_cubit.dart';
import 'package:by3ly/features/PaymentBalance/presentation/view_model/wallet_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeWalletRepos implements WalletRepos {
  int getHistoryCalls = 0;
  int topUpCalls = 0;

  bool failGetHistory = false;
  bool failTopUp = false;

  int? lastTopUpAmount;
  String? lastTopUpMethod;

  @override
  Future<Either<Failure, WalletHistoryModel>> getHistory() async {
    getHistoryCalls++;
    if (failGetHistory) return Left(ServerFailure('offline'));
    return Right(WalletHistoryModel.fromJson({
      'status': true,
      'message': 'ok',
      'data': [
        {
          'id': 1,
          'amount': 1500,
          'type': 'credit',
          'type_label': 'إيداع',
          'status': 'pending',
          'created_at': '2026-11-01 10:00:00',
          'payment_method': 'vodafone_cash',
        },
        {
          'id': 2,
          'amount': 500,
          'type': 'debit',
          'type_label': 'خصم',
          'status': 'approved',
          'created_at': '2026-10-25 09:00:00',
          'payment_method': 'wallet',
        },
      ],
    }));
  }

  @override
  Future<Either<Failure, GeneralModel>> topUp({
    required String amount,
    required String paymentMethod,
    required String receiptPath,
    String? transferReference,
  }) async {
    topUpCalls++;
    if (failTopUp) return Left(ServerFailure('rejected'));
    lastTopUpMethod = paymentMethod;
    return Right(GeneralModel(status: true, message: 'تم استلام طلب الشحن'));
  }
}

void main() {
  group('WalletHistoryModel parsing', () {
    test('envelope list parses and status variants work', () {
      final model = WalletHistoryModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': [
          {'id': 1, 'amount': 100, 'type': 'credit'},
          {'id': 2, 'amount': 50, 'type': 'debit'},
        ],
      });
      expect(model.status, isTrue);
      expect(model.history?.length, 2);
      expect(model.history?.first.id, 1);
    });

    test('data as map with transactions key parses', () {
      final model = WalletHistoryModel.fromJson({
        'status': 1,
        'data': {
          'transactions': [
            {'id': 9, 'amount': '75.5', 'type': 'credit'},
          ],
        },
      });
      expect(model.status, isTrue);
      expect(model.history?.length, 1);
      expect(model.history?.single.amount, 75.5);
    });

    test('status variants 0/"true"/"1" parse', () {
      expect(WalletHistoryModel.fromJson({'status': 1}).status, isTrue);
      expect(WalletHistoryModel.fromJson({'status': '1'}).status, isTrue);
      expect(WalletHistoryModel.fromJson({'status': 'true'}).status, isTrue);
      expect(WalletHistoryModel.fromJson({'status': 0}).status, isFalse);
    });

    test('isCredit classification handles debit/credit/arabic keywords', () {
      expect(WalletHistoryItem.fromJson({'type': 'debit'}).isCredit, isFalse);
      expect(WalletHistoryItem.fromJson({'type': 'withdraw'}).isCredit, isFalse);
      expect(WalletHistoryItem.fromJson({'type': 'خصم'}).isCredit, isFalse);
      expect(WalletHistoryItem.fromJson({'type': 'credit'}).isCredit, isTrue);
      expect(WalletHistoryItem.fromJson({'type': 'topup'}).isCredit, isTrue);
    });

    test('junk entries in the list are skipped, not crashing', () {
      final model = WalletHistoryModel.fromJson({
        'status': true,
        'data': [
          {'id': 1},
          '{not json yet}',
          42,
          {'id': 2},
        ],
      });
      expect(model.history?.length, 2);
    });
  });

  group('WalletCubit', () {
    test('getHistory success emits success with parsed list', () async {
      final repo = FakeWalletRepos();
      final cubit = WalletCubit(repo);

      await cubit.getHistory();

      expect(repo.getHistoryCalls, 1);
      expect(cubit.state, isA<GetWalletHistorySuccessState>());
      expect(cubit.history.length, 2);
    });

    test('getHistory failure emits error with message', () async {
      final repo = FakeWalletRepos()..failGetHistory = true;
      final cubit = WalletCubit(repo);

      await cubit.getHistory();

      expect(cubit.state, isA<GetWalletHistoryErrorState>());
      expect((cubit.state as GetWalletHistoryErrorState).error, 'offline');
    });

    test('topUp success passes the reference through to repo', () async {
      final repo = FakeWalletRepos();
      final cubit = WalletCubit(repo);

      await cubit.topUp(
        amount: '250',
        paymentMethod: 'instapay',
        receiptPath: '/tmp/receipt.jpg',
        transferReference: 'REF123',
      );

      expect(repo.topUpCalls, 1);
      expect(repo.lastTopUpMethod, 'instapay');
      expect(cubit.state, isA<TopUpSuccessState>());
    });

    test('topUp failure surfaces error', () async {
      final repo = FakeWalletRepos()..failTopUp = true;
      final cubit = WalletCubit(repo);

      await cubit.topUp(
        amount: '100',
        paymentMethod: 'wallet',
        receiptPath: '/tmp/r.jpg',
      );

      expect(cubit.state, isA<TopUpErrorState>());
      expect((cubit.state as TopUpErrorState).error, 'rejected');
    });
  });
}
