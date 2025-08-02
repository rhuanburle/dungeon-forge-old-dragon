// tables/occupant_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)
///
/// Esta tabela é usada para gerar ocupantes da masmorra,
/// incluindo ocupante I, ocupante II e líder.
class OccupantTable extends TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)';

  @override
  String get description => 'Tabela para gerar ocupantes da masmorra';

  @override
  int get columnCount => 3;

  @override
  List<List<dynamic>> get columns => [
        _column10, // DungeonOccupant (Ocupante I)
        _column11, // DungeonOccupant (Ocupante II)
        _column12, // DungeonOccupant (Líder)
      ];

  // Coluna 10: Ocupante I
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

  // Coluna 11: Ocupante II
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

  // Coluna 12: Líder
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

  // Métodos específicos com tipos corretos
  @override
  DungeonOccupant getColumn1(int roll) =>
      super.getColumn1(roll) as DungeonOccupant;

  @override
  DungeonOccupant getColumn2(int roll) =>
      super.getColumn2(roll) as DungeonOccupant;

  @override
  DungeonOccupant getColumn3(int roll) =>
      super.getColumn3(roll) as DungeonOccupant;
}
