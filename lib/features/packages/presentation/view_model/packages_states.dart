import '../../data/models/packages_model.dart';

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
  final String message;
  SubscribePackageSuccessState(this.message);

  @override
  String toString() => 'SubscribePackageSuccessState';
}

class SubscribePackageErrorState extends PackagesStates {
  final String error;
  SubscribePackageErrorState(this.error);

  @override
  String toString() => 'SubscribePackageErrorState(error: $error)';
}
