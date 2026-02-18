// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RoutinesTable extends Routines
    with TableInfo<$RoutinesTable, RoutineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(Insertable<RoutineRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class RoutineRow extends DataClass implements Insertable<RoutineRow> {
  final String id;
  final String name;
  final bool isActive;
  final int createdAt;
  const RoutineRow(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory RoutineRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  RoutineRow copyWith(
          {String? id, String? name, bool? isActive, int? createdAt}) =>
      RoutineRow(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );
  RoutineRow copyWithCompanion(RoutinesCompanion data) {
    return RoutineRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class RoutinesCompanion extends UpdateCompanion<RoutineRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<int> createdAt;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<RoutineRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<int>? createdAt,
      Value<int>? rowid}) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SplitDaysTable extends SplitDays
    with TableInfo<$SplitDaysTable, SplitDayRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SplitDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routineIdMeta =
      const VerificationMeta('routineId');
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
      'routine_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dayOfWeekMeta =
      const VerificationMeta('dayOfWeek');
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
      'day_of_week', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SplitType, String> splitType =
      GeneratedColumn<String>('split_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SplitType>($SplitDaysTable.$convertersplitType);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
      exerciseIds = GeneratedColumn<String>('exercise_ids', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<String>>($SplitDaysTable.$converterexerciseIds);
  @override
  List<GeneratedColumn> get $columns =>
      [id, routineId, dayOfWeek, splitType, exerciseIds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'split_days';
  @override
  VerificationContext validateIntegrity(Insertable<SplitDayRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(_routineIdMeta,
          routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta));
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
          _dayOfWeekMeta,
          dayOfWeek.isAcceptableOrUnknown(
              data['day_of_week']!, _dayOfWeekMeta));
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SplitDayRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SplitDayRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      routineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}routine_id'])!,
      dayOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_week'])!,
      splitType: $SplitDaysTable.$convertersplitType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}split_type'])!),
      exerciseIds: $SplitDaysTable.$converterexerciseIds.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}exercise_ids'])!),
    );
  }

  @override
  $SplitDaysTable createAlias(String alias) {
    return $SplitDaysTable(attachedDatabase, alias);
  }

  static TypeConverter<SplitType, String> $convertersplitType =
      const SplitTypeConverter();
  static TypeConverter<List<String>, String> $converterexerciseIds =
      const StringListConverter();
}

