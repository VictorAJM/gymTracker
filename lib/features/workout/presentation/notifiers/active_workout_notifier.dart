import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/domain/usecases/calculate_progress.dart';
import 'package:gym_tracker/features/workout/domain/usecases/save_set.dart';
import 'package:gym_tracker/features/workout/presentation/providers/exercise_providers.dart';
import 'package:gym_tracker/features/workout/presentation/providers/workout_providers.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';
import 'package:uuid/uuid.dart';

/// Arguments passed to [activeWorkoutProvider] via `.family`.
class ActiveWorkoutArgs {
  const ActiveWorkoutArgs({
    required this.splitType,
    required this.exerciseIds,
  });

  final SplitType splitType;
  final List<String> exerciseIds;

  @override
  bool operator ==(Object other) =>
      other is ActiveWorkoutArgs &&
      other.splitType == splitType &&
      _listEquals(other.exerciseIds, exerciseIds);

  @override
  int get hashCode => Object.hash(splitType, Object.hashAll(exerciseIds));

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Manages the state of the Active Workout screen.
///
/// Responsibilities:
/// - Load [Exercise] objects for the selected split day
/// - Fetch previous performance for each exercise
/// - Track which exercise card is expanded
/// - Validate and save sets via [SaveSetUseCase]
/// - Compute progress badges via [CalculateProgressUseCase]
class ActiveWorkoutNotifier extends AutoDisposeFamilyAsyncNotifier<
    ActiveWorkoutState, ActiveWorkoutArgs> {
  final _uuid = const Uuid();

  late final String _sessionId;

  @override
  Future<ActiveWorkoutState> build(ActiveWorkoutArgs arg) async {
    _sessionId = _uuid.v4();

    final exerciseRepo = ref.watch(exerciseRepositoryProvider);
    final getPrevPerf = ref.watch(getPreviousPerformanceProvider);

    // Load all exercises for the day
    final entries = <ExerciseEntry>[];
    for (final exerciseId in arg.exerciseIds) {
      final exerciseResult = await exerciseRepo.getExerciseById(exerciseId);
      final exercise = exerciseResult.getOrElse(
        (_) => Exercise(
          id: exerciseId,
          name: 'Unknown Exercise',
          primaryMuscle: _fallbackMuscle(arg.splitType),
          equipment: EquipmentType.barbell,
        ),
      );

      final prevResult = await getPrevPerf(exerciseId);
      final previousPerformance = prevResult.fold((_) => null, (p) => p);

      entries.add(ExerciseEntry(
        exercise: exercise,
        previousPerformance: previousPerformance,
      ));
    }

    return ActiveWorkoutState.loaded(
      exercises: entries,
      expandedExerciseId: entries.isNotEmpty ? entries.first.exercise.id : null,
      sessionId: _sessionId,
    );
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Toggles the expanded exercise card.
  /// Tapping the already-open card collapses it.
  void toggleExpand(String exerciseId) {
    final current = state.valueOrNull;
    if (current is! ActiveWorkoutLoaded) return;

    state = AsyncData(
      current.copyWith(
        expandedExerciseId:
            current.expandedExerciseId == exerciseId ? null : exerciseId,
      ),
    );
  }

  /// Validates and saves a new set for [exerciseId].
  ///
  /// On success: appends the set to the exercise's list and computes its
  /// [ProgressStatus] badge.
  /// On failure: re-emits the current state with an error (does not crash).
  Future<void> addSet({
    required String exerciseId,
    required double weightKg,
    required int reps,
    double? rpe,
  }) async {
    final current = state.valueOrNull;
    if (current is! ActiveWorkoutLoaded) return;

    final entryIndex =
        current.exercises.indexWhere((e) => e.exercise.id == exerciseId);
    if (entryIndex == -1) return;

    final entry = current.exercises[entryIndex];
    final setNumber = entry.sets.length + 1;
    final setId = _uuid.v4();

    // ── Validate & persist ──────────────────────────────────────────────────
    final saveSet = ref.read(saveSetProvider);
    final saveResult = await saveSet(
      SaveSetParams(
        id: setId,
        workoutSessionId: _sessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weightKg: weightKg,
        reps: reps,
        completedAt: DateTime.now(),
        rpe: rpe,
      ),
    );

    // Surface validation/DB errors via the side-channel provider.
    // The screen listens to workoutErrorProvider and shows a Snackbar.
    if (saveResult.isLeft()) {
      final failure = saveResult.fold((f) => f, (_) => null) as Failure;
      ref.read(workoutErrorProvider.notifier).state = failure;
      return;
    }

    // ── Compute progress badge ──────────────────────────────────────────────
    final calcProgress = ref.read(calculateProgressProvider);
    final savedSet = SaveSetParams(
      id: setId,
      workoutSessionId: _sessionId,
      exerciseId: exerciseId,
      setNumber: setNumber,
      weightKg: weightKg,
      reps: reps,
      completedAt: DateTime.now(),
    ).toSetLog();

    final progressResult = await calcProgress(
      CalculateProgressParams(
        current: savedSet,
        previous: entry.previousPerformance?.lastSet,
      ),
    );
    final progress = progressResult.getOrElse((_) => const FirstTime());

    // ── Update state ────────────────────────────────────────────────────────
    final newSet = LoggedSet(
      id: setId,
      setNumber: setNumber,
      weightKg: weightKg,
      reps: reps,
      rpe: rpe,
      progress: progress,
    );

    final updatedEntries = List<ExerciseEntry>.from(current.exercises);
    updatedEntries[entryIndex] = entry.copyWith(
      sets: [...entry.sets, newSet],
    );

    state = AsyncData(
      current.copyWith(exercises: updatedEntries),
    );
  }

  /// Removes a previously logged set from the in-memory list.
  /// Does NOT delete from the database (sets are immutable once saved).
  void removeSet(String exerciseId, String setId) {
    final current = state.valueOrNull;
    if (current is! ActiveWorkoutLoaded) return;

    final entryIndex =
        current.exercises.indexWhere((e) => e.exercise.id == exerciseId);
    if (entryIndex == -1) return;

    final entry = current.exercises[entryIndex];
    final updatedSets = entry.sets
        .where((s) => s.id != setId)
        .toList()
        .asMap()
        .entries
        .map((e) => e.value.copyWith(setNumber: e.key + 1))
        .toList();

    final updatedEntries = List<ExerciseEntry>.from(current.exercises);
    updatedEntries[entryIndex] = entry.copyWith(sets: updatedSets);

    state = AsyncData(current.copyWith(exercises: updatedEntries));
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Returns a sensible fallback [MuscleGroup] for the given split type.
  /// Only used when an exercise ID can't be resolved from the DB.
  MuscleGroup _fallbackMuscle(SplitType splitType) => switch (splitType) {
        SplitType.push => MuscleGroup.chest,
        SplitType.pull => MuscleGroup.back,
        SplitType.legs => MuscleGroup.quads,
        SplitType.rest => MuscleGroup.chest,
      };
}
