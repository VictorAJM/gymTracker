import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';

/// The most recent logged performance for a given exercise.
///
/// Returned by [GetPreviousPerformanceUseCase] and used to pre-fill the
/// weight / reps fields in the logging UI and to seed [CalculateProgressUseCase].
class PreviousPerformance extends Equatable {
  const PreviousPerformance({
    required this.lastSet,
    required this.estimatedOneRepMax,
  });

  /// The most recently completed set for this exercise.
  final SetLog lastSet;

  /// Pre-computed estimated 1-rep max (Epley formula).
  /// Null when [lastSet.reps] == 0.
  final double? estimatedOneRepMax;

  @override
  List<Object?> get props => [lastSet, estimatedOneRepMax];
}
