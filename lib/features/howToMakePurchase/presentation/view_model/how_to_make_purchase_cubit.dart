 import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/how_to_make_purchase_repos.dart';
import 'how_to_make_purchase_states.dart';


class HowToMakePurchaseCubit extends Cubit<HowToMakePurchaseStates> {
  HowToMakePurchaseCubit(this.howToMakePurchaseRepos) : super(HowToMakePurchaseInitState());

  static HowToMakePurchaseCubit get(context) => BlocProvider.of(context);

  HowToMakePurchaseRepos? howToMakePurchaseRepos;
  HowToMakePurchaseModel? howToMakePurchaseModel;
  List<Purchases> allDataHowToMakePurchaseList=[];
  Future<void> getHowToMakePurchaseData() async {
    emit(GetHowToMakePurchaseDataLoadingState());
    var result = await howToMakePurchaseRepos!.getHowToMakePurchaseData();
    return result.fold((failure) {
      emit(GetHowToMakePurchaseDataErrorState(failure.errMessage));
    }, (data) {
      if(data.status==true){
        howToMakePurchaseModel = data;
        allDataHowToMakePurchaseList = allDataHowToMakePurchaseList +
            howToMakePurchaseModel!.data!.purchases!;
        emit(GetHowToMakePurchaseDataSuccessState(data));
      }
      else{
        emit(GetHowToMakePurchaseDataErrorState(data.message.toString()));
      }
    });
  }




}
