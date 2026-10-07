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
