// models/dto/dungeon_generation_dto.dart

/// DTO para dados de geração de masmorra usando a Tabela 9.1
class DungeonGenerationDto {
  final String type;
  final String builderOrInhabitant;
  final String status;
  final String objective;
  final String target;
  final String targetStatus;
  final String location;
  final String entry;
  final String sizeFormula;
  final String occupantI;
  final String occupantII;
  final String leader;
  final String rumorSubject;
  final String rumorAction;
  final String rumorLocation;

  const DungeonGenerationDto({
    required this.type,
    required this.builderOrInhabitant,
    required this.status,
    required this.objective,
    required this.target,
    required this.targetStatus,
    required this.location,
    required this.entry,
    required this.sizeFormula,
    required this.occupantI,
    required this.occupantII,
    required this.leader,
    required this.rumorSubject,
    required this.rumorAction,
    required this.rumorLocation,
  });

  /// Combina objetivo, alvo e status em uma descrição completa
  String get fullObjective {
    return '$objective $target $targetStatus';
  }

  /// Combina os componentes do rumor em uma descrição completa
  String get fullRumor {
    String subject = rumorSubject;
    String action = rumorAction;
    String location = rumorLocation;

    // Substitui referências de coluna pelos valores reais
    subject = _resolveColumnReference(subject, 'coluna 11', occupantI);
    subject = _resolveColumnReference(subject, 'coluna 10', occupantI);
    subject = _resolveColumnReference(subject, 'coluna 12', leader);

    return '$subject $action $location';
  }

  /// Resolve referências de coluna nos rumores
  String _resolveColumnReference(String text, String reference, String value) {
    return text.replaceAll('[$reference]', value);
  }

  /// Cria uma cópia com novos valores
  DungeonGenerationDto copyWith({
    DungeonType? type,
    DungeonBuilder? builderOrInhabitant,
    DungeonStatus? status,
    DungeonObjective? objective,
    DungeonTarget? target,
    DungeonTargetStatus? targetStatus,
    DungeonLocation? location,
    DungeonEntry? entry,
    String? sizeFormula,
    String? occupantI,
    String? occupantII,
    String? leader,
    RumorSubject? rumorSubject,
    RumorAction? rumorAction,
    RumorLocation? rumorLocation,
  }) {
    return DungeonGenerationDto(
      type: type ?? this.type,
      builderOrInhabitant: builderOrInhabitant ?? this.builderOrInhabitant,
      status: status ?? this.status,
      objective: objective ?? this.objective,
      target: target ?? this.target,
      targetStatus: targetStatus ?? this.targetStatus,
      location: location ?? this.location,
      entry: entry ?? this.entry,
      sizeFormula: sizeFormula ?? this.sizeFormula,
      occupantI: occupantI ?? this.occupantI,
      occupantII: occupantII ?? this.occupantII,
      leader: leader ?? this.leader,
      rumorSubject: rumorSubject ?? this.rumorSubject,
      rumorAction: rumorAction ?? this.rumorAction,
      rumorLocation: rumorLocation ?? this.rumorLocation,
    );
  }

  @override
  String toString() {
    return 'DungeonGenerationDto(type: $type, builderOrInhabitant: $builderOrInhabitant, status: $status, objective: $objective, target: $target, targetStatus: $targetStatus, location: $location, entry: $entry, sizeFormula: $sizeFormula, occupantI: $occupantI, occupantII: $occupantII, leader: $leader, rumorSubject: $rumorSubject, rumorAction: $rumorAction, rumorLocation: $rumorLocation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DungeonGenerationDto &&
        other.type == type &&
        other.builderOrInhabitant == builderOrInhabitant &&
        other.status == status &&
        other.objective == objective &&
        other.target == target &&
        other.targetStatus == targetStatus &&
        other.location == location &&
        other.entry == entry &&
        other.sizeFormula == sizeFormula &&
        other.occupantI == occupantI &&
        other.occupantII == occupantII &&
        other.leader == leader &&
        other.rumorSubject == rumorSubject &&
        other.rumorAction == rumorAction &&
        other.rumorLocation == rumorLocation;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      builderOrInhabitant,
      status,
      objective,
      target,
      targetStatus,
      location,
      entry,
      sizeFormula,
      occupantI,
      occupantII,
      leader,
      rumorSubject,
      rumorAction,
      rumorLocation,
    );
  }
}

