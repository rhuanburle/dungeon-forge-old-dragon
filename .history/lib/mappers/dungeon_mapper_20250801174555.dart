// mappers/dungeon_mapper.dart

import '../models/dungeon.dart';
import '../models/room.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../enums/dungeon_tables.dart';
import '../enums/room_tables.dart';

/// Mapper para converter entre DTOs e modelos de masmorra
class DungeonMapper {
  /// Converte DungeonGenerationDto para Dungeon
  static Dungeon fromDto(DungeonGenerationDto dto, List<Room> rooms) {
    return Dungeon(
      type: dto.type.description,
      builderOrInhabitant: dto.builder.description,
      status: dto.status.description,
      objective: dto.fullObjective,
      location: dto.location.description,
      entry: dto.entry.description,
      roomsCount: rooms.length,
      occupant1: dto.occupantI.description,
      occupant2: dto.occupantII.description,
      leader: dto.leader.description,
      rumor1: dto.resolveRumorReferences(
        dto.occupantI.description,
        dto.occupantII.description,
        dto.leader.description,
      ),
      rooms: rooms,
    );
  }

  /// Converte RoomGenerationDto para Room
  static Room fromRoomDto(RoomGenerationDto dto, int index) {
    return Room(
      index: index,
      type: _buildRoomType(dto),
      air: dto.airCurrent.description,
      smell: dto.smell.description,
      sound: dto.sound.description,
      item: dto.foundItem.description,
      specialItem: dto.specialItem?.description ?? '',
      monster1: _buildMonster1(dto),
      monster2: _buildMonster2(dto),
      trap: _buildTrap(dto),
      specialTrap: _buildSpecialTrap(dto),
      roomCommon: _buildRoomCommon(dto),
      roomSpecial: _buildRoomSpecial(dto),
      roomSpecial2: _buildRoomSpecial2(dto),
      treasure: _buildTreasure(dto),
      specialTreasure: _buildSpecialTreasure(dto),
      magicItem: dto.magicItem?.description ?? '',
    );
  }

  /// Constrói o tipo de sala baseado no DTO
  static String _buildRoomType(RoomGenerationDto dto) {
    switch (dto.type) {
      case RoomType.specialRoom:
        return 'Sala Especial (${dto.specialRoom?.description ?? ''})';
      case RoomType.trap:
        return 'Armadilha (${dto.trap?.description ?? ''})';
      case RoomType.commonRoom:
        return 'Sala Comum (${dto.commonRoom?.description ?? ''})';
      case RoomType.monster:
        return 'Encontro';
      case RoomType.specialTrap:
        return 'Sala Armadilha Especial (${dto.specialTrap?.description ?? ''})';
    }
  }

  /// Constrói o primeiro monstro baseado no DTO
  static String _buildMonster1(RoomGenerationDto dto) {
    if (dto.monster == null) return '';
    
    final monsterDesc = dto.monster!.description;
    if (monsterDesc.contains(' + ')) {
      return monsterDesc.split(' + ')[0].trim();
    }
    return monsterDesc;
  }

  /// Constrói o segundo monstro baseado no DTO
  static String _buildMonster2(RoomGenerationDto dto) {
    if (dto.monster == null) return '';
    
    final monsterDesc = dto.monster!.description;
    if (monsterDesc.contains(' + ')) {
      final parts = monsterDesc.split(' + ');
      return parts.length > 1 ? parts[1].trim() : '';
    }
    return '';
  }

  /// Constrói a armadilha baseado no DTO
  static String _buildTrap(RoomGenerationDto dto) {
    if (dto.trap == null) return '';
    
    if (dto.trap == Trap.specialTrap) {
      return dto.specialTrap?.description ?? '';
    }
    return dto.trap!.description;
  }

  /// Constrói a armadilha especial baseado no DTO
  static String _buildSpecialTrap(RoomGenerationDto dto) {
    if (dto.trap != Trap.specialTrap) return '';
    return dto.specialTrap?.description ?? '';
  }

  /// Constrói a sala comum baseado no DTO
  static String _buildRoomCommon(RoomGenerationDto dto) {
    if (dto.commonRoom == null) return '';
    
    if (dto.commonRoom == CommonRoom.special) {
      return dto.specialRoom?.description ?? '';
    }
    return dto.commonRoom!.description;
  }

  /// Constrói a sala especial baseado no DTO
  static String _buildRoomSpecial(RoomGenerationDto dto) {
    if (dto.specialRoom == null) return '';
    
    if (dto.specialRoom == SpecialRoom.special2) {
      return dto.specialRoom2?.description ?? '';
    }
    return dto.specialRoom!.description;
  }

  /// Constrói a sala especial 2 baseado no DTO
  static String _buildRoomSpecial2(RoomGenerationDto dto) {
    if (dto.specialRoom != SpecialRoom.special2) return '';
    return dto.specialRoom2?.description ?? '';
  }

  /// Constrói o tesouro baseado no DTO
  static String _buildTreasure(RoomGenerationDto dto) {
    if (dto.treasure == Treasure.specialTreasure) {
      return dto.specialTreasure?.description ?? '';
    }
    return dto.treasure.description;
  }

  /// Constrói o tesouro especial baseado no DTO
  static String _buildSpecialTreasure(RoomGenerationDto dto) {
    if (dto.treasure != Treasure.specialTreasure) return '';
    return dto.specialTreasure?.description ?? '';
  }
} 