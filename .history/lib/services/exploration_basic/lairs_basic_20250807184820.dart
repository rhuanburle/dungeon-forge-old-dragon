part of '../exploration_service.dart';

Lair generateLairBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final occupationRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getLairType(typeRoll);
  final occupation = service._getLairOccupation(occupationRoll);
  final occupant = service._getLairOccupant(type);

  final description =
      '${type.description} ${occupation.description.toLowerCase()}';
  final details = service._getLairDetails(type, occupation);

  return Lair(
    type: type,
    description: description,
    details: details,
    occupation: occupation,
    occupant: occupant,
  );
}
