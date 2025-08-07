part of '../exploration_service.dart';

Dungeon generateDungeonBasicImpl(ExplorationService service) {
  final entryRoll = DiceRoller.rollStatic(1, 6);
  final floorsRoll = DiceRoller.rollStatic(1, 6);
  final roomsRoll = DiceRoller.rollStatic(1, 6);
  final guardianRoll = DiceRoller.rollStatic(1, 6);

  final entry = service._getDungeonEntry(entryRoll);
  final floors = service._getDungeonFloors(floorsRoll);
  final rooms = service._getDungeonRooms(roomsRoll);
  final guardian = service._getDungeonGuardian(guardianRoll);

  final roomDetails = service._generateRoomDetails(rooms);

  return Dungeon(
    entry: entry,
    floors: floors,
    rooms: rooms,
    guardian: guardian,
    description: 'Masmorra com $floors andares e $rooms salas',
    roomDetails: roomDetails,
  );
}

Cave generateCaveBasicImpl(ExplorationService service) {
  final roll = DiceRoller.rollStatic(1, 6);
  final entry = service._getCaveEntry(roll);
  final inhabitant = service._getCaveInhabitant(roll);

  final chamberDetails = service._generateCaveChamberDetails();

  return Cave(
    entry: entry,
    inhabitant: inhabitant,
    description: 'Caverna com $entry habitada por $inhabitant',
    chamberDetails: chamberDetails,
  );
}

Cave generateCaveWithRollBasicImpl(ExplorationService service, int roll) {
  final entry = service._getCaveEntry(roll);
  final inhabitant = service._getCaveInhabitant(roll);
  final chamberDetails = service._generateCaveChamberDetails();
  return Cave(
    entry: entry,
    inhabitant: inhabitant,
    description: 'Caverna com $entry habitada por $inhabitant',
    chamberDetails: chamberDetails,
  );
}

Cave generateCaveWithDetailedRollsBasicImpl(
  ExplorationService service,
  int entryRoll,
  int chamberTypeRoll,
  int contentRoll,
  int specialRoll,
) {
  final entry = service._getCaveEntry(entryRoll);
  final inhabitant = service._getCaveInhabitant(entryRoll);
  final chamberDetails = service._generateCaveChamberDetailsWithRolls(
    chamberTypeRoll,
    contentRoll,
    specialRoll,
  );
  return Cave(
    entry: entry,
    inhabitant: inhabitant,
    description: 'Caverna com $entry habitada por $inhabitant',
    chamberDetails: chamberDetails,
  );
}
