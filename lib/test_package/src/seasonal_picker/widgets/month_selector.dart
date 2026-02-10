import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthSelector extends StatefulWidget {
  final List<String> months;
  final int selectedIndex;
  final Function(int) onMonthSelected;
  final Color seasonColor;
  final double dialogWidth;
  final double itemWidth;
  final double height;

  const MonthSelector({
    super.key,
    required this.months,
    required this.selectedIndex,
    required this.onMonthSelected,
    required this.seasonColor,
    this.dialogWidth = 400,
    this.itemWidth = 90,
    this.height = 55,
  });

  @override
  State<MonthSelector> createState() => _MonthSelectorState();
}

class _MonthSelectorState extends State<MonthSelector> {
  late FixedExtentScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex.clamp(0, widget.months.length - 1);
    _scrollController = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void didUpdateWidget(MonthSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      if (widget.selectedIndex != _currentIndex) {
        _scrollController.animateToItem(
          widget.selectedIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: RotatedBox(
        quarterTurns: -1,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: widget.itemWidth,
          diameterRatio: 2.5,
          perspective: 0.004,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() => _currentIndex = index);
            HapticFeedback.selectionClick();
            widget.onMonthSelected(index);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.months.length,
            builder: (context, index) {
              final month = widget.months[index];
              final isSelected = index == _currentIndex;
              final distance = (index - _currentIndex).abs();

              // Calculate visual properties based on distance
              final opacity = (1.0 - (distance * 0.2)).clamp(0.4, 1.0);
              final scale = (1.0 - (distance * 0.08)).clamp(0.8, 1.0);

              return RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateToItem(
                        index,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    child: AnimatedScale(
                      scale: scale,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 280),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 24 : 14,
                          vertical: isSelected ? 12 : 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.seasonColor,
                                    widget.seasonColor.withValues(alpha: 0.85),
                                  ],
                                )
                              : null,
                          color: isSelected
                              ? null
                              : Colors.white.withValues(alpha: 0.35 * opacity),
                          borderRadius: BorderRadius.circular(
                            isSelected ? 25 : 18,
                          ),
                          border: !isSelected
                              ? Border.all(
                                  color: Colors.grey.withValues(alpha: 0.15),
                                  width: 1,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: widget.seasonColor.withValues(
                                      alpha: 0.4,
                                    ),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 5),
                                  ),
                                  BoxShadow(
                                    color: widget.seasonColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 24,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 10),
                                  ),
                                ]
                              : null,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.outfit(
                            fontSize: isSelected ? 17 : 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : Colors.black.withValues(alpha: 0.5 * opacity),
                            letterSpacing: isSelected ? 0.5 : 0,
                          ),
                          child: Text(
                            month.length > 3 ? month.substring(0, 3) : month,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
