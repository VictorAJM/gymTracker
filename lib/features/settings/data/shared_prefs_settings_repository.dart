import 'package:gym_tracker/features/settings/data/settings_repository.dart';
import 'package:gym_tracker/features/settings/domain/entities/app_settings.dart';
import 'package:gym_tracker/features/settings/domain/entities/unit_system.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Keys used to persist settings in [SharedPreferences].
abstract final class _Keys {
  static const unitSystem = 'unit_system';
  static const darkMode = 'dark_mode';
}

/// [SettingsRepository] backed by [SharedPreferences].
class SharedPrefsSettingsRepository implements SettingsRepository {
  const SharedPrefsSettingsRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<AppSettings> load() async {
    final unitSystemStr = _prefs.getString(_Keys.unitSystem);
    final darkMode = _prefs.getBool(_Keys.darkMode) ?? false;

    final unitSystem = switch (unitSystemStr) {
      'imperial' => UnitSystem.imperial,
      _ => UnitSystem.metric, // default
    };

    return AppSettings(unitSystem: unitSystem, darkMode: darkMode);
  }

  @override
  Future<void> save(AppSettings settings) async {
    await _prefs.setString(
      _Keys.unitSystem,
      settings.unitSystem.name, // 'metric' or 'imperial'
    );
    await _prefs.setBool(_Keys.darkMode, settings.darkMode);
  }
}
