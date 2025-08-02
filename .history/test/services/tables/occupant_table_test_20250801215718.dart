// test/services/tables/occupant_table_test.dart

import 'package:test/test.dart';
import '../../../lib/tables/occupant_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('OccupantTable', () {
    late OccupantTable occupantTable;

    setUp(() {
      occupantTable = OccupantTable();
    });

    group('table info', () {
      test('should return correct table information', () {
        expect(occupantTable.tableName, equals('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'));
        expect(occupantTable.description, equals('Tabela para gerar ocupantes da masmorra'));
        expect(occupantTable.columnCount, equals(3));
      });
    });

    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => occupantTable.getColumn1(roll), returnsNormally);
          expect(() => occupantTable.getColumn2(roll), returnsNormally);
          expect(() => occupantTable.getColumn3(roll), returnsNormally);
        }
      });

      test('should throw error for invalid rolls', () {
        expect(() => occupantTable.getColumn1(1), throwsArgumentError);
        expect(() => occupantTable.getColumn1(13), throwsArgumentError);
        expect(() => occupantTable.getColumnValue(1, 1), throwsArgumentError);
        expect(() => occupantTable.getColumnValue(1, 13), throwsArgumentError);
      });

      test('should throw error for invalid column indices', () {
        expect(() => occupantTable.getColumnValue(0, 6), throwsArgumentError);
        expect(() => occupantTable.getColumnValue(4, 6), throwsArgumentError);
      });
    });

    group('specific column tests', () {
      test('column 1 - DungeonOccupant (Ocupante I) should return correct values', () {
        expect(occupantTable.getColumn1(2), equals(DungeonOccupant.trolls));
        expect(occupantTable.getColumn1(3), equals(DungeonOccupant.trolls));
        expect(occupantTable.getColumn1(4), equals(DungeonOccupant.orcs));
        expect(occupantTable.getColumn1(5), equals(DungeonOccupant.orcs));
        expect(occupantTable.getColumn1(6), equals(DungeonOccupant.skeletons));
        expect(occupantTable.getColumn1(7), equals(DungeonOccupant.skeletons));
        expect(occupantTable.getColumn1(8), equals(DungeonOccupant.goblins));
        expect(occupantTable.getColumn1(9), equals(DungeonOccupant.goblins));
        expect(occupantTable.getColumn1(10), equals(DungeonOccupant.bugbears));
        expect(occupantTable.getColumn1(11), equals(DungeonOccupant.bugbears));
        expect(occupantTable.getColumn1(12), equals(DungeonOccupant.ogres));
      });

      test('column 2 - DungeonOccupant (Ocupante II) should return correct values', () {
        expect(occupantTable.getColumn2(2), equals(DungeonOccupant.kobolds));
        expect(occupantTable.getColumn2(3), equals(DungeonOccupant.kobolds));
        expect(occupantTable.getColumn2(4), equals(DungeonOccupant.grayOoze));
        expect(occupantTable.getColumn2(5), equals(DungeonOccupant.grayOoze));
        expect(occupantTable.getColumn2(6), equals(DungeonOccupant.zombies));
        expect(occupantTable.getColumn2(7), equals(DungeonOccupant.zombies));
        expect(occupantTable.getColumn2(8), equals(DungeonOccupant.giantRats));
        expect(occupantTable.getColumn2(9), equals(DungeonOccupant.giantRats));
        expect(occupantTable.getColumn2(10), equals(DungeonOccupant.pygmyFungi));
        expect(occupantTable.getColumn2(11), equals(DungeonOccupant.pygmyFungi));
        expect(occupantTable.getColumn2(12), equals(DungeonOccupant.lizardMen));
      });

      test('column 3 - DungeonOccupant (Líder) should return correct values', () {
        expect(occupantTable.getColumn3(2), equals(DungeonOccupant.hobgoblin));
        expect(occupantTable.getColumn3(3), equals(DungeonOccupant.hobgoblin));
        expect(occupantTable.getColumn3(4), equals(DungeonOccupant.gelatinousCube));
        expect(occupantTable.getColumn3(5), equals(DungeonOccupant.gelatinousCube));
        expect(occupantTable.getColumn3(6), equals(DungeonOccupant.cultist));
        expect(occupantTable.getColumn3(7), equals(DungeonOccupant.cultist));
        expect(occupantTable.getColumn3(8), equals(DungeonOccupant.shadow));
        expect(occupantTable.getColumn3(9), equals(DungeonOccupant.shadow));
        expect(occupantTable.getColumn3(10), equals(DungeonOccupant.necromancer));
        expect(occupantTable.getColumn3(11), equals(DungeonOccupant.necromancer));
        expect(occupantTable.getColumn3(12), equals(DungeonOccupant.dragon));
      });
    });

    group('generic methods', () {
      test('getColumnValue should work correctly', () {
        expect(occupantTable.getColumnValue(1, 6), equals(DungeonOccupant.skeletons));
        expect(occupantTable.getColumnValue(2, 6), equals(DungeonOccupant.zombies));
        expect(occupantTable.getColumnValue(3, 6), equals(DungeonOccupant.cultist));
      });

      test('getColumnValues should return all values for a column', () {
        final column1Values = occupantTable.getColumnValues(1);
        expect(column1Values.length, equals(12)); // 2-12 range (12 values)
        expect(column1Values[0], equals(DungeonOccupant.trolls)); // roll 2
        expect(column1Values[11], equals(DungeonOccupant.ogres)); // roll 12
      });
    });
  });
} 