// tables/deserts_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.7 - Encontros em Desertos
///
/// Esta tabela gera encontros para desertos e áreas áridas,
/// organizados por nível de dificuldade do grupo de aventureiros.
class DesertsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.7 - Encontros em Desertos';

  @override
  String get description => 'Tabela de encontros para desertos e áreas áridas';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.deserts;

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Iniciantes (1º a 2º Nível)
        [
          TableReference.animalsTable,
          MonsterType.drakold,
          MonsterType.sibilant,
          TableReference.anyTableI,
          TableReference.humansTable,
          MonsterType.camouflagedSpiderGiant,
          TableReference.extraplanarTableI,
          MonsterType.medusa,
          MonsterType.ogre,
          MonsterType.mummy,
          TableReference.anyTableII,
          MonsterType.youngBlueDragon,
        ],
        // Coluna 2: Heroicos (3º a 4º Nível)
        [
          TableReference.animalsTable,
          MonsterType.sibilant,
          MonsterType.mummy,
          TableReference.anyTableII,
          TableReference.humansTable,
          MonsterType.lizardGiant,
          TableReference.extraplanarTableII,
          MonsterType.basilisk,
          MonsterType.scarletWorm,
          MonsterType.mummy,
          TableReference.anyTableIII,
          MonsterType.blueDragon,
        ],
        // Coluna 3: Avançado (6º Nível ou Maior)
        [
          TableReference.animalsTable,
          MonsterType.scorpionGiantDesert,
          MonsterType.orc,
          TableReference.anyTableIII,
          TableReference.humansTable,
          MonsterType.scarletWorm,
          TableReference.extraplanarTableIII,
          MonsterType.mummy,
          MonsterType.bulette,
          MonsterType.sphinx,
          MonsterType.stoneGolem,
          MonsterType.oldBlueDragon,
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
