import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';

/// Abstract contract for exercise catalogue persistence operations.
abstract interface class ExerciseRepository {
  /// Returns all exercises (built-in + custom), ordered alphabetically.
  Future<Either<Failure, List<Exercise>>> getExercises();

  /// Returns the exercise with the given [id], or [NotFoundFailure].
  Future<Either<Failure, Exercise>> getExerciseById(String id);

  /// Returns exercises whose name contains [query] (case-insensitive).
  Future<Either<Failure, List<Exercise>>> searchExercises(String query);

  /// Returns exercises targeting the given [muscleGroup] as primary muscle.
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscleGroup(
    MuscleGroup muscleGroup,
  );

  /// Persists a new or updated [exercise].
  Future<Either<Failure, Unit>> saveExercise(Exercise exercise);

  /// Permanently removes the exercise with [id].
  /// Built-in exercises cannot be deleted ([ValidationFailure] is returned).
  Future<Either<Failure, Unit>> deleteExercise(String id);
}
