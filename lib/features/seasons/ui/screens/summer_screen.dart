import 'package:code_fit/shared/widgets/animations/summer_season_animation.dart';
import 'package:flutter/material.dart';

class SummerScreen extends StatelessWidget {
  const SummerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Summer Season')),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF87CEEB),
              Color(0xFFE0F7FA),
            ], // Sky blue to light cyan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SummerSeasonAnimation(size: 300),
              const SizedBox(height: 20),
              Text(
                'Enjoy the Summer!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
