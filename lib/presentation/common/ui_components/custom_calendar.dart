
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mawadk/presentation/common/ui_components/custom_ink_button.dart';
import 'package:mawadk/presentation/res/fonts_manager.dart';
import 'package:mawadk/presentation/res/sizes_manager.dart';
import 'package:smooth_corner/smooth_corner.dart';

class CustomCalendar extends StatefulWidget {
  // Date selection
  final DateTime? initialSelectedDate;
  final DateTime? initialCurrentMonth;
  final Function(DateTime selectedDate)? onDateSelected;
  final Function(DateTime currentMonth)? onMonthChanged;

  // Date constraints
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool allowPastDates;
  final bool allowFutureDates;

  // Calendar appearance
  final Color? selectedDateColor;
  final Color? todayColor;
  final Color? currentMonthTextColor;
  final Color? otherMonthTextColor;
  final Color? pastDateColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  // Header appearance
  final bool showHeader;
  final Color? headerTextColor;
  final double? headerFontSize;
  final FontWeight? headerFontWeight;
  final Color? navigationButtonColor;
  final double? navigationButtonSize;
  final Widget? customPreviousButton;
  final Widget? customNextButton;
  final Color? navigationBackgroundButtonColor;
  final double navigationSpaceSize;

  // Week days appearance
  final bool showWeekDays;
  final Color? weekDayTextColor;
  final double? weekDayFontSize;
  final FontWeight? weekDayFontWeight;
  final List<String>? customWeekDays;

  // Day appearance
  final double? daySize;
  final double? dayFontSize;
  final FontWeight? dayFontWeight;
  final Color? dayTextColor;
  final Color? selectedDayTextColor;
  final Color? todayTextColor;
  final Color? otherMonthDayTextColor;
  final Color? pastDayTextColor;

  // Calendar grid appearance
  final double? daySpacing;
  final double? weekSpacing;
  final bool showGridLines;
  final Color? gridLineColor;
  final double? gridLineWidth;

  // Localization
  final String? locale;
  final String? monthFormat;
  final String? weekDayFormat;

  // Animation
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableAnimations;

  // Customization
  final Widget Function(DateTime date, bool isSelected, bool isToday,
      bool isCurrentMonth, bool isPastDate)? customDayBuilder;
  final Widget Function(String monthYear)? customHeaderBuilder;
  final Widget Function(String weekDay)? customWeekDayBuilder;

  // Calendar behavior
  final bool enableMonthNavigation;
  final bool enableYearNavigation;
  final bool showTodayButton;
  final String? todayButtonText;
  final Color? todayButtonColor;
  final Color? todayButtonTextColor;

  // Events and markers
  final List<DateTime>? markedDates;
  final Color? markedDateColor;
  final Widget? markedDateWidget;
  final Function(DateTime date)? onDateMarked;

