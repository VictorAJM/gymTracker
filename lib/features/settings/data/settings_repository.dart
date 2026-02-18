import 'package:gym_tracker/features/settings/domain/entities/app_settings.dart';

/// Abstract contract for loading and persisting [AppSettings].
abstract interface class SettingsRepository {
  /// Loads the persisted settings. Returns defaults if nothing is saved yet.
  Future<AppSettings> load();

  /// Persists [settings] to the underlying storage.
  Future<void> save(AppSettings settings);
}
