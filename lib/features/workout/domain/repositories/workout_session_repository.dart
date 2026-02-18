import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/domain/entities/workout_session.dart';

/// Abstract contract for workout session persistence operations.
abstract interface class WorkoutSessionRepository {
  /// Returns all sessions, ordered by date descending.
  Future<Either<Failure, List<WorkoutSession>>> getSessions();

  /// Returns the session with the given [id], or [NotFoundFailure].
  Future<Either<Failure, WorkoutSession>> getSessionById(String id);

  /// Returns sessions whose date falls within [start]…[end] (inclusive).
  Future<Either<Failure, List<WorkoutSession>>> getSessionsByDateRange({
    required DateTime start,
    required DateTime end,
  });

  /// Returns sessions for a specific [routineId].
  Future<Either<Failure, List<WorkoutSession>>> getSessionsByRoutine(
    String routineId,
  );

  /// Persists a new or updated [session] (including its embedded set logs).
  Future<Either<Failure, Unit>> saveSession(WorkoutSession session);

  /// Permanently removes the session with [id] and all its set logs.
  Future<Either<Failure, Unit>> deleteSession(String id);
}
