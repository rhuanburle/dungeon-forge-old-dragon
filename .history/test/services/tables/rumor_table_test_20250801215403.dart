// test/services/tables/rumor_table_test.dart

import 'package:test/test.dart';
import '../../../lib/tables/rumor_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('RumorTable', () {
    late RumorTable rumorTable;

    setUp(() {
      rumorTable = RumorTable();
    });

    group('table info', () {
      test('should return correct table information', () {
        expect(rumorTable.tableName, equals('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'));
        expect(rumorTable.description, equals('Tabela para gerar rumores sobre a masmorra'));
        expect(rumorTable.columnCount, equals(3));
      });
    });

    group('column validation', () {
      test('should handle all valid 2d6 rolls (2-12)', () {
        for (int roll = 2; roll <= 12; roll++) {
          expect(() => rumorTable.getColumn1(roll), returnsNormally);
          expect(() => rumorTable.getColumn2(roll), returnsNormally);
          expect(() => rumorTable.getColumn3(roll), returnsNormally);
        }
      });

      test('should throw error for invalid rolls', () {
        expect(() => rumorTable.getColumn1(1), throwsArgumentError);
        expect(() => rumorTable.getColumn1(13), throwsArgumentError);
        expect(() => rumorTable.getColumnValue(1, 1), throwsArgumentError);
        expect(() => rumorTable.getColumnValue(1, 13), throwsArgumentError);
      });

      test('should throw error for invalid column indices', () {
        expect(() => rumorTable.getColumnValue(0, 6), throwsArgumentError);
        expect(() => rumorTable.getColumnValue(4, 6), throwsArgumentError);
      });
    });

    group('specific column tests', () {
      test('column 1 - RumorSubject should return correct values', () {
        expect(rumorTable.getColumn1(2), equals(RumorSubject.decapitatedOccupant));
        expect(rumorTable.getColumn1(3), equals(RumorSubject.decapitatedOccupant));
        expect(rumorTable.getColumn1(4), equals(RumorSubject.drunkPeasant));
        expect(rumorTable.getColumn1(5), equals(RumorSubject.drunkPeasant));
        expect(rumorTable.getColumn1(6), equals(RumorSubject.primaryOccupant));
        expect(rumorTable.getColumn1(7), equals(RumorSubject.primaryOccupant));
        expect(rumorTable.getColumn1(8), equals(RumorSubject.richForeigner));
        expect(rumorTable.getColumn1(9), equals(RumorSubject.richForeigner));
        expect(rumorTable.getColumn1(10), equals(RumorSubject.blindMystic));
        expect(rumorTable.getColumn1(11), equals(RumorSubject.blindMystic));
        expect(rumorTable.getColumn1(12), equals(RumorSubject.leader));
      });

      test('column 2 - RumorAction should return correct values', () {
        expect(rumorTable.getColumn2(2), equals(RumorAction.seenNear));
        expect(rumorTable.getColumn2(3), equals(RumorAction.seenNear));
        expect(rumorTable.getColumn2(4), equals(RumorAction.capturedIn));
        expect(rumorTable.getColumn2(5), equals(RumorAction.capturedIn));
        expect(rumorTable.getColumn2(6), equals(RumorAction.leftTrailsIn));
        expect(rumorTable.getColumn2(7), equals(RumorAction.leftTrailsIn));
        expect(rumorTable.getColumn2(8), equals(RumorAction.soughtPriestIn));
        expect(rumorTable.getColumn2(9), equals(RumorAction.soughtPriestIn));
        expect(rumorTable.getColumn2(10), equals(RumorAction.killedByWerewolfIn));
        expect(rumorTable.getColumn2(11), equals(RumorAction.killedByWerewolfIn));
        expect(rumorTable.getColumn2(12), equals(RumorAction.cursed));
      });

      test('column 3 - RumorLocation should return correct values', () {
        expect(rumorTable.getColumn3(2), equals(RumorLocation.autumnReligiousFestival));
        expect(rumorTable.getColumn3(3), equals(RumorLocation.autumnReligiousFestival));
        expect(rumorTable.getColumn3(4), equals(RumorLocation.villageLastYearDuringEclipse));
        expect(rumorTable.getColumn3(5), equals(RumorLocation.villageLastYearDuringEclipse));
        expect(rumorTable.getColumn3(6), equals(RumorLocation.farmWhenSheepDisappeared));
        expect(rumorTable.getColumn3(7), equals(RumorLocation.farmWhenSheepDisappeared));
        expect(rumorTable.getColumn3(8), equals(RumorLocation.nearbyVillage));
        expect(rumorTable.getColumn3(9), equals(RumorLocation.nearbyVillage));
        expect(rumorTable.getColumn3(10), equals(RumorLocation.springTradeCaravan));
        expect(rumorTable.getColumn3(11), equals(RumorLocation.springTradeCaravan));
        expect(rumorTable.getColumn3(12), equals(RumorLocation.winterBlizzard3YearsAgo));
      });
    });

    group('generic methods', () {
      test('getColumnValue should work correctly', () {
        expect(rumorTable.getColumnValue(1, 6), equals(RumorSubject.primaryOccupant));
        expect(rumorTable.getColumnValue(2, 6), equals(RumorAction.leftTrailsIn));
        expect(rumorTable.getColumnValue(3, 6), equals(RumorLocation.farmWhenSheepDisappeared));
      });

      test('getColumnValues should return all values for a column', () {
        final column1Values = rumorTable.getColumnValues(1);
        expect(column1Values.length, equals(11)); // 2-12 range
        expect(column1Values[0], equals(RumorSubject.decapitatedOccupant)); // roll 2
        expect(column1Values[10], equals(RumorSubject.leader)); // roll 12
      });
    });
  });
} 