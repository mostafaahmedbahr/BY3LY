import 'package:flutter/material.dart';

class AppNav {
  static void customNavigator({
    required BuildContext context,
    required Widget screen,
    required bool finish,
  }) {
    finish
        ? Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => screen),
            (route) => false,
          )
        : Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
  }
}
