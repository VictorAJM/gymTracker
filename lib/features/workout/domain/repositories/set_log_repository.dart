import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';

/// Abstract contract for individual set log persistence operations.
///
/// In most flows, sets are saved via [WorkoutSessionRepository.saveSession].
/// This repository exists for fine-grained operations such as editing or
/// deleting a single set, and for analytics queries.
abstract interface class SetLogRepository {
  /// Returns all set logs for the given [sessionId], ordered by set number.
  Future<Either<Failure, List<SetLog>>> getSetLogsForSession(String sessionId);

  /// Returns all set logs for a specific [exerciseId] across all sessions,
  /// ordered by completion date descending. Useful for progress tracking.
  Future<Either<Failure, List<SetLog>>> getSetLogsForExercise(
    String exerciseId,
  );

  /// Returns the most recently logged set for [exerciseId].
  /// Returns [NotFoundFailure] if the exercise has never been logged.
  Future<Either<Failure, SetLog>> getLastSetForExercise(String exerciseId);

  /// Persists a single [setLog] (insert or update).
  Future<Either<Failure, Unit>> saveSetLog(SetLog setLog);

  /// Permanently removes the set log with [id].
  Future<Either<Failure, Unit>> deleteSetLog(String id);
}
