import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';

/// UI state for the [RoutineEditorScreen].
///
/// Holds the mutable working copy of the exercise list, the master catalogue
/// for the "Available" panel, and transient UI state (search query, saving).
class RoutineEditorState {
  const RoutineEditorState({
    required this.currentExercises,
    required this.allExercises,
    this.searchQuery = '',
    this.isSaving = false,
    this.saveError,
  });

  /// The ordered list of exercises currently assigned to this split day.
  /// Mutated optimistically by add / remove / reorder operations.
  final List<Exercise> currentExercises;

  /// The full master catalogue fetched from the DB.
  final List<Exercise> allExercises;

  /// Current value of the search field in the "Available" panel.
  final String searchQuery;

  /// True while [RoutineEditorNotifier.save] is in flight.
  final bool isSaving;

  /// Non-null when the last save attempt failed.
  final Failure? saveError;

  // ── Derived ──────────────────────────────────────────────────────────────

  /// IDs of exercises already in [currentExercises] — used to filter the
  /// available list so the user can't add duplicates.
  Set<String> get currentIds => currentExercises.map((e) => e.id).toSet();

  /// Master catalogue filtered by [searchQuery] and excluding exercises
  /// already in [currentExercises].
  List<Exercise> get availableExercises {
    final q = searchQuery.toLowerCase().trim();
    return allExercises.where((e) {
      if (currentIds.contains(e.id)) return false;
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q);
    }).toList();
  }

  RoutineEditorState copyWith({
    List<Exercise>? currentExercises,
    List<Exercise>? allExercises,
    String? searchQuery,
    bool? isSaving,
    Failure? saveError,
    bool clearError = false,
  }) {
    return RoutineEditorState(
      currentExercises: currentExercises ?? this.currentExercises,
      allExercises: allExercises ?? this.allExercises,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
      saveError: clearError ? null : (saveError ?? this.saveError),
    );
  }
}
