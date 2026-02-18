import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_table.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [WorkoutSessions])
class WorkoutDao extends DatabaseAccessor<AppDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  Future<List<WorkoutSessionRow>> getAllSessions() =>
      (select(workoutSessions)..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<WorkoutSessionRow?> getSessionById(String id) =>
      (select(workoutSessions)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<List<WorkoutSessionRow>> getSessionsByDateRange(
    int startEpoch,
    int endEpoch,
  ) =>
      (select(workoutSessions)
            ..where(
              (t) =>
                  t.date.isBiggerOrEqualValue(startEpoch) &
                  t.date.isSmallerOrEqualValue(endEpoch),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<List<WorkoutSessionRow>> getSessionsByRoutine(String routineId) =>
      (select(workoutSessions)
            ..where((t) => t.routineId.equals(routineId))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();

  Future<void> upsertSession(WorkoutSessionsCompanion companion) =>
      into(workoutSessions).insertOnConflictUpdate(companion);

  Future<int> deleteSessionById(String id) =>
      (delete(workoutSessions)..where((t) => t.id.equals(id))).go();
}
