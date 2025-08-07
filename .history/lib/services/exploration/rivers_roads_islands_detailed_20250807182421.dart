part of '../exploration_service.dart';

RiversRoadsIslands generateDetailedRiversRoadsIslandsImpl(
  ExplorationService service,
) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final directionRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getRiversRoadsIslandsType(false, false, typeRoll);
  final direction = service._getRiversRoadsIslandsDirection(directionRoll);

  final description = service._generateDetailedRiversRoadsIslandsDescription(
    type,
    direction,
  );
  final details = service._generateDetailedRiversRoadsIslandsDetails(
    type,
    direction,
  );

  return RiversRoadsIslands(
    type: type,
    description: description,
    details: details,
    direction: direction,
  );
}
