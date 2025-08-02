// tables/plains_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.2 - Encontros em Planícies
///
/// Esta tabela gera encontros para planícies e campos abertos,
/// organizados por nível de dificuldade do grupo de aventureiros.
class PlainsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.2 - Encontros em Planícies';

  @override
  String get description =>
      'Tabela de encontros para planícies e campos abertos';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.plains;

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Iniciantes (1º a 2º Nível)
    [
      TableReference.animalsTable,
      MonsterType.gnoll,
      MonsterType.goblin,
      TableReference.anyTableI,
      TableReference.humansTable,
      MonsterType.lizardMan,
      TableReference.extraplanarTableI,
      MonsterType.orc,
      MonsterType.hellhound,
      MonsterType.ogre,
      TableReference.anyTableII,
      MonsterType.youngBlueDragon,
    ],
    // Coluna 2: Heroicos (3º a 5º Nível)
    [
      TableReference.animalsTable,
      MonsterType.hellhound,
      MonsterType.insectSwarm,
      TableReference.anyTableII,
      TableReference.humansTable,
      MonsterType.oniMage,
      TableReference.extraplanarTableII,
      MonsterType.troll,
      MonsterType.basilisk,
      MonsterType.gorgon,
      TableReference.anyTableIII,
      MonsterType.blueDragon,
    ],
    // Coluna 3: Avançado (6º Nível ou Maior)
    [
      TableReference.animalsTable,
      MonsterType.troll,
      MonsterType.gorgon,
      TableReference.anyTableIII,
      TableReference.humansTable,
      MonsterType.treant,
      TableReference.extraplanarTableIII,
      MonsterType.chimera,
      MonsterType.bulette,
      MonsterType.sphinx,
      MonsterType.cyclops,
      MonsterType.oldBlueDragon,
    ],
  ];

  /// Obtém o resultado para iniciantes (1º a 2º Nível)
  dynamic getBeginners(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para heroicos (3º a 5º Nível)
  dynamic getHeroic(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado para avançado (6º Nível ou Maior)
  dynamic getAdvanced(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado baseado no nível do grupo
  dynamic getByPartyLevel(PartyLevel partyLevel, int roll) {
    switch (partyLevel) {
      case PartyLevel.beginners:
        return getBeginners(roll);
      case PartyLevel.heroic:
        return getHeroic(roll);
      case PartyLevel.advanced:
        return getAdvanced(roll);
    }
  }
}
