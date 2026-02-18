import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/presentation/snackbar_helper.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/routine/presentation/notifiers/routine_editor_notifier.dart';
import 'package:gym_tracker/features/routine/presentation/state/routine_editor_state.dart';

/// Screen for editing the exercises assigned to a split day.
///
/// Shows two panels:
/// - **Current Exercises** — a [ReorderableListView] of assigned exercises.
/// - **Available Exercises** — a searchable master list; tapping adds to current.
///
/// All mutations are optimistic (UI updates immediately). Tapping Save
/// persists to the DB via [RoutineEditorNotifier.save].
class RoutineEditorScreen extends ConsumerStatefulWidget {
  const RoutineEditorScreen({
    super.key,
    required this.splitDayId,
    required this.splitType,
  });

  final String splitDayId;
  final SplitType splitType;

  @override
  ConsumerState<RoutineEditorScreen> createState() =>
      _RoutineEditorScreenState();
}

class _RoutineEditorScreenState extends ConsumerState<RoutineEditorScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  RoutineEditorNotifier get _notifier =>
      ref.read(routineEditorProvider(widget.splitDayId).notifier);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final asyncState = ref.watch(routineEditorProvider(widget.splitDayId));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Edit ${widget.splitType.displayName} Day'),
        actions: [
          asyncState.maybeWhen(
            data:
                (state) =>
                    state.isSaving
                        ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                        : FilledButton(
                          onPressed: () => _onSave(context),
                          child: const Text('Save'),
                        ),
            orElse: () => const SizedBox.shrink(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(message: err.toString()),
        data:
            (state) => _EditorBody(
              state: state,
              splitType: widget.splitType,
              searchController: _searchController,
              onAdd: _notifier.addExercise,
              onRemove: _notifier.removeExercise,
              onReorder: _notifier.reorder,
              onSearchChanged: (q) => _notifier.setSearchQuery(q),
            ),
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    final navigator = Navigator.of(context);

    final success = await _notifier.save();
    if (!mounted) return;
    if (success) {
      navigator.pop();
    } else {
      final editorState =
          ref.read(routineEditorProvider(widget.splitDayId)).valueOrNull;
      if (editorState?.saveError != null) {
        // ignore: use_build_context_synchronously
        SnackbarHelper.showFailure(context, editorState!.saveError!);
      }
    }
  }
}

// ── Editor body ───────────────────────────────────────────────────────────────

class _EditorBody extends StatelessWidget {
  const _EditorBody({
    required this.state,
    required this.splitType,
    required this.searchController,
    required this.onAdd,
    required this.onRemove,
    required this.onReorder,
    required this.onSearchChanged,
  });

  final RoutineEditorState state;
  final SplitType splitType;
  final TextEditingController searchController;
  final void Function(Exercise) onAdd;
  final void Function(String) onRemove;
  final void Function(int, int) onReorder;
  final void Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Current exercises ───────────────────────────────────────────────
        _SectionHeader(
          title: 'Current Exercises',
          subtitle:
              '${state.currentExercises.length} exercise'
              '${state.currentExercises.length == 1 ? '' : 's'} · drag to reorder',
          color: colorScheme.primary,
        ),
        if (state.currentExercises.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              'No exercises yet. Add some from the list below.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.outline,
              ),
            ),
          )
        else
          SizedBox(
            // Constrain the reorderable list so the available panel is visible.
            height: (state.currentExercises.length * 64.0).clamp(64.0, 260.0),
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.currentExercises.length,
              onReorder: onReorder,
              itemBuilder: (context, index) {
                final exercise = state.currentExercises[index];
                return _CurrentExerciseTile(
                  key: ValueKey(exercise.id),
                  exercise: exercise,
                  index: index,
                  onRemove: () => onRemove(exercise.id),
                );
              },
            ),
          ),

        const Divider(height: 1),

        // ── Available exercises ─────────────────────────────────────────────
        _SectionHeader(
          title: 'Available Exercises',
          subtitle: '${state.availableExercises.length} matching',
          color: colorScheme.secondary,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: searchController,
            onChanged: onSearchChanged,
            decoration: const InputDecoration(
              hintText: 'Search exercises…',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        Expanded(
          child:
              state.availableExercises.isEmpty
                  ? Center(
                    child: Text(
                      'No exercises found.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.outline,
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    itemCount: state.availableExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = state.availableExercises[index];
                      return _AvailableExerciseTile(
                        exercise: exercise,
                        onAdd: () => onAdd(exercise),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Current exercise tile ─────────────────────────────────────────────────────

class _CurrentExerciseTile extends StatelessWidget {
  const _CurrentExerciseTile({
    super.key,
    required this.exercise,
    required this.index,
    required this.onRemove,
  });

  final Exercise exercise;
  final int index;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 4),
        leading: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        title: Text(
          exercise.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          exercise.primaryMuscle.displayName,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove_circle_outline, color: colorScheme.error),
              tooltip: 'Remove',
              onPressed: onRemove,
            ),
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.drag_handle_rounded,
                color: colorScheme.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Available exercise tile ───────────────────────────────────────────────────

class _AvailableExerciseTile extends StatelessWidget {
  const _AvailableExerciseTile({required this.exercise, required this.onAdd});

  final Exercise exercise;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: colorScheme.secondaryContainer,
          child: Icon(
            Icons.fitness_center_rounded,
            size: 18,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        title: Text(
          exercise.name,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${exercise.primaryMuscle.displayName} · ${exercise.equipment.displayName}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.outline,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.add_circle_outline, color: colorScheme.primary),
          tooltip: 'Add to routine',
          onPressed: onAdd,
        ),
        onTap: onAdd,
      ),
    );
  }
}

// ── Error view ────────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colorScheme.error),
            ),
          ],
        ),
      ),
    );
  }
}
