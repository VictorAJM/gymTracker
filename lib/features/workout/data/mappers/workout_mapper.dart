import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/workout/domain/entities/set_log.dart';
import 'package:gym_tracker/features/workout/domain/entities/workout_session.dart';

extension SetLogRowMapper on SetLogRow {
  SetLog toDomain() => SetLog(
        id: id,
        workoutSessionId: workoutSessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weightKg: weightKg,
        reps: reps,
        rpe: rpe,
        completedAt: DateTime.fromMillisecondsSinceEpoch(completedAt),
        notes: notes,
      );
}

extension SetLogDomainMapper on SetLog {
  SetLogsCompanion toCompanion() => SetLogsCompanion(
        id: Value(id),
        workoutSessionId: Value(workoutSessionId),
        exerciseId: Value(exerciseId),
        setNumber: Value(setNumber),
        weightKg: Value(weightKg),
        reps: Value(reps),
        rpe: Value(rpe),
        completedAt: Value(completedAt.millisecondsSinceEpoch),
        notes: Value(notes),
      );
}

extension WorkoutSessionRowMapper on WorkoutSessionRow {
  /// [sets] must be fetched separately from [SetLogs].
  WorkoutSession toDomain(List<SetLog> sets) => WorkoutSession(
        id: id,
        routineId: routineId,
        splitType: splitType,
        date: DateTime.fromMillisecondsSinceEpoch(date),
        sets: sets,
        notes: notes,
        durationMinutes: durationMinutes,
      );
}

extension WorkoutSessionDomainMapper on WorkoutSession {
  WorkoutSessionsCompanion toCompanion() => WorkoutSessionsCompanion(
        id: Value(id),
        routineId: Value(routineId),
        splitType: Value(splitType),
        date: Value(date.millisecondsSinceEpoch),
        notes: Value(notes),
        durationMinutes: Value(durationMinutes),
      );
}
