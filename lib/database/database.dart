import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit/database/tabels.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(tables: [Habits, HabitCompletions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  @override
  int get schemaVersion => 1;

  Future<int> createHabit(HabitsCompanion habit) => into(habits).insert(habit);

  Stream<List<HabitWithStatus>> watchHabitForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    final query = select(habits).join([
      leftOuterJoin(
        habitCompletions,
        habitCompletions.habitId.equalsExp(habits.id) &
        habitCompletions.completionDate.isBetween(
          Variable(start),
          Variable(end),
        ),
      )
    ]);

    return query.watch().map((rows) => rows.map((row) {
      final habit = row.readTable(habits);
      final completion = row.readTableOrNull(habitCompletions);
      return HabitWithStatus(habit: habit, isCompleted: completion != null);
    }).toList());
  }

  Stream<int> watchDailySummary(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return (select(habitCompletions)
      ..where((hc) => hc.completionDate.isBetween(Variable(start), Variable(end))))
        .watch()
        .map((rows) => rows.length);
  }

  Future<void> completeHabit(int habitId, DateTime date) async {
    await transaction(() async {
      final start = DateTime(date.year, date.month, date.day);
      final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final existing = await (select(habitCompletions)
        ..where((hc) =>
        hc.habitId.equals(habitId) &
        hc.completionDate.isBetween(Variable(start), Variable(end))))
          .get();

      if (existing.isEmpty) {
        await into(habitCompletions).insert(HabitCompletionsCompanion(
          habitId: Value(habitId),
          completionDate: Value(date),
        ));
        final habit = await (select(habits)..where((h) => h.id.equals(habitId))).getSingle();
        await (update(habits)..where((h) => h.id.equals(habitId))).write(
          HabitsCompanion(
            streak: Value(habit.streak + 1),
            totalCompletions: Value(habit.totalCompletions + 1),
          ),
        );
      }
    });
  }
}

class HabitWithStatus {
  final Habit habit;
  final bool isCompleted;
  HabitWithStatus({required this.habit, required this.isCompleted});
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final folder = await getApplicationDocumentsDirectory();
    final file = File(p.join(folder.path, 'habit.db'));
    return NativeDatabase(file);
  });
}
