import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_table.dart';

part 'set_log_dao.g.dart';

@DriftAccessor(tables: [SetLogs])
class SetLogDao extends DatabaseAccessor<AppDatabase> with _$SetLogDaoMixin {
  SetLogDao(super.db);

  /// Returns all set logs for [sessionId], ordered by set number.
  Future<List<SetLogRow>> getSetLogsForSession(String sessionId) =>
      (select(setLogs)
            ..where((t) => t.workoutSessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.setNumber)]))
          .get();

  /// Returns all set logs for [exerciseId] across all sessions,
  /// ordered by completion date descending (most recent first).
  Future<List<SetLogRow>> getSetLogsForExercise(String exerciseId) =>
      (select(setLogs)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]))
          .get();

  /// Returns the single most recently completed set for [exerciseId].
  /// Returns null if the exercise has never been logged.
  Future<SetLogRow?> getLastSetForExercise(String exerciseId) =>
      (select(setLogs)
            ..where((t) => t.exerciseId.equals(exerciseId))
            ..orderBy([(t) => OrderingTerm.desc(t.completedAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Inserts or replaces a set log row.
  Future<void> upsertSetLog(SetLogsCompanion companion) =>
      into(setLogs).insertOnConflictUpdate(companion);

  /// Deletes the set log with [id]. Returns number of rows deleted.
  Future<int> deleteSetLogById(String id) =>
      (delete(setLogs)..where((t) => t.id.equals(id))).go();

  /// Deletes all set logs belonging to [sessionId].
  Future<int> deleteSetLogsForSession(String sessionId) =>
      (delete(setLogs)..where((t) => t.workoutSessionId.equals(sessionId)))
          .go();
}
