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
  /// Seeding is disabled by default so tests start with a clean, empty [exercises] table,
  /// but can be enabled by setting [seedOnCreate] to true.
  AppDatabase.forTesting(super.executor, {bool seedOnCreate = false})
    : _seedOnCreate = seedOnCreate;

  /// Whether to seed the exercise master list when the database is first created.
  final bool _seedOnCreate;

  @override
  int get schemaVersion => 4;

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
      if (from < 3) {
        await _migrateV2toV3(m);
      }
      if (from < 4) {
        await _migrateV3toV4(m);
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

  // ── v2 → v3 migration ────────────────────────────────────────────────────

  /// Migrates from schema v2 to v3.
  ///
  /// This migration ensures that all users have the latest master list of
  /// exercises. It re-runs the seeder, which uses `insertOnConflictUpdate`
  /// (via [ExerciseDao.upsertExercise]) to add new exercises and potentially
  /// update existing built-in ones. Custom exercises are unaffected because
  /// their IDs won't match the master list IDs.
  Future<void> _migrateV2toV3(Migrator m) async {
    await _seedMasterExercises();
  }

  // ── Exercise seeder ───────────────────────────────────────────────────────

  /// Seeds the [exercises] table with a built-in master list of common gym
  /// exercises if the table is currently empty.
  Future<void> _seedExercisesIfEmpty() async {
    final existing = await exerciseDao.getAllExercises();
    if (existing.isNotEmpty) return;
    await _seedMasterExercises();
  }

  /// Iterates through the master exercise list and upserts each one.
  ///
  /// This is safe to run on existing databases because [ExerciseDao.upsertExercise]
  /// uses `insertOnConflictUpdate`.
  Future<void> _seedMasterExercises() async {
    for (final seed in _masterExerciseList) {
      await exerciseDao.upsertExercise(seed);
    }
  }

  // ── v3 → v4 migration ────────────────────────────────────────────────────

  /// Migrates from schema v3 to v4.
  ///
  /// Populates empty split days in existing routines with default exercises.
  /// This addresses the issue where users had the new exercises in the DB
  /// but their routines remained empty.
  Future<void> _migrateV3toV4(Migrator m) async {
    // 1. Get all split days
    final allSplitDays = await select(splitDays).get();
    const uuid = Uuid();

    for (final day in allSplitDays) {
      // 2. Check if the day has any exercises
      final exerciseCount = await (select(routineExercises)..where(
        (t) => t.splitDayId.equals(day.id),
      )).get().then((rows) => rows.length);

      if (exerciseCount > 0) continue; // Skip populated days

      // 3. Populate empty days based on split type
      final exercisesToInsert = <String>[];

      switch (day.splitType) {
        case SplitType.push:
          exercisesToInsert.addAll([
            'ex-bench-press',
            'ex-ohp',
            'ex-incline-bench',
            'ex-lateral-raise',
            'ex-tricep-pushdown',
            'ex-decline-bench', // New
            'ex-arnold-press', // New
          ]);
          break;
        case SplitType.pull:
          exercisesToInsert.addAll([
            'ex-deadlift',
            'ex-pull-up',
            'ex-barbell-row',
            'ex-lat-pulldown',
            'ex-barbell-curl',
            'ex-t-bar-row', // New
            'ex-preacher-curl', // New
          ]);
          break;
        case SplitType.legs:
          exercisesToInsert.addAll([
            'ex-squat',
            'ex-rdl',
            'ex-leg-press',
            'ex-leg-curl',
            'ex-seated-calf',
            'ex-hack-squat', // New
            'ex-sumo-deadlift', // New
          ]);
          break;
        case SplitType.rest:
          continue;
      }

      // 4. Insert exercises
      for (var i = 0; i < exercisesToInsert.length; i++) {
        await into(routineExercises).insert(
          RoutineExercisesCompanion(
            id: Value(uuid.v4()),
            splitDayId: Value(day.id),
            exerciseId: Value(exercisesToInsert[i]),
            orderIndex: Value(i),
          ),
        );
      }
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
  // ── PUSH – Chest (Additional) ─────────────────────────────────────────────
  _ex(
    'ex-decline-bench',
    'Decline Bench Press',
    MuscleGroup.chest,
    EquipmentType.barbell,
    secondary: [MuscleGroup.shoulders, MuscleGroup.triceps],
  ),
  _ex(
    'ex-machine-chest-press',
    'Machine Chest Press',
    MuscleGroup.chest,
    EquipmentType.machine,
    secondary: [MuscleGroup.shoulders, MuscleGroup.triceps],
  ),
  _ex('ex-pec-deck', 'Pec Deck', MuscleGroup.chest, EquipmentType.machine),

  // ── PUSH – Shoulders (Additional) ─────────────────────────────────────────
  _ex(
    'ex-arnold-press',
    'Arnold Press',
    MuscleGroup.shoulders,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.triceps],
  ),
  _ex(
    'ex-upright-row',
    'Upright Row',
    MuscleGroup.shoulders,
    EquipmentType.barbell,
    secondary: [MuscleGroup.traps, MuscleGroup.biceps],
  ),
  _ex(
    'ex-cable-lateral-raise',
    'Cable Lateral Raise',
    MuscleGroup.shoulders,
    EquipmentType.cable,
  ),

  // ── PUSH – Triceps (Additional) ───────────────────────────────────────────
  _ex(
    'ex-close-grip-bench',
    'Close-Grip Bench Press',
    MuscleGroup.triceps,
    EquipmentType.barbell,
    secondary: [MuscleGroup.chest, MuscleGroup.shoulders],
  ),
  _ex(
    'ex-tricep-kickback',
    'Tricep Kickback',
    MuscleGroup.triceps,
    EquipmentType.dumbbell,
  ),
  _ex(
    'ex-overhead-cable-ext',
    'Overhead Cable Extension',
    MuscleGroup.triceps,
    EquipmentType.cable,
  ),

  // ── PULL – Back (Additional) ──────────────────────────────────────────────
  _ex(
    'ex-t-bar-row',
    'T-Bar Row',
    MuscleGroup.back,
    EquipmentType.barbell,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-pendlay-row',
    'Pendlay Row',
    MuscleGroup.back,
    EquipmentType.barbell,
    secondary: [MuscleGroup.biceps, MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-single-arm-cable-row',
    'Single-Arm Cable Row',
    MuscleGroup.back,
    EquipmentType.cable,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-assisted-pull-up',
    'Assisted Pull-Up',
    MuscleGroup.back,
    EquipmentType.machine,
    secondary: [MuscleGroup.biceps],
  ),
  _ex(
    'ex-straight-arm-pulldown',
    'Straight-Arm Pulldown',
    MuscleGroup.back,
    EquipmentType.cable,
  ),

  // ── PULL – Biceps (Additional) ────────────────────────────────────────────
  _ex(
    'ex-preacher-curl',
    'Preacher Curl',
    MuscleGroup.biceps,
    EquipmentType.ezBar,
  ),
  _ex(
    'ex-concentration-curl',
    'Concentration Curl',
    MuscleGroup.biceps,
    EquipmentType.dumbbell,
  ),
  _ex(
    'ex-spider-curl',
    'Spider Curl',
    MuscleGroup.biceps,
    EquipmentType.dumbbell,
  ),

  // ── LEGS – Quads (Additional) ─────────────────────────────────────────────
  _ex(
    'ex-hack-squat',
    'Hack Squat',
    MuscleGroup.quads,
    EquipmentType.machine,
    secondary: [MuscleGroup.glutes, MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-bulgarian-split-squat',
    'Bulgarian Split Squat',
    MuscleGroup.quads,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.glutes, MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-goblet-squat',
    'Goblet Squat',
    MuscleGroup.quads,
    EquipmentType.dumbbell,
    secondary: [MuscleGroup.glutes],
  ),

  // ── LEGS – Glutes/Hamstrings (Additional) ─────────────────────────────────
  _ex(
    'ex-sumo-deadlift',
    'Sumo Deadlift',
    MuscleGroup.hamstrings,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes, MuscleGroup.quads, MuscleGroup.back],
  ),
  _ex(
    'ex-standing-leg-curl',
    'Standing Leg Curl',
    MuscleGroup.hamstrings,
    EquipmentType.machine,
  ),
  _ex(
    'ex-glute-bridge',
    'Glute Bridge',
    MuscleGroup.glutes,
    EquipmentType.bodyweight,
    secondary: [MuscleGroup.hamstrings],
  ),
  _ex(
    'ex-cable-kickback',
    'Cable Kickback',
    MuscleGroup.glutes,
    EquipmentType.cable,
  ),
  _ex(
    'ex-good-morning',
    'Good Morning',
    MuscleGroup.hamstrings,
    EquipmentType.barbell,
    secondary: [MuscleGroup.glutes, MuscleGroup.back],
  ),

  // ── LEGS – Calves (Additional) ────────────────────────────────────────────
  _ex(
    'ex-standing-calf-raise',
    'Standing Calf Raise',
    MuscleGroup.calves,
    EquipmentType.machine,
  ),

  // ── Core (Additional) ─────────────────────────────────────────────────────
  _ex(
    'ex-hanging-leg-raise',
    'Hanging Leg Raise',
    MuscleGroup.core,
    EquipmentType.bodyweight,
  ),
  _ex(
    'ex-russian-twist',
    'Russian Twist',
    MuscleGroup.core,
    EquipmentType.bodyweight,
  ),
  _ex('ex-cable-crunch', 'Cable Crunch', MuscleGroup.core, EquipmentType.cable),
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
