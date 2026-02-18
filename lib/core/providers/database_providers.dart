import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/set_log_dao.dart';

/// Provides the singleton [AppDatabase] instance.
///
/// Override this in tests with [ProviderContainer(overrides: [...])] to inject
/// an in-memory database.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Provides the [SetLogDao] from the singleton database.
final setLogDaoProvider = Provider<SetLogDao>((ref) {
  return ref.watch(appDatabaseProvider).setLogDao;
});
