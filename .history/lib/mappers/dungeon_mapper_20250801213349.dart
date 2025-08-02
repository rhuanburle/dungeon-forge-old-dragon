// mappers/dungeon_mapper.dart

import '../models/dungeon.dart';
import '../models/dto/dungeon_generation_dto.dart';
import '../models/room.dart';
import '../enums/table_enums.dart';

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
