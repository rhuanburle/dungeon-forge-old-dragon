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
    final monster =
        _getMonster(col10Roll, dungeonData.occupantI, dungeonData.occupantII);
    final trap = _getTrap(col11Roll, col12Roll);
    final specialTrap = _getSpecialTrap(col11Roll, col12Roll);

    // Obtém dados de tesouro
    final treasure = roomTable.getColumn13(col13Roll);
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
    if (col5Roll == 7 || col5Roll == 8) {
      return _tableManager.roomTable.getColumn6(col6Roll);
    }
    return null;
  }

  /// Obtém sala comum baseado nas colunas 7, 8 e 9
  CommonRoom? _getCommonRoom(int col7Roll, int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col7Roll);
    
    if (type == RoomType.commonRoom) {
      return roomTable.getColumn7(col7Roll);
    }
    return null;
  }

  /// Obtém sala especial baseado nas colunas 8 e 9
  SpecialRoom? _getSpecialRoom(int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col8Roll);
    
    if (type == RoomType.specialRoom) {
      return roomTable.getColumn8(col8Roll);
    }
    return null;
  }

  /// Obtém sala especial 2 baseado nas colunas 8 e 9
  SpecialRoom2? _getSpecialRoom2(int col8Roll, int col9Roll) {
    final roomTable = _tableManager.roomTable;
    final type = roomTable.getColumn1(col8Roll);
    
    if (type == RoomType.specialRoom) {
      return roomTable.getColumn9(col9Roll);
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
      return roomTable.getColumn11(col11Roll);
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
  MagicItem? _getMagicItem(int col13Roll, int col14Roll, int col15Roll) {
    final roomTable = _tableManager.roomTable;
    final treasure = roomTable.getColumn13(col13Roll);
    
    if (treasure == Treasure.magicItem || 
        treasure == Treasure.specialTreasure) {
      return roomTable.getColumn15(col15Roll);
    }
    return null;
  }

  /// Obtém informações sobre a tabela de salas
  String getRoomTableInfo() {
    return _tableManager.roomTable.getTableInfo();
  }
}