class SplitDayRow extends DataClass implements Insertable<SplitDayRow> {
  final String id;
  final String routineId;
  final int dayOfWeek;
  final SplitType splitType;
  final List<String> exerciseIds;
  const SplitDayRow(
      {required this.id,
      required this.routineId,
      required this.dayOfWeek,
      required this.splitType,
      required this.exerciseIds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    {
      map['split_type'] = Variable<String>(
          $SplitDaysTable.$convertersplitType.toSql(splitType));
    }
    {
      map['exercise_ids'] = Variable<String>(
          $SplitDaysTable.$converterexerciseIds.toSql(exerciseIds));
    }
    return map;
  }

  SplitDaysCompanion toCompanion(bool nullToAbsent) {
    return SplitDaysCompanion(
      id: Value(id),
      routineId: Value(routineId),
      dayOfWeek: Value(dayOfWeek),
      splitType: Value(splitType),
      exerciseIds: Value(exerciseIds),
    );
  }

  factory SplitDayRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SplitDayRow(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      splitType: serializer.fromJson<SplitType>(json['splitType']),
      exerciseIds: serializer.fromJson<List<String>>(json['exerciseIds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'splitType': serializer.toJson<SplitType>(splitType),
      'exerciseIds': serializer.toJson<List<String>>(exerciseIds),
    };
  }

  SplitDayRow copyWith(
          {String? id,
          String? routineId,
          int? dayOfWeek,
          SplitType? splitType,
          List<String>? exerciseIds}) =>
      SplitDayRow(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        splitType: splitType ?? this.splitType,
        exerciseIds: exerciseIds ?? this.exerciseIds,
      );
  SplitDayRow copyWithCompanion(SplitDaysCompanion data) {
    return SplitDayRow(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      exerciseIds:
          data.exerciseIds.present ? data.exerciseIds.value : this.exerciseIds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SplitDayRow(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('splitType: $splitType, ')
          ..write('exerciseIds: $exerciseIds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, dayOfWeek, splitType, exerciseIds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SplitDayRow &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.dayOfWeek == this.dayOfWeek &&
          other.splitType == this.splitType &&
          other.exerciseIds == this.exerciseIds);
}

class SplitDaysCompanion extends UpdateCompanion<SplitDayRow> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<int> dayOfWeek;
  final Value<SplitType> splitType;
  final Value<List<String>> exerciseIds;
  final Value<int> rowid;
  const SplitDaysCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.splitType = const Value.absent(),
    this.exerciseIds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SplitDaysCompanion.insert({
    required String id,
    required String routineId,
    required int dayOfWeek,
    required SplitType splitType,
    this.exerciseIds = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        routineId = Value(routineId),
        dayOfWeek = Value(dayOfWeek),
        splitType = Value(splitType);
  static Insertable<SplitDayRow> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<int>? dayOfWeek,
    Expression<String>? splitType,
    Expression<String>? exerciseIds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (splitType != null) 'split_type': splitType,
      if (exerciseIds != null) 'exercise_ids': exerciseIds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SplitDaysCompanion copyWith(
      {Value<String>? id,
      Value<String>? routineId,
      Value<int>? dayOfWeek,
      Value<SplitType>? splitType,
      Value<List<String>>? exerciseIds,
      Value<int>? rowid}) {
    return SplitDaysCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      splitType: splitType ?? this.splitType,
      exerciseIds: exerciseIds ?? this.exerciseIds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(
          $SplitDaysTable.$convertersplitType.toSql(splitType.value));
    }
    if (exerciseIds.present) {
      map['exercise_ids'] = Variable<String>(
          $SplitDaysTable.$converterexerciseIds.toSql(exerciseIds.value));
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SplitDaysCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('splitType: $splitType, ')
          ..write('exerciseIds: $exerciseIds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, ExerciseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<MuscleGroup, String>
      primaryMuscle = GeneratedColumn<String>(
              'primary_muscle', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MuscleGroup>($ExercisesTable.$converterprimaryMuscle);
  @override
  late final GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      secondaryMuscles = GeneratedColumn<String>(
              'secondary_muscles', aliasedName, false,
              type: DriftSqlType.string,
              requiredDuringInsert: false,
              defaultValue: const Constant('[]'))
          .withConverter<List<MuscleGroup>>(
              $ExercisesTable.$convertersecondaryMuscles);
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentType, String> equipment =
      GeneratedColumn<String>('equipment', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<EquipmentType>($ExercisesTable.$converterequipment);
  static const VerificationMeta _instructionsMeta =
      const VerificationMeta('instructions');
  @override
  late final GeneratedColumn<String> instructions = GeneratedColumn<String>(
      'instructions', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCustomMeta =
      const VerificationMeta('isCustom');
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
      'is_custom', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_custom" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        primaryMuscle,
        secondaryMuscles,
        equipment,
        instructions,
        isCustom
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<ExerciseRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('instructions')) {
      context.handle(
          _instructionsMeta,
          instructions.isAcceptableOrUnknown(
              data['instructions']!, _instructionsMeta));
    }
    if (data.containsKey('is_custom')) {
      context.handle(_isCustomMeta,
          isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      primaryMuscle: $ExercisesTable.$converterprimaryMuscle.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}primary_muscle'])!),
      secondaryMuscles: $ExercisesTable.$convertersecondaryMuscles.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}secondary_muscles'])!),
      equipment: $ExercisesTable.$converterequipment.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}equipment'])!),
      instructions: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}instructions']),
      isCustom: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_custom'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<MuscleGroup, String> $converterprimaryMuscle =
      const MuscleGroupConverter();
  static TypeConverter<List<MuscleGroup>, String> $convertersecondaryMuscles =
      const MuscleGroupListConverter();
  static TypeConverter<EquipmentType, String> $converterequipment =
      const EquipmentTypeConverter();
}

class ExerciseRow extends DataClass implements Insertable<ExerciseRow> {
  final String id;
  final String name;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final EquipmentType equipment;
  final String? instructions;
  final bool isCustom;
  const ExerciseRow(
      {required this.id,
      required this.name,
      required this.primaryMuscle,
      required this.secondaryMuscles,
      required this.equipment,
      this.instructions,
      required this.isCustom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['primary_muscle'] = Variable<String>(
          $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle));
    }
    {
      map['secondary_muscles'] = Variable<String>(
          $ExercisesTable.$convertersecondaryMuscles.toSql(secondaryMuscles));
    }
    {
      map['equipment'] = Variable<String>(
          $ExercisesTable.$converterequipment.toSql(equipment));
    }
    if (!nullToAbsent || instructions != null) {
      map['instructions'] = Variable<String>(instructions);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      primaryMuscle: Value(primaryMuscle),
      secondaryMuscles: Value(secondaryMuscles),
      equipment: Value(equipment),
      instructions: instructions == null && nullToAbsent
          ? const Value.absent()
          : Value(instructions),
      isCustom: Value(isCustom),
    );
  }

  factory ExerciseRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscle: serializer.fromJson<MuscleGroup>(json['primaryMuscle']),
      secondaryMuscles:
          serializer.fromJson<List<MuscleGroup>>(json['secondaryMuscles']),
      equipment: serializer.fromJson<EquipmentType>(json['equipment']),
      instructions: serializer.fromJson<String?>(json['instructions']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'primaryMuscle': serializer.toJson<MuscleGroup>(primaryMuscle),
      'secondaryMuscles':
          serializer.toJson<List<MuscleGroup>>(secondaryMuscles),
      'equipment': serializer.toJson<EquipmentType>(equipment),
      'instructions': serializer.toJson<String?>(instructions),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  ExerciseRow copyWith(
          {String? id,
          String? name,
          MuscleGroup? primaryMuscle,
          List<MuscleGroup>? secondaryMuscles,
          EquipmentType? equipment,
          Value<String?> instructions = const Value.absent(),
          bool? isCustom}) =>
      ExerciseRow(
        id: id ?? this.id,
        name: name ?? this.name,
        primaryMuscle: primaryMuscle ?? this.primaryMuscle,
        secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
        equipment: equipment ?? this.equipment,
        instructions:
            instructions.present ? instructions.value : this.instructions,
        isCustom: isCustom ?? this.isCustom,
      );
  ExerciseRow copyWithCompanion(ExercisesCompanion data) {
    return ExerciseRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscle: data.primaryMuscle.present
          ? data.primaryMuscle.value
          : this.primaryMuscle,
      secondaryMuscles: data.secondaryMuscles.present
          ? data.secondaryMuscles.value
          : this.secondaryMuscles,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      instructions: data.instructions.present
          ? data.instructions.value
          : this.instructions,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, primaryMuscle, secondaryMuscles,
      equipment, instructions, isCustom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryMuscle == this.primaryMuscle &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.equipment == this.equipment &&
          other.instructions == this.instructions &&
          other.isCustom == this.isCustom);
}

class ExercisesCompanion extends UpdateCompanion<ExerciseRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<MuscleGroup> primaryMuscle;
  final Value<List<MuscleGroup>> secondaryMuscles;
  final Value<EquipmentType> equipment;
  final Value<String?> instructions;
  final Value<bool> isCustom;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscle = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.equipment = const Value.absent(),
    this.instructions = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    required String id,
    required String name,
    required MuscleGroup primaryMuscle,
    this.secondaryMuscles = const Value.absent(),
    required EquipmentType equipment,
    this.instructions = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        primaryMuscle = Value(primaryMuscle),
        equipment = Value(equipment);
  static Insertable<ExerciseRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? primaryMuscle,
    Expression<String>? secondaryMuscles,
    Expression<String>? equipment,
    Expression<String>? instructions,
    Expression<bool>? isCustom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryMuscle != null) 'primary_muscle': primaryMuscle,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (equipment != null) 'equipment': equipment,
      if (instructions != null) 'instructions': instructions,
      if (isCustom != null) 'is_custom': isCustom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<MuscleGroup>? primaryMuscle,
      Value<List<MuscleGroup>>? secondaryMuscles,
      Value<EquipmentType>? equipment,
      Value<String?>? instructions,
      Value<bool>? isCustom,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      isCustom: isCustom ?? this.isCustom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (primaryMuscle.present) {
      map['primary_muscle'] = Variable<String>(
          $ExercisesTable.$converterprimaryMuscle.toSql(primaryMuscle.value));
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>($ExercisesTable
          .$convertersecondaryMuscles
          .toSql(secondaryMuscles.value));
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(
          $ExercisesTable.$converterequipment.toSql(equipment.value));
    }
    if (instructions.present) {
      map['instructions'] = Variable<String>(instructions.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscle: $primaryMuscle, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('equipment: $equipment, ')
          ..write('instructions: $instructions, ')
          ..write('isCustom: $isCustom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _routineIdMeta =
      const VerificationMeta('routineId');
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
      'routine_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<SplitType, String> splitType =
      GeneratedColumn<String>('split_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<SplitType>($WorkoutSessionsTable.$convertersplitType);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
      'date', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, routineId, splitType, date, notes, durationMinutes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSessionRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(_routineIdMeta,
          routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta));
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSessionRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      routineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}routine_id'])!,
      splitType: $WorkoutSessionsTable.$convertersplitType.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}split_type'])!),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes']),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }

  static TypeConverter<SplitType, String> $convertersplitType =
      const SplitTypeConverter();
}

class WorkoutSessionRow extends DataClass
    implements Insertable<WorkoutSessionRow> {
  final String id;
  final String routineId;
  final SplitType splitType;
  final int date;
  final String? notes;
  final int? durationMinutes;
  const WorkoutSessionRow(
      {required this.id,
      required this.routineId,
      required this.splitType,
      required this.date,
      this.notes,
      this.durationMinutes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    {
      map['split_type'] = Variable<String>(
          $WorkoutSessionsTable.$convertersplitType.toSql(splitType));
    }
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      splitType: Value(splitType),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
    );
  }

  factory WorkoutSessionRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSessionRow(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      splitType: serializer.fromJson<SplitType>(json['splitType']),
      date: serializer.fromJson<int>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'splitType': serializer.toJson<SplitType>(splitType),
      'date': serializer.toJson<int>(date),
      'notes': serializer.toJson<String?>(notes),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
    };
  }

  WorkoutSessionRow copyWith(
          {String? id,
          String? routineId,
          SplitType? splitType,
          int? date,
          Value<String?> notes = const Value.absent(),
          Value<int?> durationMinutes = const Value.absent()}) =>
      WorkoutSessionRow(
        id: id ?? this.id,
        routineId: routineId ?? this.routineId,
        splitType: splitType ?? this.splitType,
        date: date ?? this.date,
        notes: notes.present ? notes.value : this.notes,
        durationMinutes: durationMinutes.present
            ? durationMinutes.value
            : this.durationMinutes,
      );
  WorkoutSessionRow copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSessionRow(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      splitType: data.splitType.present ? data.splitType.value : this.splitType,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionRow(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('splitType: $splitType, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('durationMinutes: $durationMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, routineId, splitType, date, notes, durationMinutes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSessionRow &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.splitType == this.splitType &&
          other.date == this.date &&
          other.notes == this.notes &&
          other.durationMinutes == this.durationMinutes);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSessionRow> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<SplitType> splitType;
  final Value<int> date;
  final Value<String?> notes;
  final Value<int?> durationMinutes;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.splitType = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String routineId,
    required SplitType splitType,
    required int date,
    this.notes = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        routineId = Value(routineId),
        splitType = Value(splitType),
        date = Value(date);
  static Insertable<WorkoutSessionRow> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? splitType,
    Expression<int>? date,
    Expression<String>? notes,
    Expression<int>? durationMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (splitType != null) 'split_type': splitType,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? routineId,
      Value<SplitType>? splitType,
      Value<int>? date,
      Value<String?>? notes,
      Value<int?>? durationMinutes,
      Value<int>? rowid}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      splitType: splitType ?? this.splitType,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (splitType.present) {
      map['split_type'] = Variable<String>(
          $WorkoutSessionsTable.$convertersplitType.toSql(splitType.value));
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('splitType: $splitType, ')
          ..write('date: $date, ')
          ..write('notes: $notes, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetLogsTable extends SetLogs with TableInfo<$SetLogsTable, SetLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _workoutSessionIdMeta =
      const VerificationMeta('workoutSessionId');
  @override
  late final GeneratedColumn<String> workoutSessionId = GeneratedColumn<String>(
      'workout_session_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _setNumberMeta =
      const VerificationMeta('setNumber');
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
      'set_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _rpeMeta = const VerificationMeta('rpe');
  @override
  late final GeneratedColumn<double> rpe = GeneratedColumn<double>(
      'rpe', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workoutSessionId,
        exerciseId,
        setNumber,
        weightKg,
        reps,
        rpe,
        completedAt,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_logs';
  @override
  VerificationContext validateIntegrity(Insertable<SetLogRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('workout_session_id')) {
      context.handle(
          _workoutSessionIdMeta,
          workoutSessionId.isAcceptableOrUnknown(
              data['workout_session_id']!, _workoutSessionIdMeta));
    } else if (isInserting) {
      context.missing(_workoutSessionIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(_setNumberMeta,
          setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta));
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rpe')) {
      context.handle(
          _rpeMeta, rpe.isAcceptableOrUnknown(data['rpe']!, _rpeMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetLogRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}workout_session_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      setNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_number'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      rpe: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rpe']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}completed_at'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $SetLogsTable createAlias(String alias) {
    return $SetLogsTable(attachedDatabase, alias);
  }
}

class SetLogRow extends DataClass implements Insertable<SetLogRow> {
  final String id;
  final String workoutSessionId;
  final String exerciseId;
  final int setNumber;
  final double weightKg;
  final int reps;
  final double? rpe;
  final int completedAt;
  final String? notes;
  const SetLogRow(
      {required this.id,
      required this.workoutSessionId,
      required this.exerciseId,
      required this.setNumber,
      required this.weightKg,
      required this.reps,
      this.rpe,
      required this.completedAt,
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_session_id'] = Variable<String>(workoutSessionId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rpe != null) {
      map['rpe'] = Variable<double>(rpe);
    }
    map['completed_at'] = Variable<int>(completedAt);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SetLogsCompanion toCompanion(bool nullToAbsent) {
    return SetLogsCompanion(
      id: Value(id),
      workoutSessionId: Value(workoutSessionId),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      weightKg: Value(weightKg),
      reps: Value(reps),
      rpe: rpe == null && nullToAbsent ? const Value.absent() : Value(rpe),
      completedAt: Value(completedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory SetLogRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetLogRow(
      id: serializer.fromJson<String>(json['id']),
      workoutSessionId: serializer.fromJson<String>(json['workoutSessionId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      rpe: serializer.fromJson<double?>(json['rpe']),
      completedAt: serializer.fromJson<int>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutSessionId': serializer.toJson<String>(workoutSessionId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'rpe': serializer.toJson<double?>(rpe),
      'completedAt': serializer.toJson<int>(completedAt),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  SetLogRow copyWith(
          {String? id,
          String? workoutSessionId,
          String? exerciseId,
          int? setNumber,
          double? weightKg,
          int? reps,
          Value<double?> rpe = const Value.absent(),
          int? completedAt,
          Value<String?> notes = const Value.absent()}) =>
      SetLogRow(
        id: id ?? this.id,
        workoutSessionId: workoutSessionId ?? this.workoutSessionId,
        exerciseId: exerciseId ?? this.exerciseId,
        setNumber: setNumber ?? this.setNumber,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        rpe: rpe.present ? rpe.value : this.rpe,
        completedAt: completedAt ?? this.completedAt,
        notes: notes.present ? notes.value : this.notes,
      );
  SetLogRow copyWithCompanion(SetLogsCompanion data) {
    return SetLogRow(
      id: data.id.present ? data.id.value : this.id,
      workoutSessionId: data.workoutSessionId.present
          ? data.workoutSessionId.value
          : this.workoutSessionId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      rpe: data.rpe.present ? data.rpe.value : this.rpe,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetLogRow(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutSessionId, exerciseId, setNumber,
      weightKg, reps, rpe, completedAt, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetLogRow &&
          other.id == this.id &&
          other.workoutSessionId == this.workoutSessionId &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.rpe == this.rpe &&
          other.completedAt == this.completedAt &&
          other.notes == this.notes);
}

class SetLogsCompanion extends UpdateCompanion<SetLogRow> {
  final Value<String> id;
  final Value<String> workoutSessionId;
  final Value<String> exerciseId;
  final Value<int> setNumber;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<double?> rpe;
  final Value<int> completedAt;
  final Value<String?> notes;
  final Value<int> rowid;
  const SetLogsCompanion({
    this.id = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.rpe = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetLogsCompanion.insert({
    required String id,
    required String workoutSessionId,
    required String exerciseId,
    required int setNumber,
    required double weightKg,
    required int reps,
    this.rpe = const Value.absent(),
    required int completedAt,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        workoutSessionId = Value(workoutSessionId),
        exerciseId = Value(exerciseId),
        setNumber = Value(setNumber),
        weightKg = Value(weightKg),
        reps = Value(reps),
        completedAt = Value(completedAt);
  static Insertable<SetLogRow> custom({
    Expression<String>? id,
    Expression<String>? workoutSessionId,
    Expression<String>? exerciseId,
    Expression<int>? setNumber,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<double>? rpe,
    Expression<int>? completedAt,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutSessionId != null) 'workout_session_id': workoutSessionId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (rpe != null) 'rpe': rpe,
      if (completedAt != null) 'completed_at': completedAt,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutSessionId,
      Value<String>? exerciseId,
      Value<int>? setNumber,
      Value<double>? weightKg,
      Value<int>? reps,
      Value<double?>? rpe,
      Value<int>? completedAt,
      Value<String?>? notes,
      Value<int>? rowid}) {
    return SetLogsCompanion(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      rpe: rpe ?? this.rpe,
      completedAt: completedAt ?? this.completedAt,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutSessionId.present) {
      map['workout_session_id'] = Variable<String>(workoutSessionId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rpe.present) {
      map['rpe'] = Variable<double>(rpe.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetLogsCompanion(')
          ..write('id: $id, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('rpe: $rpe, ')
          ..write('completedAt: $completedAt, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $SplitDaysTable splitDays = $SplitDaysTable(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $SetLogsTable setLogs = $SetLogsTable(this);
  late final RoutineDao routineDao = RoutineDao(this as AppDatabase);
  late final ExerciseDao exerciseDao = ExerciseDao(this as AppDatabase);
  late final WorkoutDao workoutDao = WorkoutDao(this as AppDatabase);
  late final SetLogDao setLogDao = SetLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [routines, splitDays, exercises, workoutSessions, setLogs];
}

typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String name,
  Value<bool> isActive,
  required int createdAt,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isActive,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RoutinesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RoutinesTable,
    RoutineRow,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (RoutineRow, BaseReferences<_$AppDatabase, $RoutinesTable, RoutineRow>),
    RoutineRow,
    PrefetchHooks Function()> {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutinesCompanion(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isActive = const Value.absent(),
            required int createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              RoutinesCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RoutinesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RoutinesTable,
    RoutineRow,
    $$RoutinesTableFilterComposer,
    $$RoutinesTableOrderingComposer,
    $$RoutinesTableAnnotationComposer,
    $$RoutinesTableCreateCompanionBuilder,
    $$RoutinesTableUpdateCompanionBuilder,
    (RoutineRow, BaseReferences<_$AppDatabase, $RoutinesTable, RoutineRow>),
    RoutineRow,
    PrefetchHooks Function()>;
typedef $$SplitDaysTableCreateCompanionBuilder = SplitDaysCompanion Function({
  required String id,
  required String routineId,
  required int dayOfWeek,
  required SplitType splitType,
  Value<List<String>> exerciseIds,
  Value<int> rowid,
});
typedef $$SplitDaysTableUpdateCompanionBuilder = SplitDaysCompanion Function({
  Value<String> id,
  Value<String> routineId,
  Value<int> dayOfWeek,
  Value<SplitType> splitType,
  Value<List<String>> exerciseIds,
  Value<int> rowid,
});

class $$SplitDaysTableFilterComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routineId => $composableBuilder(
      column: $table.routineId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SplitType, SplitType, String> get splitType =>
      $composableBuilder(
          column: $table.splitType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get exerciseIds => $composableBuilder(
          column: $table.exerciseIds,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$SplitDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routineId => $composableBuilder(
      column: $table.routineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get splitType => $composableBuilder(
      column: $table.splitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseIds => $composableBuilder(
      column: $table.exerciseIds, builder: (column) => ColumnOrderings(column));
}

class $$SplitDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $SplitDaysTable> {
  $$SplitDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SplitType, String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get exerciseIds =>
      $composableBuilder(
          column: $table.exerciseIds, builder: (column) => column);
}

class $$SplitDaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SplitDaysTable,
    SplitDayRow,
    $$SplitDaysTableFilterComposer,
    $$SplitDaysTableOrderingComposer,
    $$SplitDaysTableAnnotationComposer,
    $$SplitDaysTableCreateCompanionBuilder,
    $$SplitDaysTableUpdateCompanionBuilder,
    (SplitDayRow, BaseReferences<_$AppDatabase, $SplitDaysTable, SplitDayRow>),
    SplitDayRow,
    PrefetchHooks Function()> {
  $$SplitDaysTableTableManager(_$AppDatabase db, $SplitDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SplitDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SplitDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SplitDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> routineId = const Value.absent(),
            Value<int> dayOfWeek = const Value.absent(),
            Value<SplitType> splitType = const Value.absent(),
            Value<List<String>> exerciseIds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SplitDaysCompanion(
            id: id,
            routineId: routineId,
            dayOfWeek: dayOfWeek,
            splitType: splitType,
            exerciseIds: exerciseIds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String routineId,
            required int dayOfWeek,
            required SplitType splitType,
            Value<List<String>> exerciseIds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SplitDaysCompanion.insert(
            id: id,
            routineId: routineId,
            dayOfWeek: dayOfWeek,
            splitType: splitType,
            exerciseIds: exerciseIds,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SplitDaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SplitDaysTable,
    SplitDayRow,
    $$SplitDaysTableFilterComposer,
    $$SplitDaysTableOrderingComposer,
    $$SplitDaysTableAnnotationComposer,
    $$SplitDaysTableCreateCompanionBuilder,
    $$SplitDaysTableUpdateCompanionBuilder,
    (SplitDayRow, BaseReferences<_$AppDatabase, $SplitDaysTable, SplitDayRow>),
    SplitDayRow,
    PrefetchHooks Function()>;
typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  required String id,
  required String name,
  required MuscleGroup primaryMuscle,
  Value<List<MuscleGroup>> secondaryMuscles,
  required EquipmentType equipment,
  Value<String?> instructions,
  Value<bool> isCustom,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<MuscleGroup> primaryMuscle,
  Value<List<MuscleGroup>> secondaryMuscles,
  Value<EquipmentType> equipment,
  Value<String?> instructions,
  Value<bool> isCustom,
  Value<int> rowid,
});

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<MuscleGroup, MuscleGroup, String>
      get primaryMuscle => $composableBuilder(
          column: $table.primaryMuscle,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<MuscleGroup>, List<MuscleGroup>, String>
      get secondaryMuscles => $composableBuilder(
          column: $table.secondaryMuscles,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<EquipmentType, EquipmentType, String>
      get equipment => $composableBuilder(
          column: $table.equipment,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnFilters(column));
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get primaryMuscle => $composableBuilder(
      column: $table.primaryMuscle,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryMuscles => $composableBuilder(
      column: $table.secondaryMuscles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get equipment => $composableBuilder(
      column: $table.equipment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get instructions => $composableBuilder(
      column: $table.instructions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCustom => $composableBuilder(
      column: $table.isCustom, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MuscleGroup, String> get primaryMuscle =>
      $composableBuilder(
          column: $table.primaryMuscle, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      get secondaryMuscles => $composableBuilder(
          column: $table.secondaryMuscles, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentType, String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get instructions => $composableBuilder(
      column: $table.instructions, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExercisesTable,
    ExerciseRow,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (ExerciseRow, BaseReferences<_$AppDatabase, $ExercisesTable, ExerciseRow>),
    ExerciseRow,
    PrefetchHooks Function()> {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<MuscleGroup> primaryMuscle = const Value.absent(),
            Value<List<MuscleGroup>> secondaryMuscles = const Value.absent(),
            Value<EquipmentType> equipment = const Value.absent(),
            Value<String?> instructions = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            primaryMuscle: primaryMuscle,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            instructions: instructions,
            isCustom: isCustom,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required MuscleGroup primaryMuscle,
            Value<List<MuscleGroup>> secondaryMuscles = const Value.absent(),
            required EquipmentType equipment,
            Value<String?> instructions = const Value.absent(),
            Value<bool> isCustom = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            primaryMuscle: primaryMuscle,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            instructions: instructions,
            isCustom: isCustom,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExercisesTable,
    ExerciseRow,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (ExerciseRow, BaseReferences<_$AppDatabase, $ExercisesTable, ExerciseRow>),
    ExerciseRow,
    PrefetchHooks Function()>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  required String id,
  required String routineId,
  required SplitType splitType,
  required int date,
  Value<String?> notes,
  Value<int?> durationMinutes,
  Value<int> rowid,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<String> id,
  Value<String> routineId,
  Value<SplitType> splitType,
  Value<int> date,
  Value<String?> notes,
  Value<int?> durationMinutes,
  Value<int> rowid,
});

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get routineId => $composableBuilder(
      column: $table.routineId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SplitType, SplitType, String> get splitType =>
      $composableBuilder(
          column: $table.splitType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get routineId => $composableBuilder(
      column: $table.routineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get splitType => $composableBuilder(
      column: $table.splitType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SplitType, String> get splitType =>
      $composableBuilder(column: $table.splitType, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSessionRow,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSessionRow,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSessionRow>
    ),
    WorkoutSessionRow,
    PrefetchHooks Function()> {
  $$WorkoutSessionsTableTableManager(
      _$AppDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> routineId = const Value.absent(),
            Value<SplitType> splitType = const Value.absent(),
            Value<int> date = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            routineId: routineId,
            splitType: splitType,
            date: date,
            notes: notes,
            durationMinutes: durationMinutes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String routineId,
            required SplitType splitType,
            required int date,
            Value<String?> notes = const Value.absent(),
            Value<int?> durationMinutes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            routineId: routineId,
            splitType: splitType,
            date: date,
            notes: notes,
            durationMinutes: durationMinutes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WorkoutSessionsTable,
    WorkoutSessionRow,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (
      WorkoutSessionRow,
      BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSessionRow>
    ),
    WorkoutSessionRow,
    PrefetchHooks Function()>;
typedef $$SetLogsTableCreateCompanionBuilder = SetLogsCompanion Function({
  required String id,
  required String workoutSessionId,
  required String exerciseId,
  required int setNumber,
  required double weightKg,
  required int reps,
  Value<double?> rpe,
  required int completedAt,
  Value<String?> notes,
  Value<int> rowid,
});
typedef $$SetLogsTableUpdateCompanionBuilder = SetLogsCompanion Function({
  Value<String> id,
  Value<String> workoutSessionId,
  Value<String> exerciseId,
  Value<int> setNumber,
  Value<double> weightKg,
  Value<int> reps,
  Value<double?> rpe,
  Value<int> completedAt,
  Value<String?> notes,
  Value<int> rowid,
});

class $$SetLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));
}

class $$SetLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get setNumber => $composableBuilder(
      column: $table.setNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rpe => $composableBuilder(
      column: $table.rpe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$SetLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SetLogsTable> {
  $$SetLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
      column: $table.exerciseId, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get rpe =>
      $composableBuilder(column: $table.rpe, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SetLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SetLogsTable,
    SetLogRow,
    $$SetLogsTableFilterComposer,
    $$SetLogsTableOrderingComposer,
    $$SetLogsTableAnnotationComposer,
    $$SetLogsTableCreateCompanionBuilder,
    $$SetLogsTableUpdateCompanionBuilder,
    (SetLogRow, BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow>),
    SetLogRow,
    PrefetchHooks Function()> {
  $$SetLogsTableTableManager(_$AppDatabase db, $SetLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutSessionId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> setNumber = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<double?> rpe = const Value.absent(),
            Value<int> completedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetLogsCompanion(
            id: id,
            workoutSessionId: workoutSessionId,
            exerciseId: exerciseId,
            setNumber: setNumber,
            weightKg: weightKg,
            reps: reps,
            rpe: rpe,
            completedAt: completedAt,
            notes: notes,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String workoutSessionId,
            required String exerciseId,
            required int setNumber,
            required double weightKg,
            required int reps,
            Value<double?> rpe = const Value.absent(),
            required int completedAt,
            Value<String?> notes = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetLogsCompanion.insert(
            id: id,
            workoutSessionId: workoutSessionId,
            exerciseId: exerciseId,
            setNumber: setNumber,
            weightKg: weightKg,
            reps: reps,
            rpe: rpe,
            completedAt: completedAt,
            notes: notes,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SetLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SetLogsTable,
    SetLogRow,
    $$SetLogsTableFilterComposer,
    $$SetLogsTableOrderingComposer,
    $$SetLogsTableAnnotationComposer,
    $$SetLogsTableCreateCompanionBuilder,
    $$SetLogsTableUpdateCompanionBuilder,
    (SetLogRow, BaseReferences<_$AppDatabase, $SetLogsTable, SetLogRow>),
    SetLogRow,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$SplitDaysTableTableManager get splitDays =>
      $$SplitDaysTableTableManager(_db, _db.splitDays);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$SetLogsTableTableManager get setLogs =>
      $$SetLogsTableTableManager(_db, _db.setLogs);
}
