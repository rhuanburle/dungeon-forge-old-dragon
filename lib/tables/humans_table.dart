// tables/humans_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.11 - Humanos e Semi-Humanos
///
/// Esta tabela gera encontros com humanos e semi-humanos,
/// organizados por nível de dificuldade do grupo de aventureiros.
class HumansTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.11 - Humanos e Semi-Humanos';

  @override
  String get description => 'Tabela de humanos e semi-humanos por nível';

  @override
  int get columnCount => 4;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.easy; // 2D6 = 1D6 (simplificado)

  @override
  TerrainType get terrainType => TerrainType.subterranean; // Não aplicável para esta tabela

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Iniciantes (1º a 2º Nível)
    [
      MonsterType.caveMen, // Especial
      MonsterType.cultists,
      MonsterType.noviceAdventurers,
      MonsterType.mercenaries,
      MonsterType.patrols,
      MonsterType.commonMen,
      MonsterType.merchants,
      MonsterType.bandits,
      MonsterType.nobles,
      MonsterType.nomads,
      MonsterType.caveMen, // Especial
    ],
    // Coluna 2: Heroicos (3º a 5º Nível)
    [
      MonsterType.caveMen, // Especial
      MonsterType.cultists,
      MonsterType.noviceAdventurers,
      MonsterType.mercenaries,
      MonsterType.patrols,
      MonsterType.commonMen,
      MonsterType.merchants,
      MonsterType.bandits,
      MonsterType.nobles,
      MonsterType.nomads,
      MonsterType.caveMen, // Especial
    ],
    // Coluna 3: Avançado (6º Nível ou Maior)
    [
      MonsterType.caveMen, // Especial
      MonsterType.cultists,
      MonsterType.noviceAdventurers,
      MonsterType.mercenaries,
      MonsterType.patrols,
      MonsterType.commonMen,
      MonsterType.merchants,
      MonsterType.bandits,
      MonsterType.nobles,
      MonsterType.nomads,
      MonsterType.caveMen, // Especial
    ],
    // Coluna 4: Especial
    [
      MonsterType.caveMen,
      MonsterType.halflings,
      MonsterType.elves,
      MonsterType.fanatics,
      MonsterType.fanatics,
      MonsterType.berserkers,
      MonsterType.berserkers,
      MonsterType.dwarves,
      MonsterType.dwarves,
      MonsterType.gnomes,
    ],
  ];

  /// Obtém o resultado para iniciantes (1º a 2º Nível)
  dynamic getBeginners(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para heroicos (3º a 5º Nível)
  dynamic getHeroic(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado para avançado (6º Nível ou Maior)
  dynamic getAdvanced(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado especial
  dynamic getSpecial(int roll) => getColumnValue(4, roll);

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

  /// Obtém o resultado especial baseado no roll
  dynamic getSpecialResult(int roll) {
    if (roll == 2 || roll == 10) {
      return getSpecial(roll);
    }
    return getByPartyLevel(PartyLevel.beginners, roll);
  }
}
