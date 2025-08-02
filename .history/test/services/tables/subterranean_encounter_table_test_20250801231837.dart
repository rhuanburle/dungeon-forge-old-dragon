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
      expect(table.getBeginners(1), TableReference.animalsTable);
      expect(table.getBeginners(2), MonsterType.giantRat);
      expect(table.getBeginners(3), MonsterType.kobold);
      expect(table.getBeginners(4), TableReference.anyTableI);
      expect(table.getBeginners(5), TableReference.humansTable);
      expect(table.getBeginners(6), MonsterType.pygmyFungus);
      expect(table.getBeginners(7), TableReference.extraplanarTableI);
      expect(table.getBeginners(8), MonsterType.violetFungus);
      expect(table.getBeginners(9), MonsterType.drowElf);
      expect(table.getBeginners(10), MonsterType.bugbear);
      expect(table.getBeginners(11), MonsterType.otyugh);
      expect(table.getBeginners(12), MonsterType.youngBoneDragon);
    });

    test('should return correct values for heroic column', () {
      expect(table.getHeroic(1), TableReference.animalsTable);
      expect(table.getHeroic(2), MonsterType.troglodyte);
      expect(table.getHeroic(3), MonsterType.thoul);
      expect(table.getHeroic(4), TableReference.anyTableII);
      expect(table.getHeroic(5), TableReference.humansTable);
      expect(table.getHeroic(6), MonsterType.derro);
      expect(table.getHeroic(7), TableReference.extraplanarTableII);
      expect(table.getHeroic(8), MonsterType.grayOoze);
      expect(table.getHeroic(9), MonsterType.carrionWorm);
      expect(table.getHeroic(10), MonsterType.gelatinousCube);
      expect(table.getHeroic(11), TableReference.anyTableIII);
      expect(table.getHeroic(12), MonsterType.boneDragon);
    });

    test('should return correct values for advanced column', () {
      expect(table.getAdvanced(1), TableReference.animalsTable);
      expect(table.getAdvanced(2), MonsterType.shriekerFungus);
      expect(table.getAdvanced(3), MonsterType.ochreJelly);
      expect(table.getAdvanced(4), MonsterType.rustMonster);
      expect(table.getAdvanced(5), TableReference.humansTable);
      expect(table.getAdvanced(6), MonsterType.maceTail);
      expect(table.getAdvanced(7), TableReference.extraplanarTableIII);
      expect(table.getAdvanced(8), MonsterType.drider);
      expect(table.getAdvanced(9), MonsterType.brainDevourer);
      expect(table.getAdvanced(10), MonsterType.roper);
      expect(table.getAdvanced(11), MonsterType.beholder);
      expect(table.getAdvanced(12), MonsterType.oldBoneDragon);
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