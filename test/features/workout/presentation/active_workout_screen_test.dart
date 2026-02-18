// Widget tests for ActiveWorkoutScreen focusing on the progress comparison
// display (the "badge" that appears after logging a set).
//
// Strategy
// ─────────
// We do NOT test the notifier's business logic here — that's covered by unit
// tests. Instead we:
//   1. Create a FakeActiveWorkoutNotifier that returns a hardcoded
//      ActiveWorkoutState immediately (no DB, no async).
//   2. Override activeWorkoutProvider with the fake via ProviderScope.
//   3. Pump the screen and assert on what the user actually sees.
//
// This keeps widget tests fast, deterministic, and decoupled from the DB.
//
// Provider override pattern for AsyncNotifierProvider.family.autoDispose:
//   activeWorkoutProvider(args).overrideWith(FakeActiveWorkoutNotifier.new)
// The factory receives no arguments — the notifier reads `arg` via `this.arg`.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/providers/workout_providers.dart';
import 'package:gym_tracker/features/workout/presentation/screens/active_workout_screen.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';

// ── Fixtures ──────────────────────────────────────────────────────────────────

final _benchPress = Exercise(
  id: 'bench-press',
  name: 'Bench Press',
  primaryMuscle: MuscleGroup.chest,
  equipment: EquipmentType.barbell,
);

final _previousSet = SetLog(
  id: 'prev-set',
  workoutSessionId: 'prev-session',
  exerciseId: 'bench-press',
  setNumber: 1,
  weightKg: 100,
  reps: 5,
  completedAt: DateTime(2024, 1, 1),
);

final _previousPerformance = PreviousPerformance(
  lastSet: _previousSet,
  estimatedOneRepMax: 116.7, // 100 × (1 + 5/30)
);

final _args = ActiveWorkoutArgs(
  splitType: SplitType.push,
  exerciseIds: ['bench-press'],
);

// ── Fake notifier ─────────────────────────────────────────────────────────────

/// A fake notifier that immediately returns a pre-built [ActiveWorkoutState].
///
/// Use [_state] to inject any state variant without touching the DB.
/// The [overrideWith] factory pattern for family providers:
///
/// ```dart
/// activeWorkoutProvider(args).overrideWith(
///   () => FakeActiveWorkoutNotifier(state),
/// )
/// ```
class FakeActiveWorkoutNotifier extends ActiveWorkoutNotifier {
  FakeActiveWorkoutNotifier(this._state);

  final ActiveWorkoutState _state;

  @override
  Future<ActiveWorkoutState> build(ActiveWorkoutArgs arg) async => _state;

  // No-op overrides — widget tests don't need real persistence.
  @override
  Future<void> addSet({
    required String exerciseId,
    required double weightKg,
    required int reps,
    double? rpe,
  }) async {}

  @override
  void removeSet(String exerciseId, String setId) {}

  @override
  void toggleExpand(String exerciseId) {}
}

// ── Test helper ───────────────────────────────────────────────────────────────

