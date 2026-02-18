import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gym_tracker/core/database/type_converters.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_table.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_exercise_dao.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_exercise_table.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_table.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/set_log_dao.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_dao.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Routines,
    SplitDays,
    RoutineExercises,
    Exercises,
    WorkoutSessions,
    SetLogs,
  ],
  daos: [RoutineDao, RoutineExerciseDao, ExerciseDao, WorkoutDao, SetLogDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : _seedOnCreate = true, super(_openConnection());

  /// Constructor for in-memory databases used in tests.
  ///
  /// Seeding is disabled so tests start with a clean, empty [exercises] table.
  AppDatabase.forTesting(super.executor) : _seedOnCreate = false;

  /// Whether to seed the exercise master list when the database is first created.
  final bool _seedOnCreate;

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      if (_seedOnCreate) await _seedExercisesIfEmpty();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _migrateV1toV2(m);
      }
    },
  );

  // ── v1 → v2 migration ────────────────────────────────────────────────────

  /// Migrates from schema v1 (exerciseIds JSON blob on split_days) to v2
  /// (RoutineExercises junction table).
  ///
  /// Steps:
  ///   1. Create the new `routine_exercises` table.
  ///   2. Read every `split_days` row, parse its `exercise_ids` JSON blob,
  ///      and insert one `routine_exercises` row per exercise (preserving order).
  ///   3. The `exercise_ids` column is removed from the Dart model — Drift will
  ///      no longer read or write it (the SQLite column remains as dead weight,
  ///      which is safe and the standard Drift approach for SQLite < 3.35).
  ///   4. Seed the exercise master list if the exercises table is empty.
  Future<void> _migrateV1toV2(Migrator m) async {
    // 1. Create the new junction table.
    await m.createTable(routineExercises);

    // 2. Migrate existing exercise_ids blobs → routine_exercises rows.
    const uuid = Uuid();
    final splitDayRows =
        await customSelect(
          'SELECT id, exercise_ids FROM split_days',
          readsFrom: {splitDays},
        ).get();

    for (final row in splitDayRows) {
      final splitDayId = row.read<String>('id');
      final blob = row.read<String?>('exercise_ids') ?? '[]';
      final exerciseIds = (jsonDecode(blob) as List<dynamic>).cast<String>();

      for (var i = 0; i < exerciseIds.length; i++) {
        await into(routineExercises).insert(
          RoutineExercisesCompanion(
            id: Value(uuid.v4()),
            splitDayId: Value(splitDayId),
            exerciseId: Value(exerciseIds[i]),
            orderIndex: Value(i),
          ),
        );
      }
    }

    // 3. Seed exercises if the table is empty.
    await _seedExercisesIfEmpty();
  }

  // ── Exercise seeder ───────────────────────────────────────────────────────

  /// Seeds the [exercises] table with a built-in master list of common gym
  /// exercises if the table is currently empty.
  ///
  /// All seeded exercises have [isCustom] = false and cannot be deleted by the
  /// user (enforced in [DriftExerciseRepository.deleteExercise]).
  Future<void> _seedExercisesIfEmpty() async {
    final existing = await exerciseDao.getAllExercises();
    if (existing.isNotEmpty) return;

    for (final seed in _masterExerciseList) {
      await exerciseDao.upsertExercise(seed);
    }
  }
}

// ── Master exercise list ──────────────────────────────────────────────────────

