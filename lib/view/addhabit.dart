import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../database/database_provider.dart';
import '../database/database.dart';

class AddHabitScreen extends HookConsumerWidget {
  const AddHabitScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final descController = useTextEditingController();
    final isDaily = useState(true);
    final db = ref.read(databaseProvider);

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Habit")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          shadowColor: colors.shadow.withOpacity(0.2),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [colors.primary, colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "New Habit",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: "Title",
                    labelStyle: TextStyle(color: colors.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.onPrimary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.onPrimary),
                    ),
                  ),
                  style: TextStyle(color: colors.onPrimary),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: "Description (Optional)",
                    labelStyle: TextStyle(color: colors.onPrimary),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.onPrimary.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: colors.onPrimary),
                    ),
                  ),
                  style: TextStyle(color: colors.onPrimary),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  value: isDaily.value,
                  onChanged: (val) => isDaily.value = val,
                  title: Text("Daily Habit", style: TextStyle(color: colors.onPrimary)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.onPrimary,
                      foregroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () async {
                      if (titleController.text.isNotEmpty) {
                        await db.createHabit(HabitsCompanion(
                          title: Value(titleController.text),
                          description: Value(descController.text),
                          isDaily: Value(isDaily.value),
                        ));
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Add Habit", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
