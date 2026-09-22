import 'package:by3ly/features/allCategories/data/models/all_categoies_model.dart';

import '../../data/models/add_remove_product_to_fav_model.dart';
import '../../data/models/home_model.dart';

abstract class HomeStates{}

class HomeInitState extends HomeStates {}

class GetHomeDataLoading extends HomeStates {}

class GetHomeDataSuccess extends HomeStates {
  final HomeModel homeModel;
  GetHomeDataSuccess(this.homeModel);
}

class GetHomeDataError extends HomeStates {
  final String message;
  GetHomeDataError(this.message);
}


class AddRemoveProductToFavLoadingState extends HomeStates {}

class AddRemoveProductToFavSuccessState extends HomeStates {
  final AddRemoveProductToFavModel addRemoveProductToFavModel;
  AddRemoveProductToFavSuccessState(this.addRemoveProductToFavModel);
}

class AddRemoveProductToFavErrorState extends HomeStates {
  final String message;
  AddRemoveProductToFavErrorState(this.message);
}
