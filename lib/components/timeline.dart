import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';

class TimelineView extends StatelessWidget {
  const TimelineView({
    super.key,
    required this.selectedDate,
    required this.onDateChange,
  });

  final DateTime selectedDate;
  final void Function(DateTime) onDateChange;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: EasyDateTimeLine(
        initialDate: selectedDate,
        onDateChange: onDateChange,
        headerProps: const EasyHeaderProps(
          monthPickerType: MonthPickerType.dropDown,
          showHeader: false,
          showSelectedDate: true,
        ),
        dayProps: EasyDayProps(
          dayStructure: DayStructure.dayNumDayStr,
          activeDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            dayStrStyle: TextStyle(
              color: colors.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            dayNumStyle: TextStyle(
              color: colors.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          inactiveDayStyle: DayStyle(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.surface,
              border: Border.all(color: colors.outlineVariant, width: 1),
            ),
            dayStrStyle: TextStyle(color: colors.onSurface, fontSize: 16),
            dayNumStyle: TextStyle(color: colors.onSurface, fontSize: 16),
          ),
          todayHighlightStyle: TodayHighlightStyle.withBorder,
          todayHighlightColor: colors.primaryContainer.withOpacity(0.3),
        ),
        timeLineProps: EasyTimeLineProps(separatorPadding: 16),
      ),
    );
  }
}
