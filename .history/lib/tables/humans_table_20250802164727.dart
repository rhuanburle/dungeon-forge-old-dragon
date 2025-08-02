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
  DifficultyLevel get difficultyLevel => DifficultyLevel.easy; // 2D6 (implementado como 1D6 + ajuste)

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
  dynamic getSpecial(int roll) {
    // A coluna especial usa 1d6 (índices 1-6)
    if (roll < 1 || roll > 6) {
      throw ArgumentError('Roll deve estar entre 1 e 6 para coluna especial');
    }
    return getColumnValue(4, roll);
  }

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
    if (roll == 2 || roll == 12) { // 2d6: 2 e 12 são especiais
      // Mapear roll 2d6 para coluna especial (1-10)
      final specialRoll = roll == 2 ? 2 : 10; // 2->2, 12->10
      return getSpecial(specialRoll);
    }
    return getByPartyLevel(PartyLevel.beginners, roll);
  }

  @override
  int get minRoll => 2; // 2d6 = mínimo 2

  @override
  int get maxRoll => 12; // 2d6 = máximo 12
}
