part of '../exploration_service.dart';

TempleSanctuary generateTempleSanctuaryBasicImpl(
  ExplorationService service,
) {
  final roll = DiceRoller.rollStatic(1, 6);
  final type = service._getTempleSanctuaryType(roll);
  final description = service._getTempleSanctuaryDescription(type);
  final details = service._getTempleSanctuaryDetails(type);

  return TempleSanctuary(
    type: type,
    description: description,
    details: details,
    deity: 'Deus Antigo ${DiceRoller.rollStatic(1, 6)}',
    occupants: 'Ocupantes ${DiceRoller.rollStatic(1, 6)}',
  );
}
