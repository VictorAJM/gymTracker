import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';
import 'package:gym_tracker/features/settings/presentation/providers/settings_providers.dart';

/// The Settings screen.
///
/// Allows the user to choose their preferred unit system (Metric / Imperial)
/// and shows a placeholder for Dark Mode (future feature).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use metric defaults while the async load is in progress.
    final settings =
        ref.watch(settingsNotifierProvider).valueOrNull ?? const AppSettings();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Unit System ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Text(
              'UNITS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unit System',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Controls how weights are displayed throughout the app. '
                    'All data is stored in kg internally.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SegmentedButton<UnitSystem>(
                      segments: const [
                        ButtonSegment(
                          value: UnitSystem.metric,
                          label: Text('Metric (kg)'),
                          icon: Icon(Icons.straighten),
                        ),
                        ButtonSegment(
                          value: UnitSystem.imperial,
                          label: Text('Imperial (lbs)'),
                          icon: Icon(Icons.flag_outlined),
                        ),
                      ],
                      selected: {settings.unitSystem},
                      onSelectionChanged: (selection) {
                        ref
                            .read(settingsNotifierProvider.notifier)
                            .setUnitSystem(selection.first);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Appearance ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'APPEARANCE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Tooltip(
              message: 'Coming soon',
              child: SwitchListTile(
                title: const Text('Dark Mode'),
                subtitle: const Text('Override system theme (coming soon)'),
                value: settings.darkMode,
                // Disabled — placeholder for future implementation.
                onChanged: null,
                secondary: Icon(
                  Icons.dark_mode_outlined,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
