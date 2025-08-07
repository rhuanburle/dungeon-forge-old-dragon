part of '../exploration_service.dart';

Object generateObjectBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final subtypeRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getObjectType(typeRoll);
  final subtype = service._getObjectSubtype(type, subtypeRoll);

  final description = '${type.description} encontrado';
  final details = service._getObjectDetails(type, typeRoll);

  return Object(
    type: type,
    description: description,
    details: details,
    subtype: subtype,
  );
}
