// services/tables/room_table_9_2.dart

import '../../enums/room_tables.dart';

/// Representa a Tabela 9.2 - Salas e Câmaras de Masmorras
class RoomTable9_2 {
  static const List<RoomType> _column1 = [
    RoomType.specialRoom,
    RoomType.specialRoom,
    RoomType.trap,
    RoomType.trap,
    RoomType.commonRoom,
    RoomType.commonRoom,
    RoomType.monster,
    RoomType.monster,
    RoomType.commonRoom,
    RoomType.commonRoom,
    RoomType.specialTrap,
    RoomType.specialTrap,
  ];

  static const List<AirCurrent> _column2 = [
    AirCurrent.hotDraft,
    AirCurrent.hotDraft,
    AirCurrent.lightHotBreeze,
    AirCurrent.lightHotBreeze,
    AirCurrent.noAirCurrent,
    AirCurrent.noAirCurrent,
    AirCurrent.lightColdBreeze,
    AirCurrent.lightColdBreeze,
    AirCurrent.coldDraft,
    AirCurrent.coldDraft,
    AirCurrent.strongIcyWind,
    AirCurrent.strongIcyWind,
  ];

  static const List<Smell> _column3 = [
    Smell.rottenMeat,
    Smell.rottenMeat,
    Smell.humidityMold,
    Smell.humidityMold,
    Smell.noSpecialSmell,
    Smell.noSpecialSmell,
    Smell.earthSmell,
    Smell.earthSmell,
    Smell.smokeSmell,
    Smell.smokeSmell,
    Smell.fecesUrine,
    Smell.fecesUrine,
  ];

  static const List<Sound> _column4 = [
    Sound.metallicScratch,
    Sound.metallicScratch,
    Sound.rhythmicDrip,
    Sound.rhythmicDrip,
    Sound.noSpecialSound,
    Sound.noSpecialSound,
    Sound.windBlowing,
    Sound.windBlowing,
    Sound.distantFootsteps,
    Sound.distantFootsteps,
    Sound.whispersMoans,
    Sound.whispersMoans,
  ];

  static const List<FoundItem> _column5 = [
    FoundItem.completelyEmpty,
    FoundItem.completelyEmpty,
    FoundItem.dustDirtWebs,
    FoundItem.dustDirtWebs,
    FoundItem.oldFurniture,
    FoundItem.oldFurniture,
    FoundItem.specialItems,
    FoundItem.specialItems,
    FoundItem.foodRemainsGarbage,
    FoundItem.foodRemainsGarbage,
    FoundItem.dirtyFetidClothes,
    FoundItem.dirtyFetidClothes,
  ];

  static const List<SpecialItem> _column6 = [
    SpecialItem.monsterCarcasses,
    SpecialItem.monsterCarcasses,
    SpecialItem.oldTornPapers,
    SpecialItem.oldTornPapers,
    SpecialItem.piledBones,
    SpecialItem.piledBones,
    SpecialItem.dirtyFabricRemains,
    SpecialItem.dirtyFabricRemains,
    SpecialItem.emptyBoxesBagsChests,
    SpecialItem.emptyBoxesBagsChests,
    SpecialItem.fullBoxesBagsChests,
    SpecialItem.fullBoxesBagsChests,
  ];

  static const List<CommonRoom> _column7 = [
    CommonRoom.dormitory,
    CommonRoom.dormitory,
    CommonRoom.generalDeposit,
    CommonRoom.generalDeposit,
    CommonRoom.special,
    CommonRoom.special,
    CommonRoom.completelyEmpty,
    CommonRoom.completelyEmpty,
    CommonRoom.foodPantry,
    CommonRoom.foodPantry,
    CommonRoom.prisonCell,
    CommonRoom.prisonCell,
  ];

  static const List<SpecialRoom> _column8 = [
    SpecialRoom.trainingRoom,
    SpecialRoom.trainingRoom,
    SpecialRoom.diningRoom,
    SpecialRoom.diningRoom,
    SpecialRoom.completelyEmpty,
    SpecialRoom.completelyEmpty,
    SpecialRoom.special2,
    SpecialRoom.special2,
    SpecialRoom.religiousAltar,
    SpecialRoom.religiousAltar,
    SpecialRoom.abandonedDen,
    SpecialRoom.abandonedDen,
  ];

  static const List<SpecialRoom2> _column9 = [
    SpecialRoom2.tortureChamber,
    SpecialRoom2.tortureChamber,
    SpecialRoom2.ritualChamber,
    SpecialRoom2.ritualChamber,
    SpecialRoom2.magicalLaboratory,
    SpecialRoom2.magicalLaboratory,
    SpecialRoom2.library,
    SpecialRoom2.library,
    SpecialRoom2.crypt,
    SpecialRoom2.crypt,
    SpecialRoom2.arsenal,
    SpecialRoom2.arsenal,
  ];

