// tables/table_manager.dart

import 'base_table.dart';
import 'dungeon_table.dart';
import 'room_table.dart';

/// Gerenciador centralizado de tabelas
///
/// Esta classe fornece acesso unificado a todas as tabelas do sistema,
/// facilitando a manutenção e adição de novas tabelas.
class TableManager {
  static final TableManager _instance = TableManager._internal();
  factory TableManager() => _instance;
  TableManager._internal();

  // Instâncias das tabelas
  final DungeonTable _dungeonTable = DungeonTable();
  final RoomTable _roomTable = RoomTable();

  /// Obtém a tabela de masmorras (Tabela 9.1)
  DungeonTable get dungeonTable => _dungeonTable;

  /// Obtém a tabela de salas (Tabela 9.2)
  RoomTable get roomTable => _roomTable;

  /// Lista todas as tabelas disponíveis
  List<BaseTable> get allTables => [
        _dungeonTable,
        _roomTable,
      ];

  /// Obtém uma tabela pelo nome
  BaseTable? getTableByName(String tableName) {
    for (final table in allTables) {
      if (table.tableName == tableName) {
        return table;
      }
    }
    return null;
  }

  /// Obtém informações de todas as tabelas
  String getAllTablesInfo() {
    final buffer = StringBuffer();
    buffer.writeln('=== TABELAS DISPONÍVEIS ===\n');

    for (final table in allTables) {
      buffer.writeln(table.getTableInfo());
      buffer.writeln('---');
    }

    return buffer.toString();
  }

  /// Verifica se uma tabela existe pelo nome
  bool hasTable(String tableName) {
    return getTableByName(tableName) != null;
  }

  /// Obtém a lista de nomes de todas as tabelas
  List<String> get tableNames =>
      allTables.map((table) => table.tableName).toList();
}
