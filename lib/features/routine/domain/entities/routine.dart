import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_day.dart';

/// A training routine defining the weekly PPL schedule.
///
/// A [Routine] contains an ordered list of [SplitDay]s that map
/// each day of the week to a training focus and set of exercises.
class Routine extends Equatable {
  const Routine({
    required this.id,
    required this.name,
    required this.days,
    required this.createdAt,
    this.isActive = false,
  });

  /// Unique identifier (UUID v4).
  final String id;

  /// User-defined name (e.g. "My PPL 6-Day").
  final String name;

  /// The 7-day schedule. May contain fewer than 7 entries if some days
  /// are unscheduled.
  final List<SplitDay> days;

  /// Timestamp when this routine was first created.
  final DateTime createdAt;

  /// Whether this is the currently active routine.
  final bool isActive;

  Routine copyWith({
    String? id,
    String? name,
    List<SplitDay>? days,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Routine(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, days, createdAt, isActive];
}
