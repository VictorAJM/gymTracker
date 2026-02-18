import 'package:drift/native.dart';
import 'package:gym_tracker/core/database/app_database.dart';

/// Creates an in-memory [AppDatabase] for use in unit tests.
///
/// Each call returns a fresh database with no data, ensuring test isolation.
AppDatabase createTestDatabase() =>
    AppDatabase.forTesting(NativeDatabase.memory());
