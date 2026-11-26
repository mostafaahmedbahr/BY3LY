import 'package:by3ly/features/addAdvertisements/data/models/current_subscription_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tomorrow = DateTime.now().add(const Duration(days: 1)).toIso8601String();
  final yesterday = DateTime.now().subtract(const Duration(days: 1))
      .toIso8601String();

  group('CurrentSubscriptionModel.isCovered', () {
    test('remaining_ads > 0 with a future ends_at is covered', () {
      final model = CurrentSubscriptionModel.fromJson({
        'status': 'active',
        'data': {
          'status': 'active',
          'is_expired': false,
          'ads_limit': 5,
          'used_ads': 2,
          'remaining_ads': 3,
          'ends_at': tomorrow,
        },
      });
      expect(model.remainingAds, 3);
      expect(model.endsAt, tomorrow);
      expect(model.isCovered, isTrue);
    });

    test('remaining_ads == 0 forces the payment step', () {
      final model = CurrentSubscriptionModel.fromJson({
        'status': true,
        'data': {
          'remaining_ads': 0,
          'ads_limit': 5,
          'ends_at': tomorrow,
        },
      });
      expect(model.isCovered, isFalse);
    });

    test('passed ends_at is not covered even with ads left', () {
      final model = CurrentSubscriptionModel.fromJson({
        'status': true,
        'data': {
          'remaining_ads': 4,
          'ends_at': yesterday,
        },
      });
      expect(model.isEnded, isTrue);
      expect(model.isCovered, isFalse);
    });

    test('expired flag is not covered', () {
      final model = CurrentSubscriptionModel.fromJson({
        'data': {
          'remaining_ads': 4,
          'is_expired': 1,
          'ends_at': tomorrow,
        },
      });
      expect(model.isCovered, isFalse);
    });

    test('bare subscription object is parsed (bool status is fine)', () {
      final model = CurrentSubscriptionModel.fromJson({
        'status': true,
        'remaining_ads': '2',
        'ends_at': tomorrow,
      });
      expect(model.remainingAds, 2);
      expect(model.isCovered, isTrue);
    });

    test('no subscription payload is not covered', () {
      final model = CurrentSubscriptionModel.fromJson({
        'status': false,
        'message': 'no active subscription',
      });
      expect(model.isCovered, isFalse);
    });

    test('unlimited package falls back when remaining_ads is missing', () {
      final model = CurrentSubscriptionModel.fromJson({
        'data': {'ads_limit': 0, 'used_ads': 7},
      });
      expect(model.isCovered, isTrue);
    });
  });
}
