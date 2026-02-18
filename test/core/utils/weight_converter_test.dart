import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/utils/weight_converter.dart';
import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';

void main() {
  group('WeightConverter', () {
    // ── toDisplay ─────────────────────────────────────────────────────────────
    group('toDisplay', () {
      test('returns kg unchanged for metric', () {
        expect(WeightConverter.toDisplay(100, UnitSystem.metric), 100.0);
      });

      test('converts kg to lbs for imperial', () {
        expect(
          WeightConverter.toDisplay(100, UnitSystem.imperial),
          closeTo(220.462, 0.001),
        );
      });

      test('handles zero weight', () {
        expect(WeightConverter.toDisplay(0, UnitSystem.imperial), 0.0);
      });
    });

    // ── toKg ──────────────────────────────────────────────────────────────────
    group('toKg', () {
      test('returns display value unchanged for metric', () {
        expect(WeightConverter.toKg(100, UnitSystem.metric), 100.0);
      });

      test('converts lbs back to kg for imperial', () {
        expect(
          WeightConverter.toKg(220.462, UnitSystem.imperial),
          closeTo(100.0, 0.001),
        );
      });

      test('round-trips: toKg(toDisplay(x)) ≈ x', () {
        const kg = 82.5;
        final roundTripped = WeightConverter.toKg(
          WeightConverter.toDisplay(kg, UnitSystem.imperial),
          UnitSystem.imperial,
        );
        expect(roundTripped, closeTo(kg, 0.001));
      });
    });

    // ── label ─────────────────────────────────────────────────────────────────
    group('label', () {
      test('returns "kg" for metric', () {
        expect(WeightConverter.label(UnitSystem.metric), 'kg');
      });

      test('returns "lbs" for imperial', () {
        expect(WeightConverter.label(UnitSystem.imperial), 'lbs');
      });
    });

    // ── format ────────────────────────────────────────────────────────────────
    group('format', () {
      test('formats metric weight with one decimal and kg label', () {
        expect(WeightConverter.format(100, UnitSystem.metric), '100.0 kg');
      });

      test('formats imperial weight with one decimal and lbs label', () {
        // 100 kg × 2.20462 = 220.462 → '220.5 lbs'
        expect(WeightConverter.format(100, UnitSystem.imperial), '220.5 lbs');
      });

      test('formats zero correctly', () {
        expect(WeightConverter.format(0, UnitSystem.metric), '0.0 kg');
        expect(WeightConverter.format(0, UnitSystem.imperial), '0.0 lbs');
      });
    });
  });
}
