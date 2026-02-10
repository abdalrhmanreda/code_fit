import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'animated_number.dart';
import 'pulsing_colon.dart';

class EnhancedTimeDisplay extends StatelessWidget {
  final int hour;
  final int minute;
  final bool isPM;

  const EnhancedTimeDisplay({
    super.key,
    required this.hour,
    required this.minute,
    required this.isPM,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hour
        AnimatedNumber(value: hour, color: AppColors.kPrimaryColor),
        // Colon with pulse animation
        const PulsingColon(),
        // Minute
        AnimatedNumber(value: minute, color: Colors.grey[700]!),
      ],
    );
  }
}
