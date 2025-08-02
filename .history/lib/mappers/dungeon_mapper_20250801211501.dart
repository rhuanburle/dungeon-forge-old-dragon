// mappers/dungeon_mapper.dart

import '../models/dungeon.dart';
import '../models/room.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../enums/dungeon_tables.dart';
import '../enums/room_tables.dart';
import '../utils/treasure_resolver.dart';

/// Mapper para converter entre DTOs e modelos de masmorra
class DungeonMapper {
  /// Converte DungeonGenerationDto para Dungeon
  static Dungeon fromDto(DungeonGenerationDto dto, List<Room> rooms) {
    return Dungeon(
      type: dto.type,
      builderOrInhabitant: dto.builderOrInhabitant,
      status: dto.status,
      objective: dto.fullObjective,
      location: dto.location,
      entry: dto.entry,
      roomsCount: rooms.length,
      occupant1: dto.occupantI,
      occupant2: dto.occupantII,
      leader: dto.leader,
      rumor1: dto.fullRumor,
      rooms: rooms,
    );
  }

  /// Converte RoomGenerationDto para Room
  static Room fromRoomDto(
      RoomGenerationDto dto, int index, DungeonGenerationDto dungeonDto) {
    return Room(
      index: index,
      type: _buildRoomType(dto),
      air: dto.airCurrent,
      smell: dto.smell,
      sound: dto.sound,
      item: dto.foundItem,
      specialItem: dto.specialItem ?? '',
      monster1: _buildMonster1(dto, dungeonDto),
      monster2: _buildMonster2(dto, dungeonDto),
      trap: _buildTrap(dto),
      specialTrap: _buildSpecialTrap(dto),
      roomCommon: _buildRoomCommon(dto),
      roomSpecial: _buildRoomSpecial(dto),
      roomSpecial2: _buildRoomSpecial2(dto),
      treasure: _buildTreasure(dto),
      specialTreasure: _buildSpecialTreasure(dto),
      magicItem: _buildMagicItem(dto),
    );
  }

  /// Constrói o tipo de sala baseado no DTO
  static String _buildRoomType(RoomGenerationDto dto) {
    if (dto.type.contains('Sala Especial')) {
      final description = dto.specialRoom ?? '';
      return description.isNotEmpty
          ? 'Sala Especial ($description)'
          : 'Sala Especial';
    } else if (dto.type.contains('Armadilha')) {
      final description = dto.trap ?? '';
      return description.isNotEmpty ? 'Armadilha ($description)' : 'Armadilha';
    } else if (dto.type.contains('Sala Comum')) {
      final description = dto.commonRoom ?? '';
      return description.isNotEmpty
          ? 'Sala Comum ($description)'
          : 'Sala Comum';
    } else if (dto.type.contains('Monstro')) {
      return 'Encontro';
    } else if (dto.type.contains('Sala Armadilha Especial')) {
      final description = dto.specialTrap ?? '';
      return description.isNotEmpty
          ? 'Sala Armadilha Especial ($description)'
          : 'Sala Armadilha Especial';
    }
    return dto.type;
  }

  /// Constrói o primeiro monstro baseado no DTO
  static String _buildMonster1(
      RoomGenerationDto dto, DungeonGenerationDto dungeonDto) {
    if (dto.monster == null) return '';

    final monsterDesc = dto.monster!;
    String result;

    if (monsterDesc.contains(' + ')) {
      result = monsterDesc.split(' + ')[0].trim();
    } else {
      result = monsterDesc;
    }

    // Resolve referências de ocupantes
    result = result.replaceAll('Ocupante I', dungeonDto.occupantI);
    result = result.replaceAll('Ocupante II', dungeonDto.occupantII);

    return result;
  }

  /// Constrói o segundo monstro baseado no DTO
  static String _buildMonster2(
      RoomGenerationDto dto, DungeonGenerationDto dungeonDto) {
    if (dto.monster == null) return '';

    final monsterDesc = dto.monster!;
    String result = '';

    if (monsterDesc.contains(' + ')) {
      final parts = monsterDesc.split(' + ');
      result = parts.length > 1 ? parts[1].trim() : '';
    }

    if (result.isNotEmpty) {
      // Resolve referências de ocupantes
      result = result.replaceAll('Ocupante I', dungeonDto.occupantI);
      result = result.replaceAll('Ocupante II', dungeonDto.occupantII);
    }

    return result;
  }

  /// Constrói a armadilha baseado no DTO
  static String _buildTrap(RoomGenerationDto dto) {
    if (dto.trap == null) return '';

    if (dto.trap!.contains('Armadilha Especial…')) {
      return dto.specialTrap ?? '';
    }
    return dto.trap!;
  }

  /// Constrói a armadilha especial baseado no DTO
  static String _buildSpecialTrap(RoomGenerationDto dto) {
    if (dto.trap == null || !dto.trap!.contains('Armadilha Especial…'))
      return '';
    return dto.specialTrap ?? '';
  }

  /// Constrói a sala comum baseado no DTO
  static String _buildRoomCommon(RoomGenerationDto dto) {
    if (dto.commonRoom == null) return '';

    if (dto.commonRoom!.contains('Especial…')) {
      return dto.specialRoom ?? '';
    }
    return dto.commonRoom!.description;
  }

  /// Constrói a sala especial baseado no DTO
  static String _buildRoomSpecial(RoomGenerationDto dto) {
    if (dto.specialRoom == null) return '';

    if (dto.specialRoom!.contains('Especial 2…')) {
      return dto.specialRoom2 ?? '';
    }
    return dto.specialRoom!;
  }

  /// Constrói a sala especial 2 baseado no DTO
  static String _buildRoomSpecial2(RoomGenerationDto dto) {
    if (dto.specialRoom == null || !dto.specialRoom!.contains('Especial 2…'))
      return '';
    return dto.specialRoom2 ?? '';
  }

  /// Constrói o tesouro baseado no DTO
  static String _buildTreasure(RoomGenerationDto dto) {
    String treasureDescription;

    if (dto.treasure.contains('Tesouro Especial…')) {
      treasureDescription = dto.specialTreasure ?? '';
    } else {
      treasureDescription = dto.treasure;
    }

    // Resolve fórmulas de tesouro usando TreasureResolver
    return TreasureResolver.resolve(treasureDescription);
  }

  /// Constrói o tesouro especial baseado no DTO
  static String _buildSpecialTreasure(RoomGenerationDto dto) {
    if (!dto.treasure.contains('Tesouro Especial…')) return '';
    final treasureDescription = dto.specialTreasure ?? '';
    return TreasureResolver.resolve(treasureDescription);
  }

  /// Constrói o item mágico baseado no DTO
  static String _buildMagicItem(RoomGenerationDto dto) {
    if (dto.magicItem == null) return '';
    final magicItemDescription = dto.magicItem!;
    return TreasureResolver.resolve(magicItemDescription);
  }
}
