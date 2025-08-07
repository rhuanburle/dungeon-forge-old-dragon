part of '../exploration_service.dart';

Ossuary generateDetailedOssuaryImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final sizeRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getOssuaryType(typeRoll);
  final size = service._getOssuarySizeByType(type, sizeRoll);

  final description = service._generateDetailedOssuaryDescription(type, size);
  final details = service._generateDetailedOssuaryDetails(type, size);

  return Ossuary(
    type: type,
    description: description,
    details: details,
    size: size,
  );
}
