import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';
import 'package:gym_tracker/features/exercise/data/repositories/drift_exercise_repository.dart';
import 'package:gym_tracker/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:gym_tracker/features/routine/data/repositories/drift_routine_repository.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/repositories/routine_repository.dart';

// ── Repository providers ──────────────────────────────────────────────────────

/// Provides the concrete [RoutineRepository] backed by Drift.
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftRoutineRepository(db.routineDao, db.routineExerciseDao);
});

/// Provides the [ExerciseRepository] scoped to the routine feature.
final routineFeatureExerciseRepoProvider = Provider<ExerciseRepository>((ref) {
  return DriftExerciseRepository(ref.watch(appDatabaseProvider).exerciseDao);
});

// ── Active routine ────────────────────────────────────────────────────────────

/// Provides the active [Routine], or null if none is set.
///
/// Used by [SplitSelectionScreen] to show exercise counts and the Edit button.
final activeRoutineProvider = FutureProvider<Routine?>((ref) async {
  final repo = ref.watch(routineRepositoryProvider);
  final result = await repo.getActiveRoutine();
  return result.fold((_) => null, (r) => r);
});
