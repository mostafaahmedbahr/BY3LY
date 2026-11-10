  import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:by3ly/features/howToMakePurchase/data/repos/how_to_make_purchase_repos.dart';
import 'package:by3ly/features/howToMakePurchase/presentation/view_model/how_to_make_purchase_states.dart';


class HowToMakePurchaseCubit extends Cubit<HowToMakePurchaseStates> {
  HowToMakePurchaseCubit(this.howToMakePurchaseRepos) : super(HowToMakePurchaseInitState());

  static HowToMakePurchaseCubit get(BuildContext context) =>
      BlocProvider.of<HowToMakePurchaseCubit>(context);

  final HowToMakePurchaseRepos howToMakePurchaseRepos;
  HowToMakePurchaseModel? howToMakePurchaseModel;

  Future<void> getHowToMakePurchaseData() async {
    emit(GetHowToMakePurchaseDataLoadingState());
    final result = await howToMakePurchaseRepos.getHowToMakePurchaseData();
    return result.fold((failure) {
      debugPrint('HowToMakePurchaseCubit failed: ${failure.errMessage}');
      emit(GetHowToMakePurchaseDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        howToMakePurchaseModel = data;
        emit(GetHowToMakePurchaseDataSuccessState(data));
      }
      else{
        emit(GetHowToMakePurchaseDataErrorState(
            data.message ?? 'Something went wrong'));
      }
    });
  }




}
