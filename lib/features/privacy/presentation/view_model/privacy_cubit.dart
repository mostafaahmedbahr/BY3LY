import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/settings_model.dart';
import '../../data/repos/privacy_repo.dart';
import 'privacy_states.dart';

class PrivacyCubit extends Cubit<PrivacyStates> {
  PrivacyCubit([this.privacyRepo]) : super(PrivacyInitState());

  final PrivacyRepo? privacyRepo;

  static PrivacyCubit get(BuildContext context) => BlocProvider.of(context);

  SettingsModel? settingsModel;
  Settings? settings;

  int wayIndex = 1;
  bool notifyNewProducts = true;
  bool isSaving = false;

  var phoneNumberCon = TextEditingController();

  /// Contact methods provided by the backend, in the order it wants them
  /// displayed. Falls back to the three built-in methods before the first
  /// `GET settings` response arrives.
  List<String> get contactMethodValues {
    final values = settings?.contactMethods
        ?.map((e) => e.value?.trim() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
    if (values != null && values.isNotEmpty) return values;
    return const ['chat', 'phone', 'both'];
  }

  String get selectedContactMethod {
    final values = contactMethodValues;
    final index = wayIndex - 1;
    if (index >= 0 && index < values.length) return values[index];
    return values.first;
  }

  bool _isFetchingSettings = false;

  Future<void> getSettings() async {
    if (privacyRepo == null || _isFetchingSettings) return;
    _isFetchingSettings = true;
    emit(GetSettingsLoadingState());

    final result = await privacyRepo!.getSettings();
    _isFetchingSettings = false;
    if (isClosed) return;

    result.fold((failure) => emit(GetSettingsErrorState(failure.errMessage)), (
      data,
    ) {
      final loaded = data.data?.settings;
      if (data.status != true || loaded == null) {
        emit(GetSettingsErrorState(data.message ?? 'Something went wrong'));
        return;
      }
      settingsModel = data;
      _applySettings(loaded);
      emit(GetSettingsSuccessState(data));
    });
  }

  Future<void> saveSettings() async {
    if (privacyRepo == null || isSaving) return;
    isSaving = true;
    emit(UpdateSettingsLoadingState());

    final result = await privacyRepo!.updateSettings(
      contactMethod: selectedContactMethod,
      contactPhone: phoneNumberCon.text.trim(),
      notifyNewProducts: notifyNewProducts,
      storeName: settings?.storeName,
      storeAddress: settings?.storeAddress,
    );

    isSaving = false;
    if (isClosed) return;

    result.fold(
      (failure) => emit(UpdateSettingsErrorState(failure.errMessage)),
      (data) {
        if (data.status != true) {
          emit(
            UpdateSettingsErrorState(data.message ?? 'Something went wrong'),
          );
          return;
        }
        final updated = data.data?.settings;
        if (updated != null) {
          settingsModel = data;
          _applySettings(updated);
        }
        emit(
          UpdateSettingsSuccessState(
            message: data.message,
            settingsModel: data,
          ),
        );
      },
    );
  }

  void _applySettings(Settings value) {
    settings = value;
    notifyNewProducts = value.notifyNewProducts ?? true;
    phoneNumberCon.text = value.contactPhone ?? '';

    final values = contactMethodValues;
    final index = values.indexOf(value.contactMethod ?? '');
    wayIndex = index >= 0 ? index + 1 : 1;
  }

  void changeConnectionWay(int index) {
    wayIndex = index;
    emit(PrivacyChangeConnectionWayState());
  }

  void changeNotifyNewProducts(bool value) {
    notifyNewProducts = value;
    emit(PrivacyChangeNotifyNewProductsState());
  }
}
