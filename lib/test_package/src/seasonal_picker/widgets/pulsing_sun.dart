import 'package:flutter/material.dart';
import 'dart:math' as math;

class PulsingSun extends StatelessWidget {
  final AnimationController controller;

  const PulsingSun({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final scale = 1.0 + math.sin(controller.value * math.pi * 2) * 0.1;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xFFFCD34D), const Color(0xFFFBBF24)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(8, (index) {
                return Transform.rotate(
                  angle:
                      (index * math.pi / 4) + (controller.value * math.pi / 4),
                  child: Container(
                    width: 4,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xFFFCD34D),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
