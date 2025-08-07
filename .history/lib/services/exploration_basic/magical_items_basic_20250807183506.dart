part of '../exploration_service.dart';

MagicalItem generateMagicalItemBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final powerRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getMagicalItemType(typeRoll);
  final power = service._getMagicalItemPowerWithRolls(powerRoll, type);

  final description = '${type.description} encontrado';
  final details = service._getMagicalItemDetailsWithRolls(type, typeRoll, power);

  return MagicalItem(
    type: type,
    description: description,
    details: details,
    power: power,
  );
}
