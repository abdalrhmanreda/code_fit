import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackgroundCircles extends StatelessWidget {
  final Animation<double> pulseAnimation;

  const AnimatedBackgroundCircles({super.key, required this.pulseAnimation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildCircle(0.3, 100, const Offset(-50, -50)),
        _buildCircle(0.5, 150, const Offset(200, 100)),
        _buildCircle(0.7, 120, const Offset(-30, 400)),
        _buildCircle(0.4, 180, const Offset(150, 600)),
      ],
    );
  }

  Widget _buildCircle(double animationPhase, double size, Offset position) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Transform.scale(
        scale:
            1.0 +
            (math.sin(pulseAnimation.value * 2 * math.pi + animationPhase) *
                0.1),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.05),
          ),
        ),
      ),
    );
  }
}
