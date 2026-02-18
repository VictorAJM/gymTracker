import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/type_converters.dart';

/// Drift table definition for [Routine] entities.
@DataClassName('RoutineRow')
class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()(); // epoch milliseconds

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table definition for [SplitDay] value objects.
@DataClassName('SplitDayRow')
class SplitDays extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text()();
  IntColumn get dayOfWeek => integer()(); // 1 = Monday … 7 = Sunday
  TextColumn get splitType => text().map(const SplitTypeConverter())();
  TextColumn get exerciseIds => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();

  @override
  Set<Column> get primaryKey => {id};
}
