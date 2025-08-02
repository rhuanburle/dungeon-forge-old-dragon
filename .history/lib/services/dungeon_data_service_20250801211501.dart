// services/dungeon_data_service.dart

import '../models/dto/dungeon_generation_dto.dart';
import '../utils/dice_roller.dart';
import '../tables/dungeon_table.dart';

/// Serviço responsável por gerar dados da masmorra usando a Tabela 9.1
class DungeonDataService {
  /// Gera os dados da masmorra usando a Tabela 9.1
  DungeonGenerationDto generateDungeonData() {
    // Rolagem de 2d6 para cada coluna da Tabela 9.1
    final col1Roll = DiceRoller.roll(2, 6);
    final col2Roll = DiceRoller.roll(2, 6);
    final col3Roll = DiceRoller.roll(2, 6);
    final col4Roll = DiceRoller.roll(2, 6);
    final col5Roll = DiceRoller.roll(2, 6);
    final col6Roll = DiceRoller.roll(2, 6);
    final col7Roll = DiceRoller.roll(2, 6);
    final col8Roll = DiceRoller.roll(2, 6);
    final col9Roll = DiceRoller.roll(2, 6);
    final col10Roll = DiceRoller.roll(2, 6);
    final col11Roll = DiceRoller.roll(2, 6);
    final col12Roll = DiceRoller.roll(2, 6);
    final col13Roll = DiceRoller.roll(2, 6);
    final col14Roll = DiceRoller.roll(2, 6);
    final col15Roll = DiceRoller.roll(2, 6);

    // Obtém os valores das tabelas
    final type = DungeonTable.getColumn1(col1Roll);
    final builderOrInhabitant = DungeonTable.getColumn2(col2Roll);
    final status = DungeonTable.getColumn3(col3Roll);
    final objective = DungeonTable.getColumn4(col4Roll);
    final target = DungeonTable.getColumn5(col5Roll);
    final targetStatus = DungeonTable.getColumn6(col6Roll);
    final location = DungeonTable.getColumn7(col7Roll);
    final entry = DungeonTable.getColumn8(col8Roll);
    final sizeFormula = DungeonTable.getColumn9(col9Roll);
    final occupantI = DungeonTable.getColumn10(col10Roll);
    final occupantII = DungeonTable.getColumn11(col11Roll);
    final leader = DungeonTable.getColumn12(col12Roll);
    final rumorSubject = DungeonTable.getColumn13(col13Roll);
    final rumorAction = DungeonTable.getColumn14(col14Roll);
    final rumorLocation = DungeonTable.getColumn15(col15Roll);

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
      occupantI: occupantI,
      occupantII: occupantII,
      leader: leader,
      rumorSubject: rumorSubject,
      rumorAction: rumorAction,
      rumorLocation: rumorLocation,
    );
  }

  /// Resolve referências de ocupantes nos rumores
  String resolveOccupantReferences(
      String text, String occupantI, String occupantII, String leader) {
    return text
        .replaceAll('[coluna 10]', occupantI)
        .replaceAll('[coluna 11]', occupantII)
        .replaceAll('[coluna 12]', leader);
  }
}
