import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gym_tracker/core/database/type_converters.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_table.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_dao.dart';
import 'package:gym_tracker/features/routine/data/datasources/local/routine_table.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/set_log_dao.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_dao.dart';
import 'package:gym_tracker/features/workout/data/datasources/local/workout_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Routines,
    SplitDays,
    Exercises,
    WorkoutSessions,
    SetLogs,
  ],
  daos: [
    RoutineDao,
    ExerciseDao,
    WorkoutDao,
    SetLogDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// Constructor for in-memory databases used in tests.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'gym_tracker.db'));
    return NativeDatabase.createInBackground(file);
  });
}
