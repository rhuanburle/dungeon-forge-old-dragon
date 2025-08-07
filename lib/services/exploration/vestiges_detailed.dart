part of '../exploration_service.dart';

Vestige generateDetailedVestigeImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final detailRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getVestigeType(typeRoll);
  final detail = service._getVestigeDetail(type, detailRoll);

  final description = service._generateDetailedVestigeDescription(type, detail);
  final details = service._generateDetailedVestigeDetails(type, detail);

  return Vestige(
    type: type,
    description: description,
    details: details,
    detail: detail,
  );
}
