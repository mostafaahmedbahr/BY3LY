/// Immutable holder for the filters applied on the products grid.
///
/// Server keys: category_id, sub_category_id, min_price, max_price,
/// city_id, center_id, shipping_type (free/paid), condition (new/used).
/// `both` for shipping/condition means "no filter" (null).
///
/// The place filter uses the same cities/centers data as the
/// ChooseLocation screen and account creation (ChooseLocationCubit).
class ProductsFilter {
  final String? type;
  final double? minPrice;
  final double? maxPrice;
  final int? cityId;
  final String? cityName;
  final int? centerId;
  final String? centerName;
  final int? categoryId;
  final String? categoryName;
  final int? subCategoryId;
  final String? subCategoryName;
  final String? shippingType; // 'free' | 'paid' | null(=both)
  final String? condition; // 'new' | 'used' | null(=both)

  const ProductsFilter({
    this.type,
    this.minPrice,
    this.maxPrice,
    this.cityId,
    this.cityName,
    this.centerId,
    this.centerName,
    this.categoryId,
    this.categoryName,
    this.subCategoryId,
    this.subCategoryName,
    this.shippingType,
    this.condition,
  });

  const ProductsFilter.empty()
      : type = null,
        minPrice = null,
        maxPrice = null,
        cityId = null,
        cityName = null,
        centerId = null,
        centerName = null,
        categoryId = null,
        categoryName = null,
        subCategoryId = null,
        subCategoryName = null,
        shippingType = null,
        condition = null;

  bool get isEmpty =>
      type == null &&
      minPrice == null &&
      maxPrice == null &&
      cityId == null &&
      categoryId == null &&
      subCategoryId == null &&
      shippingType == null &&
      condition == null;

  int get activeCount =>
      (type != null ? 1 : 0) +
      (minPrice != null ? 1 : 0) +
      (maxPrice != null ? 1 : 0) +
      (cityId != null ? 1 : 0) +
      (categoryId != null ? 1 : 0) +
      (subCategoryId != null ? 1 : 0) +
      (shippingType != null ? 1 : 0) +
      (condition != null ? 1 : 0);

  /// Label shown on the active-filter chip, e.g. "القاهرة - مدينة نصر".
  String get placeLabel {
    if (cityName == null) return '';
    if (centerName != null) return '$cityName - $centerName';
    return cityName!;
  }

  /// Exact backend query keys (see products filter API):
  /// category_id, sub_category_id, min_price, max_price,
  /// city_id, center_id, shipping_type, condition.
  /// shipping_type / condition always sent (`both` = no filter).
  /// Numbers are sent as int when whole (100 not 100.0).
  Map<String, dynamic> toQueryParams() {
    final map = <String, dynamic>{};
    if (categoryId != null) map['category_id'] = categoryId;
    if (subCategoryId != null) map['sub_category_id'] = subCategoryId;
    if (minPrice != null) map['min_price'] = _cleanNum(minPrice!);
    if (maxPrice != null) map['max_price'] = _cleanNum(maxPrice!);
    if (cityId != null) map['city_id'] = cityId;
    if (centerId != null) map['center_id'] = centerId;
    map['shipping_type'] = shippingType ?? 'both';
    map['condition'] = condition ?? 'both';
    return map;
  }

  static dynamic _cleanNum(double v) =>
      v == v.roundToDouble() ? v.toInt() : v;

  ProductsFilter copyWith({
    String? type,
    double? minPrice,
    double? maxPrice,
    int? cityId,
    String? cityName,
    int? centerId,
    String? centerName,
    int? categoryId,
    String? categoryName,
    int? subCategoryId,
    String? subCategoryName,
    String? shippingType,
    String? condition,
    bool clearType = false,
    bool clearPrice = false,
    bool clearPlace = false,
    bool clearCategory = false,
    bool clearSubCategory = false,
    bool clearShipping = false,
    bool clearCondition = false,
  }) {
    return ProductsFilter(
      type: clearType ? null : (type ?? this.type),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      cityId: clearPlace ? null : (cityId ?? this.cityId),
      cityName: clearPlace ? null : (cityName ?? this.cityName),
      centerId: clearPlace ? null : (centerId ?? this.centerId),
      centerName: clearPlace ? null : (centerName ?? this.centerName),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName: clearCategory ? null : (categoryName ?? this.categoryName),
      subCategoryId:
          clearSubCategory ? null : (subCategoryId ?? this.subCategoryId),
      subCategoryName:
          clearSubCategory ? null : (subCategoryName ?? this.subCategoryName),
      shippingType: clearShipping ? null : (shippingType ?? this.shippingType),
      condition: clearCondition ? null : (condition ?? this.condition),
    );
  }
}


