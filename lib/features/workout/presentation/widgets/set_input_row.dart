import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_tracker/features/workout/domain/entities/previous_performance.dart';
import 'package:gym_tracker/features/workout/domain/entities/progress_status.dart';
import 'package:gym_tracker/features/workout/presentation/state/active_workout_state.dart';

/// A single row in the set logger: set number, weight field, reps field,
/// previous performance hint, and a progress badge.
///
/// This widget is purely presentational — it calls [onSave] when the user
/// submits the form, and [onDelete] when the delete icon is tapped.
class SetInputRow extends StatefulWidget {
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
  final void Function(double weightKg, int reps) onSave;

  /// Called when the user taps the delete icon on a saved set.
  final VoidCallback onDelete;

  @override
  State<SetInputRow> createState() => _SetInputRowState();
}

class _SetInputRowState extends State<SetInputRow> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Pre-fill with previous performance values for convenience
    if (widget.loggedSet != null) {
      _weightController.text = widget.loggedSet!.weightKg.toString();
      _repsController.text = widget.loggedSet!.reps.toString();
    } else if (widget.previousPerformance != null) {
      final prev = widget.previousPerformance!.lastSet;
      _weightController.text = prev.weightKg.toString();
      _repsController.text = prev.reps.toString();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    widget.onSave(weight, reps);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSaved = widget.loggedSet != null;

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
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      labelText: 'kg',
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
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (widget.previousPerformance != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2, left: 2),
                      child: Text(
                        'Last: ${widget.previousPerformance!.lastSet.weightKg} kg',
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
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
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
                    onFieldSubmitted: (_) => _submit(),
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
                onPressed: _submit,
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
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
  });

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
