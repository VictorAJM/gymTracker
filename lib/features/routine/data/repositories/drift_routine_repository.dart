import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/data/mappers/exercise_mapper.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_exercise_dao.dart';
import 'package:gym_tracker/features/routine/data/mappers/routine_mapper.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/repositories/routine_repository.dart';
import 'package:uuid/uuid.dart';

class DriftRoutineRepository implements RoutineRepository {
  DriftRoutineRepository(this._routineDao, this._exerciseDao);

  final RoutineDao _routineDao;
  final RoutineExerciseDao _exerciseDao;
  final _uuid = const Uuid();

  // ── Assembly helper ───────────────────────────────────────────────────────

  /// Fetches a [RoutineRow] and assembles it into a full [Routine] domain
  /// object by joining [SplitDayRow]s and their [RoutineExerciseRow]s.
  Future<Routine> _assembleRoutine(RoutineRow row) async {
    final splitDayRows = await _routineDao.getSplitDaysForRoutine(row.id);

    final days = await Future.wait(
      splitDayRows.map((dayRow) async {
        final exerciseRows = await _exerciseDao.getExercisesForSplitDay(
          dayRow.id,
        );

        // Resolve each exerciseId to a domain Exercise.
        // Rows are already ordered by orderIndex from the DAO.
        final exercises = await Future.wait(
          exerciseRows.map((re) async {
            final exRow = await _routineDao.db.exerciseDao.getExerciseById(
              re.exerciseId,
            );
            return exRow?.toDomain();
          }),
        );

        return dayRow.toDomain(exercises.whereType<Exercise>().toList());
      }),
    );

    return row.toDomain(days);
  }

  // ── RoutineRepository ─────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<Routine>>> getRoutines() async {
    try {
      final rows = await _routineDao.getAllRoutines();
      final routines = await Future.wait(rows.map(_assembleRoutine));
      return right(routines);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Routine>> getRoutineById(String id) async {
    try {
      final row = await _routineDao.getRoutineById(id);
      if (row == null) {
        return left(NotFoundFailure(message: 'Routine not found: $id'));
      }
      return right(await _assembleRoutine(row));
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Routine>> getActiveRoutine() async {
    try {
      final row = await _routineDao.getActiveRoutine();
      if (row == null) {
        return left(const NotFoundFailure(message: 'No active routine set.'));
      }
      return right(await _assembleRoutine(row));
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveRoutine(Routine routine) async {
    try {
      await _routineDao.upsertRoutine(routine.toCompanion());
      await _routineDao.deleteSplitDaysForRoutine(routine.id);

      for (final day in routine.days) {
        await _routineDao.upsertSplitDay(
          day.toCompanion(routineId: routine.id),
        );

        // Write the ordered exercise list to the junction table.
        await _exerciseDao.replaceExercisesForSplitDay(day.id, [
          for (var i = 0; i < day.exercises.length; i++)
            RoutineExercisesCompanion(
              id: Value(_uuid.v4()),
              splitDayId: Value(day.id),
              exerciseId: Value(day.exercises[i].id),
              orderIndex: Value(i),
            ),
        ]);
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActiveRoutine(String id) async {
    try {
      await _routineDao.setActiveRoutine(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRoutine(String id) async {
    try {
      await _routineDao.deleteSplitDaysForRoutine(id);
      final deleted = await _routineDao.deleteRoutineById(id);
      if (deleted == 0) {
        return left(NotFoundFailure(message: 'Routine not found: $id'));
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRoutineExercises(
    String splitDayId,
    List<Exercise> exercises,
  ) async {
    try {
      await _exerciseDao.replaceExercisesForSplitDay(splitDayId, [
        for (var i = 0; i < exercises.length; i++)
          RoutineExercisesCompanion(
            id: Value(_uuid.v4()),
            splitDayId: Value(splitDayId),
            exerciseId: Value(exercises[i].id),
            orderIndex: Value(i),
          ),
      ]);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}
