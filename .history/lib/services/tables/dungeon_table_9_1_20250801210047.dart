// services/tables/dungeon_table_9_1.dart

import '../../enums/dungeon_tables.dart';

/// Representa a Tabela 9.1 - Gerando Masmorras
class DungeonTable9_1 {
  static const List<DungeonType> _column1 = [
    DungeonType.lostConstruction,
    DungeonType.lostConstruction,
    DungeonType.artificialLabyrinth,
    DungeonType.artificialLabyrinth,
    DungeonType.naturalCaves,
    DungeonType.naturalCaves,
    DungeonType.abandonedLair,
    DungeonType.abandonedLair,
    DungeonType.abandonedFortress,
    DungeonType.abandonedFortress,
    DungeonType.deactivatedMine,
    DungeonType.deactivatedMine,
  ];

  static const List<DungeonBuilder> _column2 = [
    DungeonBuilder.unknown,
    DungeonBuilder.unknown,
    DungeonBuilder.cultists,
    DungeonBuilder.cultists,
    DungeonBuilder.ancestralCivilization,
    DungeonBuilder.ancestralCivilization,
    DungeonBuilder.dwarves,
    DungeonBuilder.dwarves,
    DungeonBuilder.mages,
    DungeonBuilder.mages,
    DungeonBuilder.giants,
    DungeonBuilder.giants,
  ];

  static const List<DungeonStatus> _column3 = [
    DungeonStatus.cursed,
    DungeonStatus.cursed,
    DungeonStatus.extinct,
    DungeonStatus.extinct,
    DungeonStatus.ancestral,
    DungeonStatus.ancestral,
    DungeonStatus.disappeared,
    DungeonStatus.disappeared,
    DungeonStatus.lost,
    DungeonStatus.lost,
    DungeonStatus.inAnotherLocation,
    DungeonStatus.inAnotherLocation,
  ];

  static const List<DungeonObjective> _column4 = [
    DungeonObjective.defend,
    DungeonObjective.defend,
    DungeonObjective.hide,
    DungeonObjective.hide,
    DungeonObjective.protect,
    DungeonObjective.protect,
    DungeonObjective.guard,
    DungeonObjective.guard,
    DungeonObjective.watch,
    DungeonObjective.watch,
    DungeonObjective.isolate,
    DungeonObjective.isolate,
  ];

  static const List<DungeonTarget> _column5 = [
    DungeonTarget.artifact,
    DungeonTarget.artifact,
    DungeonTarget.book,
    DungeonTarget.book,
    DungeonTarget.sword,
    DungeonTarget.sword,
    DungeonTarget.gem,
    DungeonTarget.gem,
    DungeonTarget.helmet,
    DungeonTarget.helmet,
    DungeonTarget.treasure,
    DungeonTarget.treasure,
  ];

  static const List<DungeonTargetStatus> _column6 = [
    DungeonTargetStatus.beingSought,
    DungeonTargetStatus.beingSought,
    DungeonTargetStatus.destroyed,
    DungeonTargetStatus.destroyed,
    DungeonTargetStatus.disappeared,
    DungeonTargetStatus.disappeared,
    DungeonTargetStatus.stolen,
    DungeonTargetStatus.stolen,
    DungeonTargetStatus.intact,
    DungeonTargetStatus.intact,
    DungeonTargetStatus.buried,
    DungeonTargetStatus.buried,
  ];

  static const List<DungeonLocation> _column7 = [
    DungeonLocation.scorchingDesert,
    DungeonLocation.scorchingDesert,
    DungeonLocation.underCity,
    DungeonLocation.underCity,
    DungeonLocation.frozenMountain,
    DungeonLocation.frozenMountain,
    DungeonLocation.wildForest,
    DungeonLocation.wildForest,
    DungeonLocation.fetidSwamp,
    DungeonLocation.fetidSwamp,
    DungeonLocation.isolatedIsland,
    DungeonLocation.isolatedIsland,
  ];

  static const List<DungeonEntry> _column8 = [
    DungeonEntry.behindWaterfall,
    DungeonEntry.behindWaterfall,
    DungeonEntry.secretTunnel,
    DungeonEntry.secretTunnel,
    DungeonEntry.smallCave,
    DungeonEntry.smallCave,
    DungeonEntry.rockFissure,
    DungeonEntry.rockFissure,
    DungeonEntry.monsterLair,
    DungeonEntry.monsterLair,
    DungeonEntry.volcanoMouth,
    DungeonEntry.volcanoMouth,
  ];

  static const List<String> _column9 = [
    'Grande – 3d6+4',
    'Grande – 3d6+4',
    'Média – 2d6+4',
    'Média – 2d6+4',
    'Pequena – 1d6+4',
    'Pequena – 1d6+4',
    'Pequena – 1d6+6',
    'Pequena – 1d6+6',
    'Média – 2d6+6',
    'Média – 2d6+6',
    'Grande – 3d6+6',
    'Grande – 3d6+6',
  ];



  /// Obtém o resultado da coluna 1 baseado no roll
  static DungeonType getColumn1(int roll) => _column1[roll - 2];

  /// Obtém o resultado da coluna 2 baseado no roll
  static DungeonBuilder getColumn2(int roll) => _column2[roll - 2];

  /// Obtém o resultado da coluna 3 baseado no roll
  static DungeonStatus getColumn3(int roll) => _column3[roll - 2];

  /// Obtém o resultado da coluna 4 baseado no roll
  static DungeonObjective getColumn4(int roll) => _column4[roll - 2];

  /// Obtém o resultado da coluna 5 baseado no roll
  static DungeonTarget getColumn5(int roll) => _column5[roll - 2];

  /// Obtém o resultado da coluna 6 baseado no roll
  static DungeonTargetStatus getColumn6(int roll) => _column6[roll - 2];

  /// Obtém o resultado da coluna 7 baseado no roll
  static DungeonLocation getColumn7(int roll) => _column7[roll - 2];

  /// Obtém o resultado da coluna 8 baseado no roll
  static DungeonEntry getColumn8(int roll) => _column8[roll - 2];

  /// Obtém o resultado da coluna 9 baseado no roll
  static String getColumn9(int roll) => _column9[roll - 2];

  /// Obtém o resultado da coluna 10 baseado no roll
  static DungeonOccupant getColumn10(int roll) => _column10[roll - 2];

  /// Obtém o resultado da coluna 11 baseado no roll
  static DungeonOccupant getColumn11(int roll) => _column11[roll - 2];

  /// Obtém o resultado da coluna 12 baseado no roll
  static DungeonOccupant getColumn12(int roll) => _column12[roll - 2];

  /// Obtém o resultado da coluna 13 baseado no roll
  static RumorSubject getColumn13(int roll) => _column13[roll - 2];

  /// Obtém o resultado da coluna 14 baseado no roll
  static RumorAction getColumn14(int roll) => _column14[roll - 2];

  /// Obtém o resultado da coluna 15 baseado no roll
  static RumorLocation getColumn15(int roll) => _column15[roll - 2];
}
