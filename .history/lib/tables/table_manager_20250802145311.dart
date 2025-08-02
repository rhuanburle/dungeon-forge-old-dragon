// tables/table_manager.dart

import 'base_table.dart';
import 'dungeon_table.dart';
import 'room_table.dart';
import 'rumor_table.dart';
import 'occupant_table.dart';
import 'subterranean_encounter_table.dart';
import 'plains_encounter_table.dart';
import 'animals_table.dart';
import 'humans_table.dart';
import 'extraplanar_table.dart';
import 'any_habitat_table.dart';

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
  final RumorTable _rumorTable = RumorTable();
  final OccupantTable _occupantTable = OccupantTable();
  final SubterraneanEncounterTable _subterraneanEncounterTable =
      SubterraneanEncounterTable();
  final PlainsEncounterTable _plainsEncounterTable = PlainsEncounterTable();
  final AnimalsTable _animalsTable = AnimalsTable();
  final HumansTable _humansTable = HumansTable();
  final ExtraplanarTable _extraplanarTable = ExtraplanarTable();
  final AnyHabitatTable _anyHabitatTable = AnyHabitatTable();

  /// Obtém a tabela de masmorras (Tabela 9.1)
  DungeonTable get dungeonTable => _dungeonTable;

  /// Obtém a tabela de salas (Tabela 9.2)
  RoomTable get roomTable => _roomTable;

  /// Obtém a tabela de rumores (Colunas 13-15 da Tabela 9.1)
  RumorTable get rumorTable => _rumorTable;

  /// Obtém a tabela de ocupantes (Colunas 10-12 da Tabela 9.1)
  OccupantTable get occupantTable => _occupantTable;

  /// Obtém a tabela de encontros subterrâneos (Tabela A13.1)
  SubterraneanEncounterTable get subterraneanEncounterTable =>
      _subterraneanEncounterTable;

  /// Obtém a tabela de encontros em planícies (Tabela A13.2)
  PlainsEncounterTable get plainsEncounterTable => _plainsEncounterTable;

  /// Obtém a tabela de animais (Tabela A13.2)
  AnimalsTable get animalsTable => _animalsTable;

  /// Obtém a tabela de humanos e semi-humanos (Tabela A13.11)
  HumansTable get humansTable => _humansTable;

  /// Obtém a tabela de encontros extraplanares (Tabela A13.10)
  ExtraplanarTable get extraplanarTable => _extraplanarTable;

  /// Obtém a tabela de encontros em qualquer habitat (Tabela A13.9)
  AnyHabitatTable get anyHabitatTable => _anyHabitatTable;

  /// Lista todas as tabelas disponíveis
  List<BaseTable> get allTables => [
        _dungeonTable,
        _roomTable,
        _rumorTable,
        _occupantTable,
        _subterraneanEncounterTable,
        _plainsEncounterTable,
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
