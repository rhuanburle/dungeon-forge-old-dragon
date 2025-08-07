part of '../exploration_service.dart';

Relic generateDetailedRelicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final conditionRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getRelicType(typeRoll);
  final condition = service._getRelicCondition(conditionRoll);

  final description = service._generateDetailedRelicDescription(type, condition);
  final details = service._generateDetailedRelicDetails(type, condition);

  return Relic(
    type: type,
    description: description,
    details: details,
    condition: condition,
  );
}
