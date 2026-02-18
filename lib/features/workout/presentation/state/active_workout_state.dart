import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';

part 'active_workout_state.freezed.dart';

// ── Supporting models ─────────────────────────────────────────────────────────

/// A single set that has been entered (but not yet committed to DB).
class LoggedSet {
  const LoggedSet({
    required this.id,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    this.rpe,
    this.progress,
  });

  final String id;
  final int setNumber;
  final double weightKg;
  final int reps;
  final double? rpe;

  /// Progress vs. the previous session's last set. Null until the set is saved.
  final ProgressStatus? progress;

  LoggedSet copyWith({
    String? id,
    int? setNumber,
    double? weightKg,
    int? reps,
    double? rpe,
    ProgressStatus? progress,
  }) =>
      LoggedSet(
        id: id ?? this.id,
        setNumber: setNumber ?? this.setNumber,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        rpe: rpe ?? this.rpe,
        progress: progress ?? this.progress,
      );
}

/// One exercise in the active workout, bundled with its previous performance
/// and the sets logged so far this session.
class ExerciseEntry {
  const ExerciseEntry({
    required this.exercise,
    this.previousPerformance,
    this.sets = const [],
  });

  final Exercise exercise;

  /// Null when this exercise has never been logged before.
  final PreviousPerformance? previousPerformance;

  /// Sets logged during the current session (in order).
  final List<LoggedSet> sets;

  ExerciseEntry copyWith({
    Exercise? exercise,
    PreviousPerformance? previousPerformance,
    List<LoggedSet>? sets,
  }) =>
      ExerciseEntry(
        exercise: exercise ?? this.exercise,
        previousPerformance: previousPerformance ?? this.previousPerformance,
        sets: sets ?? this.sets,
      );
}

// ── Freezed UI state ──────────────────────────────────────────────────────────

@freezed
class ActiveWorkoutState with _$ActiveWorkoutState {
  /// Exercises loaded and ready to log.
  const factory ActiveWorkoutState.loaded({
    required List<ExerciseEntry> exercises,

    /// The exercise card currently expanded. Null = all collapsed.
    required String? expandedExerciseId,

    /// UUID of the workout session created when the screen opened.
    required String sessionId,
  }) = ActiveWorkoutLoaded;

  const factory ActiveWorkoutState.loading() = ActiveWorkoutLoading;

  const factory ActiveWorkoutState.error(String message) = ActiveWorkoutError;
}
