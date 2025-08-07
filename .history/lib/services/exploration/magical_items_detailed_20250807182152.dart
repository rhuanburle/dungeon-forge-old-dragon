part of '../exploration_service.dart';

MagicalItem generateDetailedMagicalItemImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final powerRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getMagicalItemType(typeRoll);
  final power = service._getMagicalItemPower(type, powerRoll);

  final description = service._generateDetailedMagicalItemDescription(type, power);
  final details = service._generateDetailedMagicalItemDetails(type, power);

  return MagicalItem(
    type: type,
    description: description,
    details: details,
    power: power,
  );
}
