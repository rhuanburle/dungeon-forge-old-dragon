// tables/swamps_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.5 - Encontros em Pântanos
///
/// Esta tabela gera encontros para pântanos e áreas úmidas,
/// organizados por nível de dificuldade do grupo de aventureiros.
class SwampsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.5 - Encontros em Pântanos';

  @override
  String get description => 'Tabela de encontros para pântanos e áreas úmidas';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.swamps;

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Iniciantes (1º a 2º Nível)
        [
          TableReference.animalsTable,
          MonsterType.pygmyFungus,
          MonsterType.stirge,
          TableReference.anyTableI,
          TableReference.humansTable,
          MonsterType.lizardMan,
          TableReference.extraplanarTableI,
          MonsterType.violetFungus,
          MonsterType.sibilant,
          MonsterType.hydra,
          TableReference.anyTableII,
          MonsterType.youngBlackDragon,
        ],
        // Coluna 2: Heroicos (3º a 4º Nível)
        [
          TableReference.animalsTable,
          MonsterType.sibilant,
          MonsterType.medusa,
          TableReference.anyTableII,
          TableReference.humansTable,
          MonsterType.lizardGiant,
          TableReference.extraplanarTableII,
          MonsterType.troll,
          MonsterType.giantViper,
          MonsterType.hydra,
          TableReference.anyTableIII,
          MonsterType.blackDragon,
        ],
        // Coluna 3: Avançado (6º Nível ou Maior)
        [
          TableReference.animalsTable,
          MonsterType.giantViper,
          MonsterType.troll,
          TableReference.anyTableIII,
          TableReference.humansTable,
          MonsterType.fleshGolem,
          TableReference.extraplanarTableIII,
          MonsterType.witch,
          MonsterType.blackNaga,
          MonsterType.hydra,
          MonsterType.willOWisp,
          MonsterType.oldBlackDragon,
        ],
      ];

  /// Obtém o resultado para iniciantes (1º a 2º Nível)
  dynamic getBeginners(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para heroicos (3º a 4º Nível)
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