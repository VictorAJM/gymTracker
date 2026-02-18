/// Represents a primary or secondary muscle group targeted by an exercise.
enum MuscleGroup {
  chest,
  back,
  shoulders,
  triceps,
  biceps,
  forearms,
  quads,
  hamstrings,
  glutes,
  calves,
  core,
  traps;

  /// Human-readable display label.
  String get displayName => switch (this) {
    MuscleGroup.chest => 'Chest',
    MuscleGroup.back => 'Back',
    MuscleGroup.shoulders => 'Shoulders',
    MuscleGroup.triceps => 'Triceps',
    MuscleGroup.biceps => 'Biceps',
    MuscleGroup.forearms => 'Forearms',
    MuscleGroup.quads => 'Quads',
    MuscleGroup.hamstrings => 'Hamstrings',
    MuscleGroup.glutes => 'Glutes',
    MuscleGroup.calves => 'Calves',
    MuscleGroup.core => 'Core',
    MuscleGroup.traps => 'Traps',
  };
}
