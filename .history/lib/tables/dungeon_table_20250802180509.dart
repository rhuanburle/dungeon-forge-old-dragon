// tables/dungeon_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela 9.1 - Geração de Masmorras
///
/// Esta tabela é usada para gerar dados básicos de uma masmorra,
/// incluindo tipo, construtor, status, objetivo, alvo, localização, etc.
class DungeonTable extends TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Tabela 9.1 - Geração de Masmorras';

  @override
  String get description => 'Tabela para gerar dados básicos de masmorras';

  @override
  int get columnCount => 15;

  @override
  List<List<dynamic>> get columns => [
        _column1, // DungeonType
        _column2, // DungeonBuilder
        _column3, // DungeonStatus
        _column4, // DungeonObjective
        _column5, // DungeonTarget
        _column6, // DungeonTargetStatus
        _column7, // DungeonLocation
        _column8, // DungeonEntry
        _column9, // String (fórmula de tamanho)
        _column10, // DungeonOccupant
        _column11, // DungeonOccupant
        _column12, // DungeonOccupant
        _column13, // RumorSubject
        _column14, // RumorAction
        _column15, // RumorLocation
      ];

  // Coluna 1: Tipo de Masmorra (2d6)
  // Roll 2-3: Construção Perdida
  // Roll 4-5: Labirinto Artificial
  // Roll 6-7: Cavernas Naturais
  // Roll 8-9: Covil Desabitado
  // Roll 10-11: Fortaleza Abandonada
  // Roll 12: Mina Desativada
  static const List<DungeonType> _column1 = [
    DungeonType.lostConstruction,      // Roll 2
    DungeonType.lostConstruction,      // Roll 3
    DungeonType.artificialLabyrinth,   // Roll 4
    DungeonType.artificialLabyrinth,   // Roll 5
    DungeonType.naturalCaves,          // Roll 6
    DungeonType.naturalCaves,          // Roll 7
    DungeonType.abandonedLair,         // Roll 8
    DungeonType.abandonedLair,         // Roll 9
    DungeonType.abandonedFortress,     // Roll 10
    DungeonType.abandonedFortress,     // Roll 11
    DungeonType.deactivatedMine,       // Roll 12
  ];

  // Coluna 2: Construtor/Habitante (2d6)
  // Roll 2-3: Desconhecido
  // Roll 4-5: Cultistas
  // Roll 6-7: Civilização Ancestral
  // Roll 8-9: Anões
  // Roll 10-11: Magos
  // Roll 12: Gigantes
  static const List<DungeonBuilder> _column2 = [
    DungeonBuilder.unknown,             // Roll 2
    DungeonBuilder.unknown,             // Roll 3
    DungeonBuilder.cultists,            // Roll 4
    DungeonBuilder.cultists,            // Roll 5
    DungeonBuilder.ancestralCivilization, // Roll 6
    DungeonBuilder.ancestralCivilization, // Roll 7
    DungeonBuilder.dwarves,             // Roll 8
    DungeonBuilder.dwarves,             // Roll 9
    DungeonBuilder.mages,               // Roll 10
    DungeonBuilder.mages,               // Roll 11
    DungeonBuilder.giants,              // Roll 12
  ];

  // Coluna 3: Status da Masmorra (2d6)
  // Roll 2-3: Amaldiçoados
  // Roll 4-5: Extintos
  // Roll 6-7: Ancestrais
  // Roll 8-9: Desaparecidos
  // Roll 10-11: Perdidos
  // Roll 12: em outro local
  static const List<DungeonStatus> _column3 = [
    DungeonStatus.cursed,               // Roll 2
    DungeonStatus.cursed,               // Roll 3
    DungeonStatus.extinct,              // Roll 4
    DungeonStatus.extinct,              // Roll 5
    DungeonStatus.ancestral,            // Roll 6
    DungeonStatus.ancestral,            // Roll 7
    DungeonStatus.disappeared,          // Roll 8
    DungeonStatus.disappeared,          // Roll 9
    DungeonStatus.lost,                 // Roll 10
    DungeonStatus.lost,                 // Roll 11
    DungeonStatus.inAnotherLocation,    // Roll 12
  ];

  // Coluna 4: Objetivo da Construção
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

  // Coluna 5: Alvo Protegido
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

  // Coluna 6: Status do Alvo
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

  // Coluna 7: Localização
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

  // Coluna 8: Entrada da Masmorra
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

  // Coluna 9: Fórmula de Tamanho (2d6)
  // Roll 2-3: Grande - 3d6+4
  // Roll 4-5: Média - 2d6+4
  // Roll 6-7: Pequena - 1d6+4
  // Roll 8-9: Pequena - 1d6+6
  // Roll 10-11: Média - 2d6+6
  // Roll 12: Grande - 3d6+6
  static const List<String> _column9 = [
    '3d6 + 4 salas',  // Roll 2 - Grande
    '3d6 + 4 salas',  // Roll 3 - Grande
    '2d6 + 4 salas',  // Roll 4 - Média
    '2d6 + 4 salas',  // Roll 5 - Média
    '1d6 + 4 salas',  // Roll 6 - Pequena
    '1d6 + 4 salas',  // Roll 7 - Pequena
    '1d6 + 6 salas',  // Roll 8 - Pequena
    '1d6 + 6 salas',  // Roll 9 - Pequena
    '2d6 + 6 salas',  // Roll 10 - Média
    '2d6 + 6 salas',  // Roll 11 - Média
    '3d6 + 6 salas',  // Roll 12 - Grande
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

  // Coluna 13: Sujeito do Rumor
  static const List<RumorSubject> _column13 = [
    RumorSubject.decapitatedOccupant,
    RumorSubject.decapitatedOccupant,
    RumorSubject.drunkPeasant,
    RumorSubject.drunkPeasant,
    RumorSubject.primaryOccupant,
    RumorSubject.primaryOccupant,
    RumorSubject.richForeigner,
    RumorSubject.richForeigner,
    RumorSubject.blindMystic,
    RumorSubject.blindMystic,
    RumorSubject.leader,
    RumorSubject.leader,
  ];

  // Coluna 14: Ação do Rumor
  static const List<RumorAction> _column14 = [
    RumorAction.seenNear,
    RumorAction.seenNear,
    RumorAction.capturedIn,
    RumorAction.capturedIn,
    RumorAction.leftTrailsIn,
    RumorAction.leftTrailsIn,
    RumorAction.soughtPriestIn,
    RumorAction.soughtPriestIn,
    RumorAction.killedByWerewolfIn,
    RumorAction.killedByWerewolfIn,
    RumorAction.cursed,
    RumorAction.cursed,
  ];

  // Coluna 15: Localização do Rumor
  static const List<RumorLocation> _column15 = [
    RumorLocation.autumnReligiousFestival,
    RumorLocation.autumnReligiousFestival,
    RumorLocation.villageLastYearDuringEclipse,
    RumorLocation.villageLastYearDuringEclipse,
    RumorLocation.farmWhenSheepDisappeared,
    RumorLocation.farmWhenSheepDisappeared,
    RumorLocation.nearbyVillage,
    RumorLocation.nearbyVillage,
    RumorLocation.springTradeCaravan,
    RumorLocation.springTradeCaravan,
    RumorLocation.winterBlizzard3YearsAgo,
    RumorLocation.winterBlizzard3YearsAgo,
  ];

  // Métodos específicos com tipos corretos
  @override
  DungeonType getColumn1(int roll) => super.getColumn1(roll) as DungeonType;

  @override
  DungeonBuilder getColumn2(int roll) =>
      super.getColumn2(roll) as DungeonBuilder;

  @override
  DungeonStatus getColumn3(int roll) => super.getColumn3(roll) as DungeonStatus;

  @override
  DungeonObjective getColumn4(int roll) =>
      super.getColumn4(roll) as DungeonObjective;

  @override
  DungeonTarget getColumn5(int roll) => super.getColumn5(roll) as DungeonTarget;

  @override
  DungeonTargetStatus getColumn6(int roll) =>
      super.getColumn6(roll) as DungeonTargetStatus;

  @override
  DungeonLocation getColumn7(int roll) =>
      super.getColumn7(roll) as DungeonLocation;

  @override
  DungeonEntry getColumn8(int roll) => super.getColumn8(roll) as DungeonEntry;

  @override
  String getColumn9(int roll) => super.getColumn9(roll) as String;

  @override
  DungeonOccupant getColumn10(int roll) =>
      super.getColumn10(roll) as DungeonOccupant;

  @override
  DungeonOccupant getColumn11(int roll) =>
      super.getColumn11(roll) as DungeonOccupant;

  @override
  DungeonOccupant getColumn12(int roll) =>
      super.getColumn12(roll) as DungeonOccupant;

  @override
  RumorSubject getColumn13(int roll) => super.getColumn13(roll) as RumorSubject;

  @override
  RumorAction getColumn14(int roll) => super.getColumn14(roll) as RumorAction;

  @override
  RumorLocation getColumn15(int roll) =>
      super.getColumn15(roll) as RumorLocation;
}
