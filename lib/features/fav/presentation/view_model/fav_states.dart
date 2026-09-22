
import 'package:by3ly/core/general_models/general_model.dart';

import '../../data/models/fav_model.dart';

abstract class FavStates{}

class FavInitState extends FavStates {}

class GetFavDataLoading extends FavStates {}

class GetFavDataSuccess extends FavStates {
  final FavDataModel favDataModel;
  GetFavDataSuccess(this.favDataModel);
}

class GetFavDataError extends FavStates {
  final String message;
  GetFavDataError(this.message);
}

class RemoveProductFromFavLoading extends FavStates {}

class RemoveProductFromFavSuccess extends FavStates {
  final GeneralModel removeProductFromFavModel;
  RemoveProductFromFavSuccess(this.removeProductFromFavModel);
}

class RemoveProductFromFavError extends FavStates {
  final String message;
  RemoveProductFromFavError(this.message);
}
