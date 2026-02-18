import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/set_log_dao.dart';
import 'package:gym_tracker/features/workout/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';

class DriftSetLogRepository implements SetLogRepository {
  const DriftSetLogRepository(this._dao);

  final SetLogDao _dao;

  @override
  Future<Either<Failure, List<SetLog>>> getSetLogsForSession(
    String sessionId,
  ) async {
    try {
      final rows = await _dao.getSetLogsForSession(sessionId);
      return right(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SetLog>>> getSetLogsForExercise(
    String exerciseId,
  ) async {
    try {
      final rows = await _dao.getSetLogsForExercise(exerciseId);
      return right(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SetLog>> getLastSetForExercise(
    String exerciseId,
  ) async {
    try {
      final row = await _dao.getLastSetForExercise(exerciseId);
      if (row == null) {
        return left(
          NotFoundFailure(
            message: 'No sets found for exercise: $exerciseId',
          ),
        );
      }
      return right(row.toDomain());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSetLog(SetLog setLog) async {
    try {
      await _dao.upsertSetLog(setLog.toCompanion());
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSetLog(String id) async {
    try {
      final deleted = await _dao.deleteSetLogById(id);
      if (deleted == 0) {
        return left(NotFoundFailure(message: 'SetLog not found: $id'));
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}
