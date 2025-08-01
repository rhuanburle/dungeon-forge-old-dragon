// test/services/tables/room_table_9_2_test.dart

import 'package:test/test.dart';
import '../../../lib/services/tables/room_table_9_2.dart';
import '../../../lib/enums/room_tables.dart';

void main() {
  group('RoomTable9_2', () {
    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => RoomTable9_2.getColumn1(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn2(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn3(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn4(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn5(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn6(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn7(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn8(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn9(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn10(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn11(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn12(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn13(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn14(roll), returnsNormally);
          expect(() => RoomTable9_2.getColumn15(roll), returnsNormally);
        }
      });
    });

    group('specific column tests', () {
      test('column 1 - RoomType should return correct values', () {
        expect(RoomTable9_2.getColumn1(2), equals(RoomType.specialRoom));
        expect(RoomTable9_2.getColumn1(3), equals(RoomType.specialRoom));
        expect(RoomTable9_2.getColumn1(4), equals(RoomType.trap));
        expect(RoomTable9_2.getColumn1(5), equals(RoomType.trap));
        expect(RoomTable9_2.getColumn1(6), equals(RoomType.commonRoom));
        expect(RoomTable9_2.getColumn1(7), equals(RoomType.commonRoom));
        expect(RoomTable9_2.getColumn1(8), equals(RoomType.monster));
        expect(RoomTable9_2.getColumn1(9), equals(RoomType.monster));
        expect(RoomTable9_2.getColumn1(10), equals(RoomType.commonRoom));
        expect(RoomTable9_2.getColumn1(11), equals(RoomType.commonRoom));
        expect(RoomTable9_2.getColumn1(12), equals(RoomType.specialTrap));
      });

      test('column 2 - AirCurrent should return correct values', () {
        expect(RoomTable9_2.getColumn2(2), equals(AirCurrent.hotDraft));
        expect(RoomTable9_2.getColumn2(3), equals(AirCurrent.hotDraft));
        expect(RoomTable9_2.getColumn2(4), equals(AirCurrent.lightHotBreeze));
        expect(RoomTable9_2.getColumn2(5), equals(AirCurrent.lightHotBreeze));
        expect(RoomTable9_2.getColumn2(6), equals(AirCurrent.noAirCurrent));
        expect(RoomTable9_2.getColumn2(7), equals(AirCurrent.noAirCurrent));
        expect(RoomTable9_2.getColumn2(8), equals(AirCurrent.lightColdBreeze));
        expect(RoomTable9_2.getColumn2(9), equals(AirCurrent.lightColdBreeze));
        expect(RoomTable9_2.getColumn2(10), equals(AirCurrent.coldDraft));
        expect(RoomTable9_2.getColumn2(11), equals(AirCurrent.coldDraft));
        expect(RoomTable9_2.getColumn2(12), equals(AirCurrent.strongIcyWind));
      });

      test('column 3 - Smell should return correct values', () {
        expect(RoomTable9_2.getColumn3(2), equals(Smell.rottenMeat));
        expect(RoomTable9_2.getColumn3(3), equals(Smell.rottenMeat));
        expect(RoomTable9_2.getColumn3(4), equals(Smell.humidityMold));
        expect(RoomTable9_2.getColumn3(5), equals(Smell.humidityMold));
        expect(RoomTable9_2.getColumn3(6), equals(Smell.noSpecialSmell));
        expect(RoomTable9_2.getColumn3(7), equals(Smell.noSpecialSmell));
        expect(RoomTable9_2.getColumn3(8), equals(Smell.earthSmell));
        expect(RoomTable9_2.getColumn3(9), equals(Smell.earthSmell));
        expect(RoomTable9_2.getColumn3(10), equals(Smell.smokeSmell));
        expect(RoomTable9_2.getColumn3(11), equals(Smell.smokeSmell));
        expect(RoomTable9_2.getColumn3(12), equals(Smell.fecesUrine));
      });

      test('column 10 - Monster should return correct values', () {
        expect(RoomTable9_2.getColumn10(2),
            equals(Monster.newMonsterPlusOccupantI));
        expect(RoomTable9_2.getColumn10(3),
            equals(Monster.newMonsterPlusOccupantI));
        expect(RoomTable9_2.getColumn10(4),
            equals(Monster.occupantIPlusOccupantII));
        expect(RoomTable9_2.getColumn10(5),
            equals(Monster.occupantIPlusOccupantII));
        expect(RoomTable9_2.getColumn10(6), equals(Monster.occupantI));
        expect(RoomTable9_2.getColumn10(7), equals(Monster.occupantI));
        expect(RoomTable9_2.getColumn10(8), equals(Monster.occupantII));
        expect(RoomTable9_2.getColumn10(9), equals(Monster.occupantII));
        expect(RoomTable9_2.getColumn10(10), equals(Monster.newMonster));
        expect(RoomTable9_2.getColumn10(11), equals(Monster.newMonster));
        expect(RoomTable9_2.getColumn10(12),
            equals(Monster.newMonsterPlusOccupantII));
      });

      test('column 11 - Trap should return correct values', () {
        expect(RoomTable9_2.getColumn11(2), equals(Trap.hiddenGuillotine));
        expect(RoomTable9_2.getColumn11(3), equals(Trap.hiddenGuillotine));
        expect(RoomTable9_2.getColumn11(4), equals(Trap.pit));
        expect(RoomTable9_2.getColumn11(5), equals(Trap.pit));
        expect(RoomTable9_2.getColumn11(6), equals(Trap.poisonedDarts));
        expect(RoomTable9_2.getColumn11(7), equals(Trap.poisonedDarts));
        expect(RoomTable9_2.getColumn11(8), equals(Trap.specialTrap));
        expect(RoomTable9_2.getColumn11(9), equals(Trap.specialTrap));
        expect(RoomTable9_2.getColumn11(10), equals(Trap.fallingBlock));
        expect(RoomTable9_2.getColumn11(11), equals(Trap.fallingBlock));
        expect(RoomTable9_2.getColumn11(12), equals(Trap.acidSpray));
      });

      test('column 12 - SpecialTrap should return correct values', () {
        expect(RoomTable9_2.getColumn12(2), equals(SpecialTrap.waterWell));
        expect(RoomTable9_2.getColumn12(3), equals(SpecialTrap.waterWell));
        expect(RoomTable9_2.getColumn12(4), equals(SpecialTrap.collapse));
        expect(RoomTable9_2.getColumn12(5), equals(SpecialTrap.collapse));
        expect(RoomTable9_2.getColumn12(6),
            equals(SpecialTrap.retractableCeiling));
        expect(RoomTable9_2.getColumn12(7),
            equals(SpecialTrap.retractableCeiling));
        expect(RoomTable9_2.getColumn12(8), equals(SpecialTrap.secretDoor));
        expect(RoomTable9_2.getColumn12(9), equals(SpecialTrap.secretDoor));
        expect(RoomTable9_2.getColumn12(10), equals(SpecialTrap.alarm));
        expect(RoomTable9_2.getColumn12(11), equals(SpecialTrap.alarm));
        expect(RoomTable9_2.getColumn12(12),
            equals(SpecialTrap.dimensionalPortal));
      });

      test('column 13 - Treasure should return correct values', () {
        expect(RoomTable9_2.getColumn13(2), equals(Treasure.noTreasure));
        expect(RoomTable9_2.getColumn13(3), equals(Treasure.noTreasure));
        expect(RoomTable9_2.getColumn13(4), equals(Treasure.noTreasure));
        expect(RoomTable9_2.getColumn13(5), equals(Treasure.noTreasure));
        expect(RoomTable9_2.getColumn13(6), equals(Treasure.copperSilver));
        expect(RoomTable9_2.getColumn13(7), equals(Treasure.copperSilver));
        expect(RoomTable9_2.getColumn13(8), equals(Treasure.silverGems));
        expect(RoomTable9_2.getColumn13(9), equals(Treasure.silverGems));
        expect(RoomTable9_2.getColumn13(10), equals(Treasure.specialTreasure));
        expect(RoomTable9_2.getColumn13(11), equals(Treasure.specialTreasure));
        expect(RoomTable9_2.getColumn13(12), equals(Treasure.magicItem));
      });

      test('column 15 - MagicItem should return correct values', () {
        expect(RoomTable9_2.getColumn15(2), equals(MagicItem.any1));
        expect(RoomTable9_2.getColumn15(3), equals(MagicItem.any1));
        expect(RoomTable9_2.getColumn15(4), equals(MagicItem.any1NotWeapon));
        expect(RoomTable9_2.getColumn15(5), equals(MagicItem.any1NotWeapon));
        expect(RoomTable9_2.getColumn15(6), equals(MagicItem.potion1));
        expect(RoomTable9_2.getColumn15(7), equals(MagicItem.potion1));
        expect(RoomTable9_2.getColumn15(8), equals(MagicItem.scroll1));
        expect(RoomTable9_2.getColumn15(9), equals(MagicItem.scroll1));
        expect(RoomTable9_2.getColumn15(10), equals(MagicItem.weapon1));
        expect(RoomTable9_2.getColumn15(11), equals(MagicItem.weapon1));
        expect(RoomTable9_2.getColumn15(12), equals(MagicItem.any2));
      });
    });

    group('special reference patterns', () {
      test('column 7 should include special reference', () {
        expect(RoomTable9_2.getColumn7(6), equals(CommonRoom.special));
        expect(RoomTable9_2.getColumn7(7), equals(CommonRoom.special));
      });

      test('column 8 should include special2 reference', () {
        expect(RoomTable9_2.getColumn8(8), equals(SpecialRoom.special2));
        expect(RoomTable9_2.getColumn8(9), equals(SpecialRoom.special2));
      });

      test('column 11 should include special trap reference', () {
        expect(RoomTable9_2.getColumn11(8), equals(Trap.specialTrap));
        expect(RoomTable9_2.getColumn11(9), equals(Trap.specialTrap));
      });

      test('column 13 should include special treasure reference', () {
        expect(RoomTable9_2.getColumn13(10), equals(Treasure.specialTreasure));
        expect(RoomTable9_2.getColumn13(11), equals(Treasure.specialTreasure));
      });
    });

    group('edge cases', () {
      test('should handle minimum roll (2)', () {
        expect(() => RoomTable9_2.getColumn1(2), returnsNormally);
        expect(() => RoomTable9_2.getColumn13(2), returnsNormally);
      });

      test('should handle maximum roll (12)', () {
        expect(() => RoomTable9_2.getColumn1(12), returnsNormally);
        expect(() => RoomTable9_2.getColumn13(12), returnsNormally);
      });
    });
  });
}
