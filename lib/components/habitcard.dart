import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../database/database_provider.dart';
import '../database/database.dart';

class HabitCard extends ConsumerWidget {
  const HabitCard({
    super.key,
    required this.title,
    required this.progress,
    required this.streak,
    required this.habitId,
    required this.isCompleted,
    required this.date,
  });

  final String title;
  final double progress;
  final int streak;
  final int habitId;
  final bool isCompleted;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final db = ref.read(databaseProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isCompleted
                ? colors.primaryContainer.withOpacity(0.8)
                : colors.surface.withOpacity(0.1),
            isCompleted
                ? colors.primaryContainer.withOpacity(0.6)
                : colors.surface.withOpacity(0.05),
          ],
        ),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 16),
        ],
      ),
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.onSurface)),
              if (streak > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.local_fire_department, size: 20, color: colors.primary),
                    const SizedBox(width: 4),
                    Text('$streak day${streak > 1 ? "s" : ""}',
                        style: TextStyle(fontSize: 14, color: colors.onSurface)),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: colors.onSurface.withOpacity(0.2),
                color: colors.primary,
                minHeight: 6,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: isCompleted
                    ? null
                    : () async {
                  await db.completeHabit(habitId, date);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isCompleted ? colors.surface : colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
                child: Text(isCompleted ? "Completed" : "Complete"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
