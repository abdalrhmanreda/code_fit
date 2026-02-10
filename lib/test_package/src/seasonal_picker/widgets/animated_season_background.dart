import 'package:flutter/material.dart';
import '../season.dart';

class AnimatedSeasonBackground extends StatelessWidget {
  final Season currentSeason;
  final double pageOffset;

  const AnimatedSeasonBackground({
    super.key,
    required this.currentSeason,
    required this.pageOffset,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = pageOffset.floor();
    final nextIndex = (currentIndex + 1).clamp(0, Season.values.length - 1);
    final progress = pageOffset - currentIndex;

    final currentColors = Season.values[currentIndex].gradientColors;
    final nextColors = Season.values[nextIndex].gradientColors;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(currentColors[0], nextColors[0], progress)!,
            Color.lerp(currentColors[1], nextColors[1], progress)!,
          ],
        ),
      ),
    );
  }
}
