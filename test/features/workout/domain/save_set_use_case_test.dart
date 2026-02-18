import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/usecases/save_set.dart';
import 'package:mocktail/mocktail.dart';

class MockSetLogRepository extends Mock implements SetLogRepository {}

void main() {
  late MockSetLogRepository mockRepo;
  late SaveSetUseCase sut;

  final ts = DateTime(2024, 1, 1);

  SaveSetParams validParams({
    double weightKg = 100,
    int reps = 5,
    double? rpe,
  }) =>
      SaveSetParams(
        id: 'set-1',
        workoutSessionId: 'session-1',
        exerciseId: 'exercise-1',
        setNumber: 1,
        weightKg: weightKg,
        reps: reps,
        completedAt: ts,
        rpe: rpe,
      );

  setUp(() {
    mockRepo = MockSetLogRepository();
    sut = SaveSetUseCase(mockRepo);

    // Default: repository succeeds.
    when(() => mockRepo.saveSetLog(any())).thenAnswer((_) async => right(unit));
  });

  group('SaveSetUseCase — validation', () {
    test('returns Right(unit) for a valid set', () async {
      final result = await sut(validParams());
      expect(result.isRight(), isTrue);
      verify(() => mockRepo.saveSetLog(any())).called(1);
    });

    test('returns ValidationFailure when reps == 0', () async {
      final result = await sut(validParams(reps: 0));

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepo.saveSetLog(any()));
    });

    test('returns ValidationFailure when weightKg is negative', () async {
      final result = await sut(validParams(weightKg: -1));

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepo.saveSetLog(any()));
    });

    test('returns ValidationFailure when rpe is above 10', () async {
      final result = await sut(validParams(rpe: 11));

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepo.saveSetLog(any()));
    });

    test('returns ValidationFailure when rpe is below 1', () async {
      final result = await sut(validParams(rpe: 0));

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('Expected Left'),
      );
      verifyNever(() => mockRepo.saveSetLog(any()));
    });

    test('accepts rpe == 1 (lower boundary)', () async {
      final result = await sut(validParams(rpe: 1));
      expect(result.isRight(), isTrue);
    });

    test('accepts rpe == 10 (upper boundary)', () async {
      final result = await sut(validParams(rpe: 10));
      expect(result.isRight(), isTrue);
    });

    test('accepts weightKg == 0 (bodyweight exercise)', () async {
      final result = await sut(validParams(weightKg: 0));
      expect(result.isRight(), isTrue);
    });
  });

  group('SaveSetUseCase — repository errors', () {
    test('propagates DatabaseFailure from repository', () async {
      when(() => mockRepo.saveSetLog(any())).thenAnswer(
        (_) async => left(const DatabaseFailure(message: 'write failed')),
      );

      final result = await sut(validParams());

      expect(result.isLeft(), isTrue);
      result.fold(
        (f) => expect(f, isA<DatabaseFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
