part of '../exploration_service.dart';

Lair generateDetailedLairImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final occupationRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getLairType(typeRoll);
  final occupation = service._getLairOccupation(occupationRoll);

  final description = service._generateDetailedLairDescription(
    type,
    occupation,
  );
  final details = service._generateDetailedLairDetails(type, occupation);
  final occupant = service._getLairOccupant(type);

  return Lair(
    type: type,
    description: description,
    details: details,
    occupation: occupation,
    occupant: occupant,
  );
}
