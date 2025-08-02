// tables/forests_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.8 - Encontros em Florestas
///
/// Esta tabela gera encontros para florestas,
/// organizados por nível de dificuldade do grupo de aventureiros.
class ForestsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.8 - Encontros em Florestas';

  @override
  String get description => 'Tabela de encontros para florestas';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.forests;

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Iniciantes (1º a 2º Nível)
    [
      TableReference.animalsTable,
      MonsterType.pygmyFungus,
      MonsterType.stirge,
      TableReference.anyTableI,
      TableReference.humansTable,
      MonsterType.violetFungus,
      TableReference.extraplanarTableI,
      MonsterType.thoul,
      MonsterType.worg,
      MonsterType.blackSpiderGiant,
      TableReference.anyTableII,
      MonsterType.youngGreenDragon,
    ],
    // Coluna 2: Heroicos (3º a 5º Nível)
    [
      TableReference.animalsTable,
      MonsterType.hunterSpiderGiant,
      MonsterType.antGiantForest,
      TableReference.anyTableII,
      TableReference.humansTable,
      MonsterType.owlbear,
      TableReference.extraplanarTableII,
      MonsterType.basilisk,
      MonsterType.deadlyVine,
      MonsterType.wyvern,
      TableReference.anyTableIII,
      MonsterType.greenDragon,
    ],
    // Coluna 3: Avançado (6º Nível ou Maior)
    [
      TableReference.animalsTable,
      MonsterType.blackSpiderGiant,
      MonsterType.harpy,
      TableReference.anyTableIII,
      TableReference.humansTable,
      MonsterType.witch,
      TableReference.extraplanarTableIII,
      MonsterType.cursedTree,
      MonsterType.owlbear,
      MonsterType.treant,
      MonsterType.werebear,
      MonsterType.oldGreenDragon,
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
