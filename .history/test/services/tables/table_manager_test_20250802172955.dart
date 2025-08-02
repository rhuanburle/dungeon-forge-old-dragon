// test/services/tables/table_manager_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../../lib/tables/table_manager.dart';

void main() {
  group('TableManager', () {
    test('should be a singleton', () {
      final instance1 = TableManager();
      final instance2 = TableManager();
      expect(identical(instance1, instance2), isTrue);
    });

    test('should have all expected tables', () {
      final manager = TableManager();
      final tables = manager.allTables;

      expect(tables, isNotEmpty);
      expect(tables.length, equals(16)); // Agora temos 16 tabelas

      // Verificar se todas as tabelas têm nomes únicos
      final tableNames = tables.map((table) => table.tableName).toSet();
      expect(tableNames.length, equals(16));
    });

    test('should return correct number of tables', () {
      final manager = TableManager();
      expect(manager.allTables.length, equals(15)); // Atualizado para 15
    });

    test('should return table names', () {
      final manager = TableManager();
      final names = manager.tableNames;
      expect(names.length, equals(15)); // Atualizado para 15
      expect(names, contains('Tabela 9.1 - Geração de Masmorras'));
      expect(names, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
      expect(names, contains('Tabela A13.1 - Encontros no Subterrâneo'));
      expect(names, contains('Tabela A13.2 - Encontros em Planícies'));
      expect(names, contains('Tabela A13.2 - Animais'));
      expect(names, contains('Tabela A13.11 - Humanos e Semi-Humanos'));
      expect(names, contains('Tabela A13.10 - Encontros Extraplanares'));
      expect(names, contains('Tabela A13.9 - Encontros em Qualquer Habitat'));
    });

    test('should find table by name', () {
      final manager = TableManager();
      final table = manager.getTableByName('Tabela 9.1 - Geração de Masmorras');
      expect(table, isNotNull);
      expect(table!.tableName, equals('Tabela 9.1 - Geração de Masmorras'));
    });

    test('should return null for non-existent table', () {
      final manager = TableManager();
      final table = manager.getTableByName('Tabela Inexistente');
      expect(table, isNull);
    });

    test('should check if table exists', () {
      final manager = TableManager();
      expect(manager.hasTable('Tabela 9.1 - Geração de Masmorras'), isTrue);
      expect(manager.hasTable('Tabela Inexistente'), isFalse);
    });

    test('should get all tables info', () {
      final manager = TableManager();
      final info = manager.getAllTablesInfo();
      expect(info, isNotEmpty);
      expect(info, contains('Tabela 9.1 - Geração de Masmorras'));
      expect(info, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
      expect(info, contains('Tabela A13.1 - Encontros no Subterrâneo'));
      expect(info, contains('Tabela A13.2 - Encontros em Planícies'));
    });

    test('should work with monster encounter tables', () {
      final manager = TableManager();

      // Testar tabelas de encontros
      expect(manager.subterraneanEncounterTable, isNotNull);
      expect(manager.plainsEncounterTable, isNotNull);
      expect(manager.animalsTable, isNotNull);
      expect(manager.humansTable, isNotNull);
      expect(manager.extraplanarTable, isNotNull);
      expect(manager.anyHabitatTable, isNotNull);

      // Verificar se as tabelas têm as propriedades corretas
      expect(
        manager.subterraneanEncounterTable.tableName,
        equals('Tabela A13.1 - Encontros no Subterrâneo'),
      );
      expect(
        manager.plainsEncounterTable.tableName,
        equals('Tabela A13.2 - Encontros em Planícies'),
      );
      expect(manager.animalsTable.tableName, equals('Tabela A13.2 - Animais'));
      expect(
        manager.humansTable.tableName,
        equals('Tabela A13.11 - Humanos e Semi-Humanos'),
      );
      expect(
        manager.extraplanarTable.tableName,
        equals('Tabela A13.10 - Encontros Extraplanares'),
      );
      expect(
        manager.anyHabitatTable.tableName,
        equals('Tabela A13.9 - Encontros em Qualquer Habitat'),
      );
    });
  });
}
