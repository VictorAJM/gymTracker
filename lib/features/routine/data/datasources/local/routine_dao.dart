import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_table.dart';

part 'routine_dao.g.dart';

@DriftAccessor(tables: [Routines, SplitDays])
class RoutineDao extends DatabaseAccessor<AppDatabase> with _$RoutineDaoMixin {
  RoutineDao(super.db);

  // ── Routines ──────────────────────────────────────────────────────────────

  Future<List<RoutineRow>> getAllRoutines() =>
      (select(routines)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<RoutineRow?> getRoutineById(String id) =>
      (select(routines)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<RoutineRow?> getActiveRoutine() =>
      (select(routines)..where((t) => t.isActive.equals(true)))
          .getSingleOrNull();

  Future<void> upsertRoutine(RoutinesCompanion companion) =>
      into(routines).insertOnConflictUpdate(companion);

  /// Sets [id] as active and deactivates all others in a single transaction.
  Future<void> setActiveRoutine(String id) => transaction(() async {
        await (update(routines))
            .write(const RoutinesCompanion(isActive: Value(false)));
        await (update(routines)..where((t) => t.id.equals(id)))
            .write(const RoutinesCompanion(isActive: Value(true)));
      });

  Future<int> deleteRoutineById(String id) =>
      (delete(routines)..where((t) => t.id.equals(id))).go();

  // ── SplitDays ─────────────────────────────────────────────────────────────

  Future<List<SplitDayRow>> getSplitDaysForRoutine(String routineId) =>
      (select(splitDays)
            ..where((t) => t.routineId.equals(routineId))
            ..orderBy([(t) => OrderingTerm.asc(t.dayOfWeek)]))
          .get();

  Future<void> upsertSplitDay(SplitDaysCompanion companion) =>
      into(splitDays).insertOnConflictUpdate(companion);

  Future<int> deleteSplitDaysForRoutine(String routineId) =>
      (delete(splitDays)..where((t) => t.routineId.equals(routineId))).go();
}
