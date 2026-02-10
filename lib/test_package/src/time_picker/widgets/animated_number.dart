import 'package:flutter/material.dart';

class AnimatedNumber extends StatelessWidget {
  final int value;
  final Color color;

  const AnimatedNumber({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(animation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: Text(
        value.toString().padLeft(2, '0'),
        key: ValueKey(value),
        style: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w300,
          color: color,
          height: 1,
          letterSpacing: -2,
        ),
      ),
    );
  }
}
