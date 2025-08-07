part of '../exploration_service.dart';

AncestralDiscovery generateAncestralDiscoveryBasicImpl(
  ExplorationService service,
) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final conditionRoll = DiceRoller.rollStatic(1, 6);
  final materialRoll = DiceRoller.rollStatic(1, 6);
  final stateRoll = DiceRoller.rollStatic(1, 6);
  final guardianRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getAncestralThingType(typeRoll);
  final condition = service._getAncestralCondition(conditionRoll);
  final material = service._getAncestralMaterial(materialRoll);
  final state = service._getAncestralState(stateRoll);
  final guardian = service._getAncestralGuardian(guardianRoll);

  final description = service._getAncestralDescription(
    type,
    condition,
    material,
    state,
    guardian,
  );
  final details = service._getAncestralDetails(
    type,
    condition,
    material,
    state,
    guardian,
  );

  return AncestralDiscovery(
    type: type,
    condition: condition,
    material: material,
    state: state,
    guardian: guardian,
    description: description,
    details: details,
  );
}
