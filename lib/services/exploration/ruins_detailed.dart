part of '../exploration_service.dart';

Ruin generateDetailedRuinImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final sizeRoll = DiceRoller.rollStatic(1, 6);
  final defenseRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getRuinType(typeRoll);
  final size = service._getRuinSize(sizeRoll);
  final defenses = service._getRuinDefenses(defenseRoll, type);

  final description = service._generateDetailedRuinDescription(
    type,
    size,
    defenses,
  );
  final details = service._generateDetailedRuinDetails(type, size, defenses);

  return Ruin(
    type: type,
    description: description,
    details: details,
    size: size,
    defenses: defenses,
  );
}
