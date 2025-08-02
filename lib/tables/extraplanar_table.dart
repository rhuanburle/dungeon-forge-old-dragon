// tables/extraplanar_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela A13.10 - Encontros Extraplanares
///
/// Esta tabela gera encontros extraplanares,
/// organizados por nível de dificuldade do grupo de aventureiros.
class ExtraplanarTable extends MonsterTable<dynamic> {
  @override
  String get tableName => 'Tabela A13.10 - Encontros Extraplanares';

  @override
  String get description => 'Tabela de encontros extraplanares';

  @override
  int get columnCount => 3;

  @override
  DifficultyLevel get difficultyLevel => DifficultyLevel.custom8; // 1D8 conforme especificação

  @override
  TerrainType get terrainType => TerrainType.subterranean; // Não aplicável para esta tabela

  @override
  List<List<dynamic>> get columns => [
    // Coluna 1: Extraplanar I (Iniciantes)
    [
      MonsterType.imp,
      MonsterType.traag,
      MonsterType.waterElementalLesser,
      MonsterType.earthElementalLesser,
      MonsterType.airElementalLesser,
      MonsterType.fireElementalLesser,
      MonsterType.doppelganger,
      MonsterType.slenderMan,
    ],
    // Coluna 2: Extraplanar II (Heroicos)
    [
      MonsterType.slenderMan,
      MonsterType.flyingPolyp,
      MonsterType.waterElemental,
      MonsterType.earthElemental,
      MonsterType.airElemental,
      MonsterType.fireElemental,
      MonsterType.genie,
      MonsterType.invisibleHunter,
    ],
    // Coluna 3: Extraplanar III (Avançado)
    [
      MonsterType.invisibleHunter,
      MonsterType.efreeti,
      MonsterType.waterElementalGreater,
      MonsterType.earthElementalGreater,
      MonsterType.airElementalGreater,
      MonsterType.fireElementalGreater,
      MonsterType.shoggoth,
      MonsterType.cerberus,
    ],
  ];

  /// Obtém o resultado para Extraplanar I (Iniciantes)
  dynamic getExtraplanarI(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado para Extraplanar II (Heroicos)
  dynamic getExtraplanarII(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado para Extraplanar III (Avançado)
  dynamic getExtraplanarIII(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado baseado no nível do grupo
  dynamic getByPartyLevel(PartyLevel partyLevel, int roll) {
    switch (partyLevel) {
      case PartyLevel.beginners:
        return getExtraplanarI(roll);
      case PartyLevel.heroic:
        return getExtraplanarII(roll);
      case PartyLevel.advanced:
        return getExtraplanarIII(roll);
    }
  }
}
