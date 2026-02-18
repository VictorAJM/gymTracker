import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';

/// Represents a single training session on a specific date.
///
/// A [WorkoutSession] is created when the user starts training and
/// accumulates [SetLog] entries as they complete each set.
class WorkoutSession extends Equatable {
  const WorkoutSession({
    required this.id,
    required this.routineId,
    required this.splitType,
    required this.date,
    this.sets = const [],
    this.notes,
    this.durationMinutes,
  });

  /// Unique identifier (UUID v4).
  final String id;

  /// The routine this session belongs to.
  final String routineId;

  /// Which day of the split this session represents (push/pull/legs).
  final SplitType splitType;

  /// The calendar date this session took place.
  final DateTime date;

  /// All sets logged during this session, ordered by completion time.
  final List<SetLog> sets;

  /// Optional free-text notes for the overall session.
  final String? notes;

  /// Total session duration in minutes. Null if not tracked.
  final int? durationMinutes;

  // ---------------------------------------------------------------------------
  // Computed domain properties
  // ---------------------------------------------------------------------------

  /// Returns all sets for a specific exercise within this session.
  List<SetLog> setsForExercise(String exerciseId) =>
      sets.where((s) => s.exerciseId == exerciseId).toList();

  /// Returns the distinct exercise IDs performed in this session.
  Set<String> get exerciseIds => sets.map((s) => s.exerciseId).toSet();

  /// Total volume (sum of weight × reps) across all sets.
  double get totalVolumeKg =>
      sets.fold(0.0, (acc, s) => acc + s.weightKg * s.reps);

  WorkoutSession copyWith({
    String? id,
    String? routineId,
    SplitType? splitType,
    DateTime? date,
    List<SetLog>? sets,
    String? notes,
    int? durationMinutes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      splitType: splitType ?? this.splitType,
      date: date ?? this.date,
      sets: sets ?? this.sets,
      notes: notes ?? this.notes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    routineId,
    splitType,
    date,
    sets,
    notes,
    durationMinutes,
  ];
}
