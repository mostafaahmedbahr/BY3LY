import '../../data/models/sell_all_best_view_model.dart';

abstract class SellAllBestViewStates{}

class SellAllBestViewInitState extends SellAllBestViewStates{}

class GetAllBestViewProductsLoadingState extends SellAllBestViewStates{}
class GetAllBestViewProductsSuccessState extends SellAllBestViewStates{
  final SellAllBestViewModel sellAllBestViewModel;
  GetAllBestViewProductsSuccessState(this.sellAllBestViewModel);
}
class GetAllBestViewProductsErrorState extends SellAllBestViewStates{
  final String error;
  GetAllBestViewProductsErrorState(this.error);
}