// test/services/tables/occupant_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/tables/occupant_table.dart';
import 'package:dungeon_forge/enums/dungeon_tables.dart';

void main() {
  group('OccupantTable', () {
    test('should handle all valid 2d6 rolls (2-12)', () {
      for (int roll = 2; roll <= 12; roll++) {
        expect(() => OccupantTable.getColumn10(roll), returnsNormally);
        expect(() => OccupantTable.getColumn11(roll), returnsNormally);
        expect(() => OccupantTable.getColumn12(roll), returnsNormally);
      }
    });

    test('should return correct values for column 10', () {
      expect(OccupantTable.getColumn10(2), equals(DungeonOccupant.trolls));
      expect(OccupantTable.getColumn10(3), equals(DungeonOccupant.trolls));
      expect(OccupantTable.getColumn10(4), equals(DungeonOccupant.orcs));
      expect(OccupantTable.getColumn10(5), equals(DungeonOccupant.orcs));
      expect(OccupantTable.getColumn10(6), equals(DungeonOccupant.skeletons));
      expect(OccupantTable.getColumn10(7), equals(DungeonOccupant.skeletons));
      expect(OccupantTable.getColumn10(8), equals(DungeonOccupant.goblins));
      expect(OccupantTable.getColumn10(9), equals(DungeonOccupant.goblins));
      expect(OccupantTable.getColumn10(10), equals(DungeonOccupant.bugbears));
      expect(OccupantTable.getColumn10(11), equals(DungeonOccupant.bugbears));
      expect(OccupantTable.getColumn10(12), equals(DungeonOccupant.ogres));
    });

    test('should return correct values for column 11', () {
      expect(OccupantTable.getColumn11(2), equals(DungeonOccupant.kobolds));
      expect(OccupantTable.getColumn11(3), equals(DungeonOccupant.kobolds));
      expect(OccupantTable.getColumn11(4), equals(DungeonOccupant.grayOoze));
      expect(OccupantTable.getColumn11(5), equals(DungeonOccupant.grayOoze));
      expect(OccupantTable.getColumn11(6), equals(DungeonOccupant.zombies));
      expect(OccupantTable.getColumn11(7), equals(DungeonOccupant.zombies));
      expect(OccupantTable.getColumn11(8), equals(DungeonOccupant.giantRats));
      expect(OccupantTable.getColumn11(9), equals(DungeonOccupant.giantRats));
      expect(OccupantTable.getColumn11(10), equals(DungeonOccupant.pygmyFungi));
      expect(OccupantTable.getColumn11(11), equals(DungeonOccupant.pygmyFungi));
      expect(OccupantTable.getColumn11(12), equals(DungeonOccupant.lizardMen));
    });

    test('should return correct values for column 12', () {
      expect(OccupantTable.getColumn12(2), equals(DungeonOccupant.hobgoblin));
      expect(OccupantTable.getColumn12(3), equals(DungeonOccupant.hobgoblin));
      expect(OccupantTable.getColumn12(4), equals(DungeonOccupant.gelatinousCube));
      expect(OccupantTable.getColumn12(5), equals(DungeonOccupant.gelatinousCube));
      expect(OccupantTable.getColumn12(6), equals(DungeonOccupant.cultist));
      expect(OccupantTable.getColumn12(7), equals(DungeonOccupant.cultist));
      expect(OccupantTable.getColumn12(8), equals(DungeonOccupant.shadow));
      expect(OccupantTable.getColumn12(9), equals(DungeonOccupant.shadow));
      expect(OccupantTable.getColumn12(10), equals(DungeonOccupant.necromancer));
      expect(OccupantTable.getColumn12(11), equals(DungeonOccupant.necromancer));
      expect(OccupantTable.getColumn12(12), equals(DungeonOccupant.dragon));
    });

    test('should throw ArgumentError for invalid rolls', () {
      expect(() => OccupantTable.getColumn10(1), throwsArgumentError);
      expect(() => OccupantTable.getColumn10(13), throwsArgumentError);
      expect(() => OccupantTable.getColumn11(1), throwsArgumentError);
      expect(() => OccupantTable.getColumn11(13), throwsArgumentError);
      expect(() => OccupantTable.getColumn12(1), throwsArgumentError);
      expect(() => OccupantTable.getColumn12(13), throwsArgumentError);
    });
  });
} 