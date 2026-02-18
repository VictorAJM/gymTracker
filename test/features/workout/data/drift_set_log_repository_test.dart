import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/data/repositories/drift_set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';

import '../../../helpers/test_database.dart';

void main() {
  late DriftSetLogRepository repository;

  // ---------------------------------------------------------------------------
  // Fixtures
  // ---------------------------------------------------------------------------

  final now = DateTime(2026, 2, 17, 20, 0);
  final earlier = DateTime(2026, 2, 10, 18, 0);

  final setLog1 = SetLog(
    id: 'sl-001',
    workoutSessionId: 'ws-001',
    exerciseId: 'ex-bench',
    setNumber: 1,
    weightKg: 80.0,
    reps: 8,
    rpe: 7.5,
    completedAt: earlier,
  );

  final setLog2 = SetLog(
    id: 'sl-002',
    workoutSessionId: 'ws-001',
    exerciseId: 'ex-bench',
    setNumber: 2,
    weightKg: 82.5,
    reps: 6,
    rpe: 8.5,
    completedAt: now,
  );

  final setLog3 = SetLog(
    id: 'sl-003',
    workoutSessionId: 'ws-002',
    exerciseId: 'ex-squat',
    setNumber: 1,
    weightKg: 100.0,
    reps: 5,
    completedAt: now,
  );

  // ---------------------------------------------------------------------------
  // Setup / teardown
  // ---------------------------------------------------------------------------

  setUp(() {
    final db = createTestDatabase();
    repository = DriftSetLogRepository(db.setLogDao);
  });

  // ---------------------------------------------------------------------------
  // Tests
  // ---------------------------------------------------------------------------

  group('saveSetLog / getSetLogsForSession', () {
    test('saves a set log and retrieves it by session', () async {
      await repository.saveSetLog(setLog1);

      final result = await repository.getSetLogsForSession('ws-001');

      expect(result.isRight(), isTrue);
      final logs = result.getOrElse((_) => []);
      expect(logs, hasLength(1));
      expect(logs.first, equals(setLog1));
    });

    test('returns only set logs belonging to the given session', () async {
      await repository.saveSetLog(setLog1);
      await repository.saveSetLog(setLog2);
      await repository.saveSetLog(setLog3);

      final result = await repository.getSetLogsForSession('ws-001');
      final logs = result.getOrElse((_) => []);

      expect(logs, hasLength(2));
      expect(logs.map((l) => l.id), containsAll(['sl-001', 'sl-002']));
    });

    test('returns set logs ordered by set number ascending', () async {
      // Insert in reverse order to verify ordering.
      await repository.saveSetLog(setLog2);
      await repository.saveSetLog(setLog1);

      final result = await repository.getSetLogsForSession('ws-001');
      final logs = result.getOrElse((_) => []);

      expect(logs.map((l) => l.setNumber).toList(), [1, 2]);
    });
  });

  group('getLastSetForExercise', () {
    test('returns the most recently completed set for an exercise', () async {
      // setLog2 has a later completedAt than setLog1 for the same exercise.
      await repository.saveSetLog(setLog1);
      await repository.saveSetLog(setLog2);

      final result = await repository.getLastSetForExercise('ex-bench');

      expect(result.isRight(), isTrue);
      // setLog2 was completed at `now` which is more recent than `earlier`.
      expect(result.getOrElse((_) => setLog1).id, equals('sl-002'));
    });

    test('returns NotFoundFailure when no sets exist for the exercise',
        () async {
      final result = await repository.getLastSetForExercise('ex-unknown');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected a Left'),
      );
    });
  });

  group('getSetLogsForExercise', () {
    test('returns all sets for an exercise ordered by date descending',
        () async {
      await repository.saveSetLog(setLog1);
      await repository.saveSetLog(setLog2);
      await repository.saveSetLog(setLog3);

      final result = await repository.getSetLogsForExercise('ex-bench');
      final logs = result.getOrElse((_) => []);

      // Should return only bench press sets, most recent first.
      expect(logs, hasLength(2));
      expect(logs.first.id, 'sl-002'); // now > earlier
      expect(logs.last.id, 'sl-001');
    });
  });

  group('deleteSetLog', () {
    test('removes the set log successfully', () async {
      await repository.saveSetLog(setLog1);

      final deleteResult = await repository.deleteSetLog('sl-001');
      expect(deleteResult, equals(right(unit)));

      final getResult = await repository.getSetLogsForSession('ws-001');
      expect(getResult.getOrElse((_) => []), isEmpty);
    });

    test('returns NotFoundFailure when set log does not exist', () async {
      final result = await repository.deleteSetLog('ghost-id');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected a Left'),
      );
    });
  });
}
