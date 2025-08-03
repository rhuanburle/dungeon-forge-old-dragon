// services/room_generation_service.dart

import '../enums/table_enums.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../tables/table_manager.dart';
import '../utils/dice_roller.dart';
import '../utils/treasure_resolver.dart';

/// Serviço responsável por gerar salas usando a Tabela 9.2
class RoomGenerationService {
  final TableManager _tableManager = TableManager();

  /// Gera uma sala com base nos dados da masmorra
  RoomGenerationDto generateRoom(
    DungeonGenerationDto dungeonData,
    int roomIndex,
  ) {
    final roomTable = _tableManager.roomTable;

    // Rolagem de 2d6 para cada coluna da Tabela 9.2
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

    // Obtém os valores básicos
    final type = roomTable.getColumn1(col1Roll);
    final airCurrent = roomTable.getColumn2(col2Roll);
    final smell = roomTable.getColumn3(col3Roll);
    final sound = roomTable.getColumn4(col4Roll);
    final foundItem = roomTable.getColumn5(col5Roll);
    final specialItem = _getSpecialItem(col5Roll, col6Roll);

    // Obtém os valores específicos baseados no tipo de sala
    final commonRoom = _getCommonRoom(col7Roll, col8Roll, col9Roll);
    final specialRoom = _getSpecialRoom(col8Roll, col9Roll);
    final specialRoom2 = _getSpecialRoom2(col8Roll, col9Roll);
    final monster = _getMonster(
      col10Roll,
      dungeonData.occupantI,
      dungeonData.occupantII,
    );
    final trap = _getTrap(col11Roll, col12Roll);
    final specialTrap = _getSpecialTrap(col11Roll, col12Roll);

    // Obtém dados de tesouro com modificadores
    final treasure = _getTreasureWithModifiers(col13Roll, type, monster, trap, specialTrap);
    final specialTreasure = _getSpecialTreasure(col13Roll, col14Roll);
    final magicItem = _getMagicItem(col13Roll, col14Roll, col15Roll);

    return RoomGenerationDto(
      type: type,
      airCurrent: airCurrent,
      smell: smell,
      sound: sound,
      foundItem: foundItem,
      specialItem: specialItem,
      commonRoom: commonRoom,
      specialRoom: specialRoom,
      specialRoom2: specialRoom2,
      monster: monster,
      trap: trap,
      specialTrap: specialTrap,
      treasure: treasure,
      specialTreasure: specialTreasure,
      magicItem: magicItem,
    );
  }

  /// Obtém item especial baseado nas colunas 5 e 6
  SpecialItem? _getSpecialItem(int col5Roll, int col6Roll) {
    // Verifica se a coluna 5 indica item especial
    // Na tabela, FoundItem.specialItems está nas posições 6 e 7 (índices 6 e 7)
    // Como usamos DiceRoller.rollStatic(2, 6), os valores são 2-12
    // Para acessar índice 6, precisamos de roll=8 (2+6)
    // Para acessar índice 7, precisamos de roll=9 (2+7)
    if (col5Roll == 8 || col5Roll == 9) {
      final specialItem = _tableManager.roomTable.getColumn6(col6Roll);
      return specialItem;
    }
    return null;
  }

  /// Obtém sala comum baseado nas colunas 7, 8 e 9
  CommonRoom? _getCommonRoom(int col7Roll, int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col7Roll);

