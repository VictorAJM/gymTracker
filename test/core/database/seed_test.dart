import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:drift/native.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase.forTesting(
      NativeDatabase.memory(),
      seedOnCreate: true,
    );
  });

  tearDown(() async {
    await database.close();
  });

  test('database seeds with standard exercises', () async {
    final exercises = await database.exerciseDao.getAllExercises();

    // Verify a few new exercises exist
    final exerciseNames = exercises.map((e) => e.name).toList();

    // Check Push exercises
    expect(exerciseNames, contains('Decline Bench Press'));
    expect(exerciseNames, contains('Arnold Press'));

    // Check Pull exercises
    expect(exerciseNames, contains('T-Bar Row'));
    expect(exerciseNames, contains('Preacher Curl'));

    // Check Legs exercises
    expect(exerciseNames, contains('Hack Squat'));
    expect(exerciseNames, contains('Sumo Deadlift'));

    // Check Core
    expect(exerciseNames, contains('Russian Twist'));
  });
}
