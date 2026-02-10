import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModernDatePicker extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const ModernDatePicker({Key? key, required this.onDateSelected})
    : super(key: key);

  @override
  State<ModernDatePicker> createState() => _ModernDatePickerState();
}

class _ModernDatePickerState extends State<ModernDatePicker> {
  int _currentStep = 0; // 0: Year, 1: Month, 2: Day
  int? _selectedYear;
  int? _selectedMonth;
  int? _selectedDay;

  final int _startYear = DateTime.now().year - 10;
  final int _endYear = DateTime.now().year + 10;

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _handleYearSelect(int year) {
    setState(() {
      _selectedYear = year;
      _currentStep = 1;
    });
  }

  void _handleMonthSelect(int index) {
    setState(() {
      _selectedMonth = index + 1;
      _currentStep = 2;
    });
  }

  void _handleDaySelect(int day) {
    setState(() {
      _selectedDay = day;
    });
    // Complete selection
    final date = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
    widget.onDateSelected(date);
    Navigator.of(context).pop();
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE0F2FE), // Light Blue 50
              Colors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    onPressed: _previousStep,
                    color: Colors.black54,
                  ),
                  _buildStepIndicator(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () => Navigator.of(context).pop(),
                    color: Colors
                        .black87, // Changed from black54 to black87 for better visibility
                  ),
                ],
              ),
            ),

            // Title
            Text(
              _StepTitle(_currentStep),
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStepContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _StepTitle(int step) {
    switch (step) {
      case 0:
        return 'Select Year';
      case 1:
        return 'Select Month';
      case 2:
        return 'Select Day';
      default:
        return '';
    }
  }

  Widget _buildStepIndicator() {
    return Row(
      children: List.generate(3, (index) {
        final isActive = index == _currentStep;
        final isCompleted = index < _currentStep;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF3B82F6)
                : Colors.black12,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildYearPicker();
      case 1:
        return _buildMonthPicker();
      case 2:
        return _buildDayPicker();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildYearPicker() {
    final years = List.generate(
      _endYear - _startYear + 1,
      (index) => _startYear + index,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: years.length,
      itemBuilder: (context, index) {
        final year = years[index];
        final isSelected = year == _selectedYear;

        return GestureDetector(
          onTap: () => _handleYearSelect(year),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16), // Increased margin
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ), // Increased padding
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$year',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthPicker() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 16, // Increased spacing
        mainAxisSpacing: 16, // Increased spacing
      ),
      itemCount: _months.length,
      itemBuilder: (context, index) {
        final isSelected = (index + 1) == _selectedMonth;

        return GestureDetector(
          onTap: () => _handleMonthSelect(index),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              _months[index],
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDayPicker() {
    final daysInMonth = _getDaysInMonth(_selectedMonth!, _selectedYear!);

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 1.0,
        crossAxisSpacing: 14, // Increased spacing
        mainAxisSpacing: 14, // Increased spacing
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final isSelected = day == _selectedDay;

        return GestureDetector(
          onTap: () => _handleDaySelect(day),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
        );
      },
    );
  }

  int _getDaysInMonth(int month, int year) {
    if (month == 2) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const days31 = [1, 3, 5, 7, 8, 10, 12];
    return days31.contains(month) ? 31 : 30;
  }
}
