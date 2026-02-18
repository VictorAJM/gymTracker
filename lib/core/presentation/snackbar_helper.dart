import 'package:flutter/material.dart';
import 'package:gym_tracker/core/error/failures.dart';

/// Centralised helper for showing consistent Snackbars across the app.
///
/// Usage:
/// ```dart
/// // Show a failure from a use case result:
/// result.fold(
///   (failure) => SnackbarHelper.showFailure(context, failure),
///   (_) => SnackbarHelper.showSuccess(context, 'Set saved!'),
/// );
/// ```
///
/// All methods are no-ops if the [BuildContext] is no longer mounted.
abstract final class SnackbarHelper {
  // ── Error / Failure ────────────────────────────────────────────────────────

  /// Shows a red error Snackbar with the user-friendly message from [failure].
  static void showFailure(BuildContext context, Failure failure) {
    _show(
      context,
      message: failure.toUserMessage(),
      backgroundColor: Theme.of(context).colorScheme.errorContainer,
      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
      icon: Icons.error_outline,
    );
  }

  // ── Success ────────────────────────────────────────────────────────────────

  /// Shows a green success Snackbar.
  static void showSuccess(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      foregroundColor: Colors.white,
      icon: Icons.check_circle_outline,
    );
  }

  // ── Info ───────────────────────────────────────────────────────────────────

  /// Shows a neutral informational Snackbar.
  static void showInfo(BuildContext context, String message) {
    _show(
      context,
      message: message,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      icon: Icons.info_outline,
    );
  }

  // ── Private ────────────────────────────────────────────────────────────────

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required Color foregroundColor,
    required IconData icon,
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(color: foregroundColor),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
  }
}
