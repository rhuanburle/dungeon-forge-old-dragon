part of '../exploration_service.dart';

Ruin generateRuinBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final sizeRoll = DiceRoller.rollStatic(1, 6);
  final defenseRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getRuinType(typeRoll);
  final size = service._getRuinSizeWithRolls(sizeRoll, type);
  final defenses = service._getRuinDefenses(defenseRoll, type);

  final description = '${type.description} encontrada';
  final details = service._getRuinDetailsWithRolls(type, typeRoll, size);

  return Ruin(
    type: type,
    description: description,
    details: details,
    size: size,
    defenses: defenses,
  );
}
