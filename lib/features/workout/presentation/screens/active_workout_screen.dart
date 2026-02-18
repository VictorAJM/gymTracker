import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/core/presentation/snackbar_helper.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/providers/workout_providers.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';
import 'package:gym_tracker/features/workout/presentation/widgets/exercise_card.dart';

/// The main workout logging screen.
///
/// Receives [args] (split type + exercise IDs) from [SplitSelectionScreen].
/// Consumes [activeWorkoutProvider] to drive the UI.
///
/// Error handling: listens to [workoutErrorProvider] and shows a Snackbar
/// whenever the notifier writes a [Failure] (e.g. validation or DB error).
class ActiveWorkoutScreen extends ConsumerWidget {
  const ActiveWorkoutScreen({super.key, required this.args});

  final ActiveWorkoutArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ── Error side-channel ─────────────────────────────────────────────────
    // Listen to failures emitted by the notifier (e.g. validation errors from
    // addSet). Show a Snackbar and immediately reset the provider to null so
    // the same error doesn't re-fire on the next build.
    ref.listen<Failure?>(workoutErrorProvider, (_, failure) {
      if (failure == null) return;
      SnackbarHelper.showFailure(context, failure);
      // Reset so the same failure doesn't re-show on hot-reload / rebuild.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(workoutErrorProvider.notifier).state = null;
      });
    });

    final asyncState = ref.watch(activeWorkoutProvider(args));

    print(asyncState);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          '${args.splitType.displayName} Day',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Finish workout',
            onPressed: () => _onFinish(context),
          ),
        ],
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _ErrorView(message: err.toString()),
        data:
            (state) => state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => _ErrorView(message: message),
              loaded:
                  (exercises, expandedExerciseId, _) => _LoadedBody(
                    exercises: exercises,
                    expandedExerciseId: expandedExerciseId,
                    args: args,
                  ),
            ),
      ),
    );
  }

  void _onFinish(BuildContext context) {
    showDialog<void>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Finish Workout?'),
            content: const Text(
              'Your sets have already been saved. Ready to wrap up?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Keep going'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop(); // close dialog
                  Navigator.of(context).pop(); // back to split selection
                },
                child: const Text('Finish'),
              ),
            ],
          ),
    );
  }
}

// ── Loaded body ───────────────────────────────────────────────────────────────

class _LoadedBody extends ConsumerWidget {
  const _LoadedBody({
    required this.exercises,
    required this.expandedExerciseId,
    required this.args,
  });

  final List<ExerciseEntry> exercises;
  final String? expandedExerciseId;
  final ActiveWorkoutArgs args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(activeWorkoutProvider(args).notifier);

    if (exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.fitness_center,
              size: 64,
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No exercises for this day.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final entry = exercises[index];
        final exerciseId = entry.exercise.id;
        return ExerciseCard(
          entry: entry,
          isExpanded: expandedExerciseId == exerciseId,
          onTap: () => notifier.toggleExpand(exerciseId),
          onAddSet:
              (weight, reps) => notifier.addSet(
                exerciseId: exerciseId,
                weightKg: weight,
                reps: reps,
              ),
          onRemoveSet: (setId) => notifier.removeSet(exerciseId, setId),
        );
      },
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 56, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
