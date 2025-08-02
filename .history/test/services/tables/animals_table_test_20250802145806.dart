// test/services/tables/animals_table_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tables/animals_table.dart';
import '../../../lib/enums/table_enums.dart';

void main() {
  group('AnimalsTable', () {
    late AnimalsTable table;

    setUp(() {
      table = AnimalsTable();
    });

    test('should have correct table properties', () {
      expect(table.tableName, equals('Tabela A13.2 - Animais'));
      expect(table.description, equals('Tabela de animais por terreno'));
      expect(table.columnCount, equals(4));
      expect(table.difficultyLevel, equals(DifficultyLevel.easy));
    });

    test('should return correct values for subterranean column', () {
      expect(table.getSubterranean(1), equals(MonsterType.bat));
      expect(table.getSubterranean(2), equals(MonsterType.spiderHunterGiant));
      expect(table.getSubterranean(3), equals(MonsterType.rat));
      expect(table.getSubterranean(4), equals(MonsterType.centipedeGiant));
      expect(table.getSubterranean(5), equals(MonsterType.fireBeetleGiant));
      expect(table.getSubterranean(6), equals(MonsterType.vampireBat));
    });

    test('should return correct values for plains column', () {
      expect(table.getPlains(1), equals(MonsterType.buffalo));
      expect(table.getPlains(2), equals(MonsterType.elephant));
      expect(table.getPlains(3), equals(MonsterType.lion));
      expect(table.getPlains(4), equals(MonsterType.rhinoceros));
      expect(table.getPlains(5), equals(MonsterType.boar));
      expect(table.getPlains(6), equals(MonsterType.eagle));
    });

    test('should return correct values for hills column', () {
      expect(table.getHills(1), equals(MonsterType.boar));
      expect(table.getHills(2), equals(MonsterType.fox));
      expect(table.getHills(3), equals(MonsterType.puma));
      expect(table.getHills(4), equals(MonsterType.bear));
      expect(table.getHills(5), equals(MonsterType.wolf));
      expect(table.getHills(6), equals(MonsterType.antGiant));
    });

    test('should return correct values for mountains column', () {
      expect(table.getMountains(1), equals(MonsterType.eagle));
      expect(table.getMountains(2), equals(MonsterType.cobraVenomous));
      expect(table.getMountains(3), equals(MonsterType.puma));
      expect(table.getMountains(4), equals(MonsterType.bearBlack));
      expect(table.getMountains(5), equals(MonsterType.antGiant));
      expect(table.getMountains(6), equals(MonsterType.antGiant));
    });

    test('should return correct values for swamps', () {
      expect(table.getSwamps(1), equals(MonsterType.buffalo));
      expect(table.getSwamps(2), equals(MonsterType.cobraConstrictor));
      expect(table.getSwamps(3), equals(MonsterType.crocodile));
      expect(table.getSwamps(4), equals(MonsterType.antGiant));
      expect(table.getSwamps(5), equals(MonsterType.flyGiant));
      expect(table.getSwamps(6), equals(MonsterType.blackSpiderGiant));
    });

    test('should return correct values for glaciers', () {
      expect(table.getGlaciers(1), equals(MonsterType.carcaju));
      expect(table.getGlaciers(2), equals(MonsterType.mammoth));
      expect(table.getGlaciers(3), equals(MonsterType.bearPolar));
      expect(table.getGlaciers(4), equals(MonsterType.carcaju));
      expect(table.getGlaciers(5), equals(MonsterType.mammoth));
      expect(table.getGlaciers(6), equals(MonsterType.bearPolar));
    });

    test('should return correct values for deserts', () {
      expect(table.getDeserts(1), equals(MonsterType.camel));
      expect(table.getDeserts(2), equals(MonsterType.cobraSpitter));
      expect(table.getDeserts(3), equals(MonsterType.puma));
      expect(table.getDeserts(4), equals(MonsterType.cobraVenomous));
      expect(table.getDeserts(5), equals(MonsterType.camouflagedSpiderGiant));
      expect(table.getDeserts(6), equals(MonsterType.scorpionGiant));
    });

    test('should return correct values for forests', () {
      expect(table.getForests(1), equals(MonsterType.eagle));
      expect(table.getForests(2), equals(MonsterType.carcaju));
      expect(table.getForests(3), equals(MonsterType.wolf));
      expect(table.getForests(4), equals(MonsterType.boar));
      expect(table.getForests(5), equals(MonsterType.bear));
      expect(table.getForests(6), equals(MonsterType.blackSpiderGiant));
    });

    test('should work with getByTerrain method', () {
      expect(table.getByTerrain(TerrainType.subterranean, 1), equals(MonsterType.bat));
      expect(table.getByTerrain(TerrainType.plains, 1), equals(MonsterType.buffalo));
      expect(table.getByTerrain(TerrainType.hills, 1), equals(MonsterType.boar));
      expect(table.getByTerrain(TerrainType.mountains, 1), equals(MonsterType.eagle));
      expect(table.getByTerrain(TerrainType.swamps, 1), equals(MonsterType.buffalo));
      expect(table.getByTerrain(TerrainType.glaciers, 1), equals(MonsterType.carcaju));
      expect(table.getByTerrain(TerrainType.deserts, 1), equals(MonsterType.camel));
      expect(table.getByTerrain(TerrainType.forests, 1), equals(MonsterType.eagle));
    });

    test('should throw error for invalid roll', () {
      expect(() => table.getSubterranean(0), throwsArgumentError);
      expect(() => table.getSubterranean(7), throwsArgumentError);
      expect(() => table.getPlains(0), throwsArgumentError);
      expect(() => table.getPlains(7), throwsArgumentError);
    });

    test('should return correct table info', () {
      final info = table.getTableInfo();
      expect(info, contains('Tabela A13.2 - Animais'));
      expect(info, contains('Tabela de animais por terreno'));
      expect(info, contains('4 colunas'));
      expect(info, contains('Fácil'));
    });
  });
} 