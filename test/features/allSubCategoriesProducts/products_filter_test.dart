import 'package:by3ly/features/allSubCategoriesProducts/presentation/views/all_sub_categories_products_widgets/products_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductsFilter basics', () {
    test('default filter is empty', () {
      const filter = ProductsFilter.empty();
      expect(filter.isEmpty, isTrue);
      expect(filter.activeCount, 0);
    });

    test('toQueryParams defaults shipping/condition to both', () {
      const filter = ProductsFilter(categoryId: 3);
      expect(filter.isEmpty, isFalse);
      expect(filter.toQueryParams(), {
        'category_id': 3,
        'shipping_type': 'both',
        'condition': 'both',
      });
    });

    test('activeCount counts each active section', () {
      const filter = ProductsFilter(
        type: 'sale',
        minPrice: 100,
        maxPrice: 2000,
        cityId: 4,
        categoryId: 7,
        subCategoryId: 8,
        shippingType: 'free',
        condition: 'new',
      );
      expect(filter.isEmpty, isFalse);
      expect(filter.activeCount, 8);
    });

    test('activeCount counts price as one even with one bound', () {
      const minOnly = ProductsFilter(minPrice: 100);
      const maxOnly = ProductsFilter(maxPrice: 100);
      expect(minOnly.activeCount, 1);
      expect(maxOnly.activeCount, 1);
      expect(minOnly.isEmpty, isFalse);
    });

    test('placeLabel falls back gracefully', () {
      expect(const ProductsFilter().placeLabel, '');
      expect(const ProductsFilter(cityName: 'القاهرة').placeLabel, 'القاهرة');
      expect(const ProductsFilter(cityName: 'القاهرة', centerName: 'مدينة نصر').placeLabel,
          'القاهرة - مدينة نصر');
    });
  });

  group('toQueryParams', () {
    test('whole numbers are sent as ints', () {
      const filter = ProductsFilter(minPrice: 100.0, maxPrice: 2500.0);
      final params = filter.toQueryParams();
      expect(params['min_price'], 100);
      expect(params['min_price'], isA<int>());
      expect(params['max_price'], 2500);
      expect(params['max_price'], isA<int>());
    });

    test('fractional numbers are kept as doubles', () {
      const filter = ProductsFilter(minPrice: 100.5, maxPrice: 2500.75);
      final params = filter.toQueryParams();
      expect(params['min_price'], 100.5);
      expect(params['max_price'], 2500.75);
    });

    test('full filter maps every backend key', () {
      const filter = ProductsFilter(
        type: 'sale',
        minPrice: 10,
        maxPrice: 9999,
        cityId: 5,
        centerId: 9,
        categoryId: 2,
        subCategoryId: 17,
        shippingType: 'paid',
        condition: 'used',
      );
      expect(filter.toQueryParams(), {
        'min_price': 10,
        'max_price': 9999,
        'city_id': 5,
        'center_id': 9,
        'category_id': 2,
        'sub_category_id': 17,
        'shipping_type': 'paid',
        'condition': 'used',
      });
    });
  });

  group('copyWith', () {
    const base = ProductsFilter(
      type: 'sale',
      minPrice: 10,
      maxPrice: 100,
      cityId: 4,
      cityName: 'Cairo',
      centerId: 6,
      centerName: 'Nasr',
      categoryId: 2,
      categoryName: 'Mobiles',
      subCategoryId: 3,
      subCategoryName: 'iPhones',
      shippingType: 'free',
      condition: 'new',
    );

    test('clearType removes only the type', () {
      final copy = base.copyWith(clearType: true);
      expect(copy.type, isNull);
      expect(copy.minPrice, 10);
      expect(copy.condition, 'new');
    });

    test('clearPrice removes both price bounds', () {
      final copy = base.copyWith(clearPrice: true);
      expect(copy.minPrice, isNull);
      expect(copy.maxPrice, isNull);
      expect(copy.type, 'sale');
    });

    test('clearPlace removes city and center', () {
      final copy = base.copyWith(clearPlace: true);
      expect(copy.cityId, isNull);
      expect(copy.cityName, isNull);
      expect(copy.centerId, isNull);
      expect(copy.centerName, isNull);
      expect(copy.categoryId, 2);
    });

    test('clearCategory removes only the category (sub untouched)', () {
      final copy = base.copyWith(clearCategory: true);
      expect(copy.categoryId, isNull);
      expect(copy.categoryName, isNull);
      expect(copy.subCategoryId, 3);
      expect(copy.subCategoryName, 'iPhones');
      expect(copy.cityId, 4);
    });

    test('clearCategory + clearSubCategory together clear the branch', () {
      final copy =
          base.copyWith(clearCategory: true, clearSubCategory: true);
      expect(copy.categoryId, isNull);
      expect(copy.subCategoryId, isNull);
      expect(copy.subCategoryName, isNull);
      expect(copy.cityId, 4);
    });

    test('clearSubCategory removes only sub-category', () {
      final copy = base.copyWith(clearSubCategory: true);
      expect(copy.subCategoryId, isNull);
      expect(copy.subCategoryName, isNull);
      expect(copy.categoryId, 2);
    });

    test('clearShipping and clearCondition reset each toggle', () {
      final ship = base.copyWith(clearShipping: true);
      expect(ship.shippingType, isNull);
      expect(ship.condition, 'new');

      final cond = base.copyWith(clearCondition: true);
      expect(cond.condition, isNull);
      expect(cond.shippingType, 'free');
    });

    test('copyWith without args keeps everything', () {
      final copy = base.copyWith();
      expect(copy.type, 'sale');
      expect(copy.cityId, 4);
      expect(copy.condition, 'new');
    });
  });
}
