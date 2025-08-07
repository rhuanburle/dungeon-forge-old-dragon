part of '../exploration_service.dart';

Ossuary generateOssuaryBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final sizeRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getOssuaryType(typeRoll);
  final size = service._getOssuarySizeByType(type, sizeRoll);

  final description = '${type.description} encontradas';
  final details = service._getOssuaryDetails(type, typeRoll);

  return Ossuary(
    type: type,
    description: description,
    details: details,
    size: size,
  );
}