    if (type == RoomType.commonRoom) {
      final commonRoom = roomTable.getColumn7(col7Roll);
      // Resolve referência especial se necessário
      if (commonRoom == CommonRoom.special) {
        return _resolveSpecialCommonRoom(col8Roll, col9Roll);
      }
      return commonRoom;
    }
    return null;
  }

  /// Resolve sala comum especial
  CommonRoom? _resolveSpecialCommonRoom(int col8Roll, int col9Roll) {
    // Para sala comum especial, usa a coluna 8
    final specialRoom = _tableManager.roomTable.getColumn8(col8Roll);
    if (specialRoom == SpecialRoom.special2) {
      // Se for especial 2, usa a coluna 9
      final specialRoom2 = _tableManager.roomTable.getColumn9(col9Roll);
      // Converte SpecialRoom2 para CommonRoom se possível
      return CommonRoom.completelyEmpty; // Fallback
    }
    return CommonRoom.completelyEmpty; // Fallback
  }

  /// Obtém sala especial baseado nas colunas 8 e 9
  SpecialRoom? _getSpecialRoom(int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col8Roll);

    if (type == RoomType.specialRoom) {
      final specialRoom = roomTable.getColumn8(col8Roll);
      // Resolve referência especial se necessário
      if (specialRoom == SpecialRoom.special2) {
        // Se for especial 2, retorna null e deixa o SpecialRoom2 ser usado
        return null;
      }
      return specialRoom;
    }
    return null;
  }

  /// Obtém sala especial 2 baseado nas colunas 8 e 9
  SpecialRoom2? _getSpecialRoom2(int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col8Roll);

    if (type == RoomType.specialRoom) {
      final specialRoom = roomTable.getColumn8(col8Roll);
      if (specialRoom == SpecialRoom.special2) {
        return roomTable.getColumn9(col9Roll);
      }
    }
    return null;
  }

  /// Obtém monstro baseado na coluna 10
  Monster? _getMonster(int col10Roll, String occupantI, String occupantII) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col10Roll);

    if (type == RoomType.monster) {
      return roomTable.getColumn10(col10Roll);
    }
    return null;
  }

  /// Obtém armadilha baseado nas colunas 11 e 12
  Trap? _getTrap(int col11Roll, int col12Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col11Roll);

    if (type == RoomType.trap) {
      final trap = roomTable.getColumn11(col11Roll);
      // Resolve referência especial se necessário
      if (trap == Trap.specialTrap) {
        // Se for armadilha especial, retorna null e deixa o SpecialTrap ser usado
        return null;
      }
      return trap;
    }
    return null;
  }

  /// Obtém armadilha especial baseado nas colunas 11 e 12
  SpecialTrap? _getSpecialTrap(int col11Roll, int col12Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col11Roll);

    if (type == RoomType.specialTrap) {
      return roomTable.getColumn12(col12Roll);
    }
    return null;
  }

  /// Obtém tesouro especial baseado nas colunas 13 e 14
  SpecialTreasure? _getSpecialTreasure(int col13Roll, int col14Roll) {
    final roomTable = _tableManager.roomTable;
    final treasure = roomTable.getColumn13(col13Roll);

    if (treasure == Treasure.specialTreasure) {
      return roomTable.getColumn14(col14Roll);
    }
    return null;
  }

  /// Obtém item mágico baseado nas colunas 13, 14 e 15
  MagicItem? _getMagicItem(
    int col13Roll,
    int col14Roll,
    int col15Roll,
  ) {
    final roomTable = _tableManager.roomTable;
    final treasure = roomTable.getColumn13(col13Roll);

    if (treasure == Treasure.magicItem ||
        treasure == Treasure.specialTreasure) {
      return roomTable.getColumn15(col15Roll);
    }
    return null;
  }

  /// Obtém tesouro com modificadores baseado nas colunas 13, 14 e 15
  Treasure _getTreasureWithModifiers(
    int col13Roll,
    RoomType type,
    Monster? monster,
    Trap? trap,
    SpecialTrap? specialTrap,
  ) {
    final roomTable = _tableManager.roomTable;
    final treasure = roomTable.getColumn13(col13Roll);

    // Aplica modificadores conforme a tabela 9.2
    // +1 para salas de armadilhas, +2 para salas de monstros
    int modifiedRoll = col13Roll;

    // Verifica se é sala de armadilha
    if (type == RoomType.trap ||
        type == RoomType.specialTrap ||
        trap != null ||
        specialTrap != null) {
      modifiedRoll += 1; // +1 para salas de armadilhas
    }

    // Verifica se é sala de monstro
    if (type == RoomType.monster || monster != null) {
      modifiedRoll += 2; // +2 para salas de monstros
    }

    // Ajusta o roll para o range válido (2-12 para 2d6)
    while (modifiedRoll > 12) {
      modifiedRoll -= 11; // Volta para o range 2-12
    }
    while (modifiedRoll < 2) {
      modifiedRoll += 11; // Volta para o range 2-12
    }

    return roomTable.getColumn13(modifiedRoll);
  }

  /// Obtém informações sobre a tabela de salas
  String getRoomTableInfo() {
    return _tableManager.roomTable.getTableInfo();
  }
}
