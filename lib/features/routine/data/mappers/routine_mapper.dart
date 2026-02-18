import 'package:drift/drift.dart';
import 'package:gym_tracker/core/database/app_database.dart';
import 'package:gym_tracker/features/routine/domain/entities/routine.dart';
import 'package:gym_tracker/features/routine/domain/entities/split_day.dart';

extension SplitDayRowMapper on SplitDayRow {
  SplitDay toDomain() => SplitDay(
        dayOfWeek: dayOfWeek,
        splitType: splitType,
        exerciseIds: exerciseIds,
      );
}

extension SplitDayDomainMapper on SplitDay {
  SplitDaysCompanion toCompanion({
    required String id,
    required String routineId,
  }) =>
      SplitDaysCompanion(
        id: Value(id),
        routineId: Value(routineId),
        dayOfWeek: Value(dayOfWeek),
        splitType: Value(splitType),
        exerciseIds: Value(exerciseIds),
      );
}

extension RoutineRowMapper on RoutineRow {
  /// [days] must be fetched separately from [SplitDays].
  Routine toDomain(List<SplitDay> days) => Routine(
        id: id,
        name: name,
        days: days,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        isActive: isActive,
      );
}

extension RoutineDomainMapper on Routine {
  RoutinesCompanion toCompanion() => RoutinesCompanion(
        id: Value(id),
        name: Value(name),
        isActive: Value(isActive),
        createdAt: Value(createdAt.millisecondsSinceEpoch),
      );
}
