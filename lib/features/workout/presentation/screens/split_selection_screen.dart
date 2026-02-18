import 'package:flutter/material.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/screens/active_workout_screen.dart';

/// Entry point for starting a workout session.
///
/// Displays three large tap targets — Push, Pull, Legs — and navigates to
/// [ActiveWorkoutScreen] with a hardcoded exercise list.
///
/// TODO: Replace hardcoded exercise IDs with the active routine's split day
/// once routine management is implemented.
class SplitSelectionScreen extends StatelessWidget {
  const SplitSelectionScreen({super.key});

  // Placeholder exercise IDs — replace with real IDs from the active routine.
  static const _pushExercises = [
    'bench-press',
    'overhead-press',
    'tricep-pushdown',
  ];
  static const _pullExercises = [
    'barbell-row',
    'lat-pulldown',
    'bicep-curl',
  ];
  static const _legsExercises = [
    'squat',
    'romanian-deadlift',
    'leg-press',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Start Workout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "What are you training today?",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Select your split to begin logging.",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    _SplitCard(
                      splitType: SplitType.push,
                      exerciseIds: _pushExercises,
                      icon: Icons.arrow_upward_rounded,
                      description: 'Chest · Shoulders · Triceps',
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade400,
                          Colors.deepOrange.shade600,
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SplitCard(
                      splitType: SplitType.pull,
                      exerciseIds: _pullExercises,
                      icon: Icons.arrow_downward_rounded,
                      description: 'Back · Biceps · Rear Delts',
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade400,
                          Colors.indigo.shade600,
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SplitCard(
                      splitType: SplitType.legs,
                      exerciseIds: _legsExercises,
                      icon: Icons.directions_run_rounded,
                      description: 'Quads · Hamstrings · Glutes · Calves',
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.shade400,
                          Colors.teal.shade600,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Split card ─────────────────────────────────────────────────────────────────

class _SplitCard extends StatelessWidget {
  const _SplitCard({
    required this.splitType,
    required this.exerciseIds,
    required this.icon,
    required this.description,
    required this.gradient,
  });

  final SplitType splitType;
  final List<String> exerciseIds;
  final IconData icon;
  final String description;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Material(
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ActiveWorkoutScreen(
                args: ActiveWorkoutArgs(
                  splitType: splitType,
                  exerciseIds: exerciseIds,
                ),
              ),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(gradient: gradient),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Row(
                children: [
                  Icon(icon, size: 48, color: Colors.white),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          splitType.displayName,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withAlpha(210),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
