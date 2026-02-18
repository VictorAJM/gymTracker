import 'package:equatable/equatable.dart';
import 'package:gym_tracker/features/exercise/domain/entities/equipment_type.dart';
import 'package:gym_tracker/features/exercise/domain/entities/muscle_group.dart';

/// Represents a specific movement or exercise (e.g. Bench Press).
///
/// [Exercise] is a catalogue entry — it describes *what* the exercise is,
/// not how it was performed. Performance data lives in [SetLog].
class Exercise extends Equatable {
  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscle,
    required this.equipment,
    this.secondaryMuscles = const [],
    this.instructions,
    this.isCustom = false,
  });

  /// Unique identifier (UUID v4).
  final String id;

  /// Display name (e.g. "Bench Press", "Pull-Up").
  final String name;

  /// The main muscle group targeted.
  final MuscleGroup primaryMuscle;

  /// Additional muscles worked as synergists or stabilisers.
  final List<MuscleGroup> secondaryMuscles;

  /// Equipment required to perform this exercise.
  final EquipmentType equipment;

  /// Optional step-by-step instructions for form cues.
  final String? instructions;

  /// True if the user created this exercise (not from the built-in catalogue).
  final bool isCustom;

  Exercise copyWith({
    String? id,
    String? name,
    MuscleGroup? primaryMuscle,
    List<MuscleGroup>? secondaryMuscles,
    EquipmentType? equipment,
    String? instructions,
    bool? isCustom,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscle: primaryMuscle ?? this.primaryMuscle,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    primaryMuscle,
    secondaryMuscles,
    equipment,
    instructions,
    isCustom,
  ];
}
