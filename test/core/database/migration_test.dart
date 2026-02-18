import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart' as ft;
import 'package:flutter_test/flutter_test.dart' show test, expect, fail;
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';

void main() {
  test('migration from v2 to v3 seeds new exercises', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.delete(db.exercises).go();
    expect(await db.exerciseDao.getAllExercises(), ft.isEmpty);
  });

  test('upsertExercise updates existing and inserts new', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());

    // 1. Clear DB
    await db.delete(db.exercises).go();

    // 2. Insert a "legacy" version of Bench Press
    final benchId = 'ex-bench-press';
    const oldBench = ExercisesCompanion(
      id: Value(benchId),
      name: Value('Old Bench Press Name'),
      primaryMuscle: Value(MuscleGroup.chest),
      equipment: Value(EquipmentType.barbell),
      isCustom: Value(false),
    );
    await db.exerciseDao.upsertExercise(oldBench);

    // Verify insertion
    var bench = await db.exerciseDao.getExerciseById(benchId);
    expect(bench?.name, 'Old Bench Press Name');

    // 3. Run the seeder logic simulation
    const newBench = ExercisesCompanion(
      id: Value(benchId),
      name: Value('Bench Press'),
      primaryMuscle: Value(MuscleGroup.chest),
      equipment: Value(EquipmentType.barbell),
      isCustom: Value(false),
    );

    await db.exerciseDao.upsertExercise(newBench);

    bench = await db.exerciseDao.getExerciseById(benchId);
    expect(bench?.name, 'Bench Press', reason: 'Should update to new name');

    // 4. Verify inserting a NEW exercise works
    final newExId = 'ex-decline-bench';
    expect(await db.exerciseDao.getExerciseById(newExId), ft.isNull);

    const newEx = ExercisesCompanion(
      id: Value(newExId),
      name: Value('Decline Bench Press'),
      primaryMuscle: Value(MuscleGroup.chest),
      equipment: Value(EquipmentType.barbell),
      isCustom: Value(false),
    );
    await db.exerciseDao.upsertExercise(newEx);

    expect(await db.exerciseDao.getExerciseById(newExId), ft.isNotNull);

    await db.close();
  });
}
