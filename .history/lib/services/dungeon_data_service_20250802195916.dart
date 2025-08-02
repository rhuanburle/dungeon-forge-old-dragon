// services/dungeon_data_service.dart

import '../enums/table_enums.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../tables/table_manager.dart';
import '../tables/base_table.dart';
import '../utils/dice_roller.dart';

/// Serviço responsável por gerar dados da masmorra usando a Tabela 9.1
class DungeonDataService {
  final TableManager _tableManager = TableManager();

  /// Gera os dados da masmorra usando a Tabela 9.1
  DungeonGenerationDto generateDungeonData({
    int? level,
    TerrainType? terrainType,
    DifficultyLevel? difficultyLevel,
    PartyLevel? partyLevel,
    bool useEncounterTables = false,
  }) {
    final dungeonTable = _tableManager.dungeonTable;

    // Rolagem de 2d6 para cada coluna da Tabela 9.1
    final col1Roll = DiceRoller.rollStatic(2, 6);
    final col2Roll = DiceRoller.rollStatic(2, 6);
    final col3Roll = DiceRoller.rollStatic(2, 6);
    final col4Roll = DiceRoller.rollStatic(2, 6);
    final col5Roll = DiceRoller.rollStatic(2, 6);
    final col6Roll = DiceRoller.rollStatic(2, 6);
    final col7Roll = DiceRoller.rollStatic(2, 6);
    final col8Roll = DiceRoller.rollStatic(2, 6);
    final col9Roll = DiceRoller.rollStatic(2, 6);
    final col10Roll = DiceRoller.rollStatic(2, 6);
    final col11Roll = DiceRoller.rollStatic(2, 6);
    final col12Roll = DiceRoller.rollStatic(2, 6);
    final col13Roll = DiceRoller.rollStatic(2, 6);
    final col14Roll = DiceRoller.rollStatic(2, 6);
    final col15Roll = DiceRoller.rollStatic(2, 6);

    // Obtém os valores das tabelas
    final type = dungeonTable.getColumn1(col1Roll);
    final builderOrInhabitant = dungeonTable.getColumn2(col2Roll);
    final status = dungeonTable.getColumn3(col3Roll);
    final objective = dungeonTable.getColumn4(col4Roll);
    final target = dungeonTable.getColumn5(col5Roll);
    final targetStatus = dungeonTable.getColumn6(col6Roll);
    final location = dungeonTable.getColumn7(col7Roll);
    final entry = dungeonTable.getColumn8(col8Roll);
    final sizeFormula = dungeonTable.getColumn9(col9Roll);

    // Obtém ocupantes - usa tabelas A13 se solicitado
    final occupantI = _getOccupant(
      col10Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      useEncounterTables,
    );
    final occupantII = _getOccupant(
      col11Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      useEncounterTables,
    );
    final leader = _getOccupant(
      col12Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      useEncounterTables,
    );

    final rumorSubject = dungeonTable.getColumn13(col13Roll);
    final rumorAction = dungeonTable.getColumn14(col14Roll);
    final rumorLocation = dungeonTable.getColumn15(col15Roll);

    // Armazena os dados atuais para regeneração
    _currentDungeonData = DungeonGenerationDto(
      type: type,
      builderOrInhabitant: builderOrInhabitant,
      status: status,
      objective: objective,
      target: target,
      targetStatus: targetStatus,
      location: location,
      entry: entry,
      sizeFormula: sizeFormula,
      occupantI: occupantI,
      occupantII: occupantII,
      leader: leader,
      rumorSubject: rumorSubject,
      rumorAction: rumorAction,
      rumorLocation: rumorLocation,
    );

    return _currentDungeonData!;
  }

