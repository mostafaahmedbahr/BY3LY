import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../models/packages_model.dart';
import '../models/payment_methods_model.dart';
import '../models/subscribe_package_model.dart';

abstract class PackagesRepos {
  Future<Either<Failure, PackagesModel>> getPackages();

  Future<Either<Failure, PaymentMethodsModel>> getPaymentMethods();

  /// Wallet checkout: {package_id, payment_method}.
  /// Transfer checkout: same + receipt image (multipart).
  Future<Either<Failure, SubscribePackageModel>> checkout({
    required int packageId,
    required String paymentMethod,
    String? receiptPath,
  });
}
