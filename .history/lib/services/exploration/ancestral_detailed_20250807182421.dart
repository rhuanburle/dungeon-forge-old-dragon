part of '../exploration_service.dart';

AncestralDiscovery generateDetailedAncestralDiscoveryImpl(
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

  final specificDetails = service._generateAncestralSpecificDetails(type);

  final description = service._generateDetailedAncestralDescription(
    type,
    condition,
    material,
    state,
    guardian,
  );

  final details = service._generateDetailedAncestralDetails(
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
    specificType: specificDetails['type'],
    specificSize: specificDetails['size'],
    specificCondition: specificDetails['condition'],
    specificPower: specificDetails['power'],
    specificSubtype: specificDetails['subtype'],
  );
}
