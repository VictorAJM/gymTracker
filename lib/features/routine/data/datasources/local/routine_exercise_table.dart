import 'package:drift/drift.dart';

/// Junction table linking a [SplitDay] to its ordered [Exercise] list.
///
/// Replaces the old `exercise_ids` JSON blob on `split_days`.
/// Each row represents one exercise slot in a specific split day.
@DataClassName('RoutineExerciseRow')
class RoutineExercises extends Table {
  /// Unique row identifier (UUID v4).
  TextColumn get id => text()();

  /// FK → split_days.id
  TextColumn get splitDayId => text()();

  /// FK → exercises.id
  TextColumn get exerciseId => text()();

  /// 0-based position within the day's exercise list.
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
