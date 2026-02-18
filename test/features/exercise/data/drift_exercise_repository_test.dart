import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/data/repositories/drift_exercise_repository.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';

import '../../../helpers/test_database.dart';

void main() {
  late DriftExerciseRepository repository;

  // ---------------------------------------------------------------------------
  // Fixtures
  // ---------------------------------------------------------------------------

  final benchPress = Exercise(
    id: 'ex-001',
    name: 'Bench Press',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders],
    equipment: EquipmentType.barbell,
    isCustom: false,
  );

  final cableFly = Exercise(
    id: 'ex-002',
    name: 'Cable Fly',
    primaryMuscle: MuscleGroup.chest,
    secondaryMuscles: const [],
    equipment: EquipmentType.cable,
    isCustom: false,
  );

  final customCurl = Exercise(
    id: 'ex-003',
    name: 'Custom Hammer Curl',
    primaryMuscle: MuscleGroup.biceps,
    secondaryMuscles: const [],
    equipment: EquipmentType.dumbbell,
    isCustom: true,
  );

  // ---------------------------------------------------------------------------
  // Setup / teardown
  // ---------------------------------------------------------------------------

  setUp(() {
    final db = createTestDatabase();
    repository = DriftExerciseRepository(db.exerciseDao);
  });

  // ---------------------------------------------------------------------------
  // Tests
  // ---------------------------------------------------------------------------

  group('saveExercise / getExercises', () {
    test('saves an exercise and retrieves it in the list', () async {
      await repository.saveExercise(benchPress);

      final result = await repository.getExercises();

      expect(result.isRight(), isTrue);
      final exercises = result.getOrElse((_) => []);
      expect(exercises, hasLength(1));
      expect(exercises.first, equals(benchPress));
    });

    test('returns exercises ordered alphabetically by name', () async {
      await repository.saveExercise(cableFly);
      await repository.saveExercise(benchPress);

      final result = await repository.getExercises();
      final names = result.getOrElse((_) => []).map((e) => e.name).toList();

      expect(names, ['Bench Press', 'Cable Fly']);
    });
  });

  group('getExerciseById', () {
    test('returns the correct exercise when it exists', () async {
      await repository.saveExercise(benchPress);

      final result = await repository.getExerciseById('ex-001');

      expect(result, equals(right(benchPress)));
    });

    test('returns NotFoundFailure for unknown id', () async {
      final result = await repository.getExerciseById('does-not-exist');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected a Left'),
      );
    });
  });

  group('searchExercises', () {
    setUp(() async {
      await repository.saveExercise(benchPress);
      await repository.saveExercise(cableFly);
      await repository.saveExercise(customCurl);
    });

    test('returns matching exercises (case-insensitive)', () async {
      final result = await repository.searchExercises('bench');

      final exercises = result.getOrElse((_) => []);
      expect(exercises, hasLength(1));
      expect(exercises.first.name, 'Bench Press');
    });

    test('returns empty list when no match', () async {
      final result = await repository.searchExercises('squat');

      expect(result.getOrElse((_) => []), isEmpty);
    });
  });

  group('getExercisesByMuscleGroup', () {
    setUp(() async {
      await repository.saveExercise(benchPress);
      await repository.saveExercise(cableFly);
      await repository.saveExercise(customCurl);
    });

    test('returns only exercises with the given primary muscle', () async {
      final result =
          await repository.getExercisesByMuscleGroup(MuscleGroup.chest);

      final exercises = result.getOrElse((_) => []);
      expect(exercises, hasLength(2));
      expect(
        exercises.map((e) => e.id),
        containsAll(['ex-001', 'ex-002']),
      );
    });
  });

  group('deleteExercise', () {
    test('removes a custom exercise successfully', () async {
      await repository.saveExercise(customCurl);

      final deleteResult = await repository.deleteExercise('ex-003');
      expect(deleteResult, equals(right(unit)));

      final getResult = await repository.getExerciseById('ex-003');
      expect(getResult.isLeft(), isTrue);
    });

    test('returns ValidationFailure when deleting a built-in exercise',
        () async {
      await repository.saveExercise(benchPress);

      final result = await repository.deleteExercise('ex-001');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected a Left'),
      );
    });

    test('returns NotFoundFailure when exercise does not exist', () async {
      final result = await repository.deleteExercise('ghost-id');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected a Left'),
      );
    });
  });
}
