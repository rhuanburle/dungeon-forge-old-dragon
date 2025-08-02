// test/services/tables/rumor_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/tables/rumor_table.dart';
import 'package:dungeon_forge/enums/dungeon_tables.dart';

void main() {
  group('RumorTable', () {
    test('should handle all valid 2d6 rolls (2-12)', () {
      for (int roll = 2; roll <= 12; roll++) {
        expect(() => RumorTable.getColumn13(roll), returnsNormally);
        expect(() => RumorTable.getColumn14(roll), returnsNormally);
        expect(() => RumorTable.getColumn15(roll), returnsNormally);
      }
    });

    test('should return correct values for column 13 (RumorSubject)', () {
      expect(RumorTable.getColumn13(2), equals(RumorSubject.decapitatedOccupant));
      expect(RumorTable.getColumn13(3), equals(RumorSubject.decapitatedOccupant));
      expect(RumorTable.getColumn13(4), equals(RumorSubject.drunkPeasant));
      expect(RumorTable.getColumn13(5), equals(RumorSubject.drunkPeasant));
      expect(RumorTable.getColumn13(6), equals(RumorSubject.primaryOccupant));
      expect(RumorTable.getColumn13(7), equals(RumorSubject.primaryOccupant));
      expect(RumorTable.getColumn13(8), equals(RumorSubject.richForeigner));
      expect(RumorTable.getColumn13(9), equals(RumorSubject.richForeigner));
      expect(RumorTable.getColumn13(10), equals(RumorSubject.blindMystic));
      expect(RumorTable.getColumn13(11), equals(RumorSubject.blindMystic));
      expect(RumorTable.getColumn13(12), equals(RumorSubject.leader));
    });

    test('should return correct values for column 14 (RumorAction)', () {
      expect(RumorTable.getColumn14(2), equals(RumorAction.seenNear));
      expect(RumorTable.getColumn14(3), equals(RumorAction.seenNear));
      expect(RumorTable.getColumn14(4), equals(RumorAction.capturedIn));
      expect(RumorTable.getColumn14(5), equals(RumorAction.capturedIn));
      expect(RumorTable.getColumn14(6), equals(RumorAction.leftTrailsIn));
      expect(RumorTable.getColumn14(7), equals(RumorAction.leftTrailsIn));
      expect(RumorTable.getColumn14(8), equals(RumorAction.soughtPriestIn));
      expect(RumorTable.getColumn14(9), equals(RumorAction.soughtPriestIn));
      expect(RumorTable.getColumn14(10), equals(RumorAction.killedByWerewolfIn));
      expect(RumorTable.getColumn14(11), equals(RumorAction.killedByWerewolfIn));
      expect(RumorTable.getColumn14(12), equals(RumorAction.cursed));
    });

    test('should return correct values for column 15 (RumorLocation)', () {
      expect(RumorTable.getColumn15(2), equals(RumorLocation.autumnReligiousFestival));
      expect(RumorTable.getColumn15(3), equals(RumorLocation.autumnReligiousFestival));
      expect(RumorTable.getColumn15(4), equals(RumorLocation.villageLastYearDuringEclipse));
      expect(RumorTable.getColumn15(5), equals(RumorLocation.villageLastYearDuringEclipse));
      expect(RumorTable.getColumn15(6), equals(RumorLocation.farmWhenSheepDisappeared));
      expect(RumorTable.getColumn15(7), equals(RumorLocation.farmWhenSheepDisappeared));
      expect(RumorTable.getColumn15(8), equals(RumorLocation.nearbyVillage));
      expect(RumorTable.getColumn15(9), equals(RumorLocation.nearbyVillage));
      expect(RumorTable.getColumn15(10), equals(RumorLocation.springTradeCaravan));
      expect(RumorTable.getColumn15(11), equals(RumorLocation.springTradeCaravan));
      expect(RumorTable.getColumn15(12), equals(RumorLocation.winterBlizzard3YearsAgo));
    });

    test('should throw ArgumentError for invalid rolls', () {
      expect(() => RumorTable.getColumn13(1), throwsArgumentError);
      expect(() => RumorTable.getColumn13(13), throwsArgumentError);
      expect(() => RumorTable.getColumn14(1), throwsArgumentError);
      expect(() => RumorTable.getColumn14(13), throwsArgumentError);
      expect(() => RumorTable.getColumn15(1), throwsArgumentError);
      expect(() => RumorTable.getColumn15(13), throwsArgumentError);
    });
  });
} 