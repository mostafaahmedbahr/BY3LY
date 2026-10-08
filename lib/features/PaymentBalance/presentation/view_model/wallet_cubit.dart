import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/wallet_history_model.dart';
import '../../data/repos/wallet_repos.dart';
import 'wallet_states.dart';

class WalletCubit extends Cubit<WalletStates> {
  WalletCubit(this.walletRepos) : super(WalletInitState());

  static WalletCubit get(BuildContext context) =>
      BlocProvider.of(context);

  WalletRepos? walletRepos;
  WalletHistoryModel? historyModel;

  List<WalletHistoryItem> get history => historyModel?.history ?? [];

  Future<void> getHistory() async {
    emit(GetWalletHistoryLoadingState());
    var result = await walletRepos!.getHistory();
    return result.fold((failure) {
      emit(GetWalletHistoryErrorState(failure.errMessage));
    }, (data) {
      historyModel = data;
      emit(GetWalletHistorySuccessState(data));
    });
  }

  Future<void> topUp({
    required String amount,
    required String paymentMethod,
    required String receiptPath,
  }) async {
    emit(TopUpLoadingState());
    var result = await walletRepos!.topUp(
      amount: amount,
      paymentMethod: paymentMethod,
      receiptPath: receiptPath,
    );
    return result.fold((failure) {
      emit(TopUpErrorState(failure.errMessage));
    }, (data) {
      emit(TopUpSuccessState(data.message ?? ''));
    });
  }
}
