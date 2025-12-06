import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../database/providers.dart';
import 'habitcard.dart';

class HabitCardList extends ConsumerWidget {
  const HabitCardList({super.key, required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitsStreamProvider(date));

    return habits.when(
      data: (h) => h.isEmpty
          ? const SizedBox.shrink()
          : ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: h.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) {
          final x = h[index];
          final progress = x.isCompleted ? 1.0 : 0.0;
          return HabitCard(
            title: x.habit.title,
            streak: x.habit.streak,
            isCompleted: x.isCompleted,
            progress: progress,
            habitId: x.habit.id,
            date: date,
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
