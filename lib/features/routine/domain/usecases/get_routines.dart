import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/repositories/routine_repository.dart';

/// Returns all saved routines from the repository.
class GetRoutines implements UseCase<List<Routine>, NoParams> {
  const GetRoutines(this._repository);

  final RoutineRepository _repository;

  @override
  Future<Either<Failure, List<Routine>>> call(NoParams params) =>
      _repository.getRoutines();
}
