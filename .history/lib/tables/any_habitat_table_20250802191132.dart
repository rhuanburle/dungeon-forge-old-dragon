// tables/any_habitat_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.9 - Encontros em Qualquer Habitat
///
/// Esta tabela gera encontros para qualquer habitat,
/// organizados por nível de dificuldade do grupo de aventureiros.
class AnyHabitatTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.9 - Encontros em Qualquer Habitat';

  @override
  String get description => 'Tabela de encontros para qualquer habitat';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.challenging;

  @override
  TerrainType get terrainType => TerrainType.subterranean; // Não aplicável para esta tabela

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Qualquer I (Iniciantes)
        [
          MonsterType.drakold,
          MonsterType.goblin,
          MonsterType.orc,
          MonsterType.hobgoblin,
          TableReference.humansTable,
          MonsterType.zombie,
          MonsterType.ghoul,
          MonsterType.inhumano,
          MonsterType.shadow,
          MonsterType.homunculus,
          MonsterType.woodGolem,
          MonsterType.youngShadowDragon,
        ],
        // Coluna 2: Qualquer II (Heroicos)
        [
          MonsterType.wereRat,
          MonsterType.ogre,
          MonsterType.gargoyle,
          MonsterType.wereBoar,
          TableReference.humansTable,
          MonsterType.medusa2,
          MonsterType.wereCat,
          MonsterType.apparition,
          MonsterType.specter,
          MonsterType.troll,
          MonsterType.banshee,
          MonsterType.shadowDragon,
        ],
        // Coluna 3: Qualquer III (Avançado)
        [
          MonsterType.witch,
          MonsterType.deathKnight2,
          MonsterType.boneGolem,
          MonsterType.fleshGolem2,
          TableReference.humansTable,
          MonsterType.ghost,
          MonsterType.stoneGolem2,
          MonsterType.stormGiant,
          MonsterType.ironGolem,
          MonsterType.lich,
          MonsterType.annihilationSphere,
          MonsterType.oldShadowDragon,
        ],
      ];

  /// Obtém o resultado para Qualquer I (Iniciantes)
  dynamic getAnyI(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para Qualquer II (Heroicos)
  dynamic getAnyII(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado para Qualquer III (Avançado)
  dynamic getAnyIII(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado baseado no nível do grupo
  dynamic getByPartyLevel(PartyLevel partyLevel, int roll) {
    switch (partyLevel) {
      case PartyLevel.beginners:
        return getAnyI(roll);
      case PartyLevel.heroic:
        return getAnyII(roll);
      case PartyLevel.advanced:
        return getAnyIII(roll);
    }
  }
} 