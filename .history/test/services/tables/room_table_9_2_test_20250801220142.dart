// test/services/tables/room_table_9_2_test.dart

import 'package:test/test.dart';
import '../../../lib/tables/room_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('RoomTable', () {
    late RoomTable roomTable;

    setUp(() {
      roomTable = RoomTable();
    });

    group('table info', () {
      test('should return correct table information', () {
        expect(roomTable.tableName,
            equals('Tabela 9.2 - Salas e Câmaras de Masmorras'));
        expect(roomTable.description,
            equals('Tabela para gerar dados de salas individuais'));
        expect(roomTable.columnCount, equals(15));
      });
    });

    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => roomTable.getColumn1(roll), returnsNormally);
          expect(() => roomTable.getColumn2(roll), returnsNormally);
          expect(() => roomTable.getColumn3(roll), returnsNormally);
          expect(() => roomTable.getColumn4(roll), returnsNormally);
          expect(() => roomTable.getColumn5(roll), returnsNormally);
          expect(() => roomTable.getColumn6(roll), returnsNormally);
          expect(() => roomTable.getColumn7(roll), returnsNormally);
          expect(() => roomTable.getColumn8(roll), returnsNormally);
          expect(() => roomTable.getColumn9(roll), returnsNormally);
          expect(() => roomTable.getColumn10(roll), returnsNormally);
          expect(() => roomTable.getColumn11(roll), returnsNormally);
          expect(() => roomTable.getColumn12(roll), returnsNormally);
          expect(() => roomTable.getColumn13(roll), returnsNormally);
          expect(() => roomTable.getColumn14(roll), returnsNormally);
          expect(() => roomTable.getColumn15(roll), returnsNormally);
        }
      });

      test('should throw error for invalid rolls', () {
        expect(() => roomTable.getColumn1(1), throwsArgumentError);
        expect(() => roomTable.getColumn1(13), throwsArgumentError);
        expect(() => roomTable.getColumnValue(1, 1), throwsArgumentError);
        expect(() => roomTable.getColumnValue(1, 13), throwsArgumentError);
      });

      test('should throw error for invalid column indices', () {
        expect(() => roomTable.getColumnValue(0, 6), throwsArgumentError);
        expect(() => roomTable.getColumnValue(16, 6), throwsArgumentError);
      });
    });

    group('specific column tests', () {
      test('column 1 - RoomType should return correct values', () {
        expect(roomTable.getColumn1(2), equals(RoomType.specialRoom));
        expect(roomTable.getColumn1(3), equals(RoomType.specialRoom));
        expect(roomTable.getColumn1(4), equals(RoomType.trap));
        expect(roomTable.getColumn1(5), equals(RoomType.trap));
        expect(roomTable.getColumn1(6), equals(RoomType.commonRoom));
        expect(roomTable.getColumn1(7), equals(RoomType.commonRoom));
        expect(roomTable.getColumn1(8), equals(RoomType.monster));
        expect(roomTable.getColumn1(9), equals(RoomType.monster));
        expect(roomTable.getColumn1(10), equals(RoomType.commonRoom));
        expect(roomTable.getColumn1(11), equals(RoomType.commonRoom));
        expect(roomTable.getColumn1(12), equals(RoomType.specialTrap));
      });

      test('column 2 - AirCurrent should return correct values', () {
        expect(roomTable.getColumn2(2), equals(AirCurrent.hotDraft));
        expect(roomTable.getColumn2(3), equals(AirCurrent.hotDraft));
        expect(roomTable.getColumn2(4), equals(AirCurrent.lightHotBreeze));
        expect(roomTable.getColumn2(5), equals(AirCurrent.lightHotBreeze));
        expect(roomTable.getColumn2(6), equals(AirCurrent.noAirCurrent));
        expect(roomTable.getColumn2(7), equals(AirCurrent.noAirCurrent));
        expect(roomTable.getColumn2(8), equals(AirCurrent.lightColdBreeze));
        expect(roomTable.getColumn2(9), equals(AirCurrent.lightColdBreeze));
        expect(roomTable.getColumn2(10), equals(AirCurrent.coldDraft));
        expect(roomTable.getColumn2(11), equals(AirCurrent.coldDraft));
        expect(roomTable.getColumn2(12), equals(AirCurrent.strongIcyWind));
      });

      test('column 3 - Smell should return correct values', () {
        expect(roomTable.getColumn3(2), equals(Smell.rottenMeat));
        expect(roomTable.getColumn3(3), equals(Smell.rottenMeat));
        expect(roomTable.getColumn3(4), equals(Smell.humidityMold));
        expect(roomTable.getColumn3(5), equals(Smell.humidityMold));
        expect(roomTable.getColumn3(6), equals(Smell.noSpecialSmell));
        expect(roomTable.getColumn3(7), equals(Smell.noSpecialSmell));
        expect(roomTable.getColumn3(8), equals(Smell.earthSmell));
        expect(roomTable.getColumn3(9), equals(Smell.earthSmell));
        expect(roomTable.getColumn3(10), equals(Smell.smokeSmell));
        expect(roomTable.getColumn3(11), equals(Smell.smokeSmell));
        expect(roomTable.getColumn3(12), equals(Smell.fecesUrine));
      });

      test('column 4 - Sound should return correct values', () {
        expect(roomTable.getColumn4(2), equals(Sound.metallicScratch));
        expect(roomTable.getColumn4(3), equals(Sound.metallicScratch));
        expect(roomTable.getColumn4(4), equals(Sound.rhythmicDrip));
        expect(roomTable.getColumn4(5), equals(Sound.rhythmicDrip));
        expect(roomTable.getColumn4(6), equals(Sound.noSpecialSound));
        expect(roomTable.getColumn4(7), equals(Sound.noSpecialSound));
        expect(roomTable.getColumn4(8), equals(Sound.windBlowing));
        expect(roomTable.getColumn4(9), equals(Sound.windBlowing));
        expect(roomTable.getColumn4(10), equals(Sound.distantFootsteps));
        expect(roomTable.getColumn4(11), equals(Sound.distantFootsteps));
        expect(roomTable.getColumn4(12), equals(Sound.whispersMoans));
      });

      test('column 5 - FoundItem should return correct values', () {
        expect(roomTable.getColumn5(2), equals(FoundItem.completelyEmpty));
        expect(roomTable.getColumn5(3), equals(FoundItem.completelyEmpty));
        expect(roomTable.getColumn5(4), equals(FoundItem.dustDirtWebs));
        expect(roomTable.getColumn5(5), equals(FoundItem.dustDirtWebs));
        expect(roomTable.getColumn5(6), equals(FoundItem.oldFurniture));
        expect(roomTable.getColumn5(7), equals(FoundItem.oldFurniture));
        expect(roomTable.getColumn5(8), equals(FoundItem.specialItems));
        expect(roomTable.getColumn5(9), equals(FoundItem.specialItems));
        expect(roomTable.getColumn5(10), equals(FoundItem.foodRemainsGarbage));
        expect(roomTable.getColumn5(11), equals(FoundItem.foodRemainsGarbage));
        expect(roomTable.getColumn5(12), equals(FoundItem.dirtyFetidClothes));
      });

      test('column 6 - SpecialItem should return correct values', () {
        expect(roomTable.getColumn6(2), equals(SpecialItem.monsterCarcasses));
        expect(roomTable.getColumn6(3), equals(SpecialItem.monsterCarcasses));
        expect(roomTable.getColumn6(4), equals(SpecialItem.oldTornPapers));
        expect(roomTable.getColumn6(5), equals(SpecialItem.oldTornPapers));
        expect(roomTable.getColumn6(6), equals(SpecialItem.piledBones));
        expect(roomTable.getColumn6(7), equals(SpecialItem.piledBones));
        expect(roomTable.getColumn6(8), equals(SpecialItem.dirtyFabricRemains));
        expect(roomTable.getColumn6(9), equals(SpecialItem.dirtyFabricRemains));
        expect(
            roomTable.getColumn6(10), equals(SpecialItem.emptyBoxesBagsChests));
        expect(
            roomTable.getColumn6(11), equals(SpecialItem.emptyBoxesBagsChests));
        expect(
            roomTable.getColumn6(12), equals(SpecialItem.fullBoxesBagsChests));
      });

      test('column 7 - CommonRoom should return correct values', () {
        expect(roomTable.getColumn7(2), equals(CommonRoom.dormitory));
        expect(roomTable.getColumn7(3), equals(CommonRoom.dormitory));
        expect(roomTable.getColumn7(4), equals(CommonRoom.generalDeposit));
        expect(roomTable.getColumn7(5), equals(CommonRoom.generalDeposit));
        expect(roomTable.getColumn7(6), equals(CommonRoom.special));
        expect(roomTable.getColumn7(7), equals(CommonRoom.special));
        expect(roomTable.getColumn7(8), equals(CommonRoom.completelyEmpty));
        expect(roomTable.getColumn7(9), equals(CommonRoom.completelyEmpty));
        expect(roomTable.getColumn7(10), equals(CommonRoom.foodPantry));
        expect(roomTable.getColumn7(11), equals(CommonRoom.foodPantry));
        expect(roomTable.getColumn7(12), equals(CommonRoom.prisonCell));
      });

      test('column 8 - SpecialRoom should return correct values', () {
        expect(roomTable.getColumn8(2), equals(SpecialRoom.trainingRoom));
        expect(roomTable.getColumn8(3), equals(SpecialRoom.trainingRoom));
        expect(roomTable.getColumn8(4), equals(SpecialRoom.diningRoom));
        expect(roomTable.getColumn8(5), equals(SpecialRoom.diningRoom));
        expect(roomTable.getColumn8(6), equals(SpecialRoom.completelyEmpty));
        expect(roomTable.getColumn8(7), equals(SpecialRoom.completelyEmpty));
        expect(roomTable.getColumn8(8), equals(SpecialRoom.special2));
        expect(roomTable.getColumn8(9), equals(SpecialRoom.special2));
        expect(roomTable.getColumn8(10), equals(SpecialRoom.religiousAltar));
        expect(roomTable.getColumn8(11), equals(SpecialRoom.religiousAltar));
        expect(roomTable.getColumn8(12), equals(SpecialRoom.abandonedDen));
      });

      test('column 9 - SpecialRoom2 should return correct values', () {
        expect(roomTable.getColumn9(2), equals(SpecialRoom2.tortureChamber));
        expect(roomTable.getColumn9(3), equals(SpecialRoom2.tortureChamber));
        expect(roomTable.getColumn9(4), equals(SpecialRoom2.ritualChamber));
        expect(roomTable.getColumn9(5), equals(SpecialRoom2.ritualChamber));
        expect(roomTable.getColumn9(6), equals(SpecialRoom2.magicalLaboratory));
        expect(roomTable.getColumn9(7), equals(SpecialRoom2.magicalLaboratory));
        expect(roomTable.getColumn9(8), equals(SpecialRoom2.library));
        expect(roomTable.getColumn9(9), equals(SpecialRoom2.library));
        expect(roomTable.getColumn9(10), equals(SpecialRoom2.crypt));
        expect(roomTable.getColumn9(11), equals(SpecialRoom2.crypt));
        expect(roomTable.getColumn9(12), equals(SpecialRoom2.arsenal));
      });

      test('column 10 - Monster should return correct values', () {
        expect(
            roomTable.getColumn10(2), equals(Monster.newMonsterPlusOccupantI));
        expect(
            roomTable.getColumn10(3), equals(Monster.newMonsterPlusOccupantI));
        expect(
            roomTable.getColumn10(4), equals(Monster.occupantIPlusOccupantII));
        expect(
            roomTable.getColumn10(5), equals(Monster.occupantIPlusOccupantII));
        expect(roomTable.getColumn10(6), equals(Monster.occupantI));
        expect(roomTable.getColumn10(7), equals(Monster.occupantI));
        expect(roomTable.getColumn10(8), equals(Monster.occupantII));
        expect(roomTable.getColumn10(9), equals(Monster.occupantII));
        expect(roomTable.getColumn10(10), equals(Monster.newMonster));
        expect(roomTable.getColumn10(11), equals(Monster.newMonster));
        expect(roomTable.getColumn10(12),
            equals(Monster.newMonsterPlusOccupantII));
      });

      test('column 11 - Trap should return correct values', () {
        expect(roomTable.getColumn11(2), equals(Trap.hiddenGuillotine));
        expect(roomTable.getColumn11(3), equals(Trap.hiddenGuillotine));
        expect(roomTable.getColumn11(4), equals(Trap.pit));
        expect(roomTable.getColumn11(5), equals(Trap.pit));
        expect(roomTable.getColumn11(6), equals(Trap.poisonedDarts));
        expect(roomTable.getColumn11(7), equals(Trap.poisonedDarts));
        expect(roomTable.getColumn11(8), equals(Trap.specialTrap));
        expect(roomTable.getColumn11(9), equals(Trap.specialTrap));
        expect(roomTable.getColumn11(10), equals(Trap.fallingBlock));
        expect(roomTable.getColumn11(11), equals(Trap.fallingBlock));
        expect(roomTable.getColumn11(12), equals(Trap.acidSpray));
      });

      test('column 12 - SpecialTrap should return correct values', () {
        expect(roomTable.getColumn12(2), equals(SpecialTrap.waterWell));
        expect(roomTable.getColumn12(3), equals(SpecialTrap.waterWell));
        expect(roomTable.getColumn12(4), equals(SpecialTrap.collapse));
        expect(roomTable.getColumn12(5), equals(SpecialTrap.collapse));
        expect(
            roomTable.getColumn12(6), equals(SpecialTrap.retractableCeiling));
        expect(
            roomTable.getColumn12(7), equals(SpecialTrap.retractableCeiling));
        expect(roomTable.getColumn12(8), equals(SpecialTrap.secretDoor));
        expect(roomTable.getColumn12(9), equals(SpecialTrap.secretDoor));
        expect(roomTable.getColumn12(10), equals(SpecialTrap.alarm));
        expect(roomTable.getColumn12(11), equals(SpecialTrap.alarm));
        expect(
            roomTable.getColumn12(12), equals(SpecialTrap.dimensionalPortal));
      });

      test('column 13 - Treasure should return correct values', () {
        expect(roomTable.getColumn13(2), equals(Treasure.noTreasure));
        expect(roomTable.getColumn13(3), equals(Treasure.noTreasure));
        expect(roomTable.getColumn13(4), equals(Treasure.copperSilver));
        expect(roomTable.getColumn13(5), equals(Treasure.copperSilver));
        expect(roomTable.getColumn13(6), equals(Treasure.silverGems));
        expect(roomTable.getColumn13(7), equals(Treasure.silverGems));
        expect(roomTable.getColumn13(8), equals(Treasure.specialTreasure));
        expect(roomTable.getColumn13(9), equals(Treasure.specialTreasure));
        expect(roomTable.getColumn13(10), equals(Treasure.magicItem));
        expect(roomTable.getColumn13(11), equals(Treasure.magicItem));
        expect(roomTable.getColumn13(12), equals(Treasure.magicItem));
      });

      test('column 14 - SpecialTreasure should return correct values', () {
        expect(roomTable.getColumn14(2),
            equals(SpecialTreasure.rollAgainPlusMagicItem));
        expect(roomTable.getColumn14(3),
            equals(SpecialTreasure.rollAgainPlusMagicItem));
        expect(
            roomTable.getColumn14(4), equals(SpecialTreasure.copperSilverGems));
        expect(
            roomTable.getColumn14(5), equals(SpecialTreasure.copperSilverGems));
        expect(roomTable.getColumn14(6),
            equals(SpecialTreasure.copperSilverGems2));
        expect(roomTable.getColumn14(7),
            equals(SpecialTreasure.copperSilverGems2));
        expect(roomTable.getColumn14(8),
            equals(SpecialTreasure.copperSilverGemsValuable));
        expect(roomTable.getColumn14(9),
            equals(SpecialTreasure.copperSilverGemsValuable));
        expect(roomTable.getColumn14(10),
            equals(SpecialTreasure.copperSilverGemsMagicItem));
        expect(roomTable.getColumn14(11),
            equals(SpecialTreasure.copperSilverGemsMagicItem));
        expect(roomTable.getColumn14(12),
            equals(SpecialTreasure.rollAgainPlusMagicItem2));
      });

      test('column 15 - MagicItem should return correct values', () {
        expect(roomTable.getColumn15(2), equals(MagicItem.any1));
        expect(roomTable.getColumn15(3), equals(MagicItem.any1));
        expect(roomTable.getColumn15(4), equals(MagicItem.any1NotWeapon));
        expect(roomTable.getColumn15(5), equals(MagicItem.any1NotWeapon));
        expect(roomTable.getColumn15(6), equals(MagicItem.potion1));
        expect(roomTable.getColumn15(7), equals(MagicItem.potion1));
        expect(roomTable.getColumn15(8), equals(MagicItem.scroll1));
        expect(roomTable.getColumn15(9), equals(MagicItem.scroll1));
        expect(roomTable.getColumn15(10), equals(MagicItem.weapon1));
        expect(roomTable.getColumn15(11), equals(MagicItem.weapon1));
        expect(roomTable.getColumn15(12), equals(MagicItem.any2));
      });
    });

    group('generic methods', () {
      test('getColumnValue should work correctly', () {
        expect(roomTable.getColumnValue(1, 6), equals(RoomType.commonRoom));
        expect(roomTable.getColumnValue(2, 6), equals(AirCurrent.noAirCurrent));
        expect(roomTable.getColumnValue(3, 6), equals(Smell.noSpecialSmell));
      });

      test('getColumnValues should return all values for a column', () {
        final column1Values = roomTable.getColumnValues(1);
        expect(column1Values.length, equals(12)); // 2-12 range (12 values)
        expect(column1Values[0], equals(RoomType.specialRoom)); // roll 2
        expect(column1Values[11], equals(RoomType.specialTrap)); // roll 12
      });
    });
  });
}
