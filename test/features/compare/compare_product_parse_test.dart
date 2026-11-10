import 'package:by3ly/features/compare/data/models/compare_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CompareModel parsing (tockets from the real API)', () {
    test('data list of product maps is parsed', () {
      final model = CompareModel.fromJson({
        'status': true,
        'message': 'ok',
        'data': [
          {
            'id': 11,
            'name': 'Rocky Top',
            'desc': 'Description here',
            'price': '1500',
            'final_price': '1200',
            'old_price': '1500',
            'currency': 'EGP',
            'image': 'main.jpg',
            'rate': '5',
            'reviews_count': 4,
            'views': 42,
            'type': 'home',
            'model': 'X1',
            'marka': 'BrandA',
            'location': 'Nasr City',
            'city_id': '1',
            'category_id': 9,
            'sub_category_id': 99,
            'listing_type': 'sale',
            'listing_type_label': 'بيع',
            'is_urgent': 1,
            'is_negotiable': false,
            'status': 3,
            'images': [
              {'id': 51, 'image': 'a.jpg'},
              {'id': 52, 'image': 'b.jpg'},
              'c.jpg',
            ],
          },
          {
            'id': 22,
            'name': 'Rocky Top #2',
            'desc': 'desc2',
            'price': '3000',
            'image': 'img2.jpg',
            'rate': '4',
            'seller': {
              'id': 77,
              'name': 'Seller X',
              'image': 'seller.jpg',
              'phone': '01000000000',
              'rating': 5,
              'reviews_count': 10,
            },
          },
        ],
      });
      expect(model.status, isTrue);
      expect(model.data?.products?.length, 2);
      final p = model.data!.products![0];
      expect(p.id, 11);
      expect(p.price, '1500');
      expect(p.finalPrice, 1200);
      expect(p.currency, 'EGP');
      expect(p.imageUrls, ['a.jpg', 'b.jpg', 'c.jpg']);
      expect(p.views, 42);
      expect(p.isUrgent, isTrue);
      expect(p.isNegotiable, isFalse);
      expect(p.status, 3);
      expect(p.listingType, 'sale');
      expect(p.listingTypeLabel, 'بيع');
      expect(p.categoryId, 9);

      final p2 = model.data!.products![1];
      expect(p2.seller?.name, 'Seller X');
      expect(p2.seller?.rating, 5);
    });

    test('data map with products key (Laravel envelope) parses', () {
      final model = CompareModel.fromJson({
        'status': 1,
        'message': 'ok',
        'data': {
          'products': [
            {'id': 1, 'name': 'P1', 'price': '1000'},
            {'id': 2, 'name': 'P2', 'price': '2000'},
          ],
        },
      });
      expect(model.status, isTrue);
      expect(model.data?.products?.length, 2);
    });

    test('images as plain strings parses', () {
      final model = CompareModel.fromJson({
        'status': true,
        'data': {
          'products': [
            {'id': 1, 'name': 'X', 'price': '1000', 'image': 'main.jpg', 'images': ['a.jpg', 'b.jpg']},
          ],
        },
      });
      expect(model.data?.products?.single.imageUrls, ['a.jpg', 'b.jpg']);
    });

    test('status 0 is parsed as false', () {
      final model = CompareModel.fromJson({'status': 0, 'data': null});
      expect(model.status, isFalse);
    });

    test('empty payload produces null data', () {
      final model = CompareModel.fromJson({'status': true});
      expect(model.data, isNull);
    });
  });
}
