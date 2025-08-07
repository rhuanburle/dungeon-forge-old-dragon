part of '../exploration_service.dart';

Vestige generateVestigeBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final detailRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getVestigeType(typeRoll);
  final detail = service._getVestigeDetail(type, detailRoll);

  final description = '${type.description} encontrado';
  final details = service._getVestigeDetails(type, typeRoll);

  return Vestige(
    type: type,
    description: description,
    details: details,
    detail: detail,
  );
}
