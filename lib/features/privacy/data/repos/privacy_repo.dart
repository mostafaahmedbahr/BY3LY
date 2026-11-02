import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/settings_model.dart';

abstract class PrivacyRepo {
  Future<Either<Failure, SettingsModel>> getSettings();

  Future<Either<Failure, SettingsModel>> updateSettings({
    required String contactMethod,
    required String contactPhone,
    required bool notifyNewProducts,
    String? storeName,
    String? storeAddress,
  });
}
