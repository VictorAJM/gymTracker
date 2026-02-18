import 'package:fpdart/fpdart.dart';
import 'package:gym_tracker/core/error/failures.dart';
import 'package:gym_tracker/features/exercise/data/datasources/local/exercise_dao.dart';
import 'package:gym_tracker/features/exercise/data/mappers/exercise_mapper.dart';
import 'package:gym_tracker/features/exercise/domain/entities/exercise.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';
import 'package:gym_tracker/features/exercise/domain/repositories/exercise_repository.dart';

class DriftExerciseRepository implements ExerciseRepository {
  const DriftExerciseRepository(this._dao);

  final ExerciseDao _dao;

  @override
  Future<Either<Failure, List<Exercise>>> getExercises() async {
    try {
      final rows = await _dao.getAllExercises();
      return right(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Exercise>> getExerciseById(String id) async {
    try {
      final row = await _dao.getExerciseById(id);
      if (row == null) {
        return left(NotFoundFailure(message: 'Exercise not found: $id'));
      }
      return right(row.toDomain());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> searchExercises(String query) async {
    try {
      final rows = await _dao.searchExercises(query);
      return right(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Exercise>>> getExercisesByMuscleGroup(
    MuscleGroup muscleGroup,
  ) async {
    try {
      final rows = await _dao.getByMuscleGroup(muscleGroup.name);
      return right(rows.map((r) => r.toDomain()).toList());
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveExercise(Exercise exercise) async {
    try {
      await _dao.upsertExercise(exercise.toCompanion());
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExercise(String id) async {
    try {
      final existingRow = await _dao.getExerciseById(id);
      if (existingRow == null) {
        return left(NotFoundFailure(message: 'Exercise not found: $id'));
      }
      if (!existingRow.isCustom) {
        return left(
          const ValidationFailure(
            message: 'Built-in exercises cannot be deleted.',
          ),
        );
      }
      await _dao.deleteExerciseById(id);
      return right(unit);
    } catch (e) {
      return left(DatabaseFailure(message: e.toString()));
    }
  }
}
