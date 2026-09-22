import 'package:flutter/widgets.dart';

extension Navigation on BuildContext {
  Future<dynamic> pushNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object? arguments}) {
    return Navigator.of(this)
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName,
      {Object? arguments, required RoutePredicate predicate}) {
    return Navigator.of(this)
        .pushNamedAndRemoveUntil(routeName, predicate, arguments: arguments);
  }

  Future<dynamic> pushNamedAndRemoveAll(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  void pop() => Navigator.of(this).pop();
  void popWithData(dynamic) => Navigator.of(this).pop(dynamic);

  void popUntil(RoutePredicate predicate) =>
      Navigator.of(this).popUntil(predicate);
}

extension StringExtension on String? {
  bool isNullOrEmpty() => this == null || this == "";
}