
import 'package:by3ly/core/general_models/general_model.dart';

import '../../data/models/fav_model.dart';

abstract class FavStates{}

class FavInitState extends FavStates {
  @override
  String toString() => 'FavInitState';
}

class GetFavDataLoading extends FavStates {
  @override
  String toString() => 'GetFavDataLoading';
}

class GetFavDataSuccess extends FavStates {
  final FavDataModel favDataModel;
  GetFavDataSuccess(this.favDataModel);

  @override
  String toString() =>
      'GetFavDataSuccess(status: ${favDataModel.status})';
}

class GetFavDataError extends FavStates {
  final String message;
  GetFavDataError(this.message);

  @override
  String toString() => 'GetFavDataError(message: $message)';
}

class RemoveProductFromFavLoading extends FavStates {
  @override
  String toString() => 'RemoveProductFromFavLoading';
}

class RemoveProductFromFavSuccess extends FavStates {
  final GeneralModel removeProductFromFavModel;
  RemoveProductFromFavSuccess(this.removeProductFromFavModel);

  @override
  String toString() => 'RemoveProductFromFavSuccess';
}

class RemoveProductFromFavError extends FavStates {
  final String message;
  RemoveProductFromFavError(this.message);

  @override
  String toString() => 'RemoveProductFromFavError(message: $message)';
}

class AddProductToFavLoading extends FavStates {
  @override
  String toString() => 'AddProductToFavLoading';
}

class AddProductToFavSuccess extends FavStates {
  final GeneralModel addProductToFavModel;
  AddProductToFavSuccess(this.addProductToFavModel);

  @override
  String toString() => 'AddProductToFavSuccess';
}

class AddProductToFavError extends FavStates {
  final String message;
  AddProductToFavError(this.message);

  @override
  String toString() => 'AddProductToFavError(message: $message)';
}

/// Optimistic toggle (heart updates instantly, reverted on failure).
class FavToggleOptimistic extends FavStates {
  final int productId;
  final bool isNowFavourite;
  FavToggleOptimistic(this.productId, this.isNowFavourite);

  @override
  String toString() =>
      'FavToggleOptimistic(productId: $productId, isNowFavourite: $isNowFavourite)';
}

class FavToggleSuccess extends FavStates {
  final int productId;
  final bool isNowFavourite;
  final String? message;
  FavToggleSuccess(this.productId, this.isNowFavourite, this.message);

  @override
  String toString() =>
      'FavToggleSuccess(productId: $productId, isNowFavourite: $isNowFavourite)';
}

class FavToggleError extends FavStates {
  final String message;
  FavToggleError(this.message);

  @override
  String toString() => 'FavToggleError(message: $message)';
}