  const CustomCalendar({
    super.key,
    this.initialSelectedDate,
    this.initialCurrentMonth,
    this.onDateSelected,
    this.onMonthChanged,
    this.minDate,
    this.maxDate,
    this.allowPastDates = false,
    this.allowFutureDates = true,
    this.selectedDateColor = const Color(0xFF1C2A3A),
    this.todayColor = const Color(0xFF1C2A3A),
    this.currentMonthTextColor = const Color(0xFF6B7280),
    this.otherMonthTextColor = const Color(0xFFD1D5DB),
    this.pastDateColor = const Color(0xFFE5E7EB),
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.boxShadow,
    this.showHeader = true,
    this.headerTextColor = const Color(0xFF111928),
    this.headerFontSize = 14.0,
    this.headerFontWeight = FontWeight.bold,
    this.navigationButtonColor = const Color(0xFF4B5563),
    this.navigationButtonSize = 14.0,
    this.navigationBackgroundButtonColor = const Color(0xFF4B5563),
    this.navigationSpaceSize = 2.0,
    this.customPreviousButton,
    this.customNextButton,
    this.showWeekDays = true,
    this.weekDayTextColor = const Color(0xFF6B7280),
    this.weekDayFontSize = 12.0,
    this.weekDayFontWeight = FontWeight.w600,
    this.customWeekDays,
    this.daySize = 36.0,
    this.dayFontSize = 12.0,
    this.dayFontWeight = FontWeight.bold,
    this.dayTextColor = const Color(0xFF6B7280),
    this.selectedDayTextColor = Colors.white,
    this.todayTextColor = const Color(0xFF1C2A3A),
    this.otherMonthDayTextColor = const Color(0xFFD1D5DB),
    this.pastDayTextColor = const Color(0xFFE5E7EB),
    this.daySpacing = 2.0,
    this.weekSpacing = 8.0,
    this.showGridLines = false,
    this.gridLineColor = const Color(0xFFE5E7EB),
    this.gridLineWidth = 1.0,
    this.locale,
    this.monthFormat = 'MMMM yyyy',
    this.weekDayFormat = 'E',
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.enableAnimations = true,
    this.customDayBuilder,
    this.customHeaderBuilder,
    this.customWeekDayBuilder,
    this.enableMonthNavigation = true,
    this.enableYearNavigation = false,
    this.showTodayButton = false,
    this.todayButtonText = 'Today',
    this.todayButtonColor = const Color(0xFF1C2A3A),
    this.todayButtonTextColor = Colors.white,
    this.markedDates,
    this.markedDateColor = Colors.red,
    this.markedDateWidget,
    this.onDateMarked,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate ?? DateTime.now();
    _currentMonth = widget.initialCurrentMonth ?? DateTime.now();
  }

  // Helper methods for calendar
  List<List<DateTime>> _generateCalendarData() {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayOfWeek = firstDayOfMonth.weekday % 7; // Convert to Sunday = 0

    List<List<DateTime>> calendar = [];
    List<DateTime> currentWeek = [];

    // Add empty days for the first week
    for (int i = 0; i < firstDayOfWeek; i++) {
      currentWeek
          .add(firstDayOfMonth.subtract(Duration(days: firstDayOfWeek - i)));
    }

    // Add days of the current month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      currentWeek.add(DateTime(_currentMonth.year, _currentMonth.month, day));

      if (currentWeek.length == 7) {
        calendar.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }

    // Add remaining days from next month to complete the last week
    if (currentWeek.isNotEmpty) {
      int nextMonthDay = 1;
      while (currentWeek.length < 7) {
        currentWeek.add(DateTime(
            _currentMonth.year, _currentMonth.month + 1, nextMonthDay));
        nextMonthDay++;
      }
      calendar.add(List.from(currentWeek));
    }

    return calendar;
  }

  void _previousMonth() {
    if (!widget.enableMonthNavigation) return;

    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void _nextMonth() {
    if (!widget.enableMonthNavigation) return;

    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
    widget.onMonthChanged?.call(_currentMonth);
  }

  void _goToToday() {
    setState(() {
      _currentMonth = DateTime.now();
      _selectedDate = DateTime.now();
    });
    widget.onDateSelected?.call(_selectedDate);
    widget.onMonthChanged?.call(_currentMonth);
  }

  String _getMonthYearText(BuildContext context) {
    final locale = widget.locale ?? context.locale.languageCode;
    final formatter = DateFormat(widget.monthFormat, locale);
    return formatter.format(_currentMonth);
  }

  List<String> _getWeekDays(BuildContext context) {
    if (widget.customWeekDays != null) {
      return widget.customWeekDays!;
    }

    final locale = widget.locale ?? context.locale.languageCode;
    final formatter = DateFormat(widget.weekDayFormat, locale);
    return List.generate(7, (index) {
      final date = DateTime(2024, 1, 7 + index); // Start from Sunday
      return formatter.format(date);
    });
  }

  bool _isDateSelectable(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return false;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return false;
    if (!widget.allowPastDates &&
        date.isBefore(DateTime.now().subtract(const Duration(days: 1))))
      return false;
    if (!widget.allowFutureDates &&
        date.isAfter(DateTime.now().add(const Duration(days: 1)))) return false;
    return true;
  }

  bool _isDateMarked(DateTime date) {
    if (widget.markedDates == null) return false;
    return widget.markedDates!.any((markedDate) =>
        markedDate.year == date.year &&
        markedDate.month == date.month &&
        markedDate.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius!.r),
        border: widget.borderColor != Colors.transparent
            ? Border.all(color: widget.borderColor!, width: 1)
            : null,
        boxShadow: widget.boxShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          if (widget.showHeader) _buildHeader(context),

          if (widget.showHeader && widget.showWeekDays) SizedBox(height: 16.h),

          // Week days
          if (widget.showWeekDays) _buildWeekDays(context),

          if (widget.showWeekDays) SizedBox(height: 8.h),

          // Calendar body
          _buildCalendarBody(context),

          // Today button
          if (widget.showTodayButton) ...[
            SizedBox(height: 16.h),
            _buildTodayButton(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (widget.customHeaderBuilder != null) {
      return widget.customHeaderBuilder!(_getMonthYearText(context));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _getMonthYearText(context),
          style: TextStyle(
            fontSize: widget.headerFontSize!.sp,
            fontWeight: widget.headerFontWeight,
            color: widget.headerTextColor,
            height: 1.5,
          ),
        ),
        Row(
          children: [
            // Previous button
            CustomInkButton(
              backgroundColor: widget.navigationBackgroundButtonColor,
              borderRadius: 2.r,
              width: widget.navigationButtonSize!.w,
              height: widget.navigationButtonSize!.w,
              onTap: _previousMonth,
              alignment: Alignment.center,
              child: widget.customPreviousButton ??
                  Container(
                    width: widget.navigationButtonSize!.w,
                    height: widget.navigationButtonSize!.w,
                    decoration: BoxDecoration(
                      color: widget.navigationButtonColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Icon(
                      Icons.chevron_left,
                      size: (widget.navigationButtonSize! * 0.7).w,
                      color: Colors.white,
                    ),
                  ),
            ),
            SizedBox(width: widget.navigationSpaceSize.w),
            // Next button
            CustomInkButton(
              alignment: Alignment.center,
              onTap: _nextMonth,
              backgroundColor: widget.navigationBackgroundButtonColor,
              borderRadius: 2.r,
              width: widget.navigationButtonSize!.w,
              height: widget.navigationButtonSize!.w,
              child: widget.customNextButton ??
                  Container(
                    width: widget.navigationButtonSize!.w,
                    height: widget.navigationButtonSize!.w,
                    decoration: BoxDecoration(
                      color: widget.navigationButtonColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                    child: Icon(
                      Icons.chevron_right,
                      size: (widget.navigationButtonSize! * 0.7).w,
                      color: Colors.white,
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    return Row(
      children: _getWeekDays(context)
          .map((day) => Expanded(
                child: Center(
                  child: widget.customWeekDayBuilder != null
                      ? widget.customWeekDayBuilder!(day)
                      : Text(
                          day,
                          style: TextStyle(
                            fontSize: widget.weekDayFontSize!.sp,
                            fontWeight: widget.weekDayFontWeight,
                            color: widget.weekDayTextColor,
                            height: 1,
                          ),
                        ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarBody(BuildContext context) {
    final calendarData = _generateCalendarData();

    return Column(
      children: calendarData
          .map((week) => Padding(
                padding: EdgeInsets.only(bottom: widget.weekSpacing!.h),
                child: Row(
                  children: week
                      .map((date) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: widget.daySpacing!.w),
                              child: _buildCalendarDay(date),
                            ),
                          ))
                      .toList(),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarDay(DateTime date) {
    bool isSelected = _selectedDate.year == date.year &&
        _selectedDate.month == date.month &&
        _selectedDate.day == date.day;
    bool isCurrentMonth = date.month == _currentMonth.month;
    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;
    bool isPastDate =
        date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
    bool isSelectable = _isDateSelectable(date);
    bool isMarked = _isDateMarked(date);

    if (widget.customDayBuilder != null) {
      return widget.customDayBuilder!(
          date, isSelected, isToday, isCurrentMonth, isPastDate);
    }

    return GestureDetector(
      onTap: isSelectable
          ? () {
              setState(() {
                _selectedDate = date;
              });
              widget.onDateSelected?.call(date);
              if (isMarked) {
                widget.onDateMarked?.call(date);
              }
            }
          : null,
      child: AnimatedContainer(
        duration:
            widget.enableAnimations ? widget.animationDuration! : Duration.zero,
        curve: widget.animationCurve!,
        width: widget.daySize!.w,
        height: widget.daySize!.h,
        decoration: BoxDecoration(
          color: isSelected ? widget.selectedDateColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: widget.showGridLines
              ? Border.all(
                  color: widget.gridLineColor!,
                  width: widget.gridLineWidth!,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Day number
            Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: widget.dayFontSize!.sp,
                  fontWeight: widget.dayFontWeight,
                  color: isSelected
                      ? widget.selectedDayTextColor
                      : isPastDate && !isSelectable
                          ? widget.pastDayTextColor
                          : isCurrentMonth
                              ? isToday
                                  ? widget.todayTextColor
                                  : widget.dayTextColor
                              : widget.otherMonthDayTextColor,
                  height: 1.5,
                ),
              ),
            ),
            // Marked date indicator
            if (isMarked)
              Positioned(
                top: 2.h,
                right: 2.w,
                child: widget.markedDateWidget ??
                    Container(
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: widget.markedDateColor,
                        shape: BoxShape.circle,
                      ),
                    ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayButton() {
    return GestureDetector(
      onTap: _goToToday,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: widget.todayButtonColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          widget.todayButtonText!,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: widget.todayButtonTextColor,
          ),
        ),
      ),
    );
  }
}

// Predefined calendar styles
class CalendarStyles {
  static CustomCalendar get defaultStyle => const CustomCalendar();

  static CustomCalendar get minimalStyle => const CustomCalendar(
        showHeader: false,
        showWeekDays: false,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
      );

  static CustomCalendar get cardStyle => const CustomCalendar(
        backgroundColor: Colors.white,
        borderRadius: 16.0,
        padding: EdgeInsets.all(20.0),
        selectedDateColor: Color(0xFF1C2A3A),
        todayColor: Color(0xFF1C2A3A),
        showTodayButton: true,
      );

  static CustomCalendar get darkStyle => const CustomCalendar(
        backgroundColor: Color(0xFF1F2937),
        headerTextColor: Colors.white,
        currentMonthTextColor: Colors.white,
        otherMonthTextColor: Color(0xFF6B7280),
        weekDayTextColor: Color(0xFF9CA3AF),
        selectedDateColor: Color(0xFF3B82F6),
        todayColor: Color(0xFF3B82F6),
        navigationButtonColor: Color(0xFF4B5563),
      );

  static CustomCalendar get compactStyle => const CustomCalendar(
        daySize: 28.0,
        dayFontSize: 10.0,
        headerFontSize: 12.0,
        weekDayFontSize: 10.0,
        padding: EdgeInsets.all(8.0),
        daySpacing: 1.0,
        weekSpacing: 4.0,
      );
}

class DateCard extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateCard({
    super.key,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayName = _dayLabel(date, context.locale.languageCode);
    final dayNumber = DateFormat('d', context.locale.languageCode).format(date);
    final monthName = DateFormat('MMM', context.locale.languageCode).format(date);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 71.w,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF1F1B2E) : Colors.white,
          shape: SmoothRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
            smoothness: 1
          ),
          shadows: [
            if (!isSelected)
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeightM.medium),
            ),
            const SizedBox(height: 6),
            Text(
              dayNumber,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              monthName,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: isSelected ? Colors.white70 : Colors.grey,
                  fontWeight: FontWeightM.semiBold),
            ),
          ],
        ),
      ),
    );
  }

  String _dayLabel(DateTime date, String lang) {
    final today = DateTime.now();
    if (DateUtils.isSameDay(today, date)) {
      return  lang == "ar" ? "اليوم" : 'Today';
    }
    return DateFormat('EEE', lang).format(date).toUpperCase();
  }
}

class InfiniteDateSelector extends StatefulWidget {
  final void Function(DateTime dateTime)? onSelectedDate;
  const InfiniteDateSelector({super.key, this.onSelectedDate});

  @override
  State<InfiniteDateSelector> createState() => _InfiniteDateSelectorState();
}

class _InfiniteDateSelectorState extends State<InfiniteDateSelector> {
  int selectedIndex = 0;

  DateTime getDateByIndex(int index) {
    return DateTime.now().add(Duration(days: index));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: SizeM.pagePadding.dg),
        scrollDirection: Axis.horizontal,
        itemCount: 200, // 👈 infinite
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final date = getDateByIndex(index);
          return DateCard(
            date: date,
            isSelected: selectedIndex == index,
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onSelectedDate?.call(date);
            },
          );
        },
      ),
    );
  }
}
