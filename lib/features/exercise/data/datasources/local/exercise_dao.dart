import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_table.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  /// Returns all exercises ordered alphabetically by name.
  Future<List<ExerciseRow>> getAllExercises() =>
      (select(exercises)..orderBy([(t) => OrderingTerm.asc(t.name)])).get();

  /// Returns the exercise with [id], or null if not found.
  Future<ExerciseRow?> getExerciseById(String id) =>
      (select(exercises)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Returns exercises whose name contains [query] (case-insensitive).
  Future<List<ExerciseRow>> searchExercises(String query) => (select(exercises)
        ..where((t) => t.name.lower().contains(query.toLowerCase()))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .get();

  /// Returns exercises with [primaryMuscle] matching [muscleStr].
  Future<List<ExerciseRow>> getByMuscleGroup(String muscleStr) =>
      (select(exercises)
            ..where((t) => t.primaryMuscle.equals(muscleStr))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

  /// Inserts or replaces an exercise row.
  Future<void> upsertExercise(ExercisesCompanion companion) =>
      into(exercises).insertOnConflictUpdate(companion);

  /// Deletes the exercise with [id]. Returns number of rows deleted.
  Future<int> deleteExerciseById(String id) =>
      (delete(exercises)..where((t) => t.id.equals(id))).go();
}
