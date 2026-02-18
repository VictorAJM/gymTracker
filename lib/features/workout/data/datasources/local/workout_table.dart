import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/type_converters.dart';

/// Drift table definition for [WorkoutSession] entities.
@DataClassName('WorkoutSessionRow')
class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text()();
  TextColumn get splitType => text().map(const SplitTypeConverter())();
  IntColumn get date => integer()(); // epoch milliseconds
  TextColumn get notes => text().nullable()();
  IntColumn get durationMinutes => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table definition for [SetLog] value objects.
@DataClassName('SetLogRow')
class SetLogs extends Table {
  TextColumn get id => text()();
  TextColumn get workoutSessionId => text()();
  TextColumn get exerciseId => text()();
  IntColumn get setNumber => integer()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  RealColumn get rpe => real().nullable()();
  IntColumn get completedAt => integer()(); // epoch milliseconds
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
