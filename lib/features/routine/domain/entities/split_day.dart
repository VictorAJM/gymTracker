import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';

/// Represents a single day in a training routine.
///
/// A [SplitDay] maps a day of the week to a [SplitType] and holds
/// the ordered list of [Exercise]s to be performed that day.
///
/// This is a value object — two [SplitDay]s with the same fields
/// are considered equal.
class SplitDay extends Equatable {
  const SplitDay({
    required this.id,
    required this.dayOfWeek,
    required this.splitType,
    this.exercises = const [],
  }) : assert(
         dayOfWeek >= 1 && dayOfWeek <= 7,
         'dayOfWeek must be between 1 (Monday) and 7 (Sunday)',
       );

  /// Database row ID (UUID v4). Used to persist exercise changes via
  /// [RoutineRepository.updateRoutineExercises].
  final String id;

  /// ISO weekday: 1 = Monday … 7 = Sunday.
  final int dayOfWeek;

  /// The training focus for this day (push, pull, legs, or rest).
  final SplitType splitType;

  /// Ordered list of exercises to perform on this day.
  final List<Exercise> exercises;

  SplitDay copyWith({
    String? id,
    int? dayOfWeek,
    SplitType? splitType,
    List<Exercise>? exercises,
  }) {
    return SplitDay(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      splitType: splitType ?? this.splitType,
      exercises: exercises ?? this.exercises,
    );
  }

  @override
  List<Object?> get props => [id, dayOfWeek, splitType, exercises];
}
