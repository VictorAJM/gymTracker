import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';

/// Persists a single [SetLog] to the active workout session.
///
/// This is the primary write operation during a live workout.
class LogSet implements UseCase<Unit, LogSetParams> {
  const LogSet(this._repository);

  final SetLogRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(LogSetParams params) =>
      _repository.saveSetLog(params.setLog);
}

/// Input parameters for [LogSet].
class LogSetParams {
  const LogSetParams({required this.setLog});

  final SetLog setLog;
}
