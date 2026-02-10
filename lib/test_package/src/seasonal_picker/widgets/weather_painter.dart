import 'package:flutter/material.dart';
import '../season.dart';

class WeatherParticle {
  double x;
  double y;
  final double size;
  final double speed;
  final double sway;
  double rotation;
  final double rotationSpeed;

  WeatherParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.sway,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class WeatherPainter extends CustomPainter {
  final List<WeatherParticle> particles;
  final Season season;

  WeatherPainter({required this.particles, required this.season});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      canvas.save();
      canvas.translate(particle.x, particle.y);

      switch (season) {
        case Season.winter:
          _drawSnowflake(canvas, particle, paint);
          break;
        case Season.spring:
          _drawRain(canvas, particle, paint);
          break;
        case Season.summer:
          _drawHeatWave(canvas, particle, paint);
          break;
        case Season.autumn:
          _drawLeaf(canvas, particle, paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawSnowflake(Canvas canvas, WeatherParticle particle, Paint paint) {
    paint.color = Colors.white;
    canvas.drawCircle(Offset.zero, particle.size, paint);
  }

  void _drawRain(Canvas canvas, WeatherParticle particle, Paint paint) {
    paint.color = Colors.blue.withValues(alpha: 0.6);
    paint.strokeWidth = 2.0;
    canvas.drawLine(
      Offset.zero,
      Offset(-particle.size * 0.5, particle.size * 2),
      paint,
    );
  }

  void _drawHeatWave(Canvas canvas, WeatherParticle particle, Paint paint) {
    paint.color = const Color(0xFFFFA500).withValues(alpha: 0.3);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.5;

    final wavePath = Path()
      ..moveTo(-particle.size, 0)
      ..quadraticBezierTo(-particle.size * 0.5, particle.size, 0, 0)
      ..quadraticBezierTo(
        particle.size * 0.5,
        -particle.size,
        particle.size,
        0,
      );

    canvas.drawPath(wavePath, paint);
  }

  void _drawLeaf(Canvas canvas, WeatherParticle particle, Paint paint) {
    canvas.rotate(particle.rotation);

    final colors = [
      const Color(0xFFDC2626),
      const Color(0xFFFB923C),
      const Color(0xFFF59E0B),
    ];
    paint.color = colors[particle.hashCode % colors.length];

    final leafPath = Path()
      ..moveTo(0, -particle.size)
      ..quadraticBezierTo(
        particle.size * 0.8,
        -particle.size * 0.3,
        particle.size * 0.4,
        particle.size,
      )
      ..quadraticBezierTo(
        0,
        particle.size * 0.5,
        -particle.size * 0.4,
        particle.size,
      )
      ..quadraticBezierTo(
        -particle.size * 0.8,
        -particle.size * 0.3,
        0,
        -particle.size,
      )
      ..close();

    canvas.drawPath(leafPath, paint);

    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 0.5;
    paint.color = paint.color.withValues(alpha: 0.5);
    canvas.drawLine(Offset(0, -particle.size), Offset(0, particle.size), paint);
  }

  @override
  bool shouldRepaint(WeatherPainter oldDelegate) => true;
}
