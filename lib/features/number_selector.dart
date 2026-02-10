import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberSelector extends StatefulWidget {
  final List<int> items;
  final int selectedItem;
  final Function(int) onItemSelected;
  final Color activeColor;

  const NumberSelector({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
    required this.activeColor,
  }) : super(key: key);

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.items
          .indexOf(widget.selectedItem)
          .clamp(0, widget.items.length - 1),
      viewportFraction: 0.33,
    );
  }

  @override
  void didUpdateWidget(NumberSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      if (_pageController.hasClients) {
        final index = widget.items.indexOf(widget.selectedItem);
        if (index != -1 && _pageController.page?.round() != index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (index) => widget.onItemSelected(widget.items[index]),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 1.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
                value = (1 - (value.abs() * 0.5)).clamp(0.5, 1.0);
              } else {
                final selectedIndex = widget.items.indexOf(widget.selectedItem);
                value = index == selectedIndex ? 1.0 : 0.5;
              }

              final item = widget.items[index];
              final isSelected = item == widget.selectedItem;

              return Center(
                child: Transform.scale(
                  scale: value,
                  child: GestureDetector(
                    onTap: () => widget.onItemSelected(item),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? widget.activeColor
                            : Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: widget.activeColor.withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Text(
                        '$item',
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.white : Colors.black54,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
