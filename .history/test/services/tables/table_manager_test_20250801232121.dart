// test/services/tables/table_manager_test.dart

import '../../../lib/tables/table_manager.dart';
import '../../../lib/enums/table_enums.dart';
import 'package:test/test.dart';

void main() {
  group('TableManager', () {
    late TableManager manager;

    setUp(() {
      manager = TableManager();
    });

    test('should be a singleton', () {
      final instance1 = TableManager();
      final instance2 = TableManager();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should have all expected tables', () {
      expect(manager.dungeonTable, isNotNull);
      expect(manager.roomTable, isNotNull);
      expect(manager.rumorTable, isNotNull);
      expect(manager.occupantTable, isNotNull);
      expect(manager.subterraneanEncounterTable, isNotNull);
      expect(manager.plainsEncounterTable, isNotNull);
    });

    test('should return correct number of tables', () {
      expect(manager.allTables.length, 6);
    });

    test('should return table names', () {
      final names = manager.tableNames;
      expect(names.length, 6);
      expect(names, contains('Tabela 9.1 - Geração de Masmorras'));
      expect(names, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
      expect(names, contains('Tabela A13.1 - Encontros no Subterrâneo'));
      expect(names, contains('Tabela A13.2 - Encontros em Planícies'));
    });

    test('should find table by name', () {
      final dungeonTable = manager.getTableByName('Tabela 9.1 - Geração de Masmorras');
      expect(dungeonTable, isNotNull);
      expect(dungeonTable!.tableName, 'Tabela 9.1 - Geração de Masmorras');

      final subterraneanTable = manager.getTableByName('Tabela A13.1 - Encontros no Subterrâneo');
      expect(subterraneanTable, isNotNull);
      expect(subterraneanTable!.tableName, 'Tabela A13.1 - Encontros no Subterrâneo');
    });

    test('should return null for non-existent table', () {
      final table = manager.getTableByName('Tabela Inexistente');
      expect(table, isNull);
    });

    test('should check if table exists', () {
      expect(manager.hasTable('Tabela 9.1 - Geração de Masmorras'), isTrue);
      expect(manager.hasTable('Tabela A13.1 - Encontros no Subterrâneo'), isTrue);
      expect(manager.hasTable('Tabela Inexistente'), isFalse);
    });

    test('should get all tables info', () {
      final info = manager.getAllTablesInfo();
      expect(info, contains('Tabela 9.1 - Geração de Masmorras'));
      expect(info, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
      expect(info, contains('Tabela A13.1 - Encontros no Subterrâneo'));
      expect(info, contains('Tabela A13.2 - Encontros em Planícies'));
    });

    test('should work with monster encounter tables', () {
      // Teste da tabela subterrânea
      final subterraneanTable = manager.subterraneanEncounterTable;
      expect(subterraneanTable.getBeginners(2), MonsterType.giantRat);
      expect(subterraneanTable.getHeroic(2), MonsterType.troglodyte);
      expect(subterraneanTable.getAdvanced(2), MonsterType.shriekerFungus);

      // Teste da tabela de planícies
      final plainsTable = manager.plainsEncounterTable;
      expect(plainsTable.getBeginners(2), MonsterType.gnoll);
      expect(plainsTable.getHeroic(2), MonsterType.hellhound);
      expect(plainsTable.getAdvanced(2), MonsterType.troll);

      // Teste do método getByPartyLevel
      expect(subterraneanTable.getByPartyLevel(PartyLevel.beginners, 2), MonsterType.giantRat);
      expect(plainsTable.getByPartyLevel(PartyLevel.advanced, 2), MonsterType.troll);
    });
  });
} 