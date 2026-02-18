import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';

/// Abstract contract for all routine persistence operations.
///
/// Implementations live in the Data layer (e.g. [DriftRoutineRepository]).
/// The domain layer depends only on this interface.
abstract interface class RoutineRepository {
  /// Returns all saved routines, ordered by creation date descending.
  Future<Either<Failure, List<Routine>>> getRoutines();

  /// Returns the routine with the given [id], or [NotFoundFailure].
  Future<Either<Failure, Routine>> getRoutineById(String id);

  /// Returns the currently active routine, or [NotFoundFailure] if none set.
  Future<Either<Failure, Routine>> getActiveRoutine();

  /// Persists a new or updated [routine].
  /// If a routine with the same [id] exists it will be replaced.
  Future<Either<Failure, Unit>> saveRoutine(Routine routine);

  /// Sets the routine with [id] as active and deactivates all others.
  Future<Either<Failure, Unit>> setActiveRoutine(String id);

  /// Permanently removes the routine with [id].
  Future<Either<Failure, Unit>> deleteRoutine(String id);

  /// Atomically replaces the exercise list for the split day identified by
  /// [splitDayId]. The order of [exercises] is preserved.
  ///
  /// Returns [NotFoundFailure] if [splitDayId] does not exist.
  Future<Either<Failure, Unit>> updateRoutineExercises(
    String splitDayId,
    List<Exercise> exercises,
  );
}
