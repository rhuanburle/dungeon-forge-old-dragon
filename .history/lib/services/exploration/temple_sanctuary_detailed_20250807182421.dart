part of '../exploration_service.dart';

TempleSanctuary generateDetailedTempleSanctuaryImpl(
  ExplorationService service,
) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final religiousAspectsRoll = DiceRoller.rollStatic(1, 6);
  final occupationRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getTempleSanctuaryType(typeRoll);
  final religiousAspects = service._getReligiousAspects(religiousAspectsRoll);
  final occupation = service._getTempleSanctuaryOccupation(occupationRoll);

  final description = service._generateDetailedTempleSanctuaryDescription(
    type,
    religiousAspects,
  );
  final details = service._generateDetailedTempleSanctuaryDetails(
    type,
    religiousAspects,
    occupation,
  );

  return TempleSanctuary(
    type: type,
    description: description,
    details: details,
    deity: religiousAspects,
    occupants: occupation,
  );
}
