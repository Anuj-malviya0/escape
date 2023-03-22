import 'package:flutter/material.dart';

class FadedSlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final bool direction; // true for left-to-right, false for right-to-left

  FadedSlidePageRoute({required this.page, required this.direction})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final begin = direction ? Offset(1, 0) : Offset(-1, 0);
            final end = Offset.zero;
            final curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
}