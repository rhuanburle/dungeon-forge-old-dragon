// tables/mountains_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.4 - Encontros em Montanhas
///
/// Esta tabela gera encontros para montanhas e picos elevados,
/// organizados por nível de dificuldade do grupo de aventureiros.
class MountainsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.4 - Encontros em Montanhas';

  @override
  String get description =>
      'Tabela de encontros para montanhas e picos elevados';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.mountains;

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Iniciantes (1º a 2º Nível)
        [
          TableReference.animalsTable,
          MonsterType.kobold,
          MonsterType.goblin,
          TableReference.anyTableI,
          TableReference.humansTable,
          MonsterType.troglodyte,
          TableReference.extraplanarTableI,
          MonsterType.thoul,
          MonsterType.bugbear,
          MonsterType.giantEagle,
          TableReference.anyTableII,
          MonsterType.youngRedDragon,
        ],
        // Coluna 2: Heroicos (3º a 4º Nível)
        [
          TableReference.animalsTable,
          MonsterType.ogre,
          MonsterType.fireGiant,
          TableReference.anyTableII,
          TableReference.humansTable,
          MonsterType.griffon,
          TableReference.extraplanarTableII,
          MonsterType.troll,
          MonsterType.manticore,
          MonsterType.wyvern,
          TableReference.anyTableIII,
          MonsterType.redDragon,
        ],
        // Coluna 3: Avançado (6º Nível ou Maior)
        [
          TableReference.animalsTable,
          MonsterType.harpy,
          MonsterType.chimera,
          TableReference.anyTableIII,
          TableReference.humansTable,
          MonsterType.deathKnight,
          TableReference.extraplanarTableIII,
          MonsterType.ettin,
          MonsterType.boneDragon,
          MonsterType.iceGiant,
          MonsterType.fireGiant2,
          MonsterType.oldRedDragon,
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
