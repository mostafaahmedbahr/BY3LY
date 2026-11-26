import 'dart:async';

/// Debounces keystrokes so typing a word schedules a single rebuild instead
/// of one rebuild (and one full list filter) per character.
class SearchDebouncer {
  Timer? _timer;

  static const Duration defaultDelay = Duration(milliseconds: 180);

  void call(void Function() action, {Duration delay = defaultDelay}) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();

  void dispose() {
    cancel();
    _timer = null;
  }
}

/// Caches the last filtered result until the query, filters or source list
/// actually change. Rebuilds caused by unrelated cubit states reuse the list
/// instead of re-lowercasing/re-parsing every product.
class FilteredListCache<T> {
  String? _key;
  List<T>? _cached;

  List<T> get(String key, List<T> Function() compute) {
    if (_cached != null && _key == key) return _cached!;
    final result = compute();
    _key = key;
    _cached = result;
    return result;
  }

  /// Identity + length changes when the list is replaced or a new page is
  /// appended (the cubits mutate their cached lists in place).
  static String sourceKey(List<dynamic> source) =>
      '${identityHashCode(source)}:${source.length}';
}
