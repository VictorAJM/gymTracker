import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_day.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/routine/presentation/providers/routine_providers.dart';
import 'package:gym_tracker/features/routine/presentation/screens/routine_editor_screen.dart';
import 'package:gym_tracker/features/settings/presentation/screens/settings_screen.dart';
import 'package:gym_tracker/features/workout/presentation/notifiers/active_workout_notifier.dart';
import 'package:gym_tracker/features/workout/presentation/screens/active_workout_screen.dart';

/// Entry point for starting a workout session.
///
/// Displays three large tap targets — Push, Pull, Legs — and navigates to
/// [ActiveWorkoutScreen] with the exercises from the active routine.
///
/// If an active routine exists, an "Edit" button is shown on each card to
/// open the [RoutineEditorScreen] for that split day.
class SplitSelectionScreen extends ConsumerWidget {
  const SplitSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final asyncRoutine = ref.watch(activeRoutineProvider);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SettingsScreen(),
                  ),
                ),
          ),
        ],
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
                child: asyncRoutine.when(
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => _buildCards(context, routine: null),
                  data: (routine) => _buildCards(context, routine: routine),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context, {required Routine? routine}) {
    SplitDay? dayFor(SplitType type) =>
        routine?.days.where((d) => d.splitType == type).firstOrNull;

    return Column(
      children: [
        _SplitCard(
          splitType: SplitType.push,
          splitDay: dayFor(SplitType.push),
          icon: Icons.arrow_upward_rounded,
          description: 'Chest · Shoulders · Triceps',
          gradient: LinearGradient(
            colors: [Colors.orange.shade400, Colors.deepOrange.shade600],
          ),
        ),
        const SizedBox(height: 16),
        _SplitCard(
          splitType: SplitType.pull,
          splitDay: dayFor(SplitType.pull),
          icon: Icons.arrow_downward_rounded,
          description: 'Back · Biceps · Rear Delts',
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.indigo.shade600],
          ),
        ),
        const SizedBox(height: 16),
        _SplitCard(
          splitType: SplitType.legs,
          splitDay: dayFor(SplitType.legs),
          icon: Icons.directions_run_rounded,
          description: 'Quads · Hamstrings · Glutes · Calves',
          gradient: LinearGradient(
            colors: [Colors.green.shade400, Colors.teal.shade600],
          ),
        ),
      ],
    );
  }
}

// ── Split card ─────────────────────────────────────────────────────────────────

class _SplitCard extends StatelessWidget {
  const _SplitCard({
    required this.splitType,
    required this.splitDay,
    required this.icon,
    required this.description,
    required this.gradient,
  });

  final SplitType splitType;

  /// The matching [SplitDay] from the active routine, or null if no routine.
  final SplitDay? splitDay;

  final IconData icon;
  final String description;
  final LinearGradient gradient;

  List<String> get _exerciseIds =>
      splitDay?.exercises.map((e) => e.id).toList() ?? [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Stack(
        children: [
          // ── Main tap target ───────────────────────────────────────────────
          Material(
            borderRadius: BorderRadius.circular(24),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap:
                  () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder:
                          (_) => ActiveWorkoutScreen(
                            args: ActiveWorkoutArgs(
                              splitType: splitType,
                              exerciseIds: _exerciseIds,
                            ),
                          ),
                    ),
                  ),
              child: Ink(
                decoration: BoxDecoration(gradient: gradient),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
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
                              splitDay != null
                                  ? '${splitDay!.exercises.length} exercise'
                                      '${splitDay!.exercises.length == 1 ? '' : 's'}'
                                  : description,
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

          // ── Edit button (only when a routine split day exists) ────────────
          if (splitDay != null)
            Positioned(
              top: 8,
              right: 8,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder:
                              (_) => RoutineEditorScreen(
                                splitDayId: splitDay!.id,
                                splitType: splitType,
                              ),
                        ),
                      ),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
