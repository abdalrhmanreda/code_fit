import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../widgets/number_selector.dart';
import '../../l10n/alive_picker_localizations.dart';
import 'season.dart';
import 'widgets/widgets.dart';

class SeasonalSelectionDialog extends StatefulWidget {
  final int? startYear;
  final int? endYear;
  final double? width;
  final double? height;

  const SeasonalSelectionDialog({
    super.key,
    this.startYear,
    this.endYear,
    this.width,
    this.height,
  });

  @override
  State<SeasonalSelectionDialog> createState() =>
      _SeasonalSelectionDialogState();
}

class _SeasonalSelectionDialogState extends State<SeasonalSelectionDialog> {
  late PageController _pageController;
  int _selectedMonthIndex = DateTime.now().month - 1;
  int _selectedYear = DateTime.now().year;
  late int _selectedDay;
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now().day;
    final initialSeason = _getSeasonForMonth(_selectedMonthIndex);
    _pageController = PageController(initialPage: initialSeason.index);
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Season _getSeasonForMonth(int monthIndex) {
    if (monthIndex == 11 || monthIndex <= 1) return Season.winter;
    if (monthIndex >= 2 && monthIndex <= 4) return Season.spring;
    if (monthIndex >= 5 && monthIndex <= 7) return Season.summer;
    return Season.autumn;
  }

  void _onMonthSelected(int index) {
    setState(() {
      _selectedMonthIndex = index;
    });

    final targetSeason = _getSeasonForMonth(index);
    if (_pageController.hasClients) {
      if ((_pageController.page ?? 0).round() != targetSeason.index) {
        _pageController.animateToPage(
          targetSeason.index,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    }
  }

  void _onYearSelected(int year) {
    setState(() {
      _selectedYear = year;
      final daysInMonth = _getDaysInMonth(_selectedMonthIndex + 1, year);
      if (_selectedDay > daysInMonth) {
        _selectedDay = daysInMonth;
      }
    });
  }

  void _onDaySelected(int day) {
    setState(() {
      _selectedDay = day;
    });
  }

  int _getDaysInMonth(int month, int year) {
    if (month == 2) {
      final isLeap = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
      return isLeap ? 29 : 28;
    }
    const days31 = [1, 3, 5, 7, 8, 10, 12];
    return days31.contains(month) ? 31 : 30;
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = _getSeasonForMonth(_selectedMonthIndex);
    final viewingSeasonIndex = (_pageOffset.round()).clamp(
      0,
      Season.values.length - 1,
    );
    final viewingSeason = Season.values[viewingSeasonIndex];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: widget.width,
            height: widget.height ?? 600,
            constraints: widget.width == null
                ? const BoxConstraints(maxWidth: 420)
                : null,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Stack(
                children: [
                  AnimatedSeasonBackground(
                    currentSeason: viewingSeason,
                    pageOffset: _pageOffset,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 65,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.05),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              top: 16,
                              right: 16,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: currentSeason.iconColor.withValues(
                                      alpha: 0.2,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: currentSeason.iconColor
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              child: Text(
                                AlivePickerLocalizations.of(context).selectDate,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      NumberSelector(
                        items: List.generate(
                          (widget.endYear ?? (DateTime.now().year + 10)) -
                              (widget.startYear ?? (DateTime.now().year - 5)) +
                              1,
                          (index) =>
                              (widget.startYear ?? (DateTime.now().year - 5)) +
                              index,
                        ),
                        selectedItem: _selectedYear,
                        onItemSelected: _onYearSelected,
                        activeColor: currentSeason.iconColor,
                      ),
                      SizedBox(
                        height: 80,
                        child: MonthSelector(
                          months: AlivePickerLocalizations.of(
                            context,
                          ).monthNames,
                          selectedIndex: _selectedMonthIndex,
                          onMonthSelected: _onMonthSelected,
                          seasonColor: currentSeason.iconColor,
                          dialogWidth: 360,
                        ),
                      ),
                      NumberSelector(
                        items: List.generate(
                          _getDaysInMonth(
                            _selectedMonthIndex + 1,
                            _selectedYear,
                          ),
                          (index) => index + 1,
                        ),
                        selectedItem: _selectedDay,
                        onItemSelected: _onDaySelected,
                        activeColor: currentSeason.iconColor,
                      ),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Season.values.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SeasonScene(
                                season: Season.values[index],
                                isActive: index == viewingSeasonIndex,
                                isDialog: true,
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Cancel button - outlined style
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: currentSeason.iconColor,
                                      side: BorderSide(
                                        color: currentSeason.iconColor,
                                        width: 1,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Text(
                                      AlivePickerLocalizations.of(
                                        context,
                                      ).cancel,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  // Season months badge
                                  Column(
                                    children: [
                                      AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder:
                                            (
                                              Widget child,
                                              Animation<double> animation,
                                            ) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin: const Offset(0, 0.2),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                ),
                                              );
                                            },
                                        child: Text(
                                          currentSeason.localizedName(context),
                                          key: ValueKey(currentSeason),
                                          style: GoogleFonts.outfit(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: currentSeason.iconColor,
                                            shadows: [
                                              BoxShadow(
                                                color: Colors.white.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Text(
                                        currentSeason.localizedMonths(context),
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: currentSeason.iconColor,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // OK button - filled style
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        DateTime(
                                          _selectedYear,
                                          _selectedMonthIndex + 1,
                                          _selectedDay,
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: currentSeason.iconColor,
                                      foregroundColor: Colors.white,
                                      elevation: 4,
                                      shadowColor: currentSeason.iconColor
                                          .withValues(alpha: 0.4),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Text(
                                      AlivePickerLocalizations.of(context).ok,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
