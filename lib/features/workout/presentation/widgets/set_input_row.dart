import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/utils/weight_converter.dart';
import 'package:gym_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';
import 'package:gym_tracker/features/settings/presentation/providers/settings_providers.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';

/// A single row in the set logger: set number, weight field, reps field,
/// previous performance hint, and a progress badge.
///
/// This widget is purely presentational — it calls [onSave] when the user
/// submits the form, and [onDelete] when the delete icon is tapped.
///
/// Weight values are **always passed and received in kg** (matching the DB
/// schema). The widget reads [settingsNotifierProvider] to convert displayed
/// values to the user's preferred unit on the fly.
class SetInputRow extends ConsumerStatefulWidget {
  const SetInputRow({
    super.key,
    required this.setNumber,
    required this.previousPerformance,
    this.loggedSet,
    required this.onSave,
    required this.onDelete,
  });

  /// 1-based index of this set.
  final int setNumber;

  /// Previous session data — used to populate the hint text.
  final PreviousPerformance? previousPerformance;

  /// If non-null, this row is displaying a saved set (read-only mode).
  final LoggedSet? loggedSet;

  /// Called with (weightKg, reps) when the user submits a new set.
  /// The weight is always in **kg**, regardless of the display unit.
  final void Function(double weightKg, int reps) onSave;

  /// Called when the user taps the delete icon on a saved set.
  final VoidCallback onDelete;

  @override
  ConsumerState<SetInputRow> createState() => _SetInputRowState();
}

class _SetInputRowState extends ConsumerState<SetInputRow> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  /// The unit system active when the controllers were last populated.
  UnitSystem? _lastUnit;

  @override
  void initState() {
    super.initState();
    // Controllers are populated in the first build() call once we have
    // the unit system from the provider.
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  /// Populates the weight controller with the correct display value.
  void _populateWeight(UnitSystem unit) {
    if (widget.loggedSet != null) {
      _weightController.text = WeightConverter.toDisplay(
        widget.loggedSet!.weightKg,
        unit,
      ).toStringAsFixed(1);
    } else if (widget.previousPerformance != null) {
      _weightController.text = WeightConverter.toDisplay(
        widget.previousPerformance!.lastSet.weightKg,
        unit,
      ).toStringAsFixed(1);
    }
  }

  void _submit(UnitSystem unit) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final displayWeight = double.tryParse(_weightController.text) ?? 0;
    final weightKg = WeightConverter.toKg(displayWeight, unit);
    final reps = int.tryParse(_repsController.text) ?? 0;
    widget.onSave(weightKg, reps);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSaved = widget.loggedSet != null;

    // Use metric as default while the async settings load is in progress.
    final settings =
        ref.watch(settingsNotifierProvider).valueOrNull ?? const AppSettings();
    final unit = settings.unitSystem;

    // Re-populate controllers when the unit changes (e.g. user switches
    // metric ↔ imperial in Settings while the workout screen is open).
    if (_lastUnit != unit) {
      _lastUnit = unit;
      _repsController.text =
          widget.loggedSet?.reps.toString() ??
          widget.previousPerformance?.lastSet.reps.toString() ??
          '';
      _populateWeight(unit);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Set number ────────────────────────────────────────────────
            SizedBox(
              width: 28,
              child: Text(
                '${widget.setNumber}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),

            // ── Weight field ──────────────────────────────────────────────
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _weightController,
                    enabled: !isSaved,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: WeightConverter.label(unit),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      filled: isSaved,
                      fillColor:
                          isSaved ? colorScheme.surfaceContainerHighest : null,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      if (double.parse(v) < 0) return '≥ 0';
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(unit),
                  ),
                  if (widget.previousPerformance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2),
                      child: Text(
                        'Last: ${WeightConverter.format(widget.previousPerformance!.lastSet.weightKg, unit)}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // ── Reps field ────────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _repsController,
                    enabled: !isSaved,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: 'reps',
                      isDense: true,
                      border: const OutlineInputBorder(),
                      filled: isSaved,
                      fillColor:
                          isSaved ? colorScheme.surfaceContainerHighest : null,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final n = int.tryParse(v);
                      if (n == null || n < 1) return '≥ 1';
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(unit),
                  ),
                  if (widget.previousPerformance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2),
                      child: Text(
                        '× ${widget.previousPerformance!.lastSet.reps}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // ── Progress badge / action ───────────────────────────────────
            if (isSaved)
              _ProgressBadge(status: widget.loggedSet!.progress)
            else
              IconButton(
                icon: const Icon(Icons.check_circle_outline),
                color: colorScheme.primary,
                tooltip: 'Log set',
                onPressed: () => _submit(unit),
              ),

            // ── Delete (saved sets only) ──────────────────────────────────
            if (isSaved)
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                color: colorScheme.error,
                tooltip: 'Remove set',
                onPressed: widget.onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

// ── Progress badge ─────────────────────────────────────────────────────────────

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({this.status});

  final ProgressStatus? status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (status == null) return const SizedBox(width: 36);

    return switch (status!) {
      Progressed(:final deltaPercent) => _Badge(
        icon: Icons.arrow_upward,
        label: '+${(deltaPercent * 100).toStringAsFixed(1)}%',
        color: Colors.green.shade600,
      ),
      Regressed(:final deltaPercent) => _Badge(
        icon: Icons.arrow_downward,
        label: '${(deltaPercent * 100).toStringAsFixed(1)}%',
        color: colorScheme.error,
      ),
      Same() => _Badge(
        icon: Icons.remove,
        label: 'Same',
        color: colorScheme.outline,
      ),
      FirstTime() => _Badge(
        icon: Icons.star_outline,
        label: 'New!',
        color: colorScheme.tertiary,
      ),
    };
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label, required this.color});

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
