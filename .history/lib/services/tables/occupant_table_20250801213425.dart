// services/tables/occupant_table.dart

import 'package:work/enums/table_enums.dart';


/// Representa a Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)
class OccupantTable {
  static const List<DungeonOccupant> _column10 = [
    DungeonOccupant.trolls,
    DungeonOccupant.trolls,
    DungeonOccupant.orcs,
    DungeonOccupant.orcs,
    DungeonOccupant.skeletons,
    DungeonOccupant.skeletons,
    DungeonOccupant.goblins,
    DungeonOccupant.goblins,
    DungeonOccupant.bugbears,
    DungeonOccupant.bugbears,
    DungeonOccupant.ogres,
    DungeonOccupant.ogres,
  ];

  static const List<DungeonOccupant> _column11 = [
    DungeonOccupant.kobolds,
    DungeonOccupant.kobolds,
    DungeonOccupant.grayOoze,
    DungeonOccupant.grayOoze,
    DungeonOccupant.zombies,
    DungeonOccupant.zombies,
    DungeonOccupant.giantRats,
    DungeonOccupant.giantRats,
    DungeonOccupant.pygmyFungi,
    DungeonOccupant.pygmyFungi,
    DungeonOccupant.lizardMen,
    DungeonOccupant.lizardMen,
  ];

  static const List<DungeonOccupant> _column12 = [
    DungeonOccupant.hobgoblin,
    DungeonOccupant.hobgoblin,
    DungeonOccupant.gelatinousCube,
    DungeonOccupant.gelatinousCube,
    DungeonOccupant.cultist,
    DungeonOccupant.cultist,
    DungeonOccupant.shadow,
    DungeonOccupant.shadow,
    DungeonOccupant.necromancer,
    DungeonOccupant.necromancer,
    DungeonOccupant.dragon,
    DungeonOccupant.dragon,
  ];

  /// Obtém o ocupante I baseado no roll (Coluna 10)
  static DungeonOccupant getColumn10(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column10[roll - 2];
  }

  /// Obtém o ocupante II baseado no roll (Coluna 11)
  static DungeonOccupant getColumn11(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column11[roll - 2];
  }

  /// Obtém o líder baseado no roll (Coluna 12)
  static DungeonOccupant getColumn12(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column12[roll - 2];
  }
}
