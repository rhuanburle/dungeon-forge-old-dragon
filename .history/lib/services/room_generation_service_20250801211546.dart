// services/room_generation_service.dart

import '../models/dto/dungeon_generation_dto.dart';
import '../utils/dice_roller.dart';
import '../utils/treasure_resolver.dart';
import '../tables/room_table.dart';

/// Serviço responsável por gerar salas usando a Tabela 9.2
class RoomGenerationService {
  /// Gera uma sala com base nos dados da masmorra
  RoomGenerationDto generateRoom(
    DungeonGenerationDto dungeonData,
    int roomIndex,
  ) {
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
    final type = RoomTable.getColumn1(col1Roll);
    final airCurrent = RoomTable.getColumn2(col2Roll);
    final smell = RoomTable.getColumn3(col3Roll);
    final sound = RoomTable.getColumn4(col4Roll);
    final foundItem = RoomTable.getColumn5(col5Roll);
    final specialItem = _getSpecialItem(col5Roll, col6Roll);

    // Obtém os valores específicos baseados no tipo de sala
    final commonRoom = _getCommonRoom(col7Roll);
    final specialRoom = _getSpecialRoom(col8Roll);
    final specialRoom2 = _getSpecialRoom2(col9Roll);
    final monster =
        _getMonster(col10Roll, dungeonData.occupantI, dungeonData.occupantII);
    final trap = _getTrap(col11Roll);
    final specialTrap = _getSpecialTrap(col12Roll);

    // Aplica modificadores de tesouro conforme regra
    final treasureModifier = _getTreasureModifier(type);
    final adjustedCol13Roll = (col13Roll + treasureModifier).clamp(2, 12);
    final adjustedCol14Roll = (col14Roll + treasureModifier).clamp(2, 12);
    final adjustedCol15Roll = (col15Roll + treasureModifier).clamp(2, 12);

    final treasure = RoomTable.getColumn13(adjustedCol13Roll);
    final specialTreasure = _getSpecialTreasure(treasure, adjustedCol14Roll);
    final magicItem =
        _getMagicItem(treasure, specialTreasure, adjustedCol15Roll);

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

  /// Obtém o item especial se necessário
  String? _getSpecialItem(int col5Roll, int col6Roll) {
    if (col5Roll != 8 && col5Roll != 9)
      return null; // Só se coluna 5 indicar (roll 8-9)
    return RoomTable.getColumn6(col6Roll);
  }

  /// Obtém a sala comum se necessário
  String? _getCommonRoom(int col7Roll) {
    final commonRoom = RoomTable.getColumn7(col7Roll);
    if (commonRoom.contains('Especial…')) {
      return null; // Será resolvido em specialRoom
    }
    return commonRoom;
  }

  /// Obtém a sala especial se necessário
  String? _getSpecialRoom(int col8Roll) {
    final specialRoom = RoomTable.getColumn8(col8Roll);
    if (specialRoom.contains('Especial 2…')) {
      return null; // Será resolvido em specialRoom2
    }
    return specialRoom;
  }

  /// Obtém a sala especial 2 se necessário
  String? _getSpecialRoom2(int col9Roll) {
    return RoomTable.getColumn9(col9Roll);
  }

  /// Obtém o monstro se necessário
  String? _getMonster(int col10Roll, String occupantI, String occupantII) {
    final monster = RoomTable.getColumn10(col10Roll);
    return monster;
  }

  /// Obtém a armadilha se necessário
  String? _getTrap(int col11Roll) {
    final trap = RoomTable.getColumn11(col11Roll);
    if (trap.contains('Armadilha Especial…')) {
      return null; // Será resolvido em specialTrap
    }
    return trap;
  }

  /// Obtém a armadilha especial se necessário
  String? _getSpecialTrap(int col12Roll) {
    return RoomTable.getColumn12(col12Roll);
  }

  /// Obtém o tesouro especial se necessário
  String? _getSpecialTreasure(String treasure, int col14Roll) {
    if (treasure.contains('Tesouro Especial…')) {
      return RoomTable.getColumn14(col14Roll);
    }
    return null;
  }

  /// Obtém o item mágico se necessário
  String? _getMagicItem(
      String treasure, String? specialTreasure, int col15Roll) {
    if (treasure.contains('Item Mágico') ||
        specialTreasure?.contains('Item Mágico') == true) {
      return RoomTable.getColumn15(col15Roll);
    }
    return null;
  }

  /// Obtém o modificador de tesouro baseado no tipo de sala
  int _getTreasureModifier(String type) {
    if (type.contains('Armadilha')) return 1;
    if (type.contains('Monstro')) return 2;
    return 0;
  }
}
