import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';

extension ExerciseRowMapper on ExerciseRow {
  Exercise toDomain() => Exercise(
        id: id,
        name: name,
        primaryMuscle: primaryMuscle,
        secondaryMuscles: secondaryMuscles,
        equipment: equipment,
        instructions: instructions,
        isCustom: isCustom,
      );
}

extension ExerciseDomainMapper on Exercise {
  ExercisesCompanion toCompanion() => ExercisesCompanion(
        id: Value(id),
        name: Value(name),
        primaryMuscle: Value(primaryMuscle),
        secondaryMuscles: Value(secondaryMuscles),
        equipment: Value(equipment),
        instructions: Value(instructions),
        isCustom: Value(isCustom),
      );
}
