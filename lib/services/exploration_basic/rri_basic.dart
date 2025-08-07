part of '../exploration_service.dart';

RiversRoadsIslands generateRiversRoadsIslandsBasicImpl(
  ExplorationService service,
  bool isOcean,
  bool hasRiver,
) {
  final roll = DiceRoller.rollStatic(1, 6);
  final type = service._getRiversRoadsIslandsType(isOcean, hasRiver, roll);
  final description = service._getRiversRoadsIslandsDescription(type);
  final details = service._getRiversRoadsIslandsDetails(type);
  final direction = service._getRiversRoadsIslandsDirection(roll);

  return RiversRoadsIslands(
    type: type,
    description: description,
    details: details,
    direction: direction,
  );
}
