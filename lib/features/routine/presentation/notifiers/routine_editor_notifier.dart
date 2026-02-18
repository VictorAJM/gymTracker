import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/routine/presentation/providers/routine_providers.dart';
import 'package:gym_tracker/features/routine/presentation/state/routine_editor_state.dart';

/// Manages the state of [RoutineEditorScreen].
///
/// Keyed on [splitDayId] so each split day gets its own isolated notifier.
class RoutineEditorNotifier
    extends AutoDisposeFamilyAsyncNotifier<RoutineEditorState, String> {
  @override
  Future<RoutineEditorState> build(String splitDayId) async {
    final routineRepo = ref.watch(routineRepositoryProvider);
    final exerciseRepo = ref.watch(routineFeatureExerciseRepoProvider);

    // Load the active routine to find the current exercises for this split day.
    final routineResult = await routineRepo.getActiveRoutine();
    final currentExercises = routineResult.fold((_) => <Exercise>[], (routine) {
      final day = routine.days.where((d) => d.id == splitDayId).firstOrNull;
      return day?.exercises ?? <Exercise>[];
    });

    // Load the full master catalogue.
    final allResult = await exerciseRepo.getExercises();
    final allExercises = allResult.getOrElse((_) => <Exercise>[]);

    return RoutineEditorState(
      currentExercises: List<Exercise>.from(currentExercises),
      allExercises: allExercises,
    );
  }

  // ── Optimistic mutations ──────────────────────────────────────────────────

  /// Appends [exercise] to the end of the current list.
  void addExercise(Exercise exercise) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        currentExercises: [...current.currentExercises, exercise],
        clearError: true,
      ),
    );
  }

  /// Removes the exercise with [exerciseId] from the current list.
  void removeExercise(String exerciseId) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(
      current.copyWith(
        currentExercises:
            current.currentExercises.where((e) => e.id != exerciseId).toList(),
        clearError: true,
      ),
    );
  }

  /// Moves an exercise from [oldIndex] to [newIndex].
  ///
  /// [ReorderableListView] passes [newIndex] AFTER the item has been removed,
  /// so we adjust by subtracting 1 when moving downward.
  void reorder(int oldIndex, int newIndex) {
    final current = state.valueOrNull;
    if (current == null) return;

    final list = List<Exercise>.from(current.currentExercises);
    final item = list.removeAt(oldIndex);
    final insertAt = newIndex > oldIndex ? newIndex - 1 : newIndex;
    list.insert(insertAt, item);

    state = AsyncData(current.copyWith(currentExercises: list));
  }

  /// Updates the search query used to filter the available exercises panel.
  void setSearchQuery(String query) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(searchQuery: query));
  }

  // ── Persistence ───────────────────────────────────────────────────────────

  /// Persists the current exercise list to the database.
  /// Returns `true` on success, `false` on failure (error stored in state).
  Future<bool> save() async {
    final current = state.valueOrNull;
    if (current == null) return false;

    state = AsyncData(current.copyWith(isSaving: true, clearError: true));

    final routineRepo = ref.read(routineRepositoryProvider);
    final result = await routineRepo.updateRoutineExercises(
      arg, // arg == splitDayId (the family key)
      current.currentExercises,
    );

    return result.fold(
      (failure) {
        state = AsyncData(
          current.copyWith(isSaving: false, saveError: failure),
        );
        return false;
      },
      (_) {
        state = AsyncData(current.copyWith(isSaving: false, clearError: true));
        return true;
      },
    );
  }
}

/// Provider for [RoutineEditorNotifier], keyed on [splitDayId].
///
/// Import this from [RoutineEditorScreen] — do NOT import from
/// [routine_providers.dart] to avoid circular dependencies.
final routineEditorProvider = AsyncNotifierProvider.autoDispose
    .family<RoutineEditorNotifier, RoutineEditorState, String>(
      RoutineEditorNotifier.new,
    );
