// tables/base_table.dart

/// Classe base abstrata para todas as tabelas do sistema
///
/// Esta classe define o padrão para implementação de tabelas,
/// garantindo consistência e facilitando a manutenção.
abstract class BaseTable<T> {
  /// Nome da tabela (ex: "Tabela 9.1 - Geração de Masmorras")
  String get tableName;

  /// Descrição da tabela
  String get description;

  /// Número de colunas na tabela
  int get columnCount;

  /// Lista de dados para cada coluna
  List<List<T>> get columns;

  /// Obtém o resultado de uma coluna específica baseado no roll
  ///
  /// [columnIndex] - Índice da coluna (1-based)
  /// [roll] - Resultado do roll (2-12 para 2d6)
  ///
  /// Retorna o valor correspondente à coluna e roll
  T getColumnValue(int columnIndex, int roll) {
    if (columnIndex < 1 || columnIndex > columnCount) {
      throw ArgumentError('Índice da coluna deve estar entre 1 e $columnCount');
    }

    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12');
    }

    final column = columns[columnIndex - 1];
    return column[roll - 2];
  }

  /// Obtém todos os valores possíveis de uma coluna
  ///
  /// [columnIndex] - Índice da coluna (1-based)
  List<T> getColumnValues(int columnIndex) {
    if (columnIndex < 1 || columnIndex > columnCount) {
      throw ArgumentError('Índice da coluna deve estar entre 1 e $columnCount');
    }

    return columns[columnIndex - 1];
  }

  /// Obtém informações sobre a tabela
  String getTableInfo() {
    return '''
Tabela: $tableName
Descrição: $description
Colunas: $columnCount
Roll: 2d6 (2-12)
''';
  }
}

/// Interface para tabelas que possuem métodos específicos por coluna
abstract class TableWithColumnMethods<T> extends BaseTable<T> {
  /// Obtém o resultado da coluna 1 baseado no roll
  T getColumn1(int roll) => getColumnValue(1, roll);

  /// Obtém o resultado da coluna 2 baseado no roll
  T getColumn2(int roll) => getColumnValue(2, roll);

  /// Obtém o resultado da coluna 3 baseado no roll
  T getColumn3(int roll) => getColumnValue(3, roll);

  /// Obtém o resultado da coluna 4 baseado no roll
  T getColumn4(int roll) => getColumnValue(4, roll);

  /// Obtém o resultado da coluna 5 baseado no roll
  T getColumn5(int roll) => getColumnValue(5, roll);

  /// Obtém o resultado da coluna 6 baseado no roll
  T getColumn6(int roll) => getColumnValue(6, roll);

  /// Obtém o resultado da coluna 7 baseado no roll
  T getColumn7(int roll) => getColumnValue(7, roll);

  /// Obtém o resultado da coluna 8 baseado no roll
  T getColumn8(int roll) => getColumnValue(8, roll);

  /// Obtém o resultado da coluna 9 baseado no roll
  T getColumn9(int roll) => getColumnValue(9, roll);

  /// Obtém o resultado da coluna 10 baseado no roll
  T getColumn10(int roll) => getColumnValue(10, roll);

  /// Obtém o resultado da coluna 11 baseado no roll
  T getColumn11(int roll) => getColumnValue(11, roll);

  /// Obtém o resultado da coluna 12 baseado no roll
  T getColumn12(int roll) => getColumnValue(12, roll);

  /// Obtém o resultado da coluna 13 baseado no roll
  T getColumn13(int roll) => getColumnValue(13, roll);

  /// Obtém o resultado da coluna 14 baseado no roll
  T getColumn14(int roll) => getColumnValue(14, roll);

  /// Obtém o resultado da coluna 15 baseado no roll
  T getColumn15(int roll) => getColumnValue(15, roll);
}

/// Classe base para tabelas de monstros que suporta diferentes tipos de dados
abstract class MonsterTable<T> extends BaseTable<T> {
  /// Nível de dificuldade da tabela
  DifficultyLevel get difficultyLevel;
  
  /// Tipo de terreno da tabela
  TerrainType get terrainType;
  
  /// Número de lados do dado usado
  int get diceSides => difficultyLevel.diceSides;
  
  /// Range mínimo do dado
  int get minRoll => 1;
  
  /// Range máximo do dado
  int get maxRoll => diceSides;
  
  @override
  T getColumnValue(int columnIndex, int roll) {
    if (columnIndex < 1 || columnIndex > columnCount) {
      throw ArgumentError('Índice da coluna deve estar entre 1 e $columnCount');
    }

    if (roll < minRoll || roll > maxRoll) {
      throw ArgumentError('Roll deve estar entre $minRoll e $maxRoll');
    }

    final column = columns[columnIndex - 1];
    return column[roll - minRoll];
  }
  
  @override
  String getTableInfo() {
    return '''
Tabela: $tableName
Descrição: $description
Terreno: ${terrainType.description}
Dificuldade: ${difficultyLevel.description} (1d$diceSides)
Colunas: $columnCount
Roll: 1d$diceSides ($minRoll-$maxRoll)
''';
  }
}
