// tables/hills_encounter_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.3 - Encontros em Colinas
///
/// Esta tabela gera encontros para colinas e terrenos elevados,
/// organizados por nível de dificuldade do grupo de aventureiros.
class HillsEncounterTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.3 - Encontros em Colinas';

  @override
  String get description =>
      'Tabela de encontros para colinas e terrenos elevados';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.hills;

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Iniciantes (1º a 2º Nível)
        [
          TableReference.animalsTable,
          MonsterType.kobold,
          MonsterType.drakold,
          TableReference.anyTableI,
          TableReference.humansTable,
          MonsterType.hobgoblin,
          TableReference.extraplanarTableI,
          MonsterType.bugbear,
          MonsterType.hellhound,
          MonsterType.ogre,
          TableReference.anyTableII,
          MonsterType.youngGoldenDragon,
        ],
        // Coluna 2: Heroicos (3º a 4º Nível)
        [
          TableReference.animalsTable,
          MonsterType.werewolf,
          MonsterType.oniMage,
          TableReference.anyTableII,
          TableReference.humansTable,
          MonsterType.cockatrice,
          TableReference.extraplanarTableII,
          MonsterType.basilisk,
          MonsterType.griffon,
          MonsterType.troll,
          TableReference.anyTableIII,
          MonsterType.goldenDragon,
        ],
        // Coluna 3: Avançado (6º Nível ou Maior)
        [
          TableReference.animalsTable,
          MonsterType.boneGolem,
          MonsterType.deathKnight,
          TableReference.anyTableIII,
          TableReference.humansTable,
          MonsterType.gorgon,
          TableReference.extraplanarTableIII,
          MonsterType.treant,
          MonsterType.bulette,
          MonsterType.ettin,
          MonsterType.hillGiant,
          MonsterType.oldGoldenDragon,
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
