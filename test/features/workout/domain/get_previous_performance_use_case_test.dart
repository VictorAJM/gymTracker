import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/usecases/get_previous_performance.dart';
import 'package:mocktail/mocktail.dart';

class MockSetLogRepository extends Mock implements SetLogRepository {}

void main() {
  late MockSetLogRepository mockRepo;
  late GetPreviousPerformanceUseCase sut;

  final ts = DateTime(2024, 1, 1);

  final tSetLog = SetLog(
    id: 'set-1',
    workoutSessionId: 'session-1',
    exerciseId: 'exercise-1',
    setNumber: 1,
    weightKg: 100,
    reps: 5,
    completedAt: ts,
  );

  setUp(() {
    mockRepo = MockSetLogRepository();
    sut = GetPreviousPerformanceUseCase(mockRepo);
  });

  group('GetPreviousPerformanceUseCase', () {
    test('returns PreviousPerformance when repository returns a SetLog',
        () async {
      when(() => mockRepo.getLastSetForExercise('exercise-1'))
          .thenAnswer((_) async => right(tSetLog));

      final result = await sut('exercise-1');

      expect(result.isRight(), isTrue);
      final performance = result.getOrElse((_) => throw Exception());
      expect(performance, isA<PreviousPerformance>());
      expect(performance.lastSet, equals(tSetLog));
      // e1RM for 100 kg × 5 = 100 * (1 + 5/30) ≈ 116.67
      expect(
        performance.estimatedOneRepMax,
        closeTo(116.67, 0.01),
      );
    });

    test('returns NotFoundFailure when exercise has never been logged',
        () async {
      when(() => mockRepo.getLastSetForExercise('exercise-1')).thenAnswer(
        (_) async => left(const NotFoundFailure(message: 'No sets found')),
      );

      final result = await sut('exercise-1');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('returns DatabaseFailure when repository throws', () async {
      when(() => mockRepo.getLastSetForExercise('exercise-1')).thenAnswer(
        (_) async => left(const DatabaseFailure(message: 'DB error')),
      );

      final result = await sut('exercise-1');

      expect(result.isLeft(), isTrue);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('Expected Left'),
      );
    });

    test('estimatedOneRepMax is null when reps == 1 (already a 1RM)', () async {
      final oneRepSet = tSetLog.copyWith(reps: 1);
      when(() => mockRepo.getLastSetForExercise('exercise-1'))
          .thenAnswer((_) async => right(oneRepSet));

      final result = await sut('exercise-1');

      final performance = result.getOrElse((_) => throw Exception());
      // reps == 1 → e1RM == weightKg (not null, just equals weight)
      expect(performance.estimatedOneRepMax, equals(oneRepSet.weightKg));
    });
  });
}
