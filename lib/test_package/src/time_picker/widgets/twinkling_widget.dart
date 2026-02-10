import 'package:flutter/material.dart';
import 'dart:math' as math;

class TwinklingWidget extends StatefulWidget {
  final Widget child;

  const TwinklingWidget({super.key, required this.child});

  @override
  State<TwinklingWidget> createState() => _TwinklingWidgetState();
}

class _TwinklingWidgetState extends State<TwinklingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000 + math.Random().nextInt(1000)),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _animation, child: widget.child);
  }
}
