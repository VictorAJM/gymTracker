import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';

/// Immutable value object representing the user's persisted preferences.
class AppSettings {
  const AppSettings({
    this.unitSystem = UnitSystem.metric,
    this.darkMode = false,
  });

  /// The weight unit system the user has selected.
  final UnitSystem unitSystem;

  /// Dark mode preference (placeholder — not wired to the theme yet).
  final bool darkMode;

  AppSettings copyWith({UnitSystem? unitSystem, bool? darkMode}) {
    return AppSettings(
      unitSystem: unitSystem ?? this.unitSystem,
      darkMode: darkMode ?? this.darkMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettings &&
          runtimeType == other.runtimeType &&
          unitSystem == other.unitSystem &&
          darkMode == other.darkMode;

  @override
  int get hashCode => Object.hash(unitSystem, darkMode);
}
