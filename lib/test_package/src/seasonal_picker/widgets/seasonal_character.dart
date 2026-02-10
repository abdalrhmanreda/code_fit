import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../season.dart';
import 'breath_vapor.dart';
import 'sweat_drop.dart';

class SeasonalCharacter extends StatelessWidget {
  final Season season;
  final double idleProgress;

  const SeasonalCharacter({
    super.key,
    required this.season,
    required this.idleProgress,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          _buildAnimatedCharacter(),
          if (season == Season.winter)
            Positioned(
              top: 120,
              right: 80,
              child: BreathVapor(progress: idleProgress),
            ),
          if (season == Season.summer) ...[
            Positioned(
              top: 50,
              right: 80,
              child: SweatDrop(progress: idleProgress, delay: 0),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnimatedCharacter() {
    Widget charInterface = Image.asset(
      season.imagePath,
      width: 280,
      height: 380,
      fit: BoxFit.contain,
    );

    switch (season) {
      case Season.winter:
        final shiver = math.sin(idleProgress * math.pi * 16) * 1.5;
        final tremble = math.cos(idleProgress * math.pi * 24) * 0.5;
        return Transform.translate(
          offset: Offset(shiver, tremble),
          child: charInterface,
        );

      case Season.spring:
        final swayAngle = math.sin(idleProgress * math.pi * 2) * 0.02;
        final breath = 1.0 + math.sin(idleProgress * math.pi * 2) * 0.01;
        return Transform.scale(
          scale: breath,
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
            angle: swayAngle,
            alignment: Alignment.bottomCenter,
            child: charInterface,
          ),
        );

      case Season.summer:
        final breathe = math.sin(idleProgress * math.pi * 1.5) * 0.02;
        return Transform.scale(
          scaleY: 1.0 + breathe,
          scaleX: 1.0 - breathe * 0.3,
          alignment: Alignment.bottomCenter,
          child: Transform.rotate(
            angle: math.sin(idleProgress * math.pi) * 0.015,
            alignment: Alignment.bottomCenter,
            child: charInterface,
          ),
        );

      case Season.autumn:
        final slowSway = math.sin(idleProgress * math.pi) * 0.015;
        return Transform.rotate(
          angle: slowSway,
          alignment: Alignment.bottomCenter,
          child: charInterface,
        );
    }
  }
}
