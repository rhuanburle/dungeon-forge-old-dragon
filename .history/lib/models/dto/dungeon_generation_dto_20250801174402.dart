// models/dto/dungeon_generation_dto.dart

import '../../enums/dungeon_tables.dart';
import '../../enums/room_tables.dart';

/// DTO para representar os dados de geração de uma masmorra
class DungeonGenerationDto {
  final DungeonType type;
  final DungeonBuilder builder;
  final DungeonStatus status;
  final DungeonObjective objective;
  final DungeonTarget target;
  final DungeonTargetStatus targetStatus;
  final DungeonLocation location;
  final DungeonEntry entry;
  final DungeonSize size;
  final String sizeFormula;
  final DungeonOccupant occupantI;
  final DungeonOccupant occupantII;
  final DungeonOccupant leader;
  final RumorSubject rumorSubject;
  final RumorAction rumorAction;
  final RumorLocation rumorLocation;

  const DungeonGenerationDto({
    required this.type,
    required this.builder,
    required this.status,
    required this.objective,
    required this.target,
    required this.targetStatus,
    required this.location,
    required this.entry,
    required this.size,
    required this.sizeFormula,
    required this.occupantI,
    required this.occupantII,
    required this.leader,
    required this.rumorSubject,
    required this.rumorAction,
    required this.rumorLocation,
  });

  /// Constrói o objetivo completo da masmorra
  String get fullObjective => '${objective.description} ${target.description} ${targetStatus.description}';

  /// Constrói o rumor completo
  String get fullRumor => '${rumorSubject.description} ${rumorAction.description} ${rumorLocation.description}';

  /// Resolve as referências de coluna no rumor
  String resolveRumorReferences(String occupantI, String occupantII, String leader) {
    return fullRumor
        .replaceAll('[coluna 10]', occupantI)
        .replaceAll('[coluna 11]', occupantII)
        .replaceAll('[coluna 12]', leader);
  }
}

/// DTO para representar os dados de geração de uma sala
class RoomGenerationDto {
  final RoomType type;
  final AirCurrent airCurrent;
  final Smell smell;
  final Sound sound;
  final FoundItem foundItem;
  final SpecialItem? specialItem;
  final CommonRoom? commonRoom;
  final SpecialRoom? specialRoom;
  final SpecialRoom2? specialRoom2;
  final Monster? monster;
  final Trap? trap;
  final SpecialTrap? specialTrap;
  final Treasure treasure;
  final SpecialTreasure? specialTreasure;
  final MagicItem? magicItem;

  const RoomGenerationDto({
    required this.type,
    required this.airCurrent,
    required this.smell,
    required this.sound,
    required this.foundItem,
    this.specialItem,
    this.commonRoom,
    this.specialRoom,
    this.specialRoom2,
    this.monster,
    this.trap,
    this.specialTrap,
    required this.treasure,
    this.specialTreasure,
    this.magicItem,
  });

  /// Determina se a sala tem armadilha
  bool get hasTrap => type == RoomType.trap || type == RoomType.specialTrap;

  /// Determina se a sala tem encontro
  bool get hasMonster => type == RoomType.monster;

  /// Obtém o modificador de tesouro baseado no tipo de sala
  int get treasureModifier {
    if (hasTrap) return 1;
    if (hasMonster) return 2;
    return 0;
  }
}

/// DTO para representar os dados de tesouro
class TreasureDto {
  final String description;
  final int? copperPieces;
  final int? silverPieces;
  final int? goldPieces;
  final int? gems;
  final int? valuableObjects;
  final String? magicItem;

  const TreasureDto({
    required this.description,
    this.copperPieces,
    this.silverPieces,
    this.goldPieces,
    this.gems,
    this.valuableObjects,
    this.magicItem,
  });

  /// Verifica se o tesouro tem algum valor
  bool get hasValue => copperPieces != null || silverPieces != null || 
                      goldPieces != null || gems != null || 
                      valuableObjects != null || magicItem != null;
} 