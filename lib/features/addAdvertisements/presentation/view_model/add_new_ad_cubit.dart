import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/repos/add_advertisements_repos.dart';
import 'add_new_ad_states.dart';

/// Form state for the new unified create-ad screen.
///
/// Spec: name, description, price, discount, is_negotiable (1/0,
/// default 0), is_urgent (0/1), listing_type always "sale",
/// category + dependent sub-category, images[] (1..3), shipping_type
/// (free/paid), condition (new/used), city_id + center_id defaulting
/// to the user's own data but changeable in the form.
class AddNewAdCubit extends Cubit<AddNewAdStates> {
  AddNewAdCubit(this.addAdvertisementsRepos) : super(AddNewAdInit());

  static AddNewAdCubit get(context) => BlocProvider.of(context);

  AddAdvertisementsRepos? addAdvertisementsRepos;

  final nameCon = TextEditingController();
  final descCon = TextEditingController();
  final priceCon = TextEditingController();
  final discountCon = TextEditingController();

  final ImagePicker picker = ImagePicker();
  List<File> images = [];
  static const int maxImages = 3;

  int? categoryId;
  int? subCategoryId;

  /// 1 = negotiable (قابل للتفاوض), 0 = fixed (default).
  int isNegotiable = 0;

  /// 1 = urgent, 0 = normal (default).
  int isUrgent = 0;

  /// 'free' (مجاني) or 'paid' (بتكلفة شحن). Default free.
  String shippingType = 'free';

  /// 'new' (جديد) or 'used' (مستعمل). Default new.
  String condition = 'new';

  int? cityId;
  int? centerId;

  /// Edit mode: id of the ad being edited + its current image urls.
  int? editingAdId;
  List<String> existingImages = [];

  bool get isEditMode => editingAdId != null;

  int get totalImagesCount => images.length + existingImages.length;

  @override
  Future<void> close() {
    nameCon.dispose();
    descCon.dispose();
    priceCon.dispose();
    discountCon.dispose();
    return super.close();
  }

  /// Pre-fill city/center from the user's profile data.
  void initLocation({int? defaultCityId, int? defaultCenterId}) {
    cityId ??= defaultCityId;
    centerId ??= defaultCenterId;
  }

