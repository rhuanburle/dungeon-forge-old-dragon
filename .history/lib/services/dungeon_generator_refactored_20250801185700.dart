// services/dungeon_generator_refactored.dart

import 'dart:math';

import '../utils/dice_roller.dart';
import '../models/dungeon.dart';
import '../models/room.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../mappers/dungeon_mapper.dart';
import 'tables/dungeon_table_9_1.dart';
import 'tables/room_table_9_2.dart';
import '../enums/dungeon_tables.dart';
import '../enums/room_tables.dart';

/// Gerador de masmorras refatorado com estrutura mais profissional
class DungeonGeneratorRefactored {
  /// Gera uma masmorra completa
  Dungeon generate({
    required int level,
    required String theme,
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  }) {
    // Gera os dados da masmorra usando a Tabela 9.1
    final dungeonData = _generateDungeonData();

    // Determina o número de salas
    final roomsCount = _determineRoomsCount(
      dungeonData.sizeFormula,
      customRoomCount,
      minRooms,
      maxRooms,
    );

    // Gera as salas
    final rooms = _generateRooms(
      roomsCount,
      level,
      dungeonData,
    );

    // Converte para o modelo final
    return DungeonMapper.fromDto(dungeonData, rooms);
  }

  /// Gera os dados da masmorra usando a Tabela 9.1
  DungeonGenerationDto _generateDungeonData() {
    // Rola 2d6 para cada coluna da Tabela 9.1
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

    // Obtém os resultados das tabelas
    final type = DungeonTable9_1.getColumn1(col1Roll);
    final builder = DungeonTable9_1.getColumn2(col2Roll);
    final status = DungeonTable9_1.getColumn3(col3Roll);
    final objective = DungeonTable9_1.getColumn4(col4Roll);
    final target = DungeonTable9_1.getColumn5(col5Roll);
    final targetStatus = DungeonTable9_1.getColumn6(col6Roll);
    final location = DungeonTable9_1.getColumn7(col7Roll);
    final entry = DungeonTable9_1.getColumn8(col8Roll);
    final sizeFormula = DungeonTable9_1.getColumn9(col9Roll);
    final occupantI = DungeonTable9_1.getColumn10(col10Roll);
    final occupantII = DungeonTable9_1.getColumn11(col11Roll);
    final leader = DungeonTable9_1.getColumn12(col12Roll);
    final rumorSubject = DungeonTable9_1.getColumn13(col13Roll);
    final rumorAction = DungeonTable9_1.getColumn14(col14Roll);
    final rumorLocation = DungeonTable9_1.getColumn15(col15Roll);

    // Determina o tamanho baseado na fórmula
    final size = _determineSizeFromFormula(sizeFormula);

    return DungeonGenerationDto(
      type: type,
      builder: builder,
      status: status,
      objective: objective,
      target: target,
      targetStatus: targetStatus,
      location: location,
      entry: entry,
      size: size,
      sizeFormula: sizeFormula,
      occupantI: occupantI,
      occupantII: occupantII,
      leader: leader,
      rumorSubject: rumorSubject,
      rumorAction: rumorAction,
      rumorLocation: rumorLocation,
    );
  }

  /// Determina o tamanho da masmorra baseado na fórmula
  DungeonSize _determineSizeFromFormula(String formula) {
    if (formula.startsWith('Grande')) return DungeonSize.large;
    if (formula.startsWith('Média')) return DungeonSize.medium;
    return DungeonSize.small;
  }

  /// Determina o número de salas baseado nos parâmetros
  int _determineRoomsCount(
    String sizeFormula,
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  ) {
    var roomsCount = customRoomCount ?? _extractRoomsCount(sizeFormula);

    // Ajuste baseado em min/max
    if (customRoomCount == null && minRooms != null && maxRooms != null) {
      // Gera valor aleatório dentro do intervalo
      final low = min(minRooms, maxRooms);
      final high = max(minRooms, maxRooms);
      roomsCount = low + DiceRoller.roll(1, high - low + 1) - 1;
    } else {
      // Caso apenas um dos filtros exista aplica como clamp
      if (minRooms != null && roomsCount < minRooms) roomsCount = minRooms;
      if (maxRooms != null && roomsCount > maxRooms) roomsCount = maxRooms;
    }

    return roomsCount;
  }

  /// Extrai o número de salas da fórmula
  int _extractRoomsCount(String raw) {
    // Expected format: "Grande – 3d6+6" etc. We'll take formula part after dash.
    final parts = raw.split('–');
    if (parts.length < 2) return 5; // Fallback mínimo
    final formula = parts[1].trim();
    final count = DiceRoller.rollFormula(formula);
    // Garante pelo menos 3 salas
    return count < 3 ? 5 : count;
  }

  /// Gera as salas da masmorra
  List<Room> _generateRooms(
    int roomsCount,
    int level,
    DungeonGenerationDto dungeonData,
  ) {
    final rooms = <Room>[];

    for (int i = 1; i <= roomsCount; i++) {
      final roomData = _generateRoomData(
          level,
          dungeonData.occupantI.description,
          dungeonData.occupantII.description);
      final room = DungeonMapper.fromRoomDto(roomData, i, dungeonData);
      rooms.add(room);
    }

    return rooms;
  }

