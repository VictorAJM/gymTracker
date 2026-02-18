import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/features/settings/data/settings_repository.dart';
import 'package:gym_tracker/features/settings/data/shared_prefs_settings_repository.dart';
import 'package:gym_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── SharedPreferences singleton ───────────────────────────────────────────────

/// Provides the [SharedPreferences] instance.
///
/// This provider is **overridden** in [main.dart] with the instance obtained
/// from `SharedPreferences.getInstance()` before the app starts. Overriding
/// here avoids async work inside the provider graph.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) =>
      throw UnimplementedError(
        'sharedPreferencesProvider must be overridden in main() via ProviderScope.',
      ),
);

// ── Repository ────────────────────────────────────────────────────────────────

/// Provides the concrete [SettingsRepository].
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SharedPrefsSettingsRepository(ref.watch(sharedPreferencesProvider));
});

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Loads [AppSettings] on startup and exposes mutation methods.
///
/// Usage:
/// ```dart
/// // Read current settings
/// final settings = ref.watch(settingsNotifierProvider).valueOrNull
///     ?? const AppSettings();
///
/// // Change unit system
/// ref.read(settingsNotifierProvider.notifier).setUnitSystem(UnitSystem.imperial);
/// ```
class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() => ref.read(settingsRepositoryProvider).load();

  /// Persists and applies a new [UnitSystem].
  Future<void> setUnitSystem(UnitSystem unit) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(unitSystem: unit);
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).save(updated);
  }

  /// Persists and applies a new dark-mode preference.
  Future<void> setDarkMode(bool enabled) async {
    final current = state.valueOrNull ?? const AppSettings();
    final updated = current.copyWith(darkMode: enabled);
    state = AsyncData(updated);
    await ref.read(settingsRepositoryProvider).save(updated);
  }
}

/// The global settings provider. Watch this anywhere you need [AppSettings].
final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);
