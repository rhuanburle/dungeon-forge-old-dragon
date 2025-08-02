// services/dungeon_data_service.dart

import '../enums/table_enums.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../tables/table_manager.dart';
import '../utils/dice_roller.dart';

/// Serviço responsável por gerar dados da masmorra usando a Tabela 9.1
class DungeonDataService {
  final TableManager _tableManager = TableManager();

  /// Gera os dados da masmorra usando a Tabela 9.1
  DungeonGenerationDto generateDungeonData() {
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
    final occupantI = dungeonTable.getColumn10(col10Roll);
    final occupantII = dungeonTable.getColumn11(col11Roll);
    final leader = dungeonTable.getColumn12(col12Roll);
    final rumorSubject = dungeonTable.getColumn13(col13Roll);
    final rumorAction = dungeonTable.getColumn14(col14Roll);
    final rumorLocation = dungeonTable.getColumn15(col15Roll);

    return DungeonGenerationDto(
      type: type,
      builderOrInhabitant: builderOrInhabitant,
      status: status,
      objective: objective,
      target: target,
      targetStatus: targetStatus,
      location: location,
      entry: entry,
      sizeFormula: sizeFormula,
      occupantI: occupantI.description,
      occupantII: occupantII.description,
      leader: leader.description,
      rumorSubject: rumorSubject,
      rumorAction: rumorAction,
      rumorLocation: rumorLocation,
    );
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
