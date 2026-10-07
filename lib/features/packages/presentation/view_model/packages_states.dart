import '../../data/models/packages_model.dart';
import '../../data/models/payment_methods_model.dart';
import '../../data/models/subscribe_package_model.dart';

abstract class PackagesStates {}

class PackagesInitState extends PackagesStates {
  @override
  String toString() => 'PackagesInitState';
}

class PackagesDurationChangedState extends PackagesStates {
  @override
  String toString() => 'PackagesDurationChangedState';
}

class GetPackagesLoadingState extends PackagesStates {
  @override
  String toString() => 'GetPackagesLoadingState';
}

class GetPackagesSuccessState extends PackagesStates {
  final PackagesModel packagesModel;
  GetPackagesSuccessState(this.packagesModel);

  @override
  String toString() => 'GetPackagesSuccessState';
}

class GetPackagesErrorState extends PackagesStates {
  final String error;
  GetPackagesErrorState(this.error);

  @override
  String toString() => 'GetPackagesErrorState(error: $error)';
}

class SubscribePackageLoadingState extends PackagesStates {
  final int packageId;
  SubscribePackageLoadingState(this.packageId);

  @override
  String toString() => 'SubscribePackageLoadingState(id: $packageId)';
}

class SubscribePackageSuccessState extends PackagesStates {
  final SubscribePackageModel model;
  SubscribePackageSuccessState(this.model);

  String get message => model.message ?? '';

  @override
  String toString() => 'SubscribePackageSuccessState';
}

class SubscribePackageErrorState extends PackagesStates {
  final String error;
  SubscribePackageErrorState(this.error);

  @override
  String toString() => 'SubscribePackageErrorState(error: $error)';
}

class GetPaymentMethodsLoadingState extends PackagesStates {
  @override
  String toString() => 'GetPaymentMethodsLoadingState';
}

class GetPaymentMethodsSuccessState extends PackagesStates {
  final PaymentMethodsModel methodsModel;
  GetPaymentMethodsSuccessState(this.methodsModel);

  @override
  String toString() => 'GetPaymentMethodsSuccessState';
}

class GetPaymentMethodsErrorState extends PackagesStates {
  final String error;
  GetPaymentMethodsErrorState(this.error);

  @override
  String toString() => 'GetPaymentMethodsErrorState(error: $error)';
}

class PaymentMethodSelectedState extends PackagesStates {
  @override
  String toString() => 'PaymentMethodSelectedState';
}

class ReceiptPickedState extends PackagesStates {
  @override
  String toString() => 'ReceiptPickedState';
}
