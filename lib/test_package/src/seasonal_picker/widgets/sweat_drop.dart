import 'package:flutter/material.dart';

class SweatDrop extends StatelessWidget {
  final double progress;
  final double delay;

  const SweatDrop({super.key, required this.progress, required this.delay});

  @override
  Widget build(BuildContext context) {
    final adjusted = (progress + delay) % 1.0;
    final opacity = adjusted < 0.3
        ? adjusted / 0.3
        : 1.0 - ((adjusted - 0.3) / 0.7);

    if (opacity <= 0) return const SizedBox.shrink();

    return Transform.translate(
      offset: Offset(0, adjusted * 40),
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 8,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFF60A5FA).withValues(alpha: 0.7),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
