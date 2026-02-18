import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';
import 'package:gym_tracker/features/routine/presentation/providers/routine_providers.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/providers/workout_providers.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:drift/native.dart';

void main() {
  test(
    'activeRoutineProvider returns null on fresh install (no active routine)',
    () async {
      final db = AppDatabase.forTesting(
        NativeDatabase.memory(),
        seedOnCreate: true,
      );
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() {
        container.dispose();
        db.close();
      });

      final future = container.read(activeRoutineProvider.future);
      final result = await future.timeout(const Duration(seconds: 5));
      expect(result, isNull);
    },
  );

  test(
    'ActiveWorkoutNotifier falls back to defaults when exerciseIds is empty',
    () async {
      final db = AppDatabase.forTesting(
        NativeDatabase.memory(),
        seedOnCreate: true,
      );
      final container = ProviderContainer(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
      );
      addTearDown(() {
        container.dispose();
        db.close();
      });

      // We pass EMPTY exerciseIds
      final args = ActiveWorkoutArgs(
        splitType: SplitType.push,
        exerciseIds: [],
      );

      // Read the future to trigger build
      final state = await container.read(activeWorkoutProvider(args).future);

      // Should have auto-populated
      expect(state.exercises, isNotEmpty);
      expect(
        state.exercises.first.exercise.id,
        equals('ex-bench-press'),
      ); // Default for Push
    },
  );
}
