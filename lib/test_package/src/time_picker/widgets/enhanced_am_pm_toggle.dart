import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class EnhancedAMPMToggle extends StatelessWidget {
  final bool isPM;
  final Function(bool) onToggle;
  final AnimationController toggleController;

  const EnhancedAMPMToggle({
    super.key,
    required this.isPM,
    required this.onToggle,
    required this.toggleController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Stack(
        children: [
          // Animated background slider
          AnimatedBuilder(
            animation: toggleController,
            builder: (context, child) {
              return Positioned(
                left: toggleController.value * 72,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.kPrimaryColor.withValues(alpha: 0.7),
                        AppColors.kPrimaryColor,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kPrimaryColor.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // AM/PM Buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton('AM', !isPM, () => onToggle(false)),
              _buildToggleButton('PM', isPM, () => onToggle(true)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 40,
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            fontSize: isSelected ? 15 : 14,
            letterSpacing: 0.5,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}