/// DTO para dados de geração de sala usando a Tabela 9.2
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

  /// Verifica se a sala tem itens especiais
  bool get hasSpecialItems => specialItem != null;

  /// Verifica se a sala tem monstros
  bool get hasMonsters => monster != null;

  /// Verifica se a sala tem armadilhas
  bool get hasTraps => trap != null || specialTrap != null;

  /// Verifica se a sala tem tesouro
  bool get hasTreasure => treasure != Treasure.noTreasure;

  /// Obtém o tipo de sala como string descritiva
  String get typeDescription {
    switch (type) {
      case RoomType.specialRoom:
        return 'Sala Especial';
      case RoomType.trap:
        return 'Armadilha';
      case RoomType.commonRoom:
        return 'Sala Comum';
      case RoomType.monster:
        return 'Encontro';
      case RoomType.specialTrap:
        return 'Sala Armadilha Especial';
    }
  }

  /// Cria uma cópia com novos valores
  RoomGenerationDto copyWith({
    RoomType? type,
    AirCurrent? airCurrent,
    Smell? smell,
    Sound? sound,
    FoundItem? foundItem,
    SpecialItem? specialItem,
    CommonRoom? commonRoom,
    SpecialRoom? specialRoom,
    SpecialRoom2? specialRoom2,
    Monster? monster,
    Trap? trap,
    SpecialTrap? specialTrap,
    Treasure? treasure,
    SpecialTreasure? specialTreasure,
    MagicItem? magicItem,
  }) {
    return RoomGenerationDto(
      type: type ?? this.type,
      airCurrent: airCurrent ?? this.airCurrent,
      smell: smell ?? this.smell,
      sound: sound ?? this.sound,
      foundItem: foundItem ?? this.foundItem,
      specialItem: specialItem ?? this.specialItem,
      commonRoom: commonRoom ?? this.commonRoom,
      specialRoom: specialRoom ?? this.specialRoom,
      specialRoom2: specialRoom2 ?? this.specialRoom2,
      monster: monster,
      trap: trap,
      specialTrap: specialTrap,
      treasure: treasure ?? this.treasure,
      specialTreasure: specialTreasure ?? this.specialTreasure,
      magicItem: magicItem ?? this.magicItem,
    );
  }

  @override
  String toString() {
    return 'RoomGenerationDto(type: $type, airCurrent: $airCurrent, smell: $smell, sound: $sound, foundItem: $foundItem, specialItem: $specialItem, commonRoom: $commonRoom, specialRoom: $specialRoom, specialRoom2: $specialRoom2, monster: $monster, trap: $trap, specialTrap: $specialTrap, treasure: $treasure, specialTreasure: $specialTreasure, magicItem: $magicItem)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RoomGenerationDto &&
        other.type == type &&
        other.airCurrent == airCurrent &&
        other.smell == smell &&
        other.sound == sound &&
        other.foundItem == foundItem &&
        other.specialItem == specialItem &&
        other.commonRoom == commonRoom &&
        other.specialRoom == specialRoom &&
        other.specialRoom2 == specialRoom2 &&
        other.monster == monster &&
        other.trap == trap &&
        other.specialTrap == specialTrap &&
        other.treasure == treasure &&
        other.specialTreasure == specialTreasure &&
        other.magicItem == magicItem;
  }

  @override
  int get hashCode {
    return Object.hash(
      type,
      airCurrent,
      smell,
      sound,
      foundItem,
      specialItem,
      commonRoom,
      specialRoom,
      specialRoom2,
      monster,
      trap,
      specialTrap,
      treasure,
      specialTreasure,
      magicItem,
    );
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
  bool get hasValue =>
      copperPieces != null ||
      silverPieces != null ||
      goldPieces != null ||
      gems != null ||
      valuableObjects != null ||
      magicItem != null;
}
