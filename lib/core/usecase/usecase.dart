import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';

/// Base interface for all use cases in the domain layer.
///
/// [T] is the success return type.
/// [Params] is the input parameter type (use [NoParams] when none needed).
abstract interface class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Placeholder for use cases that require no input parameters.
final class NoParams {
  const NoParams();
}
