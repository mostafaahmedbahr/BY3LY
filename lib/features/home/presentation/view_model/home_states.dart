import '../../data/models/home_model.dart';

abstract class HomeStates{}

class HomeInitState extends HomeStates {}

class GetHomeDataLoading extends HomeStates {
  @override
  String toString() => 'GetHomeDataLoading';
}

class GetHomeDataSuccess extends HomeStates {
  final HomeModel homeModel;
  GetHomeDataSuccess(this.homeModel);

  @override
  String toString() =>
      'GetHomeDataSuccess(status: ${homeModel.status}, message: ${homeModel.message})';
}

class GetHomeDataError extends HomeStates {
  final String message;
  GetHomeDataError(this.message);

  @override
  String toString() => 'GetHomeDataError(message: $message)';
}
