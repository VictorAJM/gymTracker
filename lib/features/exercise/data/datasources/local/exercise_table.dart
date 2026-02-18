import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/type_converters.dart';

/// Drift table definition for [Exercise] entities.
@DataClassName('ExerciseRow')
class Exercises extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get primaryMuscle => text().map(const MuscleGroupConverter())();
  TextColumn get secondaryMuscles => text()
      .map(const MuscleGroupListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get equipment => text().map(const EquipmentTypeConverter())();
  TextColumn get instructions => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
