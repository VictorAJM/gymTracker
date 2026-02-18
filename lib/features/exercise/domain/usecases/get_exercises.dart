import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/repositories/exercise_repository.dart';

/// Returns all exercises from the catalogue.
class GetExercises implements UseCase<List<Exercise>, NoParams> {
  const GetExercises(this._repository);

  final ExerciseRepository _repository;

  @override
  Future<Either<Failure, List<Exercise>>> call(NoParams params) =>
      _repository.getExercises();
}
