part of '../exploration_service.dart';

Civilization generateDetailedCivilizationImpl(ExplorationService service) {
  final typeRoll = DiceRoller.rollStatic(1, 6);
  final governmentRoll = DiceRoller.rollStatic(1, 6);
  final techRoll = DiceRoller.rollStatic(1, 6);
  final attitudeRoll = DiceRoller.rollStatic(1, 6);
  final temaRoll = DiceRoller.rollStatic(1, 6);

  final type = service._getCivilizationType(typeRoll);
  final population = service._getCivilizationPopulationByType(type);
  final government = service._getCivilizationGovernment(governmentRoll);
  final tech = service._getTechLevel(techRoll);
  final appearance = service._getAppearance(techRoll);
  final alignment = service._getAlignment(techRoll);
  final ruler = service._getRuler(techRoll);
  final rulerLevel = service._getRulerLevel(techRoll);
  final race = service._getRace(techRoll);
  final special = service._getSpecial(techRoll);
  final attitude = service._getAttitude(attitudeRoll);
  final temaPovoado = service._getTemaPovoado(temaRoll);
  final temaCidade = service._getTemaCidade(temaRoll);

  final description = service._generateDetailedCivilizationDescription(
    type,
    population,
  );
  final details = service._generateDetailedCivilizationDetailsFull(
    type,
    population,
    government,
    tech,
    appearance,
    alignment,
    ruler,
    rulerLevel,
    race,
    special,
    attitude,
    temaPovoado,
    temaCidade,
  );
  final characteristics = service._generateCivilizationCharacteristics(
    tech,
    appearance,
    alignment,
    ruler,
    rulerLevel,
    race,
    special,
  );
  final attitudeAndThemes = service._generateCivilizationAttitudeAndThemes(
    attitude,
    temaPovoado,
    temaCidade,
  );

  return Civilization(
    type: type,
    description: description,
    details: details,
    population: population,
    government: government,
    characteristics: characteristics,
    attitudeAndThemes: attitudeAndThemes,
  );
}
