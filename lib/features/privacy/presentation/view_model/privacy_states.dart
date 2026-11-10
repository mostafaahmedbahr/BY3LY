import '../../data/models/settings_model.dart';

abstract class PrivacyStates {}

class PrivacyInitState extends PrivacyStates {
  @override
  String toString() => 'PrivacyInitState';
}

class PrivacyChangeConnectionWayState extends PrivacyStates {}

class PrivacyChangeNotifyNewProductsState extends PrivacyStates {}

class GetSettingsLoadingState extends PrivacyStates {}

class GetSettingsSuccessState extends PrivacyStates {
  final SettingsModel settingsModel;
  GetSettingsSuccessState(this.settingsModel);

  @override
  String toString() =>
      'GetSettingsSuccessState(status: ${settingsModel.status})';
}

class GetSettingsErrorState extends PrivacyStates {
  final String error;
  GetSettingsErrorState(this.error);

  @override
  String toString() => 'GetSettingsErrorState(error: $error)';
}

class UpdateSettingsLoadingState extends PrivacyStates {}

class UpdateSettingsSuccessState extends PrivacyStates {
  final String? message;
  final SettingsModel? settingsModel;
  UpdateSettingsSuccessState({this.message, this.settingsModel});

  @override
  String toString() => 'UpdateSettingsSuccessState(message: $message)';
}

class UpdateSettingsErrorState extends PrivacyStates {
  final String error;
  UpdateSettingsErrorState(this.error);

  @override
  String toString() => 'UpdateSettingsErrorState(error: $error)';
}
