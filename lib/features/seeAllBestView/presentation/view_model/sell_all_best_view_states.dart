import 'package:by3ly/features/seeAllBestView/data/models/sell_all_best_view_model.dart';

abstract class SellAllBestViewStates{}

class SellAllBestViewInitState extends SellAllBestViewStates{}

class GetAllBestViewProductsLoadingState extends SellAllBestViewStates {
  @override
  String toString() => 'GetAllBestViewProductsLoadingState';
}
class GetAllBestViewProductsSuccessState extends SellAllBestViewStates{
  final SellAllBestViewModel sellAllBestViewModel;
  GetAllBestViewProductsSuccessState(this.sellAllBestViewModel);

  @override
  String toString() => 'GetAllBestViewProductsSuccessState';
}
class GetAllBestViewProductsErrorState extends SellAllBestViewStates{
  final String error;
  GetAllBestViewProductsErrorState(this.error);

  @override
  String toString() => 'GetAllBestViewProductsErrorState(error: $error)';
}