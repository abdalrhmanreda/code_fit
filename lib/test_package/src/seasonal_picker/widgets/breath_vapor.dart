import 'package:flutter/material.dart';

class BreathVapor extends StatelessWidget {
  final double progress;

  const BreathVapor({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final breathCycle = (progress % 0.5) / 0.5;
    final opacity = breathCycle < 0.3
        ? breathCycle / 0.3
        : breathCycle < 0.7
        ? 1.0
        : 1.0 - ((breathCycle - 0.7) / 0.3);

    if (opacity <= 0) return const SizedBox.shrink();

    return Transform.translate(
      offset: Offset(0, -breathCycle * 30),
      child: Opacity(
        opacity: opacity.clamp(0.0, 0.5),
        child: Container(
          width: 30,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.3),
                blurRadius: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
