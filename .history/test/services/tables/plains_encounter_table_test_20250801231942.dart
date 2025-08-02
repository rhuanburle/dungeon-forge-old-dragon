// test/services/tables/plains_encounter_table_test.dart

import '../../../lib/enums/table_enums.dart';
import '../../../lib/tables/plains_encounter_table.dart';
import 'package:test/test.dart';

void main() {
  group('PlainsEncounterTable', () {
    late PlainsEncounterTable table;

    setUp(() {
      table = PlainsEncounterTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, 'Tabela A13.2 - Encontros em Planícies');
      expect(table.description, 'Tabela de encontros para planícies e campos abertos');
      expect(table.columnCount, 3);
      expect(table.difficultyLevel, DifficultyLevel.challenging);
      expect(table.terrainType, TerrainType.plains);
      expect(table.diceSides, 12);
      expect(table.minRoll, 1);
      expect(table.maxRoll, 12);
    });

    test('should return correct values for beginners column', () {
      expect(table.getBeginners(1), TableReference.animalsTable);
      expect(table.getBeginners(2), MonsterType.gnoll);
      expect(table.getBeginners(3), MonsterType.goblin);
      expect(table.getBeginners(4), TableReference.anyTableI);
      expect(table.getBeginners(5), TableReference.humansTable);
      expect(table.getBeginners(6), MonsterType.lizardMan);
      expect(table.getBeginners(7), TableReference.extraplanarTableI);
      expect(table.getBeginners(8), MonsterType.orc);
      expect(table.getBeginners(9), MonsterType.hellhound);
      expect(table.getBeginners(10), MonsterType.ogre);
      expect(table.getBeginners(11), TableReference.anyTableII);
      expect(table.getBeginners(12), MonsterType.youngBlueDragon);
    });

    test('should return correct values for heroic column', () {
      expect(table.getHeroic(1), TableReference.animalsTable);
      expect(table.getHeroic(2), MonsterType.hellhound);
      expect(table.getHeroic(3), MonsterType.insectSwarm);
      expect(table.getHeroic(4), TableReference.anyTableII);
      expect(table.getHeroic(5), TableReference.humansTable);
      expect(table.getHeroic(6), MonsterType.oniMage);
      expect(table.getHeroic(7), TableReference.extraplanarTableII);
      expect(table.getHeroic(8), MonsterType.troll);
      expect(table.getHeroic(9), MonsterType.basilisk);
      expect(table.getHeroic(10), MonsterType.gorgon);
      expect(table.getHeroic(11), TableReference.anyTableIII);
      expect(table.getHeroic(12), MonsterType.blueDragon);
    });

    test('should return correct values for advanced column', () {
      expect(table.getAdvanced(1), TableReference.animalsTable);
      expect(table.getAdvanced(2), MonsterType.troll);
      expect(table.getAdvanced(3), MonsterType.gorgon);
      expect(table.getAdvanced(4), TableReference.anyTableIII);
      expect(table.getAdvanced(5), TableReference.humansTable);
      expect(table.getAdvanced(6), MonsterType.treant);
      expect(table.getAdvanced(7), TableReference.extraplanarTableIII);
      expect(table.getAdvanced(8), MonsterType.chimera);
      expect(table.getAdvanced(9), MonsterType.bulette);
      expect(table.getAdvanced(10), MonsterType.sphinx);
      expect(table.getAdvanced(11), MonsterType.cyclops);
      expect(table.getAdvanced(12), MonsterType.oldBlueDragon);
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getBeginners(0), throwsArgumentError);
      expect(() => table.getBeginners(13), throwsArgumentError);
    });

    test('should throw error for invalid column', () {
      expect(() => table.getColumnValue(0, 1), throwsArgumentError);
      expect(() => table.getColumnValue(4, 1), throwsArgumentError);
    });

    test('should return correct column values', () {
      final column1Values = table.getColumnValues(1);
      expect(column1Values.length, 12);
      expect(column1Values[0], TableReference.animalsTable);
      expect(column1Values[11], MonsterType.youngBlueDragon);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.2 - Encontros em Planícies'));
      expect(info, contains('Desafiador (1d12)'));
      expect(info, contains('Planícies'));
    });

    test('should work with getByPartyLevel method', () {
      expect(table.getByPartyLevel(PartyLevel.beginners, 2), MonsterType.gnoll);
      expect(table.getByPartyLevel(PartyLevel.heroic, 2), MonsterType.hellhound);
      expect(table.getByPartyLevel(PartyLevel.advanced, 2), MonsterType.troll);
    });
  });
} 