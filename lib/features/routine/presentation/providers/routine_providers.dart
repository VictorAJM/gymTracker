import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';
import 'package:gym_tracker/features/routine/data/repositories/drift_routine_repository.dart';
import 'package:gym_tracker/features/routine/domain/repositories/routine_repository.dart';

/// Provides the concrete [RoutineRepository] backed by Drift.
///
/// Override in tests to inject a mock or in-memory implementation.
final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftRoutineRepository(db.routineDao, db.routineExerciseDao);
});
