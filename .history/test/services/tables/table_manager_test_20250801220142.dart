// test/services/tables/table_manager_test.dart

import 'package:test/test.dart';
import '../../../lib/tables/table_manager.dart';
import '../../../lib/tables/base_table.dart';

void main() {
  group('TableManager', () {
    late TableManager tableManager;

    setUp(() {
      tableManager = TableManager();
    });

    group('singleton pattern', () {
      test('should return the same instance', () {
        final instance1 = TableManager();
        final instance2 = TableManager();
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('table access', () {
      test('should provide access to dungeon table', () {
        expect(tableManager.dungeonTable, isNotNull);
        expect(tableManager.dungeonTable.tableName,
            equals('Tabela 9.1 - Geração de Masmorras'));
      });

      test('should provide access to room table', () {
        expect(tableManager.roomTable, isNotNull);
        expect(tableManager.roomTable.tableName,
            equals('Tabela 9.2 - Salas e Câmaras de Masmorras'));
      });

      test('should provide access to rumor table', () {
        expect(tableManager.rumorTable, isNotNull);
        expect(tableManager.rumorTable.tableName,
            equals('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'));
      });

      test('should provide access to occupant table', () {
        expect(tableManager.occupantTable, isNotNull);
        expect(tableManager.occupantTable.tableName,
            equals('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'));
      });
    });

    group('allTables', () {
      test('should return all available tables', () {
        final tables = tableManager.allTables;
        expect(tables.length, equals(4));

        final tableNames = tables.map((table) => table.tableName).toList();
        expect(tableNames, contains('Tabela 9.1 - Geração de Masmorras'));
        expect(
            tableNames, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
        expect(tableNames,
            contains('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'));
        expect(tableNames,
            contains('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'));
      });
    });

    group('getTableByName', () {
      test('should return table by name', () {
        final dungeonTable =
            tableManager.getTableByName('Tabela 9.1 - Geração de Masmorras');
        expect(dungeonTable, isNotNull);
        expect(dungeonTable!.tableName,
            equals('Tabela 9.1 - Geração de Masmorras'));
      });

      test('should return null for non-existent table', () {
        final nonExistentTable =
            tableManager.getTableByName('Non-existent Table');
        expect(nonExistentTable, isNull);
      });
    });

    group('hasTable', () {
      test('should return true for existing table', () {
        expect(
            tableManager.hasTable('Tabela 9.1 - Geração de Masmorras'), isTrue);
        expect(
            tableManager.hasTable('Tabela 9.2 - Salas e Câmaras de Masmorras'),
            isTrue);
        expect(
            tableManager
                .hasTable('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'),
            isTrue);
        expect(
            tableManager
                .hasTable('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'),
            isTrue);
      });

      test('should return false for non-existent table', () {
        expect(tableManager.hasTable('Non-existent Table'), isFalse);
      });
    });

    group('tableNames', () {
      test('should return all table names', () {
        final names = tableManager.tableNames;
        expect(names.length, equals(4));
        expect(names, contains('Tabela 9.1 - Geração de Masmorras'));
        expect(names, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
        expect(
            names, contains('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'));
        expect(names,
            contains('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'));
      });
    });

    group('getAllTablesInfo', () {
      test('should return formatted information about all tables', () {
        final info = tableManager.getAllTablesInfo();
        expect(info, isA<String>());
        expect(info, contains('=== TABELAS DISPONÍVEIS ==='));
        expect(info, contains('Tabela 9.1 - Geração de Masmorras'));
        expect(info, contains('Tabela 9.2 - Salas e Câmaras de Masmorras'));
        expect(
            info, contains('Tabela de Rumores (Colunas 13-15 da Tabela 9.1)'));
        expect(info,
            contains('Tabela de Ocupantes (Colunas 10-12 da Tabela 9.1)'));
      });
    });
  });
}
