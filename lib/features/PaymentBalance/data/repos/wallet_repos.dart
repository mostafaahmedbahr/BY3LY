import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/wallet_history_model.dart';

abstract class WalletRepos {
  Future<Either<Failure, WalletHistoryModel>> getHistory();
}
