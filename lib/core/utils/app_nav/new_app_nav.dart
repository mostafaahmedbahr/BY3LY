import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NewAppNav {
  static void customNavigator({
    required BuildContext context,
    required Widget screen,
    bool finish = false,
  }) {
    finish
        ? Navigator.pushAndRemoveUntil(
            context,
            PageTransition(type: PageTransitionType.fade, child: screen),
            (Route<dynamic> route) => false,
          )
        : Navigator.push(
            context,
            PageTransition(type: PageTransitionType.fade, child: screen),
          );
  }
}
