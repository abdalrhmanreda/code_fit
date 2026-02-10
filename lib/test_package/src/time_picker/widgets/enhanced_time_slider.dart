import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EnhancedTimeSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final Function(double) onChanged;

  const EnhancedTimeSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  @override
  State<EnhancedTimeSlider> createState() => _EnhancedTimeSliderState();
}

class _EnhancedTimeSliderState extends State<EnhancedTimeSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 6,
        activeTrackColor: AppColors.kPrimaryColor.withValues(alpha: 0.7),
        inactiveTrackColor: Colors.grey[200],
        thumbColor: Colors.white,
        overlayColor: AppColors.kPrimaryColor.withValues(alpha: 0.15),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
        thumbShape: EnhancedThumbShape(
          isActive: _isDragging,
          animation: _rippleController,
        ),
        activeTickMarkColor: Colors.transparent,
        inactiveTickMarkColor: Colors.transparent,
        trackShape: const RoundedRectSliderTrackShape(),
      ),
      child: Slider(
        value: widget.value,
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        onChanged: widget.onChanged,
        onChangeStart: (_) {
          setState(() => _isDragging = true);
          _rippleController.forward();
        },
        onChangeEnd: (_) {
          setState(() => _isDragging = false);
          _rippleController.reverse();
        },
      ),
    );
  }
}

class EnhancedThumbShape extends SliderComponentShape {
  final bool isActive;
  final AnimationController animation;

  EnhancedThumbShape({required this.isActive, required this.animation});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(28, 28);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final animValue = animation.value;

    // Outer ripple effect
    if (isActive) {
      final ripplePaint = Paint()
        ..color = AppColors.kPrimaryColor.withValues(
          alpha: 0.2 * (1 - animValue),
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, 20 + (12 * animValue), ripplePaint);
    }

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(center + const Offset(0, 2), 12, shadowPaint);

    // Blue gradient background
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.kPrimaryColor.withValues(alpha: 0.7),
          AppColors.kPrimaryColor,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 14));

    canvas.drawCircle(center, 14, gradientPaint);

    // White inner circle
    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 10, innerPaint);

    // Blue center dot
    final centerDotPaint = Paint()
      ..color = AppColors.kPrimaryColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 4, centerDotPaint);
  }
}