final List<ExercisesCompanion> _masterExerciseList = [
  // ── PUSH – Chest ──────────────────────────────────────────────────────────
  _ex(
    'ex-bench-press',
    'Bench Press',
    MuscleGroup.chest,
    EquipmentType.barbell,
    secondary: [MuscleGroup.shoulders, MuscleGroup.triceps],
  ),
  _ex(
    'ex-incline-bench',
    'Incline Bench Press',
    MuscleGroup.chest,
    EquipmentType.barbell,
    secondary: [MuscleGroup.shoulders, MuscleGroup.triceps],
  ),
  _ex(
    'ex-dumbbell-fly',
    'Dumbbell Fly',
    MuscleGroup.chest,
    EquipmentType.dumbbell,
  ),
  _ex('ex-cable-fly', 'Cable Fly', MuscleGroup.chest, EquipmentType.cable),
  _ex(
    'ex-push-up',
    'Push-Up',
    MuscleGroup.chest,
    EquipmentType.bodyweight,
    secondary: [MuscleGroup.triceps, MuscleGroup.shoulders],
  ),
  _ex(
    'ex-dips',
    'Dips',
    MuscleGroup.chest,
    EquipmentType.bodyweight,
    secondary: [MuscleGroup.triceps],
  ),

  // ── PUSH – Shoulders ──────────────────────────────────────────────────────
  _ex(
    'ex-ohp',
    'Overhead Press',
    MuscleGroup.shoulders,
    EquipmentType.barbell,
    secondary: [MuscleGroup.triceps],
  ),
  _ex(
    'ex-db-ohp',
    'Dumbbell Shoulder Press',
    MuscleGroup.shoulders,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.triceps],
  ),
  _ex(
    'ex-lateral-raise',
    'Lateral Raise',
    MuscleGroup.shoulders,
    EquipmentType.dumbbell,
  ),
  _ex(
    'ex-front-raise',
    'Front Raise',
    MuscleGroup.shoulders,
    EquipmentType.dumbbell,
  ),
  _ex(
    'ex-face-pull',
    'Face Pull',
    MuscleGroup.shoulders,
    EquipmentType.cable,
    secondary: [MuscleGroup.back],
  ),

  // ── PUSH – Triceps ────────────────────────────────────────────────────────
  _ex(
    'ex-tricep-pushdown',
    'Tricep Pushdown',
    MuscleGroup.triceps,
    EquipmentType.cable,
  ),
  _ex(
    'ex-skull-crusher',
    'Skull Crusher',
    MuscleGroup.triceps,
    EquipmentType.barbell,
  ),
  _ex(
    'ex-overhead-tricep',
    'Overhead Tricep Extension',
    MuscleGroup.triceps,
    EquipmentType.dumbbell,
  ),

  // ── PULL – Back ───────────────────────────────────────────────────────────
  _ex(
    'ex-deadlift',
    'Deadlift',
    MuscleGroup.back,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes, MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-barbell-row',
    'Barbell Row',
    MuscleGroup.back,
    EquipmentType.barbell,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-lat-pulldown',
    'Lat Pulldown',
    MuscleGroup.back,
    EquipmentType.cable,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-pull-up',
    'Pull-Up',
    MuscleGroup.back,
    EquipmentType.bodyweight,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-seated-row',
    'Seated Cable Row',
    MuscleGroup.back,
    EquipmentType.cable,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-db-row',
    'Dumbbell Row',
    MuscleGroup.back,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.biceps],
  ),

  // ── PULL – Biceps ─────────────────────────────────────────────────────────
  _ex(
    'ex-barbell-curl',
    'Barbell Curl',
    MuscleGroup.biceps,
    EquipmentType.barbell,
  ),
  _ex(
    'ex-db-curl',
    'Dumbbell Curl',
    MuscleGroup.biceps,
    EquipmentType.dumbbell,
  ),
  _ex(
    'ex-hammer-curl',
    'Hammer Curl',
    MuscleGroup.biceps,
    EquipmentType.dumbbell,
  ),
  _ex('ex-cable-curl', 'Cable Curl', MuscleGroup.biceps, EquipmentType.cable),

  // ── LEGS – Quads ──────────────────────────────────────────────────────────
  _ex(
    'ex-squat',
    'Squat',
    MuscleGroup.quads,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes, MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-front-squat',
    'Front Squat',
    MuscleGroup.quads,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes],
  ),
  _ex(
    'ex-leg-press',
    'Leg Press',
    MuscleGroup.quads,
    EquipmentType.machine,
    secondary: [MuscleGroup.glutes],
  ),
  _ex(
    'ex-leg-extension',
    'Leg Extension',
    MuscleGroup.quads,
    EquipmentType.machine,
  ),
  _ex(
    'ex-lunge',
    'Lunge',
    MuscleGroup.quads,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.glutes],
  ),

  // ── LEGS – Hamstrings & Glutes ────────────────────────────────────────────
  _ex(
    'ex-rdl',
    'Romanian Deadlift',
    MuscleGroup.hamstrings,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes],
  ),
  _ex('ex-leg-curl', 'Leg Curl', MuscleGroup.hamstrings, EquipmentType.machine),
  _ex('ex-hip-thrust', 'Hip Thrust', MuscleGroup.glutes, EquipmentType.barbell),

  // ── LEGS – Calves ─────────────────────────────────────────────────────────
  _ex('ex-calf-raise', 'Calf Raise', MuscleGroup.calves, EquipmentType.machine),
  _ex(
    'ex-seated-calf',
    'Seated Calf Raise',
    MuscleGroup.calves,
    EquipmentType.machine,
  ),

  // ── Core ──────────────────────────────────────────────────────────────────
  _ex('ex-plank', 'Plank', MuscleGroup.core, EquipmentType.bodyweight),
  _ex('ex-crunch', 'Crunch', MuscleGroup.core, EquipmentType.bodyweight),
  _ex(
    'ex-ab-wheel',
    'Ab Wheel Rollout',
    MuscleGroup.core,
    EquipmentType.bodyweight,
  ),
];

ExercisesCompanion _ex(
  String id,
  String name,
  MuscleGroup primary,
  EquipmentType equipment, {
  List<MuscleGroup> secondary = const [],
}) => ExercisesCompanion(
  id: Value(id),
  name: Value(name),
  primaryMuscle: Value(primary),
  secondaryMuscles: Value(secondary),
  equipment: Value(equipment),
  isCustom: const Value(false),
);

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gym_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
