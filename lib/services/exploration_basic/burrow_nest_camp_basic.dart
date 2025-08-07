part of '../exploration_service.dart';

Burrow generateBurrowBasicImpl(ExplorationService service) {
  final entryRoll = DiceRoller.rollStatic(1, 6);
  final occupantRoll = DiceRoller.rollStatic(1, 6);
  final treasureRoll = DiceRoller.rollStatic(1, 6);

  final entry = service._getBurrowEntry(entryRoll);
  final occupant = service._getBurrowOccupant(entryRoll, occupantRoll);
  final treasure = service._getBurrowTreasure(treasureRoll);

  return Burrow(
    entry: entry,
    occupant: occupant,
    treasure: treasure,
    description: 'Toca com $entry habitada por $occupant',
  );
}

Burrow generateBurrowWithRollBasicImpl(
  ExplorationService service,
  int entryRoll,
  int occupantRoll,
  int treasureRoll,
) {
  final entry = service._getBurrowEntry(entryRoll);
  final occupant = service._getBurrowOccupant(entryRoll, occupantRoll);
  final treasure = service._getBurrowTreasure(treasureRoll);

  return Burrow(
    entry: entry,
    occupant: occupant,
    treasure: treasure,
    description: 'Toca com $entry habitada por $occupant',
  );
}

Nest generateNestBasicImpl(ExplorationService service) {
  final roll = DiceRoller.rollStatic(1, 6);
  final owner = service._getNestOwner(roll);
  final characteristic = service._getNestCharacteristic(roll);

  return Nest(
    owner: owner,
    characteristic: characteristic,
    description: 'Ninho de $owner com $characteristic',
  );
}

Nest generateNestWithRollBasicImpl(ExplorationService service, int roll) {
  final owner = service._getNestOwner(roll);
  final characteristic = service._getNestCharacteristic(roll);

  return Nest(
    owner: owner,
    characteristic: characteristic,
    description: 'Ninho de $owner com $characteristic',
  );
}

Camp generateCampBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final specialRoll = DiceRoller.rollStatic(1, 6);
  final tentsRoll = DiceRoller.rollStatic(1, 6);
  final watchRoll = DiceRoller.rollStatic(1, 6);
  final defensesRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getCampType(typeRoll);
  final special = service._getCampSpecial(specialRoll);
  final tents = service._getCampTents(tentsRoll);
  final watch = service._getCampWatch(watchRoll);
  final defenses = service._getCampDefenses(defensesRoll);

  return Camp(
    type: type,
    special: special,
    tents: tents,
    watch: watch,
    defenses: defenses,
    description: 'Acampamento de $type com $defenses',
  );
}

Camp generateCampWithRollsBasicImpl(
  ExplorationService service,
  int typeRoll,
  int specialRoll,
  int tentsRoll,
  int watchRoll,
  int defensesRoll,
) {
  final type = service._getCampType(typeRoll);
  final special = service._getCampSpecial(specialRoll);
  final tents = service._getCampTents(tentsRoll);
  final watch = service._getCampWatch(watchRoll);
  final defenses = service._getCampDefenses(defensesRoll);

  return Camp(
    type: type,
    special: special,
    tents: tents,
    watch: watch,
    defenses: defenses,
    description: 'Acampamento de $type com $defenses',
  );
}
