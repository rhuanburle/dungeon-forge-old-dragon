part of '../exploration_service.dart';

Object generateDetailedObjectImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final subtypeRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getObjectType(typeRoll);
  final subtype = service._getObjectSubtype(type, subtypeRoll);

  final description = service._generateDetailedObjectDescription(type, subtype);
  final details = service._generateDetailedObjectDetails(type, subtype);

  return Object(
    type: type,
    description: description,
    details: details,
    subtype: subtype,
  );
}
