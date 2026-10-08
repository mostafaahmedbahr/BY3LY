import '../../data/models/wallet_history_model.dart';

abstract class WalletStates {}

class WalletInitState extends WalletStates {}

class GetWalletHistoryLoadingState extends WalletStates {}

class GetWalletHistorySuccessState extends WalletStates {
  final WalletHistoryModel model;
  GetWalletHistorySuccessState(this.model);
}

class GetWalletHistoryErrorState extends WalletStates {
  final String error;
  GetWalletHistoryErrorState(this.error);
}

class TopUpLoadingState extends WalletStates {}

class TopUpSuccessState extends WalletStates {
  final String message;
  TopUpSuccessState(this.message);
}

class TopUpErrorState extends WalletStates {
  final String error;
  TopUpErrorState(this.error);
}
