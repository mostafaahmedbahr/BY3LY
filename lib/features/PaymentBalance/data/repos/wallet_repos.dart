import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/general_models/general_model.dart';
import '../models/wallet_history_model.dart';

abstract class WalletRepos {
  Future<Either<Failure, WalletHistoryModel>> getHistory();

  Future<Either<Failure, GeneralModel>> topUp({
    required String amount,
    required String paymentMethod,
    required String receiptPath,
  });
}
