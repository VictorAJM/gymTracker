import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/providers/database_providers.dart';
import 'package:gym_tracker/features/workout/data/repositories/drift_set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/repositories/set_log_repository.dart';
import 'package:gym_tracker/features/workout/domain/usecases/calculate_progress.dart';
import 'package:gym_tracker/features/workout/domain/usecases/get_previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/usecases/save_set.dart';

// ── Repository ───────────────────────────────────────────────────────────────

/// Provides the concrete [SetLogRepository] backed by Drift.
///
/// Override in tests to inject a mock or in-memory implementation.
final setLogRepositoryProvider = Provider<SetLogRepository>((ref) {
  return DriftSetLogRepository(ref.watch(setLogDaoProvider));
});

// ── Use Cases ────────────────────────────────────────────────────────────────

/// Fetches the most recent logged set for a given exercise.
///
/// Usage:
/// ```dart
/// final useCase = ref.read(getPreviousPerformanceProvider);
/// final result = await useCase('exercise-id');
/// ```
final getPreviousPerformanceProvider =
    Provider<GetPreviousPerformanceUseCase>((ref) {
  return GetPreviousPerformanceUseCase(ref.watch(setLogRepositoryProvider));
});

/// Validates and persists a new [SetLog].
///
/// Usage:
/// ```dart
/// final useCase = ref.read(saveSetProvider);
/// final result = await useCase(SaveSetParams(...));
/// ```
final saveSetProvider = Provider<SaveSetUseCase>((ref) {
  return SaveSetUseCase(ref.watch(setLogRepositoryProvider));
});

/// Compares a current set against a previous one and returns a [ProgressStatus].
///
/// This use case is pure — no repository dependency. The default tolerance
/// is ±1%; override the provider to change it:
/// ```dart
/// overrides: [
///   calculateProgressProvider.overrideWithValue(
///     CalculateProgressUseCase(tolerancePercent: 0.05),
///   ),
/// ]
/// ```
final calculateProgressProvider = Provider<CalculateProgressUseCase>((ref) {
  return const CalculateProgressUseCase();
});
