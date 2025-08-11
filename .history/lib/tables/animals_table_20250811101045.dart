// tables/animals_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.2 - Animais
///
/// Esta tabela gera encontros com animais baseados no terreno,
/// organizados por tipo de terreno.
class AnimalsTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.2 - Animais';

  @override
  String get description => 'Tabela de animais por terreno';

  @override
  int get columnCount => 4;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.easy;

  @override
  TerrainType get terrainType => TerrainType.subterranean; // Não aplicável para esta tabela

  @override
  List<List<dynamic>> get columns => [
        // Coluna 1: Subterrâneo
        [
          MonsterType.bat,
          MonsterType.spiderHunterGiant,
          MonsterType.rat,
          MonsterType.centipedeGiant,
          MonsterType.fireBeetleGiant,
          MonsterType.vampireBat,
        ],
        // Coluna 2: Planície
        [
          MonsterType.buffalo,
          MonsterType.elephant,
          MonsterType.lion,
          MonsterType.rhinoceros,
          MonsterType.boar,
          MonsterType.eagle,
        ],
        // Coluna 3: Colina
        [
          MonsterType.boar,
          MonsterType.fox,
          MonsterType.puma,
          MonsterType.bear,
          MonsterType.wolf,
          MonsterType.antGiant,
        ],
        // Coluna 4: Montanha
        [
          MonsterType.eagle,
          MonsterType.cobraVenomous,
          MonsterType.puma,
          MonsterType.bearBlack,
          MonsterType.antGiant,
          MonsterType.antGiant,
        ],
      ];

  /// Obtém o resultado para subterrâneo
  dynamic getSubterranean(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para planície
  dynamic getPlains(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado para colina
  dynamic getHills(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado para montanha
  dynamic getMountains(int roll) => getColumnValue(4, roll);

  /// Obtém o resultado baseado no terreno
  dynamic getByTerrain(TerrainType terrain, int roll) {
    switch (terrain) {
      case TerrainType.subterranean:
        return getSubterranean(roll);
      case TerrainType.plains:
        return getPlains(roll);
      case TerrainType.hills:
        return getHills(roll);
      case TerrainType.mountains:
        return getMountains(roll);
      case TerrainType.swamps:
        return getSwamps(roll);
      case TerrainType.glaciers:
        return getGlaciers(roll);
      case TerrainType.deserts:
        return getDeserts(roll);
      case TerrainType.forests:
        return getForests(roll);
      default:
        return getSubterranean(roll);
    }
  }

  /// Obtém o resultado para pântanos
  dynamic getSwamps(int roll) {
    final animals = [
      MonsterType.buffalo,
      MonsterType.cobraConstrictor,
      MonsterType.crocodile,
      MonsterType.antGiant,
      MonsterType.flyGiant,
      MonsterType.blackSpiderGiant,
    ];
    return animals[roll - 1];
  }

  /// Obtém o resultado para geleiras
  dynamic getGlaciers(int roll) {
    final animals = [
      MonsterType.carcaju,
      MonsterType.mammoth,
      MonsterType.bearPolar,
      MonsterType.carcaju,
      MonsterType.mammoth,
      MonsterType.bearPolar,
    ];
    return animals[roll - 1];
  }

  /// Obtém o resultado para desertos
  dynamic getDeserts(int roll) {
    final animals = [
      MonsterType.camel,
      MonsterType.cobraSpitter,
      MonsterType.puma,
      MonsterType.cobraVenomous,
      MonsterType.camouflagedSpiderGiant,
      MonsterType.scorpionGiant,
    ];
    return animals[roll - 1];
  }

  /// Obtém o resultado para florestas
  dynamic getForests(int roll) {
    final animals = [
      MonsterType.eagle,
      MonsterType.carcaju,
      MonsterType.wolf,
      MonsterType.boar,
      MonsterType.bear,
      MonsterType.blackSpiderGiant,
    ];
    return animals[roll - 1];
  }
} 