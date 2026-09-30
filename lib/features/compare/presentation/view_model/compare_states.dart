import '../../data/models/compare_model.dart';

abstract class CompareStates {}

class CompareInitState extends CompareStates {
  @override
  String toString() => 'CompareInitState';
}

/// Basket of product ids picked for comparison (max 2).
class CompareBasketChanged extends CompareStates {
  final List<int> productIds;
  CompareBasketChanged(this.productIds);

  @override
  String toString() => 'CompareBasketChanged(productIds: $productIds)';
}

class CompareProductsLoading extends CompareStates {
  @override
  String toString() => 'CompareProductsLoading';
}

class CompareProductsSuccess extends CompareStates {
  final CompareModel compareModel;
  CompareProductsSuccess(this.compareModel);

  @override
  String toString() =>
      'CompareProductsSuccess(status: ${compareModel.status})';
}

class CompareProductsError extends CompareStates {
  final String message;
  CompareProductsError(this.message);

  @override
  String toString() => 'CompareProductsError(message: $message)';
}
