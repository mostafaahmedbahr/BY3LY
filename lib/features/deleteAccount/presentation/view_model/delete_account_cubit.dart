import 'package:bloc/bloc.dart';
import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';
import 'package:by3ly/features/allCategories/data/repositories/all_categories_repo.dart';
import 'package:by3ly/features/allCategories/presentation/view_model/states.dart';

import '../../data/models/delete_account_model.dart';
import '../../data/repos/delete_account_repos.dart';
import 'delete_account_states.dart';


class DeleteAccountCubit extends Cubit<DeleteAccountStates> {
  DeleteAccountCubit(this.deleteAccountRepos) : super(DeleteAccountInitState());

  DeleteAccountRepos? deleteAccountRepos;
  DeleteAccountModel? deleteAccountModel;

  List<Categories> allCategoriesList=[];
  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    var result = await deleteAccountRepos!.deleteAccount();
    return result.fold((failure) {
      emit(DeleteAccountError(failure.errMessage));
    }, (data) {
      if(data.status==true){
        deleteAccountModel = data;
        emit(DeleteAccountSuccess(data));
      }
      else{
        emit(DeleteAccountError(data.message!));
      }
    });
  }
}
