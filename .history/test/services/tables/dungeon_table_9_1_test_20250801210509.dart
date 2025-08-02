// test/services/tables/dungeon_table_9_1_test.dart

import 'package:test/test.dart';
import '../../../lib/services/tables/dungeon_table_9_1.dart';
import '../../../lib/enums/dungeon_tables.dart';

void main() {
  group('DungeonTable9_1', () {
    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => DungeonTable9_1.getColumn1(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn2(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn3(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn4(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn5(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn6(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn7(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn8(roll), returnsNormally);
          expect(() => DungeonTable9_1.getColumn9(roll), returnsNormally);
        }
      });
    });

    group('specific column tests', () {
      test('column 1 - DungeonType should return correct values', () {
        expect(DungeonTable9_1.getColumn1(2),
            equals(DungeonType.lostConstruction));
        expect(DungeonTable9_1.getColumn1(3),
            equals(DungeonType.lostConstruction));
        expect(DungeonTable9_1.getColumn1(4),
            equals(DungeonType.artificialLabyrinth));
        expect(DungeonTable9_1.getColumn1(5),
            equals(DungeonType.artificialLabyrinth));
        expect(DungeonTable9_1.getColumn1(6), equals(DungeonType.naturalCaves));
        expect(DungeonTable9_1.getColumn1(7), equals(DungeonType.naturalCaves));
        expect(
            DungeonTable9_1.getColumn1(8), equals(DungeonType.abandonedLair));
        expect(
            DungeonTable9_1.getColumn1(9), equals(DungeonType.abandonedLair));
        expect(DungeonTable9_1.getColumn1(10),
            equals(DungeonType.abandonedFortress));
        expect(DungeonTable9_1.getColumn1(11),
            equals(DungeonType.abandonedFortress));
        expect(DungeonTable9_1.getColumn1(12),
            equals(DungeonType.deactivatedMine));
      });

      test('column 2 - DungeonBuilder should return correct values', () {
        expect(DungeonTable9_1.getColumn2(2), equals(DungeonBuilder.unknown));
        expect(DungeonTable9_1.getColumn2(3), equals(DungeonBuilder.unknown));
        expect(DungeonTable9_1.getColumn2(4), equals(DungeonBuilder.cultists));
        expect(DungeonTable9_1.getColumn2(5), equals(DungeonBuilder.cultists));
        expect(DungeonTable9_1.getColumn2(6),
            equals(DungeonBuilder.ancestralCivilization));
        expect(DungeonTable9_1.getColumn2(7),
            equals(DungeonBuilder.ancestralCivilization));
        expect(DungeonTable9_1.getColumn2(8), equals(DungeonBuilder.dwarves));
        expect(DungeonTable9_1.getColumn2(9), equals(DungeonBuilder.dwarves));
        expect(DungeonTable9_1.getColumn2(10), equals(DungeonBuilder.mages));
        expect(DungeonTable9_1.getColumn2(11), equals(DungeonBuilder.mages));
        expect(DungeonTable9_1.getColumn2(12), equals(DungeonBuilder.giants));
      });

      test('column 3 - DungeonStatus should return correct values', () {
        expect(DungeonTable9_1.getColumn3(2), equals(DungeonStatus.cursed));
        expect(DungeonTable9_1.getColumn3(3), equals(DungeonStatus.cursed));
        expect(DungeonTable9_1.getColumn3(4), equals(DungeonStatus.extinct));
        expect(DungeonTable9_1.getColumn3(5), equals(DungeonStatus.extinct));
        expect(DungeonTable9_1.getColumn3(6), equals(DungeonStatus.ancestral));
        expect(DungeonTable9_1.getColumn3(7), equals(DungeonStatus.ancestral));
        expect(
            DungeonTable9_1.getColumn3(8), equals(DungeonStatus.disappeared));
        expect(
            DungeonTable9_1.getColumn3(9), equals(DungeonStatus.disappeared));
        expect(DungeonTable9_1.getColumn3(10), equals(DungeonStatus.lost));
        expect(DungeonTable9_1.getColumn3(11), equals(DungeonStatus.lost));
        expect(DungeonTable9_1.getColumn3(12),
            equals(DungeonStatus.inAnotherLocation));
      });

      test('column 9 - size formulas should be correct', () {
        expect(DungeonTable9_1.getColumn9(2), equals('Grande – 3d6+4'));
        expect(DungeonTable9_1.getColumn9(3), equals('Grande – 3d6+4'));
        expect(DungeonTable9_1.getColumn9(4), equals('Média – 2d6+4'));
        expect(DungeonTable9_1.getColumn9(5), equals('Média – 2d6+4'));
        expect(DungeonTable9_1.getColumn9(6), equals('Pequena – 1d6+4'));
        expect(DungeonTable9_1.getColumn9(7), equals('Pequena – 1d6+4'));
        expect(DungeonTable9_1.getColumn9(8), equals('Pequena – 1d6+6'));
        expect(DungeonTable9_1.getColumn9(9), equals('Pequena – 1d6+6'));
        expect(DungeonTable9_1.getColumn9(10), equals('Média – 2d6+6'));
        expect(DungeonTable9_1.getColumn9(11), equals('Média – 2d6+6'));
        expect(DungeonTable9_1.getColumn9(12), equals('Grande – 3d6+6'));
      });
    });

    group('edge cases', () {
      test('should handle minimum roll (2)', () {
        expect(() => DungeonTable9_1.getColumn1(2), returnsNormally);
        expect(() => DungeonTable9_1.getColumn9(2), returnsNormally);
      });

      test('should handle maximum roll (12)', () {
        expect(() => DungeonTable9_1.getColumn1(12), returnsNormally);
        expect(() => DungeonTable9_1.getColumn9(12), returnsNormally);
      });
    });
  });
}
