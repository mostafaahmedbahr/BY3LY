import '../../data/models/how_to_make_purchase_model.dart';

abstract class HowToMakePurchaseStates{}

class HowToMakePurchaseInitState extends HowToMakePurchaseStates{}

class GetHowToMakePurchaseDataLoadingState extends HowToMakePurchaseStates{}
class GetHowToMakePurchaseDataSuccessState extends HowToMakePurchaseStates{
  final HowToMakePurchaseModel howToMakePurchaseModel;
  GetHowToMakePurchaseDataSuccessState(this.howToMakePurchaseModel);

}
class GetHowToMakePurchaseDataErrorState extends HowToMakePurchaseStates{
  final String error;
  GetHowToMakePurchaseDataErrorState(this.error);

}