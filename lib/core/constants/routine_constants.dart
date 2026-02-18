import 'package:gym_tracker/features/routine/domain/entities/split_type.dart';

/// Default exercises for each split type.
/// Used for seeding and self-healing empty routines.
const Map<SplitType, List<String>> defaultSplitExercises = {
  SplitType.push: [
    'ex-bench-press',
    'ex-ohp',
    'ex-incline-bench',
    'ex-lateral-raise',
    'ex-tricep-pushdown',
    'ex-decline-bench',
    'ex-arnold-press',
  ],
  SplitType.pull: [
    'ex-deadlift',
    'ex-pull-up',
    'ex-barbell-row',
    'ex-lat-pulldown',
    'ex-barbell-curl',
    'ex-t-bar-row',
    'ex-preacher-curl',
  ],
  SplitType.legs: [
    'ex-squat',
    'ex-rdl',
    'ex-leg-press',
    'ex-leg-curl',
    'ex-seated-calf',
    'ex-hack-squat',
    'ex-sumo-deadlift',
  ],
};
