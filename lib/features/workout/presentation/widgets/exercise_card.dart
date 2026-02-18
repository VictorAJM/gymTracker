import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';
import 'package:gym_tracker/features/workout/presentation/widgets/set_input_row.dart';

/// An expandable card for a single exercise in the active workout.
///
/// Collapsed: shows exercise name, primary muscle chip, and set count.
/// Expanded: shows all logged sets + an input row for the next set.
class ExerciseCard extends ConsumerWidget {
  const ExerciseCard({
    super.key,
    required this.entry,
    required this.isExpanded,
    required this.onTap,
    required this.onAddSet,
    required this.onRemoveSet,
  });

  final ExerciseEntry entry;
  final bool isExpanded;
  final VoidCallback onTap;
  final void Function(double weightKg, int reps) onAddSet;
  final void Function(String setId) onRemoveSet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final exercise = entry.exercise;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: isExpanded ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side:
            isExpanded
                ? BorderSide(color: colorScheme.primary, width: 1.5)
                : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──────────────────────────────────────────────
                _CardHeader(
                  exercise: exercise,
                  setCount: entry.sets.length,
                  isExpanded: isExpanded,
                ),

                // ── Expanded content ─────────────────────────────────────
                if (isExpanded) ...[
                  const Divider(height: 24),

                  // Saved sets
                  ...entry.sets.map(
                    (set) => SetInputRow(
                      key: ValueKey(set.id),
                      setNumber: set.setNumber,
                      previousPerformance: entry.previousPerformance,
                      loggedSet: set,
                      onSave: (w, r) {}, // no-op for saved sets
                      onDelete: () => onRemoveSet(set.id),
                    ),
                  ),

                  // Input row for the next set
                  SetInputRow(
                    key: ValueKey('input-${entry.sets.length}'),
                    setNumber: entry.sets.length + 1,
                    previousPerformance: entry.previousPerformance,
                    onSave: onAddSet,
                    onDelete: () {}, // no-op for the input row
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.exercise,
    required this.setCount,
    required this.isExpanded,
  });

  final Exercise exercise;
  final int setCount;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        // Exercise icon
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.fitness_center,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),

        // Name + muscle chip
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exercise.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: [
                  _MuscleChip(label: exercise.primaryMuscle.displayName),
                  if (setCount > 0)
                    Chip(
                      label: Text('$setCount set${setCount == 1 ? '' : 's'}'),
                      padding: EdgeInsets.zero,
                      labelStyle: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                      backgroundColor: colorScheme.secondaryContainer,
                      side: BorderSide.none,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                ],
              ),
            ],
          ),
        ),

        // Expand chevron
        AnimatedRotation(
          turns: isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: Icon(
            Icons.keyboard_arrow_down,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _MuscleChip extends StatelessWidget {
  const _MuscleChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(label),
      padding: EdgeInsets.zero,
      labelStyle: Theme.of(
        context,
      ).textTheme.labelSmall?.copyWith(color: colorScheme.onTertiaryContainer),
      backgroundColor: colorScheme.tertiaryContainer,
      side: BorderSide.none,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
