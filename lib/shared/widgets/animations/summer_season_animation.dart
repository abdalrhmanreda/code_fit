import 'dart:math' as math;
import 'package:flutter/material.dart';

class SummerSeasonAnimation extends StatefulWidget {
  final double size;

  const SummerSeasonAnimation({super.key, this.size = 200});

  @override
  State<SummerSeasonAnimation> createState() => _SummerSeasonAnimationState();
}

class _SummerSeasonAnimationState extends State<SummerSeasonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SunPainter(_controller.value),
        );
      },
    );
  }
}

class _SunPainter extends CustomPainter {
  final double progress;

  _SunPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 4;

    final sunPaint = Paint()
      ..color =
          const Color(0xFFFFD700) // Gold
      ..style = PaintingStyle.fill;

    // Draw Sun Body
    canvas.drawCircle(center, radius, sunPaint);

    // Draw Rays
    final rayPaint = Paint()
      ..color =
          const Color(0xFFFF8C00) // DarkOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final rayCount = 12;
    final rayLength = radius * 0.8;
    final angleStep = (2 * math.pi) / rayCount;

    for (int i = 0; i < rayCount; i++) {
      final angle = (i * angleStep) + (progress * 2 * math.pi);
      final start = Offset(
        center.dx + math.cos(angle) * (radius + 5),
        center.dy + math.sin(angle) * (radius + 5),
      );
      final end = Offset(
        center.dx + math.cos(angle) * (radius + 5 + rayLength),
        center.dy + math.sin(angle) * (radius + 5 + rayLength),
      );
      canvas.drawLine(start, end, rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SunPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
