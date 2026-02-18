import 'package:equatable/equatable.dart';

/// Records a single set performed for an exercise within a [WorkoutSession].
///
/// [SetLog] is a value object capturing the key performance metrics:
/// weight, reps, and optionally RPE (Rate of Perceived Exertion).
class SetLog extends Equatable {
  const SetLog({
    required this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.setNumber,
    required this.weightKg,
    required this.reps,
    required this.completedAt,
    this.rpe,
    this.notes,
  }) : assert(setNumber >= 1, 'setNumber must be at least 1'),
       assert(weightKg >= 0, 'weightKg must be non-negative'),
       assert(reps >= 0, 'reps must be non-negative'),
       assert(
         rpe == null || (rpe >= 1 && rpe <= 10),
         'RPE must be between 1 and 10',
       );

  /// Unique identifier (UUID v4).
  final String id;

  /// The session this set belongs to.
  final String workoutSessionId;

  /// The exercise being performed.
  final String exerciseId;

  /// 1-based index of this set within the exercise for the session.
  final int setNumber;

  /// Load lifted in kilograms. Use 0 for bodyweight exercises.
  final double weightKg;

  /// Number of repetitions completed.
  final int reps;

  /// Rate of Perceived Exertion (1–10 scale). Null if not recorded.
  final double? rpe;

  /// Timestamp when this set was logged.
  final DateTime completedAt;

  /// Optional free-text notes (e.g. "paused reps", "close grip").
  final String? notes;

  SetLog copyWith({
    String? id,
    String? workoutSessionId,
    String? exerciseId,
    int? setNumber,
    double? weightKg,
    int? reps,
    double? rpe,
    DateTime? completedAt,
    String? notes,
  }) {
    return SetLog(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
    );
  }

  /// Convenience: estimated 1-rep max using the Epley formula.
  /// Returns null if reps == 1 (already a 1RM) or reps == 0.
  double? get estimatedOneRepMax {
    if (reps <= 0) return null;
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30);
  }

  @override
  List<Object?> get props => [
    id,
    workoutSessionId,
    exerciseId,
    setNumber,
    weightKg,
    reps,
    rpe,
    completedAt,
    notes,
  ];
}
