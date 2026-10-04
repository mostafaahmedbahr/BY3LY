import 'package:by3ly/features/howToMakePurchase/data/models/how_to_make_purchase_model.dart';

abstract class HowToMakePurchaseStates{}

class HowToMakePurchaseInitState extends HowToMakePurchaseStates{}

class GetHowToMakePurchaseDataLoadingState extends HowToMakePurchaseStates {
  @override
  String toString() => 'GetHowToMakePurchaseDataLoadingState';
}
class GetHowToMakePurchaseDataSuccessState extends HowToMakePurchaseStates{
  final HowToMakePurchaseModel howToMakePurchaseModel;
  GetHowToMakePurchaseDataSuccessState(this.howToMakePurchaseModel);

  @override
  String toString() =>
      'GetHowToMakePurchaseDataSuccessState(title: ${howToMakePurchaseModel.data?.title})';
}
class GetHowToMakePurchaseDataErrorState extends HowToMakePurchaseStates{
  final String error;
  GetHowToMakePurchaseDataErrorState(this.error);

  @override
  String toString() => 'GetHowToMakePurchaseDataErrorState(error: $error)';
}