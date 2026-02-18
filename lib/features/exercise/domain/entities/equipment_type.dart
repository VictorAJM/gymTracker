/// Represents the equipment required to perform an exercise.
enum EquipmentType {
  barbell,
  dumbbell,
  cable,
  machine,
  bodyweight,
  kettlebell,
  resistanceBand,
  ezBar;

  /// Human-readable display label.
  String get displayName => switch (this) {
    EquipmentType.barbell => 'Barbell',
    EquipmentType.dumbbell => 'Dumbbell',
    EquipmentType.cable => 'Cable',
    EquipmentType.machine => 'Machine',
    EquipmentType.bodyweight => 'Bodyweight',
    EquipmentType.kettlebell => 'Kettlebell',
    EquipmentType.resistanceBand => 'Resistance Band',
    EquipmentType.ezBar => 'EZ Bar',
  };
}
