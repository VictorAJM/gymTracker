import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';

// ---------------------------------------------------------------------------
// SplitType
// ---------------------------------------------------------------------------

class SplitTypeConverter extends TypeConverter<SplitType, String> {
  const SplitTypeConverter();

  @override
  SplitType fromSql(String fromDb) => SplitType.values.byName(fromDb);

  @override
  String toSql(SplitType value) => value.name;
}

// ---------------------------------------------------------------------------
// MuscleGroup
// ---------------------------------------------------------------------------

class MuscleGroupConverter extends TypeConverter<MuscleGroup, String> {
  const MuscleGroupConverter();

  @override
  MuscleGroup fromSql(String fromDb) => MuscleGroup.values.byName(fromDb);

  @override
  String toSql(MuscleGroup value) => value.name;
}

// ---------------------------------------------------------------------------
// EquipmentType
// ---------------------------------------------------------------------------

class EquipmentTypeConverter extends TypeConverter<EquipmentType, String> {
  const EquipmentTypeConverter();

  @override
  EquipmentType fromSql(String fromDb) => EquipmentType.values.byName(fromDb);

  @override
  String toSql(EquipmentType value) => value.name;
}

// ---------------------------------------------------------------------------
// List<String>  (JSON-encoded — used for exerciseIds)
// ---------------------------------------------------------------------------

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>).cast<String>();

  @override
  String toSql(List<String> value) => jsonEncode(value);
}

// ---------------------------------------------------------------------------
// List<MuscleGroup>  (JSON-encoded — used for secondaryMuscles)
// ---------------------------------------------------------------------------

class MuscleGroupListConverter
    extends TypeConverter<List<MuscleGroup>, String> {
  const MuscleGroupListConverter();

  @override
  List<MuscleGroup> fromSql(String fromDb) =>
      (jsonDecode(fromDb) as List<dynamic>)
          .cast<String>()
          .map(MuscleGroup.values.byName)
          .toList();

  @override
  String toSql(List<MuscleGroup> value) =>
      jsonEncode(value.map((m) => m.name).toList());
}
