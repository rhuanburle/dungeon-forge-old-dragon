// mappers/dungeon_mapper.dart

import '../models/dungeon.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../models/room.dart';
import '../enums/table_enums.dart';
import '../utils/treasure_resolver.dart';

/// Mapper responsável por converter DTOs em modelos de domínio
class DungeonMapper {
  /// Converte DungeonGenerationDto em Dungeon
  static Dungeon fromDto(DungeonGenerationDto dto, List<Room> rooms) {
    return Dungeon(
      type: dto.type.description,
      builderOrInhabitant: dto.builderOrInhabitant.description,
      status: dto.status.description,
      objective: dto.fullObjective,
      location: dto.location.description,
      entry: dto.entry.description,
      roomsCount: rooms.length,
      occupant1: dto.occupantI,
      occupant2: dto.occupantII,
      leader: dto.leader,
      rumor1: dto.fullRumor,
      rooms: rooms,
    );
  }

  /// Converte RoomGenerationDto em Room
  static Room fromRoomDto(RoomGenerationDto dto, int index, DungeonGenerationDto dungeonDto) {
    return Room(
      index: index,
      type: _buildRoomType(dto),
      air: dto.airCurrent.description,
      smell: dto.smell.description,
      sound: dto.sound.description,
      item: dto.foundItem.description,
      specialItem: dto.specialItem?.description ?? '',
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

  /// Converte Dungeon em DungeonGenerationDto
  static DungeonGenerationDto toDto(Dungeon dungeon) {
    // Encontra os enums correspondentes
    final type = _findDungeonType(dungeon.type);
    final builderOrInhabitant =
        _findDungeonBuilder(dungeon.builderOrInhabitant);
    final status = _findDungeonStatus(dungeon.status);
    final objective = _findDungeonObjective(dungeon.objective);
    final target = _findDungeonTarget('tesouro'); // Default value
    final targetStatus = _findDungeonTargetStatus('intacto'); // Default value
    final location = _findDungeonLocation(dungeon.location);
    final entry = _findDungeonEntry(dungeon.entry);
    final rumorSubject = _findRumorSubject(dungeon.rumor1);
    final rumorAction = _findRumorAction(dungeon.rumor1);
    final rumorLocation = _findRumorLocation(dungeon.rumor1);

    return DungeonGenerationDto(
      type: type,
      builderOrInhabitant: builderOrInhabitant,
      status: status,
      objective: objective,
      target: target,
      targetStatus: targetStatus,
      location: location,
      entry: entry,
      sizeFormula: '1d6 + 4 salas', // Default value
      occupantI: dungeon.occupant1,
      occupantII: dungeon.occupant2,
      leader: dungeon.leader,
      rumorSubject: rumorSubject,
      rumorAction: rumorAction,
      rumorLocation: rumorLocation,
    );
  }

  /// Constrói o tipo de sala baseado no DTO
  static String _buildRoomType(RoomGenerationDto dto) {
    switch (dto.type) {
      case RoomType.specialRoom:
        final description = dto.specialRoom?.description ?? '';
        return description.isNotEmpty
            ? 'Sala Especial ($description)'
            : 'Sala Especial';
      case RoomType.trap:
        final description = dto.trap?.description ?? '';
        return description.isNotEmpty
            ? 'Armadilha ($description)'
            : 'Armadilha';
      case RoomType.commonRoom:
        final description = dto.commonRoom?.description ?? '';
        return description.isNotEmpty
            ? 'Sala Comum ($description)'
            : 'Sala Comum';
      case RoomType.monster:
        return 'Encontro';
      case RoomType.specialTrap:
        final description = dto.specialTrap?.description ?? '';
        return description.isNotEmpty
            ? 'Sala Armadilha Especial ($description)'
            : 'Sala Armadilha Especial';
    }
  }

  /// Constrói o primeiro monstro baseado no DTO
  static String _buildMonster1(RoomGenerationDto dto, DungeonGenerationDto dungeonDto) {
    if (dto.monster == null) return '';

    final monsterDesc = dto.monster!.description;
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
  static String _buildMonster2(RoomGenerationDto dto, DungeonGenerationDto dungeonDto) {
    if (dto.monster == null) return '';

    final monsterDesc = dto.monster!.description;
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
    String treasureDescription;

    if (dto.treasure == Treasure.specialTreasure) {
      treasureDescription = dto.specialTreasure?.description ?? '';
    } else {
      treasureDescription = dto.treasure.description;
    }

    // Resolve fórmulas de tesouro usando TreasureResolver
    return TreasureResolver.resolve(treasureDescription);
  }

  /// Constrói o tesouro especial baseado no DTO
  static String _buildSpecialTreasure(RoomGenerationDto dto) {
    if (dto.treasure != Treasure.specialTreasure) return '';
    final treasureDescription = dto.specialTreasure?.description ?? '';
    return TreasureResolver.resolve(treasureDescription);
  }

  /// Constrói o item mágico baseado no DTO
  static String _buildMagicItem(RoomGenerationDto dto) {
    if (dto.magicItem == null) return '';
    final magicItemDescription = dto.magicItem!.description;
    return TreasureResolver.resolve(magicItemDescription);
  }

  /// Encontra o enum DungeonType baseado na descrição
  static DungeonType _findDungeonType(String description) {
    return DungeonType.values.firstWhere(
      (type) => type.description == description,
      orElse: () => DungeonType.lostConstruction,
    );
  }

  /// Encontra o enum DungeonBuilder baseado na descrição
  static DungeonBuilder _findDungeonBuilder(String description) {
    return DungeonBuilder.values.firstWhere(
      (builder) => builder.description == description,
      orElse: () => DungeonBuilder.unknown,
    );
  }

  /// Encontra o enum DungeonStatus baseado na descrição
  static DungeonStatus _findDungeonStatus(String description) {
    return DungeonStatus.values.firstWhere(
      (status) => status.description == description,
      orElse: () => DungeonStatus.lost,
    );
  }

  /// Encontra o enum DungeonObjective baseado na descrição
  static DungeonObjective _findDungeonObjective(String description) {
    return DungeonObjective.values.firstWhere(
      (objective) => objective.description == description,
      orElse: () => DungeonObjective.defend,
    );
  }

  /// Encontra o enum DungeonTarget baseado na descrição
  static DungeonTarget _findDungeonTarget(String description) {
    return DungeonTarget.values.firstWhere(
      (target) => target.description == description,
      orElse: () => DungeonTarget.treasure,
    );
  }

  /// Encontra o enum DungeonTargetStatus baseado na descrição
  static DungeonTargetStatus _findDungeonTargetStatus(String description) {
    return DungeonTargetStatus.values.firstWhere(
      (status) => status.description == description,
      orElse: () => DungeonTargetStatus.intact,
    );
  }

  /// Encontra o enum DungeonLocation baseado na descrição
  static DungeonLocation _findDungeonLocation(String description) {
    return DungeonLocation.values.firstWhere(
      (location) => location.description == description,
      orElse: () => DungeonLocation.wildForest,
    );
  }

  /// Encontra o enum DungeonEntry baseado na descrição
  static DungeonEntry _findDungeonEntry(String description) {
    return DungeonEntry.values.firstWhere(
      (entry) => entry.description == description,
      orElse: () => DungeonEntry.secretTunnel,
    );
  }

  /// Encontra o enum RumorSubject baseado na descrição
  static RumorSubject _findRumorSubject(String description) {
    return RumorSubject.values.firstWhere(
      (subject) => subject.description == description,
      orElse: () => RumorSubject.drunkPeasant,
    );
  }

  /// Encontra o enum RumorAction baseado na descrição
  static RumorAction _findRumorAction(String description) {
    return RumorAction.values.firstWhere(
      (action) => action.description == description,
      orElse: () => RumorAction.seenNear,
    );
  }

  /// Encontra o enum RumorLocation baseado na descrição
  static RumorLocation _findRumorLocation(String description) {
    return RumorLocation.values.firstWhere(
      (location) => location.description == description,
      orElse: () => RumorLocation.nearbyVillage,
    );
  }
}
