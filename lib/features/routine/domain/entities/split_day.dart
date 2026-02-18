import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';

/// Represents a single day in a training routine.
///
/// A [SplitDay] maps a day of the week to a [SplitType] and holds
/// the ordered list of exercise IDs to be performed that day.
///
/// This is a value object — two [SplitDay]s with the same fields
/// are considered equal.
class SplitDay extends Equatable {
  const SplitDay({
    required this.dayOfWeek,
    required this.splitType,
    this.exerciseIds = const [],
  }) : assert(
         dayOfWeek >= 1 && dayOfWeek <= 7,
         'dayOfWeek must be between 1 (Monday) and 7 (Sunday)',
       );

  /// ISO weekday: 1 = Monday … 7 = Sunday.
  final int dayOfWeek;

  /// The training focus for this day (push, pull, legs, or rest).
  final SplitType splitType;

  /// Ordered list of exercise IDs to perform on this day.
  final List<String> exerciseIds;

  SplitDay copyWith({
    int? dayOfWeek,
    SplitType? splitType,
    List<String>? exerciseIds,
  }) {
    return SplitDay(
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      splitType: splitType ?? this.splitType,
      exerciseIds: exerciseIds ?? this.exerciseIds,
    );
  }

  @override
  List<Object?> get props => [dayOfWeek, splitType, exerciseIds];
}
