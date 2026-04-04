import 'package:flutter/material.dart';

Duration get dialogSlidingFadeTransitionDuration =>
    const Duration(milliseconds: 500);

Widget dialogSlideFadeTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final curvedAnimation = CurvedAnimation(
    parent: animation,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );

  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(curvedAnimation),
    child: FadeTransition(opacity: curvedAnimation, child: child),
  );
}
