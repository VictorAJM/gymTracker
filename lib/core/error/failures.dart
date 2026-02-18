/// Sealed class hierarchy representing domain-level failures.
///
/// All repository methods return [Either<Failure, T>] so that the
/// presentation layer can handle errors declaratively without try/catch.
sealed class Failure {
  const Failure({required this.message});

  final String message;

  @override
  String toString() => '$runtimeType(message: $message)';
}

/// Thrown when a database read/write operation fails.
final class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message});
}

/// Thrown when a requested resource does not exist.
final class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

/// Thrown when domain validation rules are violated.
final class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

/// Thrown for unexpected / unclassified errors.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

// ── Presentation bridge ───────────────────────────────────────────────────────

/// Maps a [Failure] to a short, user-friendly string suitable for display in
/// a Snackbar or inline error widget.
///
/// The switch is exhaustive over the sealed hierarchy — adding a new [Failure]
/// subclass without updating this extension will cause a compile-time error.
extension FailureMessage on Failure {
  String toUserMessage() => switch (this) {
        // DB errors: hide internal details, give actionable guidance.
        DatabaseFailure() =>
          'Something went wrong saving your data. Please try again.',

        // Not found: treat as informational, not an error.
        NotFoundFailure() =>
          'No previous data found for this exercise — this is your first time!',

        // Validation: the message is already user-facing (set in the use case).
        ValidationFailure() => message,

        // Catch-all: never expose stack traces or internal messages.
        UnexpectedFailure() =>
          'An unexpected error occurred. Please restart the app.',
      };
}