  static const List<Monster> _column10 = [
    Monster.newMonsterPlusOccupantI,
    Monster.newMonsterPlusOccupantI,
    Monster.occupantIPlusOccupantII,
    Monster.occupantIPlusOccupantII,
    Monster.occupantI,
    Monster.occupantI,
    Monster.occupantII,
    Monster.occupantII,
    Monster.newMonster,
    Monster.newMonster,
    Monster.newMonsterPlusOccupantII,
    Monster.newMonsterPlusOccupantII,
  ];

  static const List<Trap> _column11 = [
    Trap.hiddenGuillotine,
    Trap.hiddenGuillotine,
    Trap.pit,
    Trap.pit,
    Trap.poisonedDarts,
    Trap.poisonedDarts,
    Trap.specialTrap,
    Trap.specialTrap,
    Trap.fallingBlock,
    Trap.fallingBlock,
    Trap.acidSpray,
    Trap.acidSpray,
  ];

  static const List<SpecialTrap> _column12 = [
    SpecialTrap.waterWell,
    SpecialTrap.waterWell,
    SpecialTrap.collapse,
    SpecialTrap.collapse,
    SpecialTrap.retractableCeiling,
    SpecialTrap.retractableCeiling,
    SpecialTrap.secretDoor,
    SpecialTrap.secretDoor,
    SpecialTrap.alarm,
    SpecialTrap.alarm,
    SpecialTrap.dimensionalPortal,
    SpecialTrap.dimensionalPortal,
  ];

  static const List<Treasure> _column13 = [
    Treasure.noTreasure,
    Treasure.noTreasure,
    Treasure.noTreasure,
    Treasure.noTreasure,
    Treasure.copperSilver,
    Treasure.copperSilver,
    Treasure.silverGems,
    Treasure.silverGems,
    Treasure.specialTreasure,
    Treasure.specialTreasure,
    Treasure.magicItem,
    Treasure.magicItem,
  ];

  static const List<SpecialTreasure> _column14 = [
    SpecialTreasure.rollAgainPlusMagicItem,
    SpecialTreasure.rollAgainPlusMagicItem,
    SpecialTreasure.copperSilverGems,
    SpecialTreasure.copperSilverGems,
    SpecialTreasure.copperSilverGems2,
    SpecialTreasure.copperSilverGems2,
    SpecialTreasure.copperSilverGemsValuable,
    SpecialTreasure.copperSilverGemsValuable,
    SpecialTreasure.copperSilverGemsMagicItem,
    SpecialTreasure.copperSilverGemsMagicItem,
    SpecialTreasure.rollAgainPlusMagicItem2,
    SpecialTreasure.rollAgainPlusMagicItem2,
  ];

  static const List<MagicItem> _column15 = [
    MagicItem.any1,
    MagicItem.any1,
    MagicItem.any1NotWeapon,
    MagicItem.any1NotWeapon,
    MagicItem.potion1,
    MagicItem.potion1,
    MagicItem.scroll1,
    MagicItem.scroll1,
    MagicItem.weapon1,
    MagicItem.weapon1,
    MagicItem.any2,
    MagicItem.any2,
  ];

  /// Obtém o resultado da coluna 1 baseado no roll
  static RoomType getColumn1(int roll) => _column1[roll - 2];

  /// Obtém o resultado da coluna 2 baseado no roll
  static AirCurrent getColumn2(int roll) => _column2[roll - 2];

  /// Obtém o resultado da coluna 3 baseado no roll
  static Smell getColumn3(int roll) => _column3[roll - 2];

  /// Obtém o resultado da coluna 4 baseado no roll
  static Sound getColumn4(int roll) => _column4[roll - 2];

  /// Obtém o resultado da coluna 5 baseado no roll
  static FoundItem getColumn5(int roll) => _column5[roll - 2];

  /// Obtém o resultado da coluna 6 baseado no roll
  static SpecialItem getColumn6(int roll) => _column6[roll - 2];

  /// Obtém o resultado da coluna 7 baseado no roll
  static CommonRoom getColumn7(int roll) => _column7[roll - 2];

  /// Obtém o resultado da coluna 8 baseado no roll
  static SpecialRoom getColumn8(int roll) => _column8[roll - 2];

  /// Obtém o resultado da coluna 9 baseado no roll
  static SpecialRoom2 getColumn9(int roll) => _column9[roll - 2];

  /// Obtém o resultado da coluna 10 baseado no roll
  static Monster getColumn10(int roll) => _column10[roll - 2];

  /// Obtém o resultado da coluna 11 baseado no roll
  static Trap getColumn11(int roll) => _column11[roll - 2];

  /// Obtém o resultado da coluna 12 baseado no roll
  static SpecialTrap getColumn12(int roll) => _column12[roll - 2];

  /// Obtém o resultado da coluna 13 baseado no roll
  static Treasure getColumn13(int roll) => _column13[roll - 2];

  /// Obtém o resultado da coluna 14 baseado no roll
  static SpecialTreasure getColumn14(int roll) => _column14[roll - 2];

  /// Obtém o resultado da coluna 15 baseado no roll
  static MagicItem getColumn15(int roll) => _column15[roll - 2];
}
