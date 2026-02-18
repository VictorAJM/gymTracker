import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';

/// Fetches the most recent logged set for a given exercise and wraps it in a
/// [PreviousPerformance] value object.
///
/// Used by the logging UI to pre-fill weight/reps fields and to seed
/// [CalculateProgressUseCase].
///
/// Returns [NotFoundFailure] when the exercise has never been logged before —
/// the UI should treat this as a "first time" state rather than an error.
class GetPreviousPerformanceUseCase
    implements UseCase<PreviousPerformance, String> {
  const GetPreviousPerformanceUseCase(this._repository);

  final SetLogRepository _repository;

  /// [params] is the `exerciseId` to look up.
  @override
  Future<Either<Failure, PreviousPerformance>> call(String params) async {
    final result = await _repository.getLastSetForExercise(params);
    return result.map(
      (lastSet) => PreviousPerformance(
        lastSet: lastSet,
        estimatedOneRepMax: lastSet.estimatedOneRepMax,
      ),
    );
  }
}
