import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit/view/addhabit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/dailycard.dart';
import '../components/timeline.dart';
import '../database/database.dart';
import '../database/database_provider.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = useState(DateTime.now());
    final db = ref.watch(databaseProvider);

    final habitsStream = ref.watch(
      StreamProvider.autoDispose<List<HabitWithStatus>>(
            (ref) => db.watchHabitForDate(selectedDate.value),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "HabitFlare",
          style: TextStyle(
            fontFamily: 'Playwrite Norge',
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimelineView(
                selectedDate: selectedDate.value,
                onDateChange: (date) => selectedDate.value = date,
              ),
              habitsStream.when(
                data: (habits) {
                  final completed = habits.where((h) => h.isCompleted).length;
                  final total = habits.length;
                  return Daily(
                    completedtasks: completed,
                    totaltasks: total,
                    date:
                    "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2,'0')}-${selectedDate.value.day.toString().padLeft(2,'0')}",
                    selectedDate: selectedDate.value,
                  );
                },
                loading: () => Daily(
                  completedtasks: 0,
                  totaltasks: 0,
                  date:
                  "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2,'0')}-${selectedDate.value.day.toString().padLeft(2,'0')}",
                  selectedDate: selectedDate.value,
                ),
                error: (e, _) => Daily(
                  completedtasks: 0,
                  totaltasks: 0,
                  date:
                  "${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2,'0')}-${selectedDate.value.day.toString().padLeft(2,'0')}",
                  selectedDate: selectedDate.value,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddHabitScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