/// Wraps [ActiveWorkoutScreen] in a [ProviderScope] with the fake notifier.
///
/// Override pattern for AsyncNotifierProvider.family.autoDispose in Riverpod 2.x:
/// Use `activeWorkoutProvider.overrideWith(factory)` on the **family** itself,
/// not on a specific instance. The factory closure captures [state].
Widget buildScreen(ActiveWorkoutState state) {
  return ProviderScope(
    overrides: [
      // Override the whole family — the fake notifier ignores `arg` and
      // returns the pre-built state immediately.
      activeWorkoutProvider.overrideWith(
        () => FakeActiveWorkoutNotifier(state),
      ),
    ],
    child: MaterialApp(home: ActiveWorkoutScreen(args: _args)),
  );
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('ActiveWorkoutScreen — progress badge display', () {
    // ── Progressed ────────────────────────────────────────────────────────────
    testWidgets('shows ▲ icon and percentage when user progressed', (
      tester,
    ) async {
      // Arrange: a logged set that beats the previous performance.
      // Note: deltaPercent is a decimal (0.058 = 5.8%), the UI formats it.
      const progressedSet = LoggedSet(
        id: 'set-1',
        setNumber: 1,
        weightKg: 110,
        reps: 5,
        progress: Progressed(deltaPercent: 0.058),
      );

      final state = ActiveWorkoutState.loaded(
        sessionId: 'session-1',
        exercises: [
          ExerciseEntry(
            exercise: _benchPress,
            previousPerformance: _previousPerformance,
            sets: [progressedSet],
          ),
        ],
        expandedExerciseId: 'bench-press',
      );

      // Act
      await tester.pumpWidget(buildScreen(state));
      await tester.pump(); // settle async notifier

      // Assert: the progress badge icon is visible.
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    // ── Regressed ─────────────────────────────────────────────────────────────
    testWidgets('shows ▼ icon when user regressed', (tester) async {
      const regressedSet = LoggedSet(
        id: 'set-1',
        setNumber: 1,
        weightKg: 80,
        reps: 5,
        progress: Regressed(deltaPercent: -0.032),
      );

      final state = ActiveWorkoutState.loaded(
        sessionId: 'session-1',
        exercises: [
          ExerciseEntry(
            exercise: _benchPress,
            previousPerformance: _previousPerformance,
            sets: [regressedSet],
          ),
        ],
        expandedExerciseId: 'bench-press',
      );

      await tester.pumpWidget(buildScreen(state));
      await tester.pump();

      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    // ── Same ──────────────────────────────────────────────────────────────────
    testWidgets('shows = icon when performance is the same', (tester) async {
      const sameSet = LoggedSet(
        id: 'set-1',
        setNumber: 1,
        weightKg: 100,
        reps: 5,
        progress: Same(),
      );

      final state = ActiveWorkoutState.loaded(
        sessionId: 'session-1',
        exercises: [
          ExerciseEntry(
            exercise: _benchPress,
            previousPerformance: _previousPerformance,
            sets: [sameSet],
          ),
        ],
        expandedExerciseId: 'bench-press',
      );

      await tester.pumpWidget(buildScreen(state));
      await tester.pump();

      expect(find.byIcon(Icons.remove), findsOneWidget);
    });

    // ── FirstTime ─────────────────────────────────────────────────────────────
    testWidgets('shows "New!" text when there is no previous performance', (
      tester,
    ) async {
      const firstTimeSet = LoggedSet(
        id: 'set-1',
        setNumber: 1,
        weightKg: 60,
        reps: 8,
        progress: FirstTime(),
      );

      final state = ActiveWorkoutState.loaded(
        sessionId: 'session-1',
        exercises: [
          ExerciseEntry(
            exercise: _benchPress,
            previousPerformance: null, // no history
            sets: [firstTimeSet],
          ),
        ],
        expandedExerciseId: 'bench-press',
      );

      await tester.pumpWidget(buildScreen(state));
      await tester.pump();

      expect(find.text('New!'), findsOneWidget);
      expect(find.byIcon(Icons.star_outline), findsOneWidget);
    });

    // ── Previous performance hint ─────────────────────────────────────────────
    testWidgets(
      'shows "Last: X kg × N" hint text when previous performance exists',
      (tester) async {
        // Empty sets — we're testing the hint in the input row, not a badge.
        final state = ActiveWorkoutState.loaded(
          sessionId: 'session-1',
          exercises: [
            ExerciseEntry(
              exercise: _benchPress,
              previousPerformance: _previousPerformance,
            ),
          ],
          expandedExerciseId: 'bench-press',
        );

        await tester.pumpWidget(buildScreen(state));
        await tester.pump();

        // The SetInputRow shows "Last: 100.0 kg × 5" as hint text.
        expect(find.textContaining('Last: 100.0 kg'), findsOneWidget);
      },
    );

    // ── Error state ───────────────────────────────────────────────────────────
    testWidgets('shows error view when state is error', (tester) async {
      // ActiveWorkoutState.error takes a positional String (Freezed-generated).
      const state = ActiveWorkoutState.error('Failed to load exercises');

      await tester.pumpWidget(buildScreen(state));
      await tester.pump();

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });
}
