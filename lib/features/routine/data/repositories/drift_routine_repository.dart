import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/features/routine/data/mappers/routine_mapper.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/repositories/routine_repository.dart';
import 'package:uuid/uuid.dart';

class DriftRoutineRepository implements RoutineRepository {
  DriftRoutineRepository(this._dao);

  final RoutineDao _dao;
  final _uuid = const Uuid();

  Future<Routine> _assembleRoutine(RoutineRow row) async {
    final splitDayRows = await _dao.getSplitDaysForRoutine(row.id);
    final days = splitDayRows.map((d) => d.toDomain()).toList();
    return row.toDomain(days);
  }

  @override
  Future<Either<Failure, List<Routine>>> getRoutines() async {
    try {
      final rows = await _dao.getAllRoutines();
      final routines = await Future.wait(rows.map(_assembleRoutine));
      return right(routines);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Routine>> getRoutineById(String id) async {
    try {
      final row = await _dao.getRoutineById(id);
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
      final row = await _dao.getActiveRoutine();
      if (row == null) {
        return left(
          const NotFoundFailure(message: 'No active routine set.'),
        );
      }
      return right(await _assembleRoutine(row));
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveRoutine(Routine routine) async {
    try {
      await _dao.upsertRoutine(routine.toCompanion());
      await _dao.deleteSplitDaysForRoutine(routine.id);
      for (final day in routine.days) {
        await _dao.upsertSplitDay(
          day.toCompanion(
            id: _uuid.v4(),
            routineId: routine.id,
          ),
        );
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> setActiveRoutine(String id) async {
    try {
      await _dao.setActiveRoutine(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRoutine(String id) async {
    try {
      await _dao.deleteSplitDaysForRoutine(id);
      final deleted = await _dao.deleteRoutineById(id);
      if (deleted == 0) {
        return left(NotFoundFailure(message: 'Routine not found: $id'));
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}
