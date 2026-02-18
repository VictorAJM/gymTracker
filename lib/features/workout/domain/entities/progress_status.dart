/// The outcome of comparing a new set against the previous performance
/// for the same exercise.
///
/// Use exhaustive pattern matching to handle every case in the UI:
/// ```dart
/// switch (status) {
///   case Progressed() => ...
///   case Regressed()  => ...
///   case Same()       => ...
///   case FirstTime()  => ...
/// }
/// ```
sealed class ProgressStatus {
  const ProgressStatus();
}

/// The estimated 1-rep max improved by more than the tolerance threshold.
final class Progressed extends ProgressStatus {
  const Progressed({required this.deltaPercent});

  /// Positive percentage improvement (e.g. 0.05 = 5%).
  final double deltaPercent;
}

/// The estimated 1-rep max declined by more than the tolerance threshold.
final class Regressed extends ProgressStatus {
  const Regressed({required this.deltaPercent});

  /// Negative percentage change (e.g. -0.03 = −3%).
  final double deltaPercent;
}

/// Performance is within the ±[CalculateProgressUseCase.tolerancePercent]
/// band — considered unchanged.
final class Same extends ProgressStatus {
  const Same();
}

/// No previous data exists for this exercise — this is the first time it
/// has been logged.
final class FirstTime extends ProgressStatus {
  const FirstTime();
}
