/// Represents the type of training day in a Push/Pull/Legs split.
enum SplitType {
  push,
  pull,
  legs,

  /// A scheduled rest or active recovery day.
  rest;

  /// Human-readable display label.
  String get displayName => switch (this) {
    SplitType.push => 'Push',
    SplitType.pull => 'Pull',
    SplitType.legs => 'Legs',
    SplitType.rest => 'Rest',
  };
}
