import 'package:flutter/material.dart';
import 'package:code_fit/config/colors/app_colors.dart';

import 'widgets/enhanced_sky_background.dart';
import 'widgets/enhanced_am_pm_toggle.dart';
import 'widgets/enhanced_time_display.dart';
import 'widgets/enhanced_time_slider.dart';
import 'widgets/enhanced_button.dart';

class AnimatedTimePickerDialog extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay) onTimeSelected;

  const AnimatedTimePickerDialog({
    super.key,
    required this.initialTime,
    required this.onTimeSelected,
  });

  @override
  State<AnimatedTimePickerDialog> createState() =>
      _AnimatedTimePickerDialogState();
}

class _AnimatedTimePickerDialogState extends State<AnimatedTimePickerDialog>
    with TickerProviderStateMixin {
  late int hour;
  late int minute;
  late bool isPM;
  late AnimationController _scaleController;
  late AnimationController _skyTransitionController;
  late AnimationController _toggleController;

  @override
  void initState() {
    super.initState();
    hour = widget.initialTime.hourOfPeriod == 0
        ? 12
        : widget.initialTime.hourOfPeriod;
    minute = widget.initialTime.minute;
    isPM = widget.initialTime.period == DayPeriod.pm;

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _skyTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _toggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    if (isPM) {
      _toggleController.value = 1.0;
    }

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _skyTransitionController.dispose();
    _toggleController.dispose();
    super.dispose();
  }

  void _togglePeriod(bool toPM) {
    if (isPM != toPM) {
      setState(() {
        isPM = toPM;
      });

      if (toPM) {
        _toggleController.forward();
      } else {
        _toggleController.reverse();
      }

      _skyTransitionController.forward(from: 0);
    }
  }

  void _onOkPressed() {
    int hour24 = hour;
    if (isPM && hour != 12) {
      hour24 = hour + 12;
    } else if (!isPM && hour == 12) {
      hour24 = 0;
    }

    widget.onTimeSelected(TimeOfDay(hour: hour24, minute: minute));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 420),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Enhanced Sky Background
                  EnhancedSkyBackground(
                    isPM: isPM,
                    transitionController: _skyTransitionController,
                  ),

                  const SizedBox(height: 32),

                  // Enhanced AM/PM Toggle
                  EnhancedAMPMToggle(
                    isPM: isPM,
                    onToggle: _togglePeriod,
                    toggleController: _toggleController,
                  ),

                  const SizedBox(height: 24),

                  // Enhanced Time Display
                  EnhancedTimeDisplay(hour: hour, minute: minute, isPM: isPM),

                  const SizedBox(height: 40),

                  // Hour Slider with Label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hour',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                hour.toString().padLeft(2, '0'),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.kPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        EnhancedTimeSlider(
                          value: hour.toDouble(),
                          min: 1,
                          max: 12,
                          divisions: 11,
                          onChanged: (value) {
                            setState(() {
                              hour = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Minute Slider with Label
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Minute',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                minute.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        EnhancedTimeSlider(
                          value: minute.toDouble(),
                          min: 0,
                          max: 59,
                          divisions: 59,
                          onChanged: (value) {
                            setState(() {
                              minute = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Enhanced Action Buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        EnhancedButton(
                          label: 'CANCEL',
                          onPressed: () => Navigator.of(context).pop(),
                          isPrimary: false,
                        ),
                        const SizedBox(width: 12),
                        EnhancedButton(
                          label: 'OK',
                          onPressed: _onOkPressed,
                          isPrimary: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