  Future<void> pickFromCamera(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    if (totalImagesCount >= maxImages) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Max 3 images')),
      );
      return;
    }
    final x = await picker.pickImage(source: ImageSource.camera);
    if (x != null) {
      images = [...images, File(x.path)];
      emit(AddNewAdImagesChanged());
    }
  }

  Future<void> pickImages(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    const warning =
        SnackBar(content: Text('Max 3 images'));
    final selected = await picker.pickMultiImage();
    if (selected.isEmpty) return;
    final room = maxImages - totalImagesCount;
    if (room <= 0) {
      messenger.showSnackBar(warning);
      emit(AddNewAdImagesChanged());
      return;
    }
    images = [
      ...images,
      ...selected.take(room).map((x) => File(x.path)),
    ];
    if (selected.length > room) {
      messenger.showSnackBar(warning);
    }
    emit(AddNewAdImagesChanged());
  }

  void removeImage(int index) {
    if (index < 0 || index >= images.length) return;
    images.removeAt(index);
    emit(AddNewAdImagesChanged());
  }

  void selectCategory(int? id) {
    categoryId = id;
    // Sub-category always depends on the chosen category.
    subCategoryId = null;
    emit(AddNewAdSelectionChanged());
  }

  void selectSubCategory(int? id) {
    subCategoryId = id;
    emit(AddNewAdSelectionChanged());
  }

  void toggleNegotiable(bool value) {
    isNegotiable = value ? 1 : 0;
    emit(AddNewAdSelectionChanged());
  }

  void toggleUrgent(bool value) {
    isUrgent = value ? 1 : 0;
    emit(AddNewAdSelectionChanged());
  }

  void selectShipping(String value) {
    shippingType = value;
    emit(AddNewAdSelectionChanged());
  }

  void selectCondition(String value) {
    condition = value;
    emit(AddNewAdSelectionChanged());
  }

  void selectCity(int? id) {
    cityId = id;
    // Center always depends on the chosen city.
    centerId = null;
    emit(AddNewAdSelectionChanged());
  }

  void selectCenter(int? id) {
    centerId = id;
    emit(AddNewAdSelectionChanged());
  }

  /// Pre-fill the form from an existing ad for editing.
  /// City/center fall back to the user's profile data when the ad
  /// doesn't carry them.
  void fillForEdit({
    required int adId,
    String? name,
    String? description,
    String? price,
    String? discount,
    int? negotiable,
    int? urgent,
    int? categoryId,
    int? subCategoryId,
    String? shipping,
    String? conditionValue,
    int? cityIdValue,
    int? centerIdValue,
    List<String> imageUrls = const [],
    int? profileCityId,
    int? profileCenterId,
  }) {
    editingAdId = adId;
    nameCon.text = name ?? '';
    descCon.text = description ?? '';
    priceCon.text = price ?? '';
    discountCon.text = discount ?? '';
    isNegotiable = negotiable ?? 0;
    isUrgent = urgent ?? 0;
    this.categoryId = categoryId;
    this.subCategoryId = subCategoryId;
    if (shipping == 'paid' || shipping == 'free') {
      shippingType = shipping!;
    }
    if (conditionValue == 'new' || conditionValue == 'used') {
      condition = conditionValue!;
    }
    cityId = cityIdValue ?? profileCityId;
    centerId = centerIdValue ?? profileCenterId;
    existingImages = imageUrls.where((u) => u.trim().isNotEmpty).toList();
  }

  void removeExistingImage(int index) {
    if (index < 0 || index >= existingImages.length) return;
    existingImages.removeAt(index);
    emit(AddNewAdImagesChanged());
  }

  /// Returns an error message key-free string when something is missing.
  String? validate() {
    if (totalImagesCount < 1) return 'imagesRequired';
    if (nameCon.text.trim().isEmpty) return 'nameRequired';
    if (descCon.text.trim().isEmpty) return 'descRequired';
    if (priceCon.text.trim().isEmpty) return 'priceRequired';
    if (categoryId == null) return 'categoryRequired';
    if (subCategoryId == null) return 'subCategoryRequired';
    if (cityId == null) return 'cityRequired';
    if (centerId == null) return 'centerRequired';
    return null;
  }

  Future<void> submit({
    required String paymentMethod,
    String? receiptPath,
  }) async {
    emit(AddNewAdLoading());
    final result = await addAdvertisementsRepos!.addNewAd(      name: nameCon.text.trim(),
      description: descCon.text.trim(),
      price: priceCon.text.trim(),
      discount:
          discountCon.text.trim().isEmpty ? null : discountCon.text.trim(),
      isNegotiable: isNegotiable,
      isUrgent: isUrgent,
      categoryId: categoryId!,
      subCategoryId: subCategoryId!,
      shippingType: shippingType,
      condition: condition,
      cityId: cityId!,
      centerId: centerId!,
      images: images,
      paymentMethod: paymentMethod,
      receiptPath: receiptPath,
    );
    return result.fold((failure) {
      debugPrint('AddNewAdCubit submit failed: ${failure.errMessage}');
      emit(AddNewAdError(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        emit(AddNewAdSuccess(data.message));
      } else {
        emit(AddNewAdError(data.message ?? 'Something went wrong'));
      }
    });
  }

  Future<void> submitEdit() async {
    final adId = editingAdId;
    if (adId == null) {
      emit(AddNewAdError('Something went wrong'));
      return;
    }
    emit(AddNewAdLoading());
    final result = await addAdvertisementsRepos!.editAd(
      adId: adId,
      name: nameCon.text.trim(),
      description: descCon.text.trim(),
      price: priceCon.text.trim(),
      discount:
          discountCon.text.trim().isEmpty ? null : discountCon.text.trim(),
      isNegotiable: isNegotiable,
      isUrgent: isUrgent,
      categoryId: categoryId!,
      subCategoryId: subCategoryId!,
      shippingType: shippingType,
      condition: condition,
      cityId: cityId!,
      centerId: centerId!,
      images: images,
    );
    return result.fold((failure) {
      debugPrint('AddNewAdCubit submitEdit failed: ${failure.errMessage}');
      emit(AddNewAdError(failure.errMessage));
    }, (data) {
      if (data.status == true) {
        emit(AddNewAdSuccess(data.message));
      } else {
        emit(AddNewAdError(data.message ?? 'Something went wrong'));
      }
    });
  }
}
