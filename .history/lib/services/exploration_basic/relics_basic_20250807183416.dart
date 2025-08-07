part of '../exploration_service.dart';

Relic generateRelicBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final conditionRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getRelicType(typeRoll);
  final condition = service._getRelicCondition(conditionRoll);
  final itemDetails = service._getRelicItemDetails(type, typeRoll, condition);

  final description = '${type.description} encontrada';
  final details = service._getRelicDetailsWithRolls(
    type,
    typeRoll,
    condition,
    itemDetails,
  );

  return Relic(
    type: type,
    description: description,
    details: details,
    condition: condition,
  );
}
