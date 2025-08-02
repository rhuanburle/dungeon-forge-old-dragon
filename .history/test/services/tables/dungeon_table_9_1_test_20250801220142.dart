// test/services/tables/dungeon_table_9_1_test.dart

import 'package:test/test.dart';
import '../../../lib/tables/dungeon_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('DungeonTable', () {
    late DungeonTable dungeonTable;

    setUp(() {
      dungeonTable = DungeonTable();
    });

    group('table info', () {
      test('should return correct table information', () {
        expect(dungeonTable.tableName,
            equals('Tabela 9.1 - Geração de Masmorras'));
        expect(dungeonTable.description,
            equals('Tabela para gerar dados básicos de masmorras'));
        expect(dungeonTable.columnCount, equals(15));
      });
    });

    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => dungeonTable.getColumn1(roll), returnsNormally);
          expect(() => dungeonTable.getColumn2(roll), returnsNormally);
          expect(() => dungeonTable.getColumn3(roll), returnsNormally);
          expect(() => dungeonTable.getColumn4(roll), returnsNormally);
          expect(() => dungeonTable.getColumn5(roll), returnsNormally);
          expect(() => dungeonTable.getColumn6(roll), returnsNormally);
          expect(() => dungeonTable.getColumn7(roll), returnsNormally);
          expect(() => dungeonTable.getColumn8(roll), returnsNormally);
          expect(() => dungeonTable.getColumn9(roll), returnsNormally);
          expect(() => dungeonTable.getColumn10(roll), returnsNormally);
          expect(() => dungeonTable.getColumn11(roll), returnsNormally);
          expect(() => dungeonTable.getColumn12(roll), returnsNormally);
          expect(() => dungeonTable.getColumn13(roll), returnsNormally);
          expect(() => dungeonTable.getColumn14(roll), returnsNormally);
          expect(() => dungeonTable.getColumn15(roll), returnsNormally);
        }
      });

      test('should throw error for invalid rolls', () {
        expect(() => dungeonTable.getColumn1(1), throwsArgumentError);
        expect(() => dungeonTable.getColumn1(13), throwsArgumentError);
        expect(() => dungeonTable.getColumnValue(1, 1), throwsArgumentError);
        expect(() => dungeonTable.getColumnValue(1, 13), throwsArgumentError);
      });

      test('should throw error for invalid column indices', () {
        expect(() => dungeonTable.getColumnValue(0, 6), throwsArgumentError);
        expect(() => dungeonTable.getColumnValue(16, 6), throwsArgumentError);
      });
    });

    group('specific column tests', () {
      test('column 1 - DungeonType should return correct values', () {
        expect(
            dungeonTable.getColumn1(2), equals(DungeonType.lostConstruction));
        expect(
            dungeonTable.getColumn1(3), equals(DungeonType.lostConstruction));
        expect(dungeonTable.getColumn1(4),
            equals(DungeonType.artificialLabyrinth));
        expect(dungeonTable.getColumn1(5),
            equals(DungeonType.artificialLabyrinth));
        expect(dungeonTable.getColumn1(6), equals(DungeonType.naturalCaves));
        expect(dungeonTable.getColumn1(7), equals(DungeonType.naturalCaves));
        expect(dungeonTable.getColumn1(8), equals(DungeonType.abandonedLair));
        expect(dungeonTable.getColumn1(9), equals(DungeonType.abandonedLair));
        expect(
            dungeonTable.getColumn1(10), equals(DungeonType.abandonedFortress));
        expect(
            dungeonTable.getColumn1(11), equals(DungeonType.abandonedFortress));
        expect(
            dungeonTable.getColumn1(12), equals(DungeonType.deactivatedMine));
      });

      test('column 2 - DungeonBuilder should return correct values', () {
        expect(dungeonTable.getColumn2(2), equals(DungeonBuilder.unknown));
        expect(dungeonTable.getColumn2(3), equals(DungeonBuilder.unknown));
        expect(dungeonTable.getColumn2(4), equals(DungeonBuilder.cultists));
        expect(dungeonTable.getColumn2(5), equals(DungeonBuilder.cultists));
        expect(dungeonTable.getColumn2(6),
            equals(DungeonBuilder.ancestralCivilization));
        expect(dungeonTable.getColumn2(7),
            equals(DungeonBuilder.ancestralCivilization));
        expect(dungeonTable.getColumn2(8), equals(DungeonBuilder.dwarves));
        expect(dungeonTable.getColumn2(9), equals(DungeonBuilder.dwarves));
        expect(dungeonTable.getColumn2(10), equals(DungeonBuilder.mages));
        expect(dungeonTable.getColumn2(11), equals(DungeonBuilder.mages));
        expect(dungeonTable.getColumn2(12), equals(DungeonBuilder.giants));
      });

      test('column 3 - DungeonStatus should return correct values', () {
        expect(dungeonTable.getColumn3(2), equals(DungeonStatus.cursed));
        expect(dungeonTable.getColumn3(3), equals(DungeonStatus.cursed));
        expect(dungeonTable.getColumn3(4), equals(DungeonStatus.extinct));
        expect(dungeonTable.getColumn3(5), equals(DungeonStatus.extinct));
        expect(dungeonTable.getColumn3(6), equals(DungeonStatus.ancestral));
        expect(dungeonTable.getColumn3(7), equals(DungeonStatus.ancestral));
        expect(dungeonTable.getColumn3(8), equals(DungeonStatus.disappeared));
        expect(dungeonTable.getColumn3(9), equals(DungeonStatus.disappeared));
        expect(dungeonTable.getColumn3(10), equals(DungeonStatus.lost));
        expect(dungeonTable.getColumn3(11), equals(DungeonStatus.lost));
        expect(dungeonTable.getColumn3(12),
            equals(DungeonStatus.inAnotherLocation));
      });

      test('column 9 - size formulas should be correct', () {
        expect(dungeonTable.getColumn9(2), equals('1d6 + 4 salas'));
        expect(dungeonTable.getColumn9(3), equals('1d6 + 4 salas'));
        expect(dungeonTable.getColumn9(4), equals('2d6 + 6 salas'));
        expect(dungeonTable.getColumn9(5), equals('2d6 + 6 salas'));
        expect(dungeonTable.getColumn9(6), equals('3d6 + 8 salas'));
        expect(dungeonTable.getColumn9(7), equals('3d6 + 8 salas'));
        expect(dungeonTable.getColumn9(8), equals('4d6 + 10 salas'));
        expect(dungeonTable.getColumn9(9), equals('4d6 + 10 salas'));
        expect(dungeonTable.getColumn9(10), equals('5d6 + 12 salas'));
        expect(dungeonTable.getColumn9(11), equals('5d6 + 12 salas'));
        expect(dungeonTable.getColumn9(12), equals('6d6 + 14 salas'));
      });

      test(
          'column 10 - DungeonOccupant (Ocupante I) should return correct values',
          () {
        expect(dungeonTable.getColumn10(2), equals(DungeonOccupant.trolls));
        expect(dungeonTable.getColumn10(3), equals(DungeonOccupant.trolls));
        expect(dungeonTable.getColumn10(4), equals(DungeonOccupant.orcs));
        expect(dungeonTable.getColumn10(5), equals(DungeonOccupant.orcs));
        expect(dungeonTable.getColumn10(6), equals(DungeonOccupant.skeletons));
        expect(dungeonTable.getColumn10(7), equals(DungeonOccupant.skeletons));
        expect(dungeonTable.getColumn10(8), equals(DungeonOccupant.goblins));
        expect(dungeonTable.getColumn10(9), equals(DungeonOccupant.goblins));
        expect(dungeonTable.getColumn10(10), equals(DungeonOccupant.bugbears));
        expect(dungeonTable.getColumn10(11), equals(DungeonOccupant.bugbears));
        expect(dungeonTable.getColumn10(12), equals(DungeonOccupant.ogres));
      });

      test(
          'column 11 - DungeonOccupant (Ocupante II) should return correct values',
          () {
        expect(dungeonTable.getColumn11(2), equals(DungeonOccupant.kobolds));
        expect(dungeonTable.getColumn11(3), equals(DungeonOccupant.kobolds));
        expect(dungeonTable.getColumn11(4), equals(DungeonOccupant.grayOoze));
        expect(dungeonTable.getColumn11(5), equals(DungeonOccupant.grayOoze));
        expect(dungeonTable.getColumn11(6), equals(DungeonOccupant.zombies));
        expect(dungeonTable.getColumn11(7), equals(DungeonOccupant.zombies));
        expect(dungeonTable.getColumn11(8), equals(DungeonOccupant.giantRats));
        expect(dungeonTable.getColumn11(9), equals(DungeonOccupant.giantRats));
        expect(
            dungeonTable.getColumn11(10), equals(DungeonOccupant.pygmyFungi));
        expect(
            dungeonTable.getColumn11(11), equals(DungeonOccupant.pygmyFungi));
        expect(dungeonTable.getColumn11(12), equals(DungeonOccupant.lizardMen));
      });

      test('column 12 - DungeonOccupant (Líder) should return correct values',
          () {
        expect(dungeonTable.getColumn12(2), equals(DungeonOccupant.hobgoblin));
        expect(dungeonTable.getColumn12(3), equals(DungeonOccupant.hobgoblin));
        expect(dungeonTable.getColumn12(4),
            equals(DungeonOccupant.gelatinousCube));
        expect(dungeonTable.getColumn12(5),
            equals(DungeonOccupant.gelatinousCube));
        expect(dungeonTable.getColumn12(6), equals(DungeonOccupant.cultist));
        expect(dungeonTable.getColumn12(7), equals(DungeonOccupant.cultist));
        expect(dungeonTable.getColumn12(8), equals(DungeonOccupant.shadow));
        expect(dungeonTable.getColumn12(9), equals(DungeonOccupant.shadow));
        expect(
            dungeonTable.getColumn12(10), equals(DungeonOccupant.necromancer));
        expect(
            dungeonTable.getColumn12(11), equals(DungeonOccupant.necromancer));
        expect(dungeonTable.getColumn12(12), equals(DungeonOccupant.dragon));
      });
    });

    group('generic methods', () {
      test('getColumnValue should work correctly', () {
        expect(dungeonTable.getColumnValue(1, 6),
            equals(DungeonType.naturalCaves));
        expect(dungeonTable.getColumnValue(2, 6),
            equals(DungeonBuilder.ancestralCivilization));
        expect(
            dungeonTable.getColumnValue(3, 6), equals(DungeonStatus.ancestral));
      });

      test('getColumnValues should return all values for a column', () {
        final column1Values = dungeonTable.getColumnValues(1);
        expect(column1Values.length, equals(12)); // 2-12 range (12 values)
        expect(
            column1Values[0], equals(DungeonType.lostConstruction)); // roll 2
        expect(
            column1Values[11], equals(DungeonType.deactivatedMine)); // roll 12
      });
    });
  });
}
