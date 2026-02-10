import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../season.dart';
import 'weather_painter.dart';
import 'pulsing_sun.dart';
import 'seasonal_character.dart';

class SeasonScene extends StatefulWidget {
  final Season season;
  final bool isActive;
  final bool isDialog;

  const SeasonScene({
    super.key,
    required this.season,
    required this.isActive,
    this.isDialog = false,
  });

  @override
  State<SeasonScene> createState() => _SeasonSceneState();
}

class _SeasonSceneState extends State<SeasonScene>
    with TickerProviderStateMixin {
  late AnimationController _idleController;
  late AnimationController _particleController;
  late List<WeatherParticle> _particles;

  @override
  void initState() {
    super.initState();

    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    _initializeParticles();
    _particleController.addListener(_updateParticles);
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(40, (index) {
      return WeatherParticle(
        x: random.nextDouble() * 400,
        y: random.nextDouble() * 800,
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * 2 + 1,
        sway: random.nextDouble() * 2 - 1,
        rotation: random.nextDouble() * math.pi * 2,
        rotationSpeed: random.nextDouble() * 0.1 - 0.05,
      );
    });
  }

  void _updateParticles() {
    if (!widget.isActive) return;

    setState(() {
      for (var particle in _particles) {
        particle.y += particle.speed;
        particle.x += math.sin(particle.y * 0.02) * particle.sway;
        particle.rotation += particle.rotationSpeed;

        if (particle.y > 800) {
          particle.y = -10;
          particle.x = math.Random().nextDouble() * 400;
        }
      }
    });
  }

  @override
  void dispose() {
    _idleController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: const Size(400, 800),
          painter: WeatherPainter(particles: _particles, season: widget.season),
        ),
        if (widget.season == Season.summer)
          Positioned(
            top: 100,
            right: 60,
            child: PulsingSun(controller: _idleController),
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedBuilder(
            animation: _idleController,
            builder: (context, child) {
              return SeasonalCharacter(
                season: widget.season,
                idleProgress: _idleController.value,
              );
            },
          ),
        ),
      ],
    );
  }
}
