import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';

/// Validates and persists a single [SetLog].
///
/// Domain validation is performed *before* constructing the [SetLog] object so
/// that invalid input surfaces as a [ValidationFailure] with a user-friendly
/// message rather than an assertion error.
class SaveSetUseCase implements UseCase<Unit, SaveSetParams> {
  const SaveSetUseCase(this._repository);

  final SetLogRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(SaveSetParams params) async {
    // ── Domain validation ──────────────────────────────────────────────────
    if (params.reps < 1) {
      return left(
        const ValidationFailure(message: 'Reps must be at least 1.'),
      );
    }
    if (params.weightKg < 0) {
      return left(
        const ValidationFailure(message: 'Weight cannot be negative.'),
      );
    }
    if (params.rpe != null && (params.rpe! < 1 || params.rpe! > 10)) {
      return left(
        const ValidationFailure(message: 'RPE must be between 1 and 10.'),
      );
    }

    // ── Persist ───────────────────────────────────────────────────────────
    return _repository.saveSetLog(params.toSetLog());
  }
}

/// Input parameters for [SaveSetUseCase].
class SaveSetParams {
  const SaveSetParams({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    required this.completedAt,
    this.rpe,
    this.notes,
  });

  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final int setNumber;
  final double weightKg;
  final int reps;
  final DateTime completedAt;
  final double? rpe;
  final String? notes;

  /// Converts validated params to a domain [SetLog].
  SetLog toSetLog() => SetLog(
        id: id,
        workoutSessionId: workoutSessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weightKg: weightKg,
        reps: reps,
        completedAt: completedAt,
        rpe: rpe,
        notes: notes,
      );
}
