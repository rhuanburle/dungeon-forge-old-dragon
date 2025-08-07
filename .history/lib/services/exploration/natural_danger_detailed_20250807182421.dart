part of '../exploration_service.dart';

NaturalDanger generateDetailedNaturalDangerImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  // Keep variable reserved for future use if needed
  // final effectRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getNaturalDangerType(TerrainType.forests, typeRoll);
  final effects = service._getNaturalDangerEffects(type);

  final description = service._generateDetailedNaturalDangerDescription(
    type,
    effects,
  );
  final details = service._generateDetailedNaturalDangerDetails(type, effects);

  return NaturalDanger(
    type: type,
    description: description,
    details: details,
    effects: effects,
  );
}
