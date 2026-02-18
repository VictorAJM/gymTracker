import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/features/exercise/data/repositories/drift_exercise_repository.dart';
import 'package:gym_tracker/features/exercise/domain/repositories/exercise_repository.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';

/// Provides the [ExerciseDao] from the singleton database.
final exerciseDaoProvider = Provider<ExerciseDao>((ref) {
  return ref.watch(appDatabaseProvider).exerciseDao;
});

/// Provides the concrete [ExerciseRepository] backed by Drift.
final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  return DriftExerciseRepository(ref.watch(exerciseDaoProvider));
});
