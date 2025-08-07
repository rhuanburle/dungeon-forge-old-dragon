part of '../exploration_service.dart';

Civilization generateCivilizationBasicImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final governmentRoll = DiceRoller.rollStatic(1, 6);
  final type = service._getCivilizationType(typeRoll);
  final population = service._getCivilizationPopulationByType(type);
  final government = service._getCivilizationGovernment(governmentRoll);
  final details = service._getCivilizationDetails(type);

  return Civilization(
    type: type,
    description: '${type.description} encontrada',
    details: details,
    population: population,
    government: government,
    characteristics: 'Características',
    attitudeAndThemes: 'Atitude e Temas',
  );
}
