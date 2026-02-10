import 'package:flutter/material.dart';

class PulsingColon extends StatefulWidget {
  const PulsingColon({super.key});

  @override
  State<PulsingColon> createState() => _PulsingColonState();
}

class _PulsingColonState extends State<PulsingColon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.3, end: 1.0).animate(_controller),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          ':',
          style: TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.w300,
            color: Colors.grey[400],
            height: 1,
          ),
        ),
      ),
    );
  }
}
