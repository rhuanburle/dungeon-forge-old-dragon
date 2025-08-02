// tables/subterranean_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.1 - Encontros no Subterrâneo
/// 
/// Esta tabela gera encontros para masmorras e cavernas,
/// organizados por nível de dificuldade do grupo de aventureiros.
class SubterraneanEncounterTable extends MonsterTable<dynamic> implements TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Tabela A13.1 - Encontros no Subterrâneo';

  @override
  String get description => 'Tabela de encontros para masmorras e cavernas';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.subterranean;

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Iniciantes (1º a 2º Nível)
    [
      TableReference.animalsTable,
      MonsterType.giantRat,
      MonsterType.kobold,
      TableReference.anyTableI,
      TableReference.humansTable,
      MonsterType.pygmyFungus,
      TableReference.extraplanarTableI,
      MonsterType.violetFungus,
      MonsterType.drowElf,
      MonsterType.bugbear,
      MonsterType.otyugh,
      MonsterType.youngBoneDragon,
    ],
    // Coluna 2: Heroicos (3º a 5º Nível)
    [
      TableReference.animalsTable,
      MonsterType.troglodyte,
      MonsterType.thoul,
      TableReference.anyTableII,
      TableReference.humansTable,
      MonsterType.derro,
      TableReference.extraplanarTableII,
      MonsterType.grayOoze,
      MonsterType.carrionWorm,
      MonsterType.gelatinousCube,
      TableReference.anyTableIII,
      MonsterType.boneDragon,
    ],
    // Coluna 3: Avançado (6º Nível ou Maior)
    [
      TableReference.animalsTable,
      MonsterType.shriekerFungus,
      MonsterType.ochreJelly,
      MonsterType.rustMonster,
      TableReference.humansTable,
      MonsterType.maceTail,
      TableReference.extraplanarTableIII,
      MonsterType.drider,
      MonsterType.brainDevourer,
      MonsterType.roper,
      MonsterType.beholder,
      MonsterType.oldBoneDragon,
    ],
  ];

  /// Obtém o resultado para iniciantes (1º a 2º Nível)
  dynamic getBeginners(int roll) => getColumn1(roll);

  /// Obtém o resultado para heroicos (3º a 5º Nível)
  dynamic getHeroic(int roll) => getColumn2(roll);

  /// Obtém o resultado para avançado (6º Nível ou Maior)
  dynamic getAdvanced(int roll) => getColumn3(roll);

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