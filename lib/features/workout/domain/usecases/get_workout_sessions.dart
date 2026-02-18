import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/workout/domain/entities/workout_session.dart';
import 'package:gym_tracker/features/workout/domain/repositories/workout_session_repository.dart';

/// Returns all workout sessions ordered by date descending.
class GetWorkoutSessions implements UseCase<List<WorkoutSession>, NoParams> {
  const GetWorkoutSessions(this._repository);

  final WorkoutSessionRepository _repository;

  @override
  Future<Either<Failure, List<WorkoutSession>>> call(NoParams params) =>
      _repository.getSessions();
}
