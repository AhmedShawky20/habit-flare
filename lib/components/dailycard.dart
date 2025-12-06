import 'package:flutter/material.dart';
import 'habitcardlist.dart';

class Daily extends StatelessWidget {
  const Daily({
    super.key,
    required this.completedtasks,
    required this.totaltasks,
    required this.date,
    required this.selectedDate,
  });

  final int completedtasks;
  final int totaltasks;
  final String date;
  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 8,
          shadowColor: colors.shadow.withOpacity(0.2),
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                  colors: [colors.primary, colors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Daily Summary",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                            color: colors.onPrimary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(date,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text("$completedtasks of $totaltasks tasks done",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: colors.onPrimary, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                      value: totaltasks == 0 ? 0 : completedtasks / totaltasks,
                      backgroundColor: colors.onPrimary.withOpacity(0.2),
                      color: colors.onPrimary,
                      minHeight: 8),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text("Habits",
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 16),
        HabitCardList(date: selectedDate),
      ],
    );
  }
}
