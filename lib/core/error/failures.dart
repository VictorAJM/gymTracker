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
