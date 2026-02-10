import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:code_fit/test_package/src/date_picker/modern_date_picker.dart';
import 'package:code_fit/test_package/src/time_picker/animated_time_picker_dialog.dart';
import 'package:code_fit/test_package/src/seasonal_picker/seasonal_selection_dialog.dart';

class AlivePickerShowcaseScreen extends StatefulWidget {
  const AlivePickerShowcaseScreen({super.key});

  @override
  State<AlivePickerShowcaseScreen> createState() =>
      _AlivePickerShowcaseScreenState();
}

class _AlivePickerShowcaseScreenState extends State<AlivePickerShowcaseScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedSeasonalDate;

  void _showDatePicker() {
    showDialog(
      context: context,
      builder: (context) => ModernDatePicker(
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  void _showTimePicker() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Time Picker',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AnimatedTimePickerDialog(
          initialTime: _selectedTime ?? TimeOfDay.now(),
          onTimeSelected: (time) {
            setState(() {
              _selectedTime = time;
            });
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  void _showSeasonalPicker() {
    showDialog(
      context: context,
      builder: (context) => const SeasonalSelectionDialog(),
    ).then((result) {
      if (result != null && result is DateTime) {
        setState(() {
          _selectedSeasonalDate = result;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Alive Pickers',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPickerCard(
                  title: 'Modern Date Picker',
                  description:
                      'A step-by-step elegant date selection experience.',
                  icon: Icons.calendar_today_rounded,
                  color: const Color(0xFF3B82F6),
                  onTap: _showDatePicker,
                  result: _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'No date selected',
                ),
                const SizedBox(height: 20),
                _buildPickerCard(
                  title: 'Animated Time Picker',
                  description: 'A fluid, glassmorphic time selection dialog.',
                  icon: Icons.access_time_rounded,
                  color: const Color(0xFF8B5CF6),
                  onTap: _showTimePicker,
                  result: _selectedTime != null
                      ? _selectedTime!.format(context)
                      : 'No time selected',
                ),
                const SizedBox(height: 20),
                _buildPickerCard(
                  title: 'Seasonal Picker',
                  description:
                      'A beautiful date picker that changes with the seasons.',
                  icon: Icons.wb_sunny_rounded,
                  color: const Color(0xFFF59E0B),
                  onTap: _showSeasonalPicker,
                  result: _selectedSeasonalDate != null
                      ? '${_selectedSeasonalDate!.day}/${_selectedSeasonalDate!.month}/${_selectedSeasonalDate!.year}'
                      : 'No date selected',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String result,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          result,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