  /// Regenera apenas os ocupantes da masmorra usando tabelas A13
  void regenerateOccupants({
    required TerrainType terrainType,
    required DifficultyLevel difficultyLevel,
    required PartyLevel partyLevel,
  }) {
    // Gera novos dados de ocupantes
    final col10Roll = DiceRoller.rollStatic(2, 6);
    final col11Roll = DiceRoller.rollStatic(2, 6);
    final col12Roll = DiceRoller.rollStatic(2, 6);

    // Obtém ocupantes usando tabelas A13
    final occupantI = _getOccupant(
      col10Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      true, // useEncounterTables = true
    );
    final occupantII = _getOccupant(
      col11Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      true, // useEncounterTables = true
    );
    final leader = _getOccupant(
      col12Roll,
      terrainType,
      difficultyLevel,
      partyLevel,
      true, // useEncounterTables = true
    );

    // Atualiza os dados da masmorra
    _currentDungeonData = _currentDungeonData?.copyWith(
      occupantI: occupantI,
      occupantII: occupantII,
      leader: leader,
    );
  }

  /// Dados atuais da masmorra (para regeneração de ocupantes)
  DungeonGenerationDto? _currentDungeonData;

  /// Obtém ocupante usando tabela A13 ou tabela padrão da masmorra
  String _getOccupant(
    int roll,
    TerrainType? terrainType,
    DifficultyLevel? difficultyLevel,
    PartyLevel? partyLevel,
    bool useEncounterTables,
  ) {
    // Se não usar tabelas de encontro, usa a tabela padrão da masmorra
    if (!useEncounterTables ||
        terrainType == null ||
        difficultyLevel == null ||
        partyLevel == null) {
      final dungeonTable = _tableManager.dungeonTable;
      return dungeonTable.getColumn10(roll).description;
    }

    // Usa tabelas A13 para gerar encontros
    try {
      final encounterTable = _getTableForTerrain(terrainType);
      final encounterRoll = _rollForTable(encounterTable, difficultyLevel);
      final result = _getResultFromTable(
        encounterTable,
        partyLevel,
        encounterRoll,
      );

      // Se o resultado for um monstro solitário, retorna apenas o nome
      if (result is MonsterType) {
        return result.description;
      }

      // Se for um encontro com quantidade, retorna o nome do monstro
      if (result is String && result.contains(':')) {
        final parts = result.split(':');
        if (parts.length >= 2) {
          return parts[1].trim(); // Retorna apenas o nome do monstro
        }
      }

      return result.toString();
    } catch (e) {
      // Fallback para tabela padrão da masmorra
      final dungeonTable = _tableManager.dungeonTable;
      return dungeonTable.getColumn10(roll).description;
    }
  }

  /// Obtém a tabela apropriada para o terreno
  dynamic _getTableForTerrain(TerrainType terrain) {
    switch (terrain) {
      case TerrainType.subterranean:
        return _tableManager.subterraneanEncounterTable;
      case TerrainType.plains:
        return _tableManager.plainsEncounterTable;
      case TerrainType.hills:
        return _tableManager.hillsEncounterTable;
      case TerrainType.mountains:
        return _tableManager.mountainsEncounterTable;
      case TerrainType.swamps:
        return _tableManager.swampsEncounterTable;
      case TerrainType.glaciers:
        return _tableManager.glaciersEncounterTable;
      case TerrainType.deserts:
        return _tableManager.desertsEncounterTable;
      case TerrainType.forests:
        return _tableManager.forestsEncounterTable;
      case TerrainType.any:
        return _tableManager.anyHabitatTable;
      case TerrainType.extraplanar:
        return _tableManager.extraplanarTable;
      case TerrainType.extraplanar:
        return _tableManager.extraplanarTable;
      default:
        return _tableManager.subterraneanEncounterTable;
    }
  }

  /// Rola o dado apropriado para a tabela
  int _rollForTable(dynamic table, DifficultyLevel selectedDifficulty) {
    // Se a tabela tem dados customizados, usa eles
    if (table is MonsterTable) {
      final tableDifficulty = table.difficultyLevel;

      // Tratamento especial para 2d6
      if (tableDifficulty == DifficultyLevel.custom2d6) {
        final roll = DiceRoller.rollStatic(2, 6); // 2d6 real
        if (roll < 2 || roll > 12) {
          throw ArgumentError('Roll deve estar entre 2 e 12 para 2d6');
        }
        return roll;
      }

      // Para tabelas com dados customizados (como Extraplanar com 1d8), usa os dados da tabela
      if (tableDifficulty == DifficultyLevel.custom8) {
        final roll = DiceRoller.rollStatic(1, 8); // 1d8
        if (roll < 1 || roll > 8) {
          throw ArgumentError('Roll deve estar entre 1 e 8 para 1d8');
        }
        return roll;
      }

      // Para tabelas padrão, usa a dificuldade selecionada pelo usuário
      final diceSides = selectedDifficulty.diceSides;
      final roll = DiceRoller.rollStatic(1, diceSides);

      if (roll < 1 || roll > diceSides) {
        throw ArgumentError('Roll deve estar entre 1 e $diceSides');
      }

      return roll;
    }

    // Fallback para dificuldade padrão
    final diceSides = selectedDifficulty.diceSides;
    final roll = DiceRoller.rollStatic(1, diceSides);

    if (roll < 1 || roll > diceSides) {
      throw ArgumentError('Roll deve estar entre 1 e $diceSides');
    }

    return roll;
  }

