import 'dart:async';

import 'package:by3ly/core/errors/failure.dart';
import 'package:by3ly/features/deleteAccount/data/models/delete_account_model.dart';
import 'package:by3ly/features/deleteAccount/data/repos/delete_account_repos.dart';
import 'package:by3ly/features/deleteAccount/presentation/view_model/delete_account_cubit.dart';
import 'package:by3ly/features/deleteAccount/presentation/view_model/delete_account_states.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeDeleteAccountRepos implements DeleteAccountRepos {
  int calls = 0;
  bool shouldFail = false;

  /// Body of the fake envelope, e.g. {'status': true, 'message': 'ok'}.
  Map<String, dynamic> response = {'status': true, 'message': 'تم حذف الحساب'};

  Completer<void>? gate;

  @override
  Future<Either<Failure, DeleteAccountModel>> deleteAccount() async {
    calls++;
    if (gate != null) await gate!.future;
    if (shouldFail) return Left(ServerFailure('offline'));
    return Right(DeleteAccountModel.fromJson(response));
  }
}

void main() {
  group('DeleteAccountCubit', () {
    test('success emits Loading then Success and stores the model', () async {
      final repo = FakeDeleteAccountRepos();
      final cubit = DeleteAccountCubit(repo);

      await cubit.deleteAccount();

      expect(repo.calls, 1);
      expect(cubit.state, isA<DeleteAccountSuccess>());
      expect(cubit.deleteAccountModel?.status, isTrue);
      expect(cubit.deleteAccountModel?.message, 'تم حذف الحساب');
    });

    test('failure emits Loading then Error with failure message', () async {
      final repo = FakeDeleteAccountRepos()..shouldFail = true;
      final cubit = DeleteAccountCubit(repo);

      await cubit.deleteAccount();

      expect(cubit.state, isA<DeleteAccountError>());
      expect((cubit.state as DeleteAccountError).message, 'offline');
    });

    test('status false with server message emits Error(message)', () async {
      final repo = FakeDeleteAccountRepos()
        ..response = {'status': false, 'message': 'لا يمكن حذف الحساب'};
      final cubit = DeleteAccountCubit(repo);

      await cubit.deleteAccount();

      expect(cubit.state, isA<DeleteAccountError>());
      expect((cubit.state as DeleteAccountError).message,
          'لا يمكن حذف الحساب');
    });

    test('status false without message emits Error(null) for localized fallback', () async {
      final repo = FakeDeleteAccountRepos()..response = {'status': false};
      final cubit = DeleteAccountCubit(repo);

      await cubit.deleteAccount();

      expect(cubit.state, isA<DeleteAccountError>());
      expect((cubit.state as DeleteAccountError).message, isNull);
    });

    test('double tap during a request issues a single API call', () async {
      final repo = FakeDeleteAccountRepos()..gate = Completer<void>();
      final cubit = DeleteAccountCubit(repo);

      final first = cubit.deleteAccount();
      final second = cubit.deleteAccount(); // should be a no-op
      repo.gate!.complete();
      await Future.wait([first, second]);

      expect(repo.calls, 1);
    });
  });

  group('DeleteAccountModel parsing', () {
    test('status as 1 and as "1" parses to true', () {
      expect(DeleteAccountModel.fromJson({'status': 1}).status, isTrue);
      expect(DeleteAccountModel.fromJson({'status': '1'}).status, isTrue);
      expect(DeleteAccountModel.fromJson({'status': true}).status, isTrue);
    });

    test('status as 0 and as "0" parses to false', () {
      expect(DeleteAccountModel.fromJson({'status': 0}).status, isFalse);
      expect(DeleteAccountModel.fromJson({'status': '0'}).status, isFalse);
      expect(DeleteAccountModel.fromJson({'status': false}).status, isFalse);
    });

    test('number as int and as string parses', () {
      expect(DeleteAccountModel.fromJson({'number': 42}).number, 42);
      expect(DeleteAccountModel.fromJson({'number': '42'}).number, 42);
      expect(DeleteAccountModel.fromJson({'number': 'x'}).number, isNull);
    });

    test('empty payload stays null instead of crashing', () {
      final model = DeleteAccountModel.fromJson(const <String, dynamic>{});
      expect(model.status, isNull);
      expect(model.number, isNull);
      expect(model.message, isNull);
    });
  });
}