  /// Gera os dados de uma sala usando a Tabela 9.2
  RoomGenerationDto _generateRoomData(
    int level,
    String occupantI,
    String occupantII,
  ) {
    // Rola 2d6 para cada coluna da Tabela 9.2
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

    // Aplica modificadores para tesouros conforme regra: +1 para armadilhas, +2 para monstros
    int col13Roll = DiceRoller.roll(2, 6);
    int col14Roll = DiceRoller.roll(2, 6);
    int col15Roll = DiceRoller.roll(2, 6);

    // Obtém os resultados básicos
    final type = RoomTable9_2.getColumn1(col1Roll);
    final airCurrent = RoomTable9_2.getColumn2(col2Roll);
    final smell = RoomTable9_2.getColumn3(col3Roll);
    final sound = RoomTable9_2.getColumn4(col4Roll);
    final foundItem = RoomTable9_2.getColumn5(col5Roll);
    final specialItem = _getSpecialItem(col5Roll, col6Roll);
    final commonRoom = _getCommonRoom(col7Roll, col8Roll, col9Roll);
    final specialRoom = _getSpecialRoom(col8Roll, col9Roll);
    final specialRoom2 = _getSpecialRoom2(col8Roll, col9Roll);
    final monster = _getMonster(col10Roll, occupantI, occupantII);
    final trap = _getTrap(col11Roll, col12Roll);
    final specialTrap = _getSpecialTrap(col11Roll, col12Roll);

    // Aplica modificadores de tesouro conforme regra
    final treasureModifier = _getTreasureModifier(type);
    col13Roll += treasureModifier;
    col14Roll += treasureModifier;
    col15Roll += treasureModifier;

    // Garante que os valores não ultrapassem 12 (máximo de 2d6)
    col13Roll = col13Roll.clamp(2, 12);
    col14Roll = col14Roll.clamp(2, 12);
    col15Roll = col15Roll.clamp(2, 12);

    final treasure = RoomTable9_2.getColumn13(col13Roll);
    final specialTreasure = _getSpecialTreasure(treasure, col14Roll);
    final magicItem = _getMagicItem(treasure, specialTreasure, col15Roll);

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
  SpecialItem? _getSpecialItem(int col5Roll, int col6Roll) {
    if (col5Roll != 8 && col5Roll != 9)
      return null; // Só se coluna 5 indicar (roll 8-9)
    return RoomTable9_2.getColumn6(col6Roll);
  }

  /// Obtém a sala comum se necessário
  CommonRoom? _getCommonRoom(int col7Roll, int col8Roll, int col9Roll) {
    final commonRoom = RoomTable9_2.getColumn7(col7Roll);
    if (commonRoom == CommonRoom.special) {
      // Se caiu "Especial…", resolve recursivamente
      final specialRoom = RoomTable9_2.getColumn8(col8Roll);
      if (specialRoom == SpecialRoom.special2) {
        return null; // Será resolvido em specialRoom2
      }
      return null; // Será resolvido em specialRoom
    }
    return commonRoom;
  }

  /// Obtém a sala especial se necessário
  SpecialRoom? _getSpecialRoom(int col8Roll, int col9Roll) {
    final specialRoom = RoomTable9_2.getColumn8(col8Roll);
    if (specialRoom == SpecialRoom.special2) {
      return null; // Será resolvido em specialRoom2
    }
    return specialRoom;
  }

  /// Obtém a sala especial 2 se necessário
  SpecialRoom2? _getSpecialRoom2(int col8Roll, int col9Roll) {
    final specialRoom = RoomTable9_2.getColumn8(col8Roll);
    if (specialRoom == SpecialRoom.special2) {
      return RoomTable9_2.getColumn9(col9Roll);
    }
    return null;
  }

  /// Obtém o monstro se necessário
  Monster? _getMonster(int col10Roll, String occupantI, String occupantII) {
    final monster = RoomTable9_2.getColumn10(col10Roll);
    return monster;
  }

  /// Obtém a armadilha se necessário
  Trap? _getTrap(int col11Roll, int col12Roll) {
    final trap = RoomTable9_2.getColumn11(col11Roll);
    if (trap == Trap.specialTrap) {
      return null; // Será resolvido em specialTrap
    }
    return trap;
  }

  /// Obtém a armadilha especial se necessário
  SpecialTrap? _getSpecialTrap(int col11Roll, int col12Roll) {
    final trap = RoomTable9_2.getColumn11(col11Roll);
    if (trap == Trap.specialTrap) {
      return RoomTable9_2.getColumn12(col12Roll);
    }
    return null;
  }

  /// Obtém o tesouro especial se necessário
  SpecialTreasure? _getSpecialTreasure(Treasure treasure, int col14Roll) {
    if (treasure == Treasure.specialTreasure) {
      return RoomTable9_2.getColumn14(col14Roll);
    }
    return null;
  }

  /// Obtém o item mágico se necessário
  MagicItem? _getMagicItem(
      Treasure treasure, SpecialTreasure? specialTreasure, int col15Roll) {
    if (treasure == Treasure.magicItem ||
        specialTreasure?.description.contains('Item Mágico') == true) {
      return RoomTable9_2.getColumn15(col15Roll);
    }
    return null;
  }

  /// Obtém o modificador de tesouro baseado no tipo de sala
  int _getTreasureModifier(RoomType type) {
    if (type == RoomType.trap || type == RoomType.specialTrap) return 1;
    if (type == RoomType.monster) return 2;
    return 0;
  }
}
