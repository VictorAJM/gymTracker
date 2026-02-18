import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_exercise_table.dart';

part 'routine_exercise_dao.g.dart';

@DriftAccessor(tables: [RoutineExercises])
class RoutineExerciseDao extends DatabaseAccessor<AppDatabase>
    with _$RoutineExerciseDaoMixin {
  RoutineExerciseDao(super.db);

  /// Returns all exercise rows for [splitDayId], ordered by [orderIndex].
  Future<List<RoutineExerciseRow>> getExercisesForSplitDay(String splitDayId) =>
      (select(routineExercises)
            ..where((t) => t.splitDayId.equals(splitDayId))
            ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]))
          .get();

  /// Atomically deletes all existing exercises for [splitDayId] and inserts
  /// [companions] in their place. Runs inside a transaction.
  Future<void> replaceExercisesForSplitDay(
    String splitDayId,
    List<RoutineExercisesCompanion> companions,
  ) => transaction(() async {
    await (delete(routineExercises)
      ..where((t) => t.splitDayId.equals(splitDayId))).go();
    for (final c in companions) {
      await into(routineExercises).insert(c);
    }
  });

  /// Deletes all exercise rows for [splitDayId].
  Future<void> deleteExercisesForSplitDay(String splitDayId) =>
      (delete(routineExercises)
        ..where((t) => t.splitDayId.equals(splitDayId))).go();
}
