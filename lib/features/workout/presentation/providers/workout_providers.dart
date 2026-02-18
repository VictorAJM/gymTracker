import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';
import 'package:gym_tracker/features/workout/data/repositories/drift_set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/usecases/calculate_progress.dart';
import 'package:gym_tracker/features/workout/domain/usecases/get_previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/usecases/save_set.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';

// ── Repository ───────────────────────────────────────────────────────────────

/// Provides the concrete [SetLogRepository] backed by Drift.
///
/// Override in tests to inject a mock or in-memory implementation.
final setLogRepositoryProvider = Provider<SetLogRepository>((ref) {
  return DriftSetLogRepository(ref.watch(setLogDaoProvider));
});

// ── Use Cases ────────────────────────────────────────────────────────────────

/// Fetches the most recent logged set for a given exercise.
final getPreviousPerformanceProvider =
    Provider<GetPreviousPerformanceUseCase>((ref) {
  return GetPreviousPerformanceUseCase(ref.watch(setLogRepositoryProvider));
});

/// Validates and persists a new [SetLog].
final saveSetProvider = Provider<SaveSetUseCase>((ref) {
  return SaveSetUseCase(ref.watch(setLogRepositoryProvider));
});

/// Compares a current set against a previous one and returns a [ProgressStatus].
final calculateProgressProvider = Provider<CalculateProgressUseCase>((ref) {
  return const CalculateProgressUseCase();
});

/// Side-channel for surfacing [Failure]s from [ActiveWorkoutNotifier] to the UI.
///
/// The notifier writes a [Failure] here when [addSet] fails validation or
/// encounters a DB error. The screen listens with [ref.listen] and shows a
/// Snackbar via [SnackbarHelper]. Resets to null after being consumed.
final workoutErrorProvider = StateProvider<Failure?>((ref) => null);

// ── Screen Notifier ───────────────────────────────────────────────────────────

/// Drives the Active Workout screen.
///
/// Usage:
/// ```dart
/// final args = ActiveWorkoutArgs(splitType: SplitType.push, exerciseIds: [...]);
/// ref.watch(activeWorkoutProvider(args))
/// ```
final activeWorkoutProvider = AsyncNotifierProvider.family
    .autoDispose<ActiveWorkoutNotifier, ActiveWorkoutState, ActiveWorkoutArgs>(
  ActiveWorkoutNotifier.new,
);
