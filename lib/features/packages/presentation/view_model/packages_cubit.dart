import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/models/packages_model.dart';
import '../../data/models/payment_methods_model.dart';
import '../../data/repos/packages_repos.dart';
import 'packages_states.dart';

class PackagesCubit extends Cubit<PackagesStates> {
  PackagesCubit(this.packagesRepos) : super(PackagesInitState());

  static PackagesCubit get(BuildContext context) =>
      BlocProvider.of(context);

  PackagesRepos? packagesRepos;
  PackagesModel? packagesModel;

  /// The four duration tabs: monthly / 3 months / 6 months / yearly.
  static const List<Map<String, dynamic>> durations = [
    {'months': 1, 'label': 'شهرى'},
    {'months': 3, 'label': '3 شهور'},
    {'months': 6, 'label': '6 شهور'},
    {'months': 12, 'label': 'سنوى'},
  ];

  int selectedDurationIndex = 0;

  void changeDuration(int index) {
    if (selectedDurationIndex == index) return;
    selectedDurationIndex = index;
    emit(PackagesDurationChangedState());
  }

  List<Packages> get allPackages => packagesModel?.data?.packages ?? [];

  /// Client-side filter by the selected duration tab (durationDays
  /// mapped to 1 / 3 / 6 / 12 months). If no package carries duration
  /// info, everything is shown under every tab so the screen never
  /// ends up empty because of filtering.
  List<Packages> get filteredPackages {
    final all = allPackages;
    if (all.isEmpty) return all;
    final months = durations[selectedDurationIndex]['months'] as int;
    final hasInfo = all.any((p) => p.durationMonths != null);
    if (!hasInfo) return all;
    return all.where((p) => p.durationMonths == months).toList();
  }

  Future<void> getPackages() async {
    emit(GetPackagesLoadingState());
    var result = await packagesRepos!.getPackages();
    return result.fold((failure) {
      emit(GetPackagesErrorState(failure.errMessage));
    }, (data) {
      packagesModel = data;
      emit(GetPackagesSuccessState(data));
    });
  }

  /// The package currently being subscribed to (shows a spinner
  /// on its own button only).
  int? subscribingPackageId;

  /// Wallet checkout: {package_id, payment_method: "wallet"}.
  Future<void> checkoutWithWallet({required int packageId}) async {
    subscribingPackageId = packageId;
    emit(SubscribePackageLoadingState(packageId));
    var result = await packagesRepos!.checkout(
      packageId: packageId,
      paymentMethod: 'wallet',
    );
    subscribingPackageId = null;
    return result.fold((failure) {
      emit(SubscribePackageErrorState(failure.errMessage));
    }, (data) {
      emit(SubscribePackageSuccessState(data));
    });
  }

  // ----- Transfer flow -----

  PaymentMethodsModel? paymentMethodsModel;

  List<PaymentMethod> get paymentMethods =>
      paymentMethodsModel?.data?.methods ?? [];

  PaymentMethod? selectedMethod;

  void selectMethod(PaymentMethod method) {
    selectedMethod = method;
    emit(PaymentMethodSelectedState());
  }

  /// Session-wide cache shared by every instance: the API is called
  /// once, later opens reuse it unless [forceRefresh] is true.
  static PaymentMethodsModel? cachedMethods;

  Future<void> getPaymentMethods({bool forceRefresh = false}) async {
    final cached = cachedMethods ?? paymentMethodsModel;
    if (!forceRefresh && cached != null) {
      // Serve once-fetched methods instantly (one network call
      // per session) and still notify listeners so fresh cubits
      // (e.g. the add-ad sheet) render them.
      paymentMethodsModel = cached;
      final methods = cached.data?.methods ?? [];
      selectedMethod ??=
          methods.isNotEmpty ? methods.first : null;
      emit(GetPaymentMethodsSuccessState(cached));
      return;
    }
    emit(GetPaymentMethodsLoadingState());
    var result = await packagesRepos!.getPaymentMethods();
    return result.fold((failure) {
      emit(GetPaymentMethodsErrorState(failure.errMessage));
    }, (data) {
      paymentMethodsModel = data;
      cachedMethods = data;
      final methods = data.data?.methods ?? [];
      selectedMethod = methods.isNotEmpty ? methods.first : null;
      emit(GetPaymentMethodsSuccessState(data));
    });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? receiptImage;

  Future<void> pickReceipt() async {
    final picked =
        await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    receiptImage = picked;
    emit(ReceiptPickedState());
  }

  void clearTransferForm() {
    receiptImage = null;
    selectedMethod = paymentMethods.isNotEmpty ? paymentMethods.first : null;
  }

  /// Transfer checkout: {package_id, payment_method, receipt image}.
  Future<void> checkoutWithTransfer({required int packageId}) async {
    final method = selectedMethod;
    if (method?.code == null || receiptImage == null) return;
    subscribingPackageId = packageId;
    emit(SubscribePackageLoadingState(packageId));
    var result = await packagesRepos!.checkout(
      packageId: packageId,
      paymentMethod: method!.code!,
      receiptPath: receiptImage!.path,
    );
    subscribingPackageId = null;
    return result.fold((failure) {
      emit(SubscribePackageErrorState(failure.errMessage));
    }, (data) {
      emit(SubscribePackageSuccessState(data));
    });
  }
}
