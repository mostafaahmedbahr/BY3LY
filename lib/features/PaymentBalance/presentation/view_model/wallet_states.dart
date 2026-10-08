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
