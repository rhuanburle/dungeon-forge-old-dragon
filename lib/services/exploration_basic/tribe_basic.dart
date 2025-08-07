part of '../exploration_service.dart';

Tribe generateTribeBasicImpl(
  ExplorationService service,
  TerrainType terrainType,
) {
  final roll = DiceRoller.rollStatic(1, 6);
  final type = service._getTribeType(terrainType, roll);
  final members = service._getTribeMembers(type);
  final soldiers = service._getTribeSoldiers(type, members);
  final leaders = service._getTribeLeaders(type);
  final religious = service._getTribeReligious(type, members);
  final special = service._getTribeSpecial(type, members);

  return Tribe(
    type: type,
    members: members,
    soldiers: soldiers,
    leaders: leaders,
    religious: religious,
    special: special,
    description: 'Tribo de $type com $members membros',
  );
}

Tribe generateTribeWithRollBasicImpl(
  ExplorationService service,
  TerrainType terrainType,
  int roll,
) {
  final type = service._getTribeType(terrainType, roll);
  final members = service._getTribeMembers(type);
  final soldiers = service._getTribeSoldiers(type, members);
  final leaders = service._getTribeLeaders(type);
  final religious = service._getTribeReligious(type, members);
  final special = service._getTribeSpecial(type, members);

  return Tribe(
    type: type,
    members: members,
    soldiers: soldiers,
    leaders: leaders,
    religious: religious,
    special: special,
    description: 'Tribo de $type com $members membros',
  );
}
