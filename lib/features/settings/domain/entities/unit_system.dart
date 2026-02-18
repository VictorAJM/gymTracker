/// The unit system the user prefers for weight display.
///
/// The database always stores weights in **kg**. This enum controls
/// presentation only — conversion happens in [WeightConverter].
enum UnitSystem {
  metric,
  imperial;

  /// Human-readable label shown in the Settings UI.
  String get displayName => switch (this) {
    UnitSystem.metric => 'Metric (kg)',
    UnitSystem.imperial => 'Imperial (lbs)',
  };
}
