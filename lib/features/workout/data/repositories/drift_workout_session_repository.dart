import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/set_log_dao.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_dao.dart';
import 'package:gym_tracker/features/workout/data/mappers/workout_mapper.dart';
import 'package:gym_tracker/features/workout/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workout/domain/repositories/workout_session_repository.dart';

class DriftWorkoutSessionRepository implements WorkoutSessionRepository {
  const DriftWorkoutSessionRepository({
    required WorkoutDao workoutDao,
    required SetLogDao setLogDao,
  })  : _workoutDao = workoutDao,
        _setLogDao = setLogDao;

  final WorkoutDao _workoutDao;
  final SetLogDao _setLogDao;

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<WorkoutSession> _assembleSession(WorkoutSessionRow row) async {
    final setRows = await _setLogDao.getSetLogsForSession(row.id);
    final sets = setRows.map((r) => r.toDomain()).toList();
    return row.toDomain(sets);
  }

  // ── Interface ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<WorkoutSession>>> getSessions() async {
    try {
      final rows = await _workoutDao.getAllSessions();
      final sessions = await Future.wait(rows.map(_assembleSession));
      return right(sessions);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutSession>> getSessionById(String id) async {
    try {
      final row = await _workoutDao.getSessionById(id);
      if (row == null) {
        return left(NotFoundFailure(message: 'Session not found: $id'));
      }
      return right(await _assembleSession(row));
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getSessionsByDateRange({
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final rows = await _workoutDao.getSessionsByDateRange(
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
      );
      final sessions = await Future.wait(rows.map(_assembleSession));
      return right(sessions);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkoutSession>>> getSessionsByRoutine(
    String routineId,
  ) async {
    try {
      final rows = await _workoutDao.getSessionsByRoutine(routineId);
      final sessions = await Future.wait(rows.map(_assembleSession));
      return right(sessions);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveSession(WorkoutSession session) async {
    try {
      await _workoutDao.upsertSession(session.toCompanion());
      for (final setLog in session.sets) {
        await _setLogDao.upsertSetLog(setLog.toCompanion());
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteSession(String id) async {
    try {
      await _setLogDao.deleteSetLogsForSession(id);
      final deleted = await _workoutDao.deleteSessionById(id);
      if (deleted == 0) {
        return left(NotFoundFailure(message: 'Session not found: $id'));
      }
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}
