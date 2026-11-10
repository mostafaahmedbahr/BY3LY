import 'package:by3ly/core/app_services/local_services/cache_helper.dart';
import 'package:by3ly/core/app_services/local_services/cache_token.dart';
import 'package:by3ly/features/layout/presentation/view_model/layout_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/delete_account_model.dart';
import '../../data/repos/delete_account_repos.dart';
import 'delete_account_states.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountStates> {
  DeleteAccountCubit(this.deleteAccountRepos) : super(DeleteAccountInitState());

  static DeleteAccountCubit get(BuildContext context) =>
      BlocProvider.of<DeleteAccountCubit>(context);

  final DeleteAccountRepos deleteAccountRepos;
  DeleteAccountModel? deleteAccountModel;

  Future<void> deleteAccount() async {
    if (state is DeleteAccountLoading) return; // debounce double taps
    emit(DeleteAccountLoading());
    final result = await deleteAccountRepos.deleteAccount();
    result.fold(
      (failure) {
        emit(DeleteAccountError(failure.errMessage));
      },
      (data) {
        if (data.status == true) {
          deleteAccountModel = data;
          emit(DeleteAccountSuccess(data));
        } else {
          final serverMessage = data.message?.trim();
          emit(DeleteAccountError(
            (serverMessage == null || serverMessage.isEmpty)
                ? null
                : serverMessage,
          ));
        }
      },
    );
  }

  /// Wipes local credentials (token + cached profile email) and resets the
  /// bottom-nav index. Call after a successful deletion before routing to
  /// the login screen — a deleted account must never stay "signed in".
  void clearSession() {
    CacheTokenManger.userToken = null;
    CacheTokenManger.clearUserToken(); // async secure-storage wipe
    CacheHelper.removeData(key: "email");
    LayoutCubit.pageIndex = 0;
  }
}
