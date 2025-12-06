import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'database.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final habitsProvider = StreamProvider.autoDispose.family<List<HabitWithStatus>, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchHabitForDate(date);
});

final dailySummaryProvider = StreamProvider.autoDispose.family<int, DateTime>((ref, date) {
  final db = ref.watch(databaseProvider);
  return db.watchDailySummary(date);
});
