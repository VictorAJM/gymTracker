import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';

/// Pure utility for converting weights between kg (storage) and the
/// user's preferred display unit.
///
/// The database **always stores kg**. Call [toDisplay] before showing a value
/// to the user, and [toKg] before writing a user-entered value to the DB.
class WeightConverter {
  const WeightConverter._();

  static const double _kgToLbs = 2.20462;

  // ── Conversion ─────────────────────────────────────────────────────────────

  /// Converts a stored kg value to the display unit.
  static double toDisplay(double kg, UnitSystem unit) =>
      unit == UnitSystem.imperial ? kg * _kgToLbs : kg;

  /// Converts a user-entered display value back to kg for storage.
  static double toKg(double display, UnitSystem unit) =>
      unit == UnitSystem.imperial ? display / _kgToLbs : display;

  // ── Formatting ─────────────────────────────────────────────────────────────

  /// Returns the weight unit label: `'kg'` or `'lbs'`.
  static String label(UnitSystem unit) =>
      unit == UnitSystem.imperial ? 'lbs' : 'kg';

  /// Formats a kg value for display with one decimal place and the unit label.
  ///
  /// Example: `format(100, UnitSystem.imperial)` → `'220.5 lbs'`
  static String format(double kg, UnitSystem unit) =>
      '${toDisplay(kg, unit).toStringAsFixed(1)} ${label(unit)}';
}
