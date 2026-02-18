import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/usecase/usecase.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';

/// Compares a [current] set against an optional [previous] set and returns a
/// [ProgressStatus] describing the outcome.
///
/// This use case is **pure and synchronous** — it performs no I/O and holds no
/// state. The caller is responsible for fetching the previous set (typically
/// via [GetPreviousPerformanceUseCase]) before invoking this use case.
///
/// **Comparison metric**: estimated 1-rep max (Epley formula).
/// Using e1RM avoids the apples-to-oranges problem when comparing sets with
/// different rep ranges (e.g. 100 kg × 3 vs 80 kg × 5).
///
/// **Tolerance**: changes within ±[tolerancePercent] are classified as [Same]
/// to avoid noise from minor load adjustments.
class CalculateProgressUseCase
    implements UseCase<ProgressStatus, CalculateProgressParams> {
  const CalculateProgressUseCase({this.tolerancePercent = 0.01});

  /// Fractional tolerance for "Same" classification (default 1%).
  final double tolerancePercent;

  @override
  Future<Either<Failure, ProgressStatus>> call(
    CalculateProgressParams params,
  ) async =>
      right(_compare(params.current, params.previous));

  // ── Private helpers ──────────────────────────────────────────────────────

  ProgressStatus _compare(SetLog current, SetLog? previous) {
    if (previous == null) return const FirstTime();

    final currentE1rm = _e1rm(current);
    final previousE1rm = _e1rm(previous);

    // Fall back to raw weight when e1RM is unavailable (reps == 0).
    final currentValue = currentE1rm ?? current.weightKg;
    final previousValue = previousE1rm ?? previous.weightKg;

    if (previousValue == 0) {
      // Avoid division by zero: any weight > 0 is progress.
      return currentValue > 0
          ? const Progressed(deltaPercent: 1.0)
          : const Same();
    }

    final delta = (currentValue - previousValue) / previousValue;

    if (delta > tolerancePercent) return Progressed(deltaPercent: delta);
    if (delta < -tolerancePercent) return Regressed(deltaPercent: delta);
    return const Same();
  }

  /// Returns the Epley estimated 1-rep max, or null when reps == 0.
  double? _e1rm(SetLog set) {
    if (set.reps <= 0) return null;
    if (set.reps == 1) return set.weightKg;
    return set.weightKg * (1 + set.reps / 30);
  }
}

/// Input parameters for [CalculateProgressUseCase].
class CalculateProgressParams {
  const CalculateProgressParams({
    required this.current,
    this.previous,
  });

  /// The set just logged.
  final SetLog current;

  /// The most recently logged set for the same exercise from a prior session.
  /// Pass `null` to indicate no prior history.
  final SetLog? previous;
}
