part of '../exploration_service.dart';

CastleFort generateCastleFortBasicImpl(ExplorationService service) {
  final roll = DiceRoller.rollStatic(1, 6);
  final type = service._getCastleFortType(roll);
  final description = service._getCastleFortDescription(type);
  final details = service._getCastleFortDetails(type);
  final size = service._getCastleFortSize(roll);
  final defenses = service._getCastleFortDefenses(roll);

  final detailRoll = DiceRoller.rollStatic(1, 6);
  final occupants = service._getCastleFortOccupants(type, detailRoll);
  final age = service._getCastleFortAge(detailRoll);
  final condition = service._getCastleFortCondition(detailRoll);
  final lord = service._getCastleFortLord(detailRoll);
  final garrison = service._getCastleFortGarrison(detailRoll);
  final special = service._getCastleFortSpecial(detailRoll);
  final rumors = service._getCastleFortRumors(roll);

  return CastleFort(
    type: type,
    description: description,
    details: details,
    size: size,
    defenses: defenses,
    occupants: occupants,
    age: age,
    condition: condition,
    lord: lord,
    garrison: garrison,
    special: special,
    rumors: rumors,
  );
}
