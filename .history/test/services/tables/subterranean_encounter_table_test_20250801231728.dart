// test/services/tables/subterranean_encounter_table_test.dart

import 'package:dungeon_forge/enums/table_enums.dart';
import 'package:dungeon_forge/tables/subterranean_encounter_table.dart';
import 'package:test/test.dart';

void main() {
  group('SubterraneanEncounterTable', () {
    late SubterraneanEncounterTable table;

    setUp(() {
      table = SubterraneanEncounterTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, 'Tabela A13.1 - Encontros no Subterrâneo');
      expect(table.description, 'Tabela de encontros para masmorras e cavernas');
      expect(table.columnCount, 3);
      expect(table.difficultyLevel, DifficultyLevel.challenging);
      expect(table.terrainType, TerrainType.subterranean);
      expect(table.diceSides, 12);
      expect(table.minRoll, 1);
      expect(table.maxRoll, 12);
    });

    test('should return correct values for beginners column', () {
      expect(table.getColumn1(1), TableReference.animalsTable);
      expect(table.getColumn1(2), MonsterType.giantRat);
      expect(table.getColumn1(3), MonsterType.kobold);
      expect(table.getColumn1(4), TableReference.anyTableI);
      expect(table.getColumn1(5), TableReference.humansTable);
      expect(table.getColumn1(6), MonsterType.pygmyFungus);
      expect(table.getColumn1(7), TableReference.extraplanarTableI);
      expect(table.getColumn1(8), MonsterType.violetFungus);
      expect(table.getColumn1(9), MonsterType.drowElf);
      expect(table.getColumn1(10), MonsterType.bugbear);
      expect(table.getColumn1(11), MonsterType.otyugh);
      expect(table.getColumn1(12), MonsterType.youngBoneDragon);
    });

    test('should return correct values for heroic column', () {
      expect(table.getColumn2(1), TableReference.animalsTable);
      expect(table.getColumn2(2), MonsterType.troglodyte);
      expect(table.getColumn2(3), MonsterType.thoul);
      expect(table.getColumn2(4), TableReference.anyTableII);
      expect(table.getColumn2(5), TableReference.humansTable);
      expect(table.getColumn2(6), MonsterType.derro);
      expect(table.getColumn2(7), TableReference.extraplanarTableII);
      expect(table.getColumn2(8), MonsterType.grayOoze);
      expect(table.getColumn2(9), MonsterType.carrionWorm);
      expect(table.getColumn2(10), MonsterType.gelatinousCube);
      expect(table.getColumn2(11), TableReference.anyTableIII);
      expect(table.getColumn2(12), MonsterType.boneDragon);
    });

    test('should return correct values for advanced column', () {
      expect(table.getColumn3(1), TableReference.animalsTable);
      expect(table.getColumn3(2), MonsterType.shriekerFungus);
      expect(table.getColumn3(3), MonsterType.ochreJelly);
      expect(table.getColumn3(4), MonsterType.rustMonster);
      expect(table.getColumn3(5), TableReference.humansTable);
      expect(table.getColumn3(6), MonsterType.maceTail);
      expect(table.getColumn3(7), TableReference.extraplanarTableIII);
      expect(table.getColumn3(8), MonsterType.drider);
      expect(table.getColumn3(9), MonsterType.brainDevourer);
      expect(table.getColumn3(10), MonsterType.roper);
      expect(table.getColumn3(11), MonsterType.beholder);
      expect(table.getColumn3(12), MonsterType.oldBoneDragon);
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getColumn1(0), throwsArgumentError);
      expect(() => table.getColumn1(13), throwsArgumentError);
    });

    test('should throw error for invalid column', () {
      expect(() => table.getColumnValue(0, 1), throwsArgumentError);
      expect(() => table.getColumnValue(4, 1), throwsArgumentError);
    });

    test('should return correct column values', () {
      final column1Values = table.getColumnValues(1);
      expect(column1Values.length, 12);
      expect(column1Values[0], TableReference.animalsTable);
      expect(column1Values[11], MonsterType.youngBoneDragon);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.1 - Encontros no Subterrâneo'));
      expect(info, contains('Desafiador (1d12)'));
      expect(info, contains('Subterrâneo'));
    });
  });
} 