  /// Obtém o resultado da tabela baseado no nível do grupo
  dynamic _getResultFromTable(dynamic table, PartyLevel partyLevel, int roll) {
    // Handle animals table which uses terrain-based methods
    if (table.runtimeType.toString().contains('AnimalsTable')) {
      // For animals table, we need to adjust roll to 1-6 range
      final adjustedRoll = ((roll - 1) % 6) + 1;
      // For animals table, we need terrain context - use subterranean as default
      return table.getSubterranean(adjustedRoll);
    }

    // Handle extraplanar table which uses 1D8
    if (table.runtimeType.toString().contains('ExtraplanarTable')) {
      // For extraplanar table, we need to adjust roll to 1-8 range
      final adjustedRoll = ((roll - 1) % 8) + 1;
      return table.getByPartyLevel(partyLevel, adjustedRoll);
    }

    // Handle humans table which uses 2D6
    if (table.runtimeType.toString().contains('HumansTable')) {
      // For humans table, we need to adjust roll to 2-12 range (2d6)
      // Since roll is already 2-12 from 2d6, we can use it directly
      return table.getByPartyLevel(partyLevel, roll);
    }

    // Try to use getByPartyLevel method first (for tables like AnyHabitatTable)
    if (table.runtimeType.toString().contains('AnyHabitatTable')) {
      return table.getByPartyLevel(partyLevel, roll);
    }

    // For other tables, try to use getByPartyLevel method
    try {
      final result = table.getByPartyLevel(partyLevel, roll);
      
      // Se o resultado for uma referência de tabela, resolve ela
      if (result is TableReference) {
        return _resolveTableReference(result);
      }
      
      return result;
    } catch (e) {
      // If that fails, try to use the roll directly
      final result = table.getColumnValue(1, roll);
      
      // Se o resultado for uma referência de tabela, resolve ela
      if (result is TableReference) {
        return _resolveTableReference(result);
      }
      
      return result;
    }
  }

  /// Resolve uma referência de tabela para um monstro específico
  String _resolveTableReference(TableReference reference) {
    switch (reference) {
      case TableReference.animalsTable:
        return 'Rato Gigante'; // Animal comum subterrâneo
      case TableReference.humansTable:
        return 'Cultistas'; // Humano comum
      case TableReference.anyTableI:
        return 'Goblin'; // Monstro comum nível 1
      case TableReference.anyTableII:
        return 'Orc'; // Monstro comum nível 2
      case TableReference.anyTableIII:
        return 'Ogre'; // Monstro comum nível 3
      case TableReference.extraplanarTableI:
        return 'Imp'; // Extraplanar nível 1
      case TableReference.extraplanarTableII:
        return 'Demônio Menor'; // Extraplanar nível 2
      case TableReference.extraplanarTableIII:
        return 'Demônio Maior'; // Extraplanar nível 3
      default:
        return 'Goblin'; // Fallback
    }
  }

  /// Resolve referências de ocupantes nos rumores
  String resolveOccupantReferences(
    String text,
    String occupantI,
    String occupantII,
    String leader,
  ) {
    return text
        .replaceAll('[coluna 10]', occupantI)
        .replaceAll('[coluna 11]', occupantII)
        .replaceAll('[coluna 12]', leader);
  }

  /// Obtém informações sobre a tabela de masmorras
  String getDungeonTableInfo() {
    return _tableManager.dungeonTable.getTableInfo();
  }
}
