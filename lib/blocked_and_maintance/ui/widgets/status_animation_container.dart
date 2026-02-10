import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatusAnimationContainer extends StatelessWidget {
  final bool isMaintenance;

  const StatusAnimationContainer({super.key, required this.isMaintenance});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isMaintenance
            ? LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.3),
                  Colors.white.withValues(alpha: 0.15),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.red.shade100.withValues(alpha: 0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: isMaintenance
                ? Colors.purple.withValues(alpha: 0.2)
                : Colors.red.withValues(alpha: 0.25),
            blurRadius: 30,
            spreadRadius: 5,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: -5,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      child: Lottie.asset(
        isMaintenance
            ? 'assets/lottie/Gears.json'
            : 'assets/lottie/Rejected.json',
        height: 200,
        width: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
