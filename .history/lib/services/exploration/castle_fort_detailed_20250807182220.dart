part of '../exploration_service.dart';

CastleFort generateDetailedCastleFortImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final sizeRoll = DiceRoller.rollStatic(1, 6);
  final defenseRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getCastleFortType(typeRoll);
  final size = service._getCastleFortSize(sizeRoll);
  final defenses = service._getCastleFortDefenses(defenseRoll);
  final detailRoll = DiceRoller.rollStatic(1, 6);
  final occupants = service._getCastleFortOccupants(type, detailRoll);

  final description =
      service._generateDetailedCastleFortDescription(type, size, defenses);
  final details = service._generateDetailedCastleFortDetails(
    type,
    size,
    defenses,
    occupants,
  );

  return CastleFort(
    type: type,
    description: description,
    details: details,
    size: size,
    defenses: defenses,
    occupants: occupants,
    age: 'Não especificado',
    condition: 'Não especificado',
    lord: 'Não especificado',
    garrison: 'Não especificado',
    special: 'Não especificado',
    rumors: 'Não especificado',
  );
}
