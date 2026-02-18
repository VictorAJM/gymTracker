import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/usecases/calculate_progress.dart';

void main() {
  late CalculateProgressUseCase sut;

  // A fixed timestamp — irrelevant to the comparison logic.
  final ts = DateTime(2024, 1, 1);

  SetLog makeSet({
    required double weightKg,
    required int reps,
    String id = 'set-1',
  }) =>
      SetLog(
        id: id,
        workoutSessionId: 'session-1',
        exerciseId: 'exercise-1',
        setNumber: 1,
        weightKg: weightKg,
        reps: reps,
        completedAt: ts,
      );

  setUp(() {
    // Use 0% tolerance so tests can assert exact boundaries.
    sut = const CalculateProgressUseCase(tolerancePercent: 0);
  });

  group('CalculateProgressUseCase', () {
    // ── FirstTime ────────────────────────────────────────────────────────

    test('returns FirstTime when previous is null', () async {
      final current = makeSet(weightKg: 100, reps: 5);
      final result = await sut(CalculateProgressParams(current: current));

      expect(result, isA<Right<dynamic, ProgressStatus>>());
      expect(result.getOrElse((_) => const Same()), isA<FirstTime>());
    });

    // ── Progressed ───────────────────────────────────────────────────────

    test('returns Progressed when e1RM improves', () async {
      // Previous: 100 kg × 5  → e1RM ≈ 116.67 kg
      // Current:  105 kg × 5  → e1RM ≈ 122.5  kg  (+5%)
      final previous = makeSet(weightKg: 100, reps: 5, id: 'prev');
      final current = makeSet(weightKg: 105, reps: 5);

      final result = await sut(
        CalculateProgressParams(current: current, previous: previous),
      );

      final status = result.getOrElse((_) => const Same());
      expect(status, isA<Progressed>());
      expect((status as Progressed).deltaPercent, greaterThan(0));
    });

    test('returns Progressed when same weight but more reps', () async {
      // Previous: 100 kg × 5  → e1RM ≈ 116.67 kg
      // Current:  100 kg × 8  → e1RM ≈ 126.67 kg  (+8.6%)
      final previous = makeSet(weightKg: 100, reps: 5, id: 'prev');
      final current = makeSet(weightKg: 100, reps: 8);

      final status = (await sut(
              CalculateProgressParams(current: current, previous: previous)))
          .getOrElse((_) => const Same());

      expect(status, isA<Progressed>());
    });

    // ── Regressed ────────────────────────────────────────────────────────

    test('returns Regressed when e1RM declines', () async {
      // Previous: 100 kg × 5  → e1RM ≈ 116.67 kg
      // Current:   90 kg × 5  → e1RM ≈ 105     kg  (-10%)
      final previous = makeSet(weightKg: 100, reps: 5, id: 'prev');
      final current = makeSet(weightKg: 90, reps: 5);

      final status = (await sut(
              CalculateProgressParams(current: current, previous: previous)))
          .getOrElse((_) => const Same());

      expect(status, isA<Regressed>());
      expect((status as Regressed).deltaPercent, lessThan(0));
    });

    // ── Same ─────────────────────────────────────────────────────────────

    test('returns Same when weight and reps are identical', () async {
      final previous = makeSet(weightKg: 100, reps: 5, id: 'prev');
      final current = makeSet(weightKg: 100, reps: 5);

      final status = (await sut(
              CalculateProgressParams(current: current, previous: previous)))
          .getOrElse((_) => const Progressed(deltaPercent: 1));

      expect(status, isA<Same>());
    });

    // ── 1-rep sets (raw weight fallback) ─────────────────────────────────

    test('compares raw weight when both sets have reps == 1', () async {
      final previous = makeSet(weightKg: 100, reps: 1, id: 'prev');
      final current = makeSet(weightKg: 110, reps: 1);

      final status = (await sut(
              CalculateProgressParams(current: current, previous: previous)))
          .getOrElse((_) => const Same());

      // 110 > 100 → Progressed
      expect(status, isA<Progressed>());
    });

    // ── Tolerance band ───────────────────────────────────────────────────

    test('1% tolerance: classifies 0.5% improvement as Same', () async {
      // Use default 1% tolerance for this test.
      final sutWithTolerance =
          const CalculateProgressUseCase(tolerancePercent: 0.01);

      // Previous: 100 kg × 10  → e1RM ≈ 133.33 kg
      // Current:  100.5 kg × 10 → e1RM ≈ 134.0  kg  (+0.5%)
      final previous = makeSet(weightKg: 100, reps: 10, id: 'prev');
      final current = makeSet(weightKg: 100.5, reps: 10);

      final status = (await sutWithTolerance(
              CalculateProgressParams(current: current, previous: previous)))
          .getOrElse((_) => const Progressed(deltaPercent: 1));

      expect(status, isA<Same>());
    });

    // ── Edge: previous weight == 0 ───────────────────────────────────────

    test('handles previous weight of 0 without division by zero', () async {
      final previous = makeSet(weightKg: 0, reps: 5, id: 'prev');
      final current = makeSet(weightKg: 10, reps: 5);

      // Should not throw; any positive weight is Progressed.
      final result = await sut(
          CalculateProgressParams(current: current, previous: previous));

      expect(result.isRight(), isTrue);
    });
  });
}
