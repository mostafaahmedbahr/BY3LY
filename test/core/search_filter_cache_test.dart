import 'package:by3ly/core/utils/search_filter_cache.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SearchDebouncer', () {
    test('rapid keystrokes collapse into a single scheduled update', () {
      fakeAsync((async) {
        final debouncer = SearchDebouncer();
        var calls = 0;

        debouncer(() => calls++);
        async.elapse(const Duration(milliseconds: 90));
        debouncer(() => calls++);
        async.elapse(const Duration(milliseconds: 90));
        expect(calls, 0, reason: 'still inside the debounce window');

        async.elapse(const Duration(milliseconds: 100));
        expect(calls, 1);

        debouncer.dispose();
      });
    });

    test('cancel drops a pending update', () {
      fakeAsync((async) {
        final debouncer = SearchDebouncer();
        var calls = 0;
        debouncer(() => calls++);
        debouncer.cancel();
        async.elapse(const Duration(seconds: 1));
        expect(calls, 0);
      });
    });
  });

  group('FilteredListCache', () {
    test('reuses the same list until the key changes', () {
      final cache = FilteredListCache<int>();
      var computations = 0;
      List<int> compute() {
        computations++;
        return [1, 2, 3];
      }

      final first = cache.get('query|source', compute);
      final second = cache.get('query|source', compute);
      expect(identical(first, second), isTrue);
      expect(computations, 1);

      final third = cache.get('other|source', compute);
      expect(identical(first, third), isFalse);
      expect(computations, 2);
    });

    test('sourceKey changes when the list grows', () {
      final list = <int>[1];
      final before = FilteredListCache.sourceKey(list);
      list.add(2);
      expect(FilteredListCache.sourceKey(list), isNot(before));
    });
  });
}
