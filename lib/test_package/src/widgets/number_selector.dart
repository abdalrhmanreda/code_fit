import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberSelector extends StatefulWidget {
  final List<int> items;
  final int selectedItem;
  final Function(int) onItemSelected;
  final Color activeColor;
  final double itemWidth;
  final double height;

  const NumberSelector({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    required this.activeColor,
    this.itemWidth = 70,
    this.height = 50,
  });

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late FixedExtentScrollController _scrollController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.items
        .indexOf(widget.selectedItem)
        .clamp(0, widget.items.length - 1);
    _scrollController = FixedExtentScrollController(initialItem: _currentIndex);
  }

  @override
  void didUpdateWidget(NumberSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      final newIndex = widget.items.indexOf(widget.selectedItem);
      if (newIndex != -1 && newIndex != _currentIndex) {
        _scrollController.animateToItem(
          newIndex,
          duration: const Duration(milliseconds: 350),
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
          diameterRatio: 3.0,
          perspective: 0.003,
          physics: const FixedExtentScrollPhysics(),
          onSelectedItemChanged: (index) {
            setState(() => _currentIndex = index);
            HapticFeedback.selectionClick();
            widget.onItemSelected(widget.items[index]);
          },
          childDelegate: ListWheelChildBuilderDelegate(
            childCount: widget.items.length,
            builder: (context, index) {
              final item = widget.items[index];
              final isSelected = index == _currentIndex;
              final distance = (index - _currentIndex).abs();

              // Calculate opacity and scale based on distance from center
              final opacity = (1.0 - (distance * 0.25)).clamp(0.3, 1.0);
              final scale = (1.0 - (distance * 0.1)).clamp(0.7, 1.0);

              return RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateToItem(
                        index,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                      );
                    },
                    child: AnimatedScale(
                      scale: scale,
                      duration: const Duration(milliseconds: 200),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 10 : 12,
                          vertical: isSelected ? 10 : 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? widget.activeColor
                              : Colors.white.withValues(alpha: 0.4 * opacity),
                          borderRadius: BorderRadius.circular(
                            isSelected ? 16 : 12,
                          ),
                          border: !isSelected
                              ? Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                  width: 1,
                                )
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: widget.activeColor.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                  BoxShadow(
                                    color: widget.activeColor.withValues(
                                      alpha: 0.15,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 8),
                                  ),
                                ]
                              : null,
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? Colors.white
                                : Colors.black.withValues(alpha: 0.5 * opacity),
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: isSelected ? 18 : 14,
                          ),
                          child: Text('$item'),
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
