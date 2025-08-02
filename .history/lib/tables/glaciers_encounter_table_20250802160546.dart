// tables/glaciers_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.6 - Encontros em Geleiras
///
/// Esta tabela gera encontros para geleiras e áreas geladas,
/// organizados por nível de dificuldade do grupo de aventureiros.
class GlaciersEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.6 - Encontros em Geleiras';

  @override
  String get description => 'Tabela de encontros para geleiras e áreas geladas';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.glaciers;

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Iniciantes (1º a 2º Nível)
    [
      TableReference.animalsTable,
      MonsterType.goblin,
      MonsterType.orc,
      TableReference.anyTableI,
      TableReference.humansTable,
      MonsterType.hobgoblin,
      TableReference.extraplanarTableI,
      MonsterType.goblin,
      MonsterType.hobgoblin,
      MonsterType.ogre,
      TableReference.anyTableII,
      MonsterType.youngWhiteDragon,
    ],
    // Coluna 2: Heroicos (3º a 5º Nível)
    [
      TableReference.animalsTable,
      MonsterType.ogre,
      MonsterType.troll,
      TableReference.anyTableII,
      TableReference.humansTable,
      MonsterType.troll,
      TableReference.extraplanarTableII,
      TableReference.anyTableII,
      MonsterType.werebear,
      MonsterType.iceGolem,
      TableReference.anyTableIII,
      MonsterType.whiteDragon,
    ],
    // Coluna 3: Avançado (6º Nível ou Maior)
    [
      TableReference.animalsTable,
      MonsterType.troll,
      MonsterType.deathKnight,
      TableReference.anyTableIII,
      TableReference.humansTable,
      MonsterType.werebear,
      TableReference.extraplanarTableIII,
      TableReference.anyTableIII,
      MonsterType.iceGolem,
      MonsterType.iceGiant,
      MonsterType.remorhaz,
      MonsterType.oldWhiteDragon,
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
