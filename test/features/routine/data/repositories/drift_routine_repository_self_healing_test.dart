import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:gym_tracker/features/routine/data/repositories/drift_routine_repository.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:uuid/uuid.dart';
import 'package:gym_tracker/core/constants/routine_constants.dart';

void main() {
  late AppDatabase db;
  late DriftRoutineRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory(), seedOnCreate: true);
    repository = DriftRoutineRepository(db.routineDao, db.routineExerciseDao);
  });

  tearDown(() async {
    await db.close();
  });

  test('getActiveRoutine populates empty split days (self-healing)', () async {
    // 1. Setup: Create a routine with empty split days
    const uuid = Uuid();
    final routineId = uuid.v4();
    final pushDayId = uuid.v4();

    await db
        .into(db.routines)
        .insert(
          RoutinesCompanion.insert(
            id: routineId,
            name: 'Test Routine',
            createdAt: DateTime.now().millisecondsSinceEpoch,
            isActive: const Value(true),
          ),
        );

    await db
        .into(db.splitDays)
        .insert(
          SplitDaysCompanion.insert(
            id: pushDayId,
            routineId: routineId,
            dayOfWeek: 1,
            splitType: SplitType.push,
          ),
        );

    // Ensure exercises are initially empty
    var exercises = await db.routineExerciseDao.getExercisesForSplitDay(
      pushDayId,
    );
    expect(exercises, isEmpty);

    // 2. Act: Call getActiveRoutine
    final result = await repository.getActiveRoutine();

    // 3. Assert: Check result and DB
    expect(result.isRight(), true);
    final routine = result.getRight().toNullable()!;

    final pushDay = routine.days.firstWhere(
      (d) => d.splitType == SplitType.push,
    );
    final expectedCount = defaultSplitExercises[SplitType.push]!.length;

    // Check returned domain object
    expect(pushDay.exercises, hasLength(expectedCount));
    expect(pushDay.exercises.map((e) => e.id), contains('ex-bench-press'));

    // Check DB persistence
    exercises = await db.routineExerciseDao.getExercisesForSplitDay(pushDayId);
    expect(exercises, hasLength(expectedCount));
  });

  test('getActiveRoutine replaces ghost rows with defaults', () async {
    // 1. Setup
    const uuid = Uuid();
    final routineId = uuid.v4();
    final pushDayId = uuid.v4();

    await db
        .into(db.routines)
        .insert(
          RoutinesCompanion.insert(
            id: routineId,
            name: 'Test Routine',
            createdAt: DateTime.now().millisecondsSinceEpoch,
            isActive: const Value(true),
          ),
        );

    await db
        .into(db.splitDays)
        .insert(
          SplitDaysCompanion.insert(
            id: pushDayId,
            routineId: routineId,
            dayOfWeek: 1,
            splitType: SplitType.push,
          ),
        );

    // Insert ONE custom exercise manually
    await db
        .into(db.routineExercises)
        .insert(
          RoutineExercisesCompanion(
            id: Value(uuid.v4()),
            splitDayId: Value(pushDayId),
            exerciseId: const Value('custom-ex'),
            orderIndex: const Value(0),
          ),
        );

    // 2. Act
    final result = await repository.getActiveRoutine();

    // 3. Assert: The ghost row should have triggered self-healing!
    expect(result.isRight(), true);
    final routine = result.getRight().toNullable()!;
    final pushDay = routine.days.firstWhere(
      (d) => d.splitType == SplitType.push,
    );

    // Ghost row (count 1) resulted in 0 resolved exercises.
    // Self-healing should have kicked in and populated defaults.
    final expectedCount = defaultSplitExercises[SplitType.push]!.length;
    expect(pushDay.exercises, hasLength(expectedCount));
    expect(pushDay.exercises.map((e) => e.id), contains('ex-bench-press'));

    // Verify DB was updated
    final dbExercises = await db.routineExerciseDao.getExercisesForSplitDay(
      pushDayId,
    );
    expect(dbExercises, hasLength(expectedCount));
    // Ghost ID 'custom-ex' should be gone
    expect(dbExercises.map((e) => e.exerciseId), isNot(contains('custom-ex')));
  });
}
