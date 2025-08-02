// tables/room_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela 9.2 - Salas e Câmaras de Masmorras
///
/// Esta tabela é usada para gerar dados de salas individuais,
/// incluindo tipo, ambiente, itens, monstros, armadilhas, etc.
class RoomTable extends TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Tabela 9.2 - Salas e Câmaras de Masmorras';

  @override
  String get description => 'Tabela para gerar dados de salas individuais';

  @override
  int get columnCount => 15;

  @override
  List<List<dynamic>> get columns => [
        _column1, // RoomType
        _column2, // AirCurrent
        _column3, // Smell
        _column4, // Sound
        _column5, // FoundItem
        _column6, // SpecialItem
        _column7, // CommonRoom
        _column8, // SpecialRoom
        _column9, // SpecialRoom2
        _column10, // Monster
        _column11, // Trap
        _column12, // SpecialTrap
        _column13, // Treasure
        _column14, // SpecialTreasure
        _column15, // MagicItem
      ];

  // Coluna 1: Tipo de Sala
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

  // Coluna 2: Corrente de Ar
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

  // Coluna 3: Odor
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

  // Coluna 4: Som
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

  // Coluna 5: Item Encontrado
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

  // Coluna 6: Item Especial
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

  // Coluna 7: Sala Comum
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

  // Coluna 8: Sala Especial
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

  // Coluna 9: Sala Especial 2
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

  // Coluna 10: Monstro
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

  // Coluna 11: Armadilha
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

  // Coluna 12: Armadilha Especial
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

  // Coluna 13: Tesouro
  static const List<Treasure> _column13 = [
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
    Treasure.magicItem,
    Treasure.magicItem,
  ];

  // Coluna 14: Tesouro Especial
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

  // Coluna 15: Item Mágico
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

  // Métodos específicos com tipos corretos
  @override
  RoomType getColumn1(int roll) => super.getColumn1(roll) as RoomType;

  @override
  AirCurrent getColumn2(int roll) => super.getColumn2(roll) as AirCurrent;

  @override
  Smell getColumn3(int roll) => super.getColumn3(roll) as Smell;

  @override
  Sound getColumn4(int roll) => super.getColumn4(roll) as Sound;

  @override
  FoundItem getColumn5(int roll) => super.getColumn5(roll) as FoundItem;

  @override
  SpecialItem getColumn6(int roll) => super.getColumn6(roll) as SpecialItem;

  @override
  CommonRoom getColumn7(int roll) => super.getColumn7(roll) as CommonRoom;

  @override
  SpecialRoom getColumn8(int roll) => super.getColumn8(roll) as SpecialRoom;

  @override
  SpecialRoom2 getColumn9(int roll) => super.getColumn9(roll) as SpecialRoom2;

  @override
  Monster getColumn10(int roll) => super.getColumn10(roll) as Monster;

  @override
  Trap getColumn11(int roll) => super.getColumn11(roll) as Trap;

  @override
  SpecialTrap getColumn12(int roll) => super.getColumn12(roll) as SpecialTrap;

  @override
  Treasure getColumn13(int roll) => super.getColumn13(roll) as Treasure;

  @override
  SpecialTreasure getColumn14(int roll) =>
      super.getColumn14(roll) as SpecialTreasure;

  @override
  MagicItem getColumn15(int roll) => super.getColumn15(roll) as MagicItem;
}
