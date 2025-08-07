part of '../exploration_service.dart';

NaturalDanger generateNaturalDangerBasicImpl(
  ExplorationService service,
  TerrainType terrainType,
) {
  final roll = DiceRoller.rollStatic(1, 6);
  final type = service._getNaturalDangerType(terrainType, roll);
  final description = service._getNaturalDangerDescription(type);
  final details = service._getNaturalDangerDetails(type);

  return NaturalDanger(
    type: type,
    description: description,
    details: details,
    effects: service._getNaturalDangerEffects(type),
  );
}
