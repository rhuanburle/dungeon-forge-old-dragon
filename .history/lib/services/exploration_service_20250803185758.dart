import '../enums/exploration_enums.dart';
import '../enums/table_enums.dart';
import '../models/exploration.dart';
import '../utils/dice_roller.dart';

/// Serviço responsável pela geração de descobertas de exploração dos Ermos
class ExplorationService {
  ExplorationService();

  /// Teste de explorar - 1 chance em 1d6 de descobrir algo
  ExplorationResult exploreHex({required bool isWilderness}) {
    // Para áreas selvagens: 1d6 (1 chance em 6)
    // Para áreas civilizadas: 1d8 (1 chance em 8)
    final maxValue = isWilderness ? 6 : 8;
    final roll = DiceRoller.rollStatic(1, maxValue);
    final hasDiscovery = roll == 1;

    if (!hasDiscovery) {
      return const ExplorationResult(
        hasDiscovery: false,
        description: 'Nada foi descoberto nesta exploração.',
      );
    }

    // Corrigir: usar rolagem aleatória para determinar o tipo de descoberta
    final discoveryRoll = DiceRoller.rollStatic(1, isWilderness ? 6 : 8);
    final discoveryType = _getDiscoveryType(discoveryRoll, isWilderness);
    final description = _getDiscoveryDescription(discoveryType);

    return ExplorationResult(
      hasDiscovery: true,
      discoveryType: discoveryType,
      description: description,
    );
  }

  /// Explora hex com tipo de descoberta específico (seleção manual)
  ExplorationResult exploreHexWithType(DiscoveryType discoveryType) {
    final description = _getDiscoveryDescription(discoveryType);

    return ExplorationResult(
      hasDiscovery: true,
      discoveryType: discoveryType,
      description: description,
    );
  }

  /// Gera descoberta ancestral (Tabela 4.4)
  AncestralDiscovery generateAncestralDiscovery() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final conditionRoll = DiceRoller.rollStatic(1, 6);
    final materialRoll = DiceRoller.rollStatic(1, 6);
    final stateRoll = DiceRoller.rollStatic(1, 6);
    final guardianRoll = DiceRoller.rollStatic(1, 6);

    final type = _getAncestralThingType(typeRoll);
    final condition = _getAncestralCondition(conditionRoll);
    final material = _getAncestralMaterial(materialRoll);
    final state = _getAncestralState(stateRoll);
    final guardian = _getAncestralGuardian(guardianRoll);

    final description = _generateAncestralDescription(
      type,
      condition,
      material,
      state,
      guardian,
    );

    return AncestralDiscovery(
      type: type,
      condition: condition,
      material: material,
      state: state,
      guardian: guardian,
      description: description,
    );
  }

  /// Gera ruínas (Tabela 4.5)
  Ruin generateRuin(RuinType ruinType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getRuinDetails(ruinType, roll);

    return Ruin(
      type: ruinType,
      description: '${ruinType.description} encontrada',
      details: details,
    );
  }

  /// Gera relíquias (Tabela 4.6)
  Relic generateRelic(RelicType relicType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getRelicDetails(relicType, roll);

    return Relic(
      type: relicType,
      description: '${relicType.description} encontrada',
      details: details,
    );
  }

  /// Gera objetos (Tabela 4.8)
  Object generateObject(ObjectType objectType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getObjectDetails(objectType, roll);

    return Object(
      type: objectType,
      description: '${objectType.description} encontrado',
      details: details,
    );
  }

  /// Gera vestígios (Tabela 4.9)
  Vestige generateVestige(VestigeType vestigeType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getVestigeDetails(vestigeType, roll);

    return Vestige(
      type: vestigeType,
      description: '${vestigeType.description} encontrado',
      details: details,
    );
  }

  /// Gera ossadas (Tabela 4.11)
  Ossuary generateOssuary(OssuaryType ossuaryType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getOssuaryDetails(ossuaryType, roll);

    return Ossuary(
      type: ossuaryType,
      description: '${ossuaryType.description} encontradas',
      details: details,
    );
  }

  /// Gera itens mágicos (Tabela 4.12)
  MagicalItem generateMagicalItem(MagicalItemType magicalItemType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final details = _getMagicalItemDetails(magicalItemType, roll);

    return MagicalItem(
      type: magicalItemType,
      description: '${magicalItemType.description} encontrado',
      details: details,
    );
  }

  /// Gera covil de monstros (Tabela 4.13)
  Lair generateLair() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final occupationRoll = DiceRoller.rollStatic(1, 6);

    final type = _getLairType(typeRoll);
    final occupation = _getLairOccupation(occupationRoll);

    return Lair(
      type: type,
      occupation: occupation,
      description:
          '${type.description} ${occupation.description.toLowerCase()}',
    );
  }

  /// Gera masmorra (Tabela 4.14)
  Dungeon generateDungeon() {
    final entryRoll = DiceRoller.rollStatic(1, 6);
    final floorsRoll = DiceRoller.rollStatic(1, 6);
    final roomsRoll = DiceRoller.rollStatic(1, 6);
    final guardianRoll = DiceRoller.rollStatic(1, 6);

    final entry = _getDungeonEntry(entryRoll);
    final floors = _getDungeonFloors(floorsRoll);
    final rooms = _getDungeonRooms(roomsRoll);
    final guardian = _getDungeonGuardian(guardianRoll);

    return Dungeon(
      entry: entry,
      floors: floors,
      rooms: rooms,
      guardian: guardian,
      description: 'Masmorra com $floors andares e $rooms salas',
    );
  }

  /// Gera caverna (Tabela 4.16)
  Cave generateCave() {
    final roll = DiceRoller.rollStatic(1, 6);
    final entry = _getCaveEntry(roll);
    final inhabitant = _getCaveInhabitant(roll);

    return Cave(
      entry: entry,
      inhabitant: inhabitant,
      description: 'Caverna com $entry habitada por $inhabitant',
    );
  }

  /// Gera toca (Tabela 4.18)
  Burrow generateBurrow() {
    final entryRoll = DiceRoller.rollStatic(1, 6);
    final occupantRoll = DiceRoller.rollStatic(1, 6);
    final treasureRoll = DiceRoller.rollStatic(1, 6);

    final entry = _getBurrowEntry(entryRoll);
    final occupant = _getBurrowOccupant(entryRoll, occupantRoll);
    final treasure = _getBurrowTreasure(treasureRoll);

    return Burrow(
      entry: entry,
      occupant: occupant,
      treasure: treasure,
      description: 'Toca com $entry habitada por $occupant',
    );
  }

  /// Gera ninho (Tabela 4.21)
  Nest generateNest() {
    final roll = DiceRoller.rollStatic(1, 6);
    final owner = _getNestOwner(roll);
    final characteristic = _getNestCharacteristic(roll);

    return Nest(
      owner: owner,
      characteristic: characteristic,
      description: 'Ninho de $owner com $characteristic',
    );
  }

  /// Gera acampamento (Tabela 4.22)
  Camp generateCamp() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final specialRoll = DiceRoller.rollStatic(1, 6);
    final tentsRoll = DiceRoller.rollStatic(1, 6);
    final watchRoll = DiceRoller.rollStatic(1, 6);
    final defensesRoll = DiceRoller.rollStatic(1, 6);

    final type = _getCampType(typeRoll);
    final special = _getCampSpecial(specialRoll);
    final tents = _getCampTents(tentsRoll);
    final watch = _getCampWatch(watchRoll);
    final defenses = _getCampDefenses(defensesRoll);

    return Camp(
      type: type,
      special: special,
      tents: tents,
      watch: watch,
      defenses: defenses,
      description: 'Acampamento de $type com $defenses',
    );
  }

  /// Gera tribo (Tabela 4.23)
  Tribe generateTribe(TerrainType terrainType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getTribeType(terrainType, roll);
    final members = _getTribeMembers(type);
    final soldiers = _getTribeSoldiers(type, members);
    final leaders = _getTribeLeaders(type);
    final religious = _getTribeReligious(type, members);
    final special = _getTribeSpecial(type, members);

    return Tribe(
      type: type,
      members: members,
      soldiers: soldiers,
      leaders: leaders,
      religious: religious,
      special: special,
      description: 'Tribo de $type com $members membros',
    );
  }

  /// Gera rios, estradas e ilhas (Tabela 4.25)
  RiversRoadsIslands generateRiversRoadsIslands({
    required bool isOcean,
    required bool hasRiver,
  }) {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getRiversRoadsIslandsType(isOcean, hasRiver, roll);
    final description = _getRiversRoadsIslandsDescription(type);
    final details = _getRiversRoadsIslandsDetails(type);

    return RiversRoadsIslands(
      type: type,
      description: description,
      details: details,
    );
  }

  /// Gera castelo ou forte (Tabela 4.30)
  CastleFort generateCastleFort() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getCastleFortType(roll);
    final description = _getCastleFortDescription(type);
    final details = _getCastleFortDetails(type);

    return CastleFort(type: type, description: description, details: details);
  }

  /// Gera templo ou santuário (Tabela 4.33)
  TempleSanctuary generateTempleSanctuary() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getTempleSanctuaryType(roll);
    final description = _getTempleSanctuaryDescription(type);
    final details = _getTempleSanctuaryDetails(type);

    return TempleSanctuary(
      type: type,
      description: description,
      details: details,
    );
  }

  /// Gera perigo natural (Tabela 4.38)
  NaturalDanger generateNaturalDanger(TerrainType terrainType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getNaturalDangerType(terrainType, roll);
    final description = _getNaturalDangerDescription(type);

    return NaturalDanger(type: type, description: description);
  }

  /// Gera civilização (Tabela 4.39)
  Civilization generateCivilization() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getCivilizationType(roll);
    final description = _getCivilizationDescription(type);
    final details = _getCivilizationDetails(type);

    return Civilization(type: type, description: description, details: details);
  }

  /// Gera assentamento (Tabela 4.40)
  Settlement generateSettlement() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getSettlementType(roll);
    final description = _getSettlementDescription(type);
    final details = _getSettlementDetails(type);

    return Settlement(type: type, description: description, details: details);
  }

  // Métodos auxiliares para determinar tipos baseados em rolagens
  DiscoveryType _getDiscoveryType(int roll, bool isWilderness) {
    if (isWilderness) {
      // 1d6 para áreas selvagens (1-6)
      switch (roll) {
        case 1:
          return DiscoveryType.ancestralDiscoveries;
        case 2:
          return DiscoveryType.lairs;
        case 3:
          return DiscoveryType.riversRoadsIslands;
        case 4:
          return DiscoveryType.castlesForts;
        case 5:
          return DiscoveryType.templesSanctuaries;
        case 6:
          return DiscoveryType.naturalDangers;
        default:
          return DiscoveryType.ancestralDiscoveries;
      }
    } else {
      // 1d8 para áreas civilizadas (1-8)
      switch (roll) {
        case 1:
          return DiscoveryType.ancestralDiscoveries;
        case 2:
          return DiscoveryType.lairs;
        case 3:
          return DiscoveryType.riversRoadsIslands;
        case 4:
          return DiscoveryType.castlesForts;
        case 5:
          return DiscoveryType.templesSanctuaries;
        case 6:
          return DiscoveryType.naturalDangers;
        case 7:
        case 8:
          return DiscoveryType.civilization;
        default:
          return DiscoveryType.ancestralDiscoveries;
      }
    }
  }

  String _getDiscoveryDescription(DiscoveryType type) {
    return 'Descoberta: ${type.description}';
  }

  AncestralThingType _getAncestralThingType(int roll) {
    switch (roll) {
      case 1:
        return AncestralThingType.ruins;
      case 2:
        return AncestralThingType.relics;
      case 3:
        return AncestralThingType.objects;
      case 4:
        return AncestralThingType.vestiges;
      case 5:
        return AncestralThingType.ossuaries;
      case 6:
        return AncestralThingType.magicalItems;
      default:
        return AncestralThingType.ruins;
    }
  }

  AncestralCondition _getAncestralCondition(int roll) {
    switch (roll) {
      case 1:
        return AncestralCondition.partiallyCovered;
      case 2:
        return AncestralCondition.totallyCovered;
      case 3:
        return AncestralCondition.overgrown;
      case 4:
        return AncestralCondition.inCrevice;
      case 5:
        return AncestralCondition.inCrater;
      case 6:
        return AncestralCondition.inCave;
      default:
        return AncestralCondition.partiallyCovered;
    }
  }

  AncestralMaterial _getAncestralMaterial(int roll) {
    switch (roll) {
      case 1:
        return AncestralMaterial.ashes;
      case 2:
        return AncestralMaterial.sandOrEarth;
      case 3:
        return AncestralMaterial.vegetation;
      case 4:
        return AncestralMaterial.stone;
      case 5:
        return AncestralMaterial.vines;
      case 6:
        return AncestralMaterial.webs;
      default:
        return AncestralMaterial.ashes;
    }
  }

  AncestralState _getAncestralState(int roll) {
    switch (roll) {
      case 1:
        return AncestralState.veryDeteriorated;
      case 2:
        return AncestralState.partiallyDeteriorated;
      case 3:
        return AncestralState.ruinedAndFallen;
      case 4:
        return AncestralState.partiallyOperational;
      case 5:
        return AncestralState.fullyOperational;
      case 6:
        return AncestralState.almostUntouched;
      default:
        return AncestralState.veryDeteriorated;
    }
  }

  AncestralGuardian _getAncestralGuardian(int roll) {
    switch (roll) {
      case 1:
        return AncestralGuardian.none;
      case 2:
        return AncestralGuardian.traps;
      case 3:
        return AncestralGuardian.giants;
      case 4:
        return AncestralGuardian.undead;
      case 5:
        return AncestralGuardian.others;
      case 6:
        return AncestralGuardian.dragons;
      default:
        return AncestralGuardian.none;
    }
  }

  String _generateAncestralDescription(
    AncestralThingType type,
    AncestralCondition condition,
    AncestralMaterial material,
    AncestralState state,
    AncestralGuardian guardian,
  ) {
    return '${type.description} ${condition.description} ${material.description}, ${state.description}. ${guardian.description}.';
  }

  // Implementação dos métodos auxiliares para cada tipo de descoberta
  String _getRuinDetails(RuinType type, int roll) {
    // Tabela 4.5 - Ruínas
    switch (type) {
      case RuinType.house:
        switch (roll) {
          case 1:
            return 'Cabana';
          case 2:
            return 'Casebre';
          case 3:
            return 'Casa grande';
          case 4:
            return 'Mansão';
          case 5:
            return 'Fazenda';
          case 6:
            return 'Palácio';
          default:
            return 'Cabana';
        }
      case RuinType.village:
        switch (roll) {
          case 1:
            return '2d4 casas';
          case 2:
            return '2d6 casas';
          case 3:
            return '4d4 casas';
          case 4:
            return '4d6 casas';
          case 5:
            return '4d8 casas';
          case 6:
            return '8d6 casas';
          default:
            return '2d4 casas';
        }
      case RuinType.city:
        switch (roll) {
          case 1:
            return '10d6 casas';
          case 2:
            return '20d6 casas';
          case 3:
            return '10d6 casas + paliçada';
          case 4:
            return '20d6 casas + muralha';
          case 5:
            return '30d6 casas + muralha';
          case 6:
            return '30d6 casas + muralha + forte';
          default:
            return '10d6 casas';
        }
      case RuinType.fort:
        switch (roll) {
          case 1:
            return 'Torre';
          case 2:
            return 'Torre + muralha';
          case 3:
            return 'Forte pequeno';
          case 4:
            return 'Forte + torre';
          case 5:
            return 'Forte + 2 torres';
          case 6:
            return 'Forte + 2 torres + muralha';
          default:
            return 'Torre';
        }
      case RuinType.castle:
        switch (roll) {
          case 1:
            return 'Castelo + paliçada';
          case 2:
            return 'Castelo + paliçada + fosso';
          case 3:
            return 'Castelo + 2 torres + paliçada + fosso';
          case 4:
            return 'Castelo + 4 torres + paliçada + fosso';
          case 5:
            return 'Castelo + 4 torres + muralha + fosso';
          case 6:
            return 'Castelo + 6 torres + 2 muralhas + fosso';
          default:
            return 'Castelo + paliçada';
        }
      case RuinType.temple:
        switch (roll) {
          case 1:
            return 'Pequeno altar';
          case 2:
            return 'Santuário';
          case 3:
            return 'Igreja pequena';
          case 4:
            return 'Igreja grande';
          case 5:
            return 'Catedral';
          case 6:
            return 'Mosteiro';
          default:
            return 'Pequeno altar';
        }
    }
  }

  String _getRelicDetails(RelicType type, int roll) {
    // Tabela 4.6 - Relíquias
    switch (type) {
      case RelicType.tools:
        switch (roll) {
          case 1:
            return 'Escada';
          case 2:
            return 'Pá';
          case 3:
            return 'Picareta';
          case 4:
            return 'Martelo';
          case 5:
            return 'Serrote';
          case 6:
            return 'Machado';
          default:
            return 'Escada';
        }
      case RelicType.mechanisms:
        switch (roll) {
          case 1:
            return 'Relógio solar';
          case 2:
            return 'Balança';
          case 3:
            return 'Tear';
          case 4:
            return 'Rebolo';
          case 5:
            return 'Mós';
          case 6:
            return 'Ábaco';
          default:
            return 'Relógio solar';
        }
      case RelicType.tombs:
        switch (roll) {
          case 1:
            return 'Monte de terra';
          case 2:
            return 'Pilha de pedras';
          case 3:
            return 'Pira crematória';
          case 4:
            return 'Sarcófago de pedra';
          case 5:
            return 'Lápide com escrita';
          case 6:
            return 'Cripta subterrânea';
          default:
            return 'Monte de terra';
        }
      case RelicType.armors:
        switch (roll) {
          case 1:
            return 'Escudo...';
          case 2:
            return 'Armadura de couro...';
          case 3:
            return 'Cota de malha...';
          case 4:
            return 'Cota de malha...';
          case 5:
            return 'Armadura de placas...';
          case 6:
            return 'Armadura completa...';
          default:
            return 'Escudo...';
        }
      case RelicType.weapons:
        switch (roll) {
          case 1:
            return 'Adaga...';
          case 2:
            return 'Espada curta...';
          case 3:
            return 'Machado...';
          case 4:
            return 'Tridente...';
          case 5:
            return 'Espada longa...';
          case 6:
            return 'Lança...';
          default:
            return 'Adaga...';
        }
      case RelicType.containers:
        switch (roll) {
          case 1:
            return 'Barril...';
          case 2:
            return 'Arca...';
          case 3:
            return 'Caixa de madeira...';
          case 4:
            return 'Jarros de cerâmica...';
          case 5:
            return 'Mochila...';
          case 6:
            return 'Sacos de couro...';
          default:
            return 'Barril...';
        }
    }
  }

  String _getObjectDetails(ObjectType type, int roll) {
    // Tabela 4.8 - Objetos
    switch (type) {
      case ObjectType.utensils:
        switch (roll) {
          case 1:
            return 'Talheres';
          case 2:
            return 'Para costura';
          case 3:
            return 'Para escrever';
          case 4:
            return 'Instrumento musical';
          case 5:
            return 'Para navegação';
          case 6:
            return 'Para primeiros socorros';
          default:
            return 'Talheres';
        }
      case ObjectType.clothes:
        switch (roll) {
          case 1:
            return 'Túnicas e camisas';
          case 2:
            return 'Roupas de cama';
          case 3:
            return 'Roupas íntimas';
          case 4:
            return 'Traje de exploração';
          case 5:
            return 'Trajes para inverno';
          case 6:
            return 'Trajes nobres';
          default:
            return 'Túnicas e camisas';
        }
      case ObjectType.furniture:
        switch (roll) {
          case 1:
            return 'Trono';
          case 2:
            return 'Cama';
          case 3:
            return 'Mesa';
          case 4:
            return 'Cofre';
          case 5:
            return 'Vários gigantes';
          case 6:
            return 'Vários em miniatura';
          default:
            return 'Trono';
        }
      case ObjectType.toys:
        switch (roll) {
          case 1:
            return 'Boneca de pano';
          case 2:
            return 'Boneca de louça';
          case 3:
            return 'Cavalo de madeira';
          case 4:
            return 'Soldado de chumbo';
          case 5:
            return 'Arma de madeira';
          case 6:
            return 'Jogo de tabuleiro';
          default:
            return 'Boneca de pano';
        }
      case ObjectType.vehicles:
        switch (roll) {
          case 1:
            return 'Carroça';
          case 2:
            return 'Carruagem';
          case 3:
            return 'Sela e arreio de cavalo';
          case 4:
            return 'Barcaça';
          case 5:
            return 'Canoa';
          case 6:
            return 'Balão';
          default:
            return 'Carroça';
        }
      case ObjectType.books:
        switch (roll) {
          case 1:
            return 'Mapa de tesouro';
          case 2:
            return 'Dicionário 2 idiomas';
          case 3:
            return 'Enciclopédia';
          case 4:
            return 'Romance picante';
          case 5:
            return 'Caderno com anotações';
          case 6:
            return 'Pergaminho mágico';
          default:
            return 'Mapa de tesouro';
        }
    }
  }

  String _getVestigeDetails(VestigeType type, int roll) {
    // Tabela 4.9 - Vestígios
    switch (type) {
      case VestigeType.religious:
        switch (roll) {
          case 1:
            return 'Pirâmide';
          case 2:
            return 'Observatório lunar';
          case 3:
            return 'Círculo de pedra';
          case 4:
            return 'Monolito';
          case 5:
            return 'Totem';
          case 6:
            return 'Altar';
          default:
            return 'Pirâmide';
        }
      case VestigeType.signs:
        switch (roll) {
          case 1:
            return 'Marco de fronteira';
          case 2:
            return 'Aviso de água potável';
          case 3:
            return 'Perigo. Monstros';
          case 4:
            return 'Refúgio seguro';
          case 5:
            return 'Magia à frente';
          case 6:
            return 'Perigo. Vá embora';
          default:
            return 'Marco de fronteira';
        }
      case VestigeType.ancient:
        switch (roll) {
          case 1:
            return 'Pontas de flecha';
          case 2:
            return 'Ídolo monstruoso';
          case 3:
            return 'Desenhos rupestres';
          case 4:
            return 'Artesanato de ossos';
          case 5:
            return 'Cestos de palha';
          case 6:
            return 'Cerâmica';
          default:
            return 'Pontas de flecha';
        }
      case VestigeType.source:
        switch (roll) {
          case 1:
            return 'Chafariz...';
          case 2:
            return 'Estátua de mulher...';
          case 3:
            return 'Estátua monstruosa...';
          case 4:
            return 'Nascente no chão...';
          case 5:
            return 'Poço...';
          case 6:
            return 'Gêiser...';
          default:
            return 'Chafariz...';
        }
      case VestigeType.structure:
        switch (roll) {
          case 1:
            return 'Dique';
          case 2:
            return 'Muro';
          case 3:
            return 'Moinho';
          case 4:
            return 'Aqueduto';
          case 5:
            return 'Mina abandonada';
          case 6:
            return 'Escadaria';
          default:
            return 'Dique';
        }
      case VestigeType.paths:
        switch (roll) {
          case 1:
            return 'Trilha';
          case 2:
            return 'Trilhos';
          case 3:
            return 'Caminho pavimentado';
          case 4:
            return 'Ponte de madeira';
          case 5:
            return 'Ponte de pedras';
          case 6:
            return 'Ponte de cordas';
          default:
            return 'Trilha';
        }
    }
  }

  String _getOssuaryDetails(OssuaryType type, int roll) {
    // Tabela 4.11 - Ossadas
    switch (type) {
      case OssuaryType.small:
        switch (roll) {
          case 1:
            return 'Halfling';
          case 2:
            return 'Anão';
          case 3:
            return 'Gnomo';
          case 4:
            return 'Drakold';
          case 5:
            return 'Goblin';
          case 6:
            return 'Kobold';
          default:
            return 'Halfling';
        }
      case OssuaryType.humanoid:
        switch (roll) {
          case 1:
            return 'Humano';
          case 2:
            return 'Humano';
          case 3:
            return 'Humano';
          case 4:
            return 'Humano';
          case 5:
            return 'Elfo';
          case 6:
            return 'Meio-elfo';
          default:
            return 'Humano';
        }
      case OssuaryType.medium:
        switch (roll) {
          case 1:
            return 'Elfo Drow';
          case 2:
            return 'Hobgoblin';
          case 3:
            return 'Homem Lagarto';
          case 4:
            return 'Orc';
          case 5:
            return 'Sibilante';
          case 6:
            return 'Troglodita';
          default:
            return 'Elfo Drow';
        }
      case OssuaryType.large:
        switch (roll) {
          case 1:
            return 'Bugbear';
          case 2:
            return 'Centauro';
          case 3:
            return 'Ciclope';
          case 4:
            return 'Ettin';
          case 5:
            return 'Gnoll';
          case 6:
            return 'Ogro';
          default:
            return 'Bugbear';
        }
      case OssuaryType.colossal:
        switch (roll) {
          case 1:
            return 'Gigante da Colina';
          case 2:
            return 'Gigante da Montanha';
          case 3:
            return 'Gigante da Tempestade';
          case 4:
            return 'Hidra';
          case 5:
            return 'Víbora Gigante';
          case 6:
            return 'Dragão';
          default:
            return 'Gigante da Colina';
        }
      case OssuaryType.special:
        switch (roll) {
          case 1:
            return 'revestido de metal';
          case 2:
            return 'apenas os crânios';
          case 3:
            return 'humanoides com asas';
          case 4:
            return 'dentro de armaduras';
          case 5:
            return 'ossadas incompletas';
          case 6:
            return 'com tesouro do tipo B';
          default:
            return 'revestido de metal';
        }
    }
  }

  String _getMagicalItemDetails(MagicalItemType type, int roll) {
    // Tabela 4.12 - Itens Mágicos
    switch (type) {
      case MagicalItemType.weapons:
        switch (roll) {
          case 1:
            return 'Esp. Longa -1 Amaldiçoada (Caótica)';
          case 2:
            return 'Espada Longa +1';
          case 3:
            return 'Espada Longa +2';
          case 4:
            return 'Adaga +1';
          case 5:
            return 'Machado de Batalha +1';
          case 6:
            return 'Flechas +1 (10 unidades)';
          default:
            return 'Esp. Longa -1 Amaldiçoada (Caótica)';
        }
      case MagicalItemType.armors:
        switch (roll) {
          case 1:
            return 'Armadura -1 Amaldiçoada (Caótica)';
          case 2:
            return 'Armadura Acolchoada +1';
          case 3:
            return 'Armadura de Couro +1';
          case 4:
            return 'Armadura de Couro Batido +1';
          case 5:
            return 'Cota de Malha +1';
          case 6:
            return 'Escudo +1';
          default:
            return 'Armadura -1 Amaldiçoada (Caótica)';
        }
      case MagicalItemType.potions:
        switch (roll) {
          case 1:
            return 'Poção Amaldiçoada (Caótica)';
          case 2:
            return 'Poção de Cura';
          case 3:
            return 'Poção da Diminuição';
          case 4:
            return 'Poção da Forma Gasosa';
          case 5:
            return 'Poção da Força Gigante';
          case 6:
            return 'Venenos';
          default:
            return 'Poção Amaldiçoada (Caótica)';
        }
      case MagicalItemType.rings:
        switch (roll) {
          case 1:
            return 'Anel Amaldiçoado';
          case 2:
            return 'Anel de Proteção +1';
          case 3:
            return 'Anel do Controle de Animais';
          case 4:
            return 'Anel da Regeneração';
          case 5:
            return 'Anel da Invisibilidade';
          case 6:
            return 'Jogue 2 vezes nesta tabela';
          default:
            return 'Anel Amaldiçoado';
        }
      case MagicalItemType.staves:
        switch (roll) {
          case 1:
            return 'Varinha de Detecção de Magia';
          case 2:
            return 'Varinha de Paralisação';
          case 3:
            return 'Varinha de Bolas de Fogo';
          case 4:
            return 'Cajado da Cura';
          case 5:
            return 'Cajado de Ataque';
          case 6:
            return 'Bastão do Cancelamento';
          default:
            return 'Varinha de Detecção de Magia';
        }
      case MagicalItemType.others:
        switch (roll) {
          case 1:
            return 'Sacola Devoradora (Caótica)';
          case 2:
            return 'Bola de Cristal';
          case 3:
            return 'Manto Élfico';
          case 4:
            return 'Botas Élficas';
          case 5:
            return 'Manoplas da Força do Ogro';
          case 6:
            return 'Jogue 2 vezes nesta tabela';
          default:
            return 'Sacola Devoradora (Caótica)';
        }
    }
  }

  LairType _getLairType(int roll) {
    switch (roll) {
      case 1:
        return LairType.dungeons;
      case 2:
        return LairType.caves;
      case 3:
        return LairType.burrows;
      case 4:
        return LairType.nests;
      case 5:
        return LairType.camps;
      case 6:
        return LairType.tribes;
      default:
        return LairType.dungeons;
    }
  }

  LairOccupation _getLairOccupation(int roll) {
    switch (roll) {
      case 1:
        return LairOccupation.emptyAndAbandoned;
      case 2:
        return LairOccupation.empty;
      case 3:
        return LairOccupation.halfOccupied;
      case 4:
        return LairOccupation.halfOccupied;
      case 5:
        return LairOccupation.occupied;
      case 6:
        return LairOccupation.occupied;
      default:
        return LairOccupation.emptyAndAbandoned;
    }
  }

  String _getDungeonEntry(int roll) {
    switch (roll) {
      case 1:
        return 'Pequena gruta';
      case 2:
        return 'Túnel secreto';
      case 3:
        return 'Fissura numa grande rocha';
      case 4:
        return 'Buraco no chão';
      case 5:
        return 'Atrás de trepadeiras';
      case 6:
        return 'Tronco de uma árvore oca';
      default:
        return 'Pequena gruta';
    }
  }

  int _getDungeonFloors(int roll) {
    switch (roll) {
      case 1:
        return 1;
      case 2:
        return 2;
      case 3:
        return 2;
      case 4:
        return 2;
      case 5:
        return 3;
      case 6:
        return 4;
      default:
        return 1;
    }
  }

  int _getDungeonRooms(int roll) {
    switch (roll) {
      case 1:
        return DiceRoller.rollStatic(1, 4);
      case 2:
        return DiceRoller.rollStatic(1, 4) + 1;
      case 3:
        return DiceRoller.rollStatic(1, 6) + 1;
      case 4:
        return DiceRoller.rollStatic(2, 6) + 2;
      case 5:
        return DiceRoller.rollStatic(3, 6) + 3;
      case 6:
        return DiceRoller.rollStatic(5, 6) + 5;
      default:
        return DiceRoller.rollStatic(1, 4);
    }
  }

  String _getDungeonGuardian(int roll) {
    switch (roll) {
      case 1:
        return 'Nenhum';
      case 2:
        return 'Armadilhas';
      case 3:
        return 'Gigantes';
      case 4:
        return 'Mortos-Vivos';
      case 5:
        return 'Outros';
      case 6:
        return 'Dragões';
      default:
        return 'Nenhum';
    }
  }

  String _getCaveEntry(int roll) {
    switch (roll) {
      case 1:
        return 'Buraco no chão';
      case 2:
        return 'Fissura numa grande rocha';
      case 3:
        return 'Abertura em arco';
      case 4:
        return 'Abertura estreita sob rocha';
      case 5:
        return 'Por cima de um grupo de pedras';
      case 6:
        return 'No fundo de um vau';
      default:
        return 'Buraco no chão';
    }
  }

  String _getCaveInhabitant(int roll) {
    switch (roll) {
      case 1:
        return '${DiceRoller.rollStatic(1, 10)} Fungo Pigmeu';
      case 2:
        return '${DiceRoller.rollStatic(1, 6)} Aranha Negra Gigante';
      case 3:
        return '${DiceRoller.rollStatic(1, 2)} Urso Pardo';
      case 4:
        return '${DiceRoller.rollStatic(1, 6)} Urso-Coruja';
      case 5:
        return '${DiceRoller.rollStatic(1, 4)} Ettin';
      case 6:
        return '1 Dragão';
      default:
        return '${DiceRoller.rollStatic(1, 10)} Fungo Pigmeu';
    }
  }

  String _getBurrowEntry(int roll) {
    switch (roll) {
      case 1:
        return 'Fenda Profunda no solo';
      case 2:
        return 'Fenda Rasa no solo';
      case 3:
        return 'Colmeia Gigante em fenda na rocha';
      case 4:
        return 'Colmeia Gigante em túnel escavado';
      case 5:
        return 'Toca Escavada na terra';
      case 6:
        return 'Formigueiro Gigante';
      default:
        return 'Fenda Profunda no solo';
    }
  }

  String _getBurrowOccupant(int entryRoll, int occupantRoll) {
    // Tabela 4.19 - Ocupantes das Tocas
    switch (entryRoll) {
      case 1: // Fenda Profunda
        switch (occupantRoll) {
          case 1:
            return 'Aranha Caçadora Gigante (${DiceRoller.rollStatic(1, 2)})';
          case 2:
            return 'Centopeia Gigante (${DiceRoller.rollStatic(2, 4)})';
          case 3:
            return 'Escorpião Gigante (${DiceRoller.rollStatic(1, 6)})';
          case 4:
            return 'Víbora Gigante (${DiceRoller.rollStatic(1, 4)})';
          case 5:
            return 'Aranha Negra Gigante (${DiceRoller.rollStatic(1, 3)})';
          case 6:
            return 'Lagarto Gigante (${DiceRoller.rollStatic(1, 3)})';
          default:
            return 'Aranha Caçadora Gigante (${DiceRoller.rollStatic(1, 2)})';
        }
      case 2: // Fenda Rasa
        switch (occupantRoll) {
          case 1:
            return 'Aranha Camufladora Gigante (${DiceRoller.rollStatic(1, 4)})';
          case 2:
            return 'Besouro de Fogo Gigante (${DiceRoller.rollStatic(1, 4)})';
          case 3:
            return 'Besouro Bombardeiro Gigante (${DiceRoller.rollStatic(1, 3)})';
          case 4:
            return 'Centopeia Gigante (${DiceRoller.rollStatic(2, 4)})';
          case 5:
            return 'Sapo Gigante (${DiceRoller.rollStatic(2, 6)})';
          case 6:
            return 'Rato Gigante (${DiceRoller.rollStatic(2, 8)})';
          default:
            return 'Aranha Camufladora Gigante (${DiceRoller.rollStatic(1, 4)})';
        }
      case 3: // Colmeia Gigante em fenda na rocha
      case 4: // Colmeia Gigante em túnel escavado
        switch (occupantRoll) {
          case 1:
            return 'Formiga Gigante (${DiceRoller.rollStatic(1, 6)})';
          case 2:
            return 'Mosca Gigante (${DiceRoller.rollStatic(2, 4)})';
          case 3:
            return 'Vespa Gigante (${DiceRoller.rollStatic(2, 4)})';
          case 4:
            return 'Stirge (${DiceRoller.rollStatic(1, 4)})';
          case 5:
            return 'Abelhas Assassinas (${DiceRoller.rollStatic(2, 4)})';
          case 6:
            return 'Aranha Negra Gigante (${DiceRoller.rollStatic(1, 3)})';
          default:
            return 'Formiga Gigante (${DiceRoller.rollStatic(1, 6)})';
        }
      case 5: // Toca Escavada na terra
        switch (occupantRoll) {
          case 1:
            return 'Aranha Peluda Gigante (${DiceRoller.rollStatic(1, 2)})';
          case 2:
            return 'Aranha Camufladora Gigante (${DiceRoller.rollStatic(1, 4)})';
          case 3:
            return 'Centopeia Gigante (${DiceRoller.rollStatic(2, 4)})';
          case 4:
            return 'Besouro Bombardeiro Gigante (${DiceRoller.rollStatic(1, 3)})';
          case 5:
            return 'Lagarto Gigante (${DiceRoller.rollStatic(1, 3)})';
          case 6:
            return 'Rato Gigante (${DiceRoller.rollStatic(2, 8)})';
          default:
            return 'Aranha Peluda Gigante (${DiceRoller.rollStatic(1, 2)})';
        }
      case 6: // Formigueiro Gigante
        switch (occupantRoll) {
          case 1:
            return 'Besouro de Fogo Gigante (${DiceRoller.rollStatic(1, 4)})';
          case 2:
            return 'Formiga Gigante (${DiceRoller.rollStatic(1, 6)})';
          case 3:
            return 'Escorpião Gigante (${DiceRoller.rollStatic(1, 6)})';
          case 4:
            return 'Aranha Negra Gigante (${DiceRoller.rollStatic(1, 3)})';
          case 5:
            return 'Aranha Peluda Gigante (${DiceRoller.rollStatic(1, 2)})';
          case 6:
            return 'Centopeia Gigante (${DiceRoller.rollStatic(2, 4)})';
          default:
            return 'Besouro de Fogo Gigante (${DiceRoller.rollStatic(1, 4)})';
        }
      default:
        return 'Ocupante da toca';
    }
  }

  String _getBurrowTreasure(int roll) {
    switch (roll) {
      case 1:
        return 'Nada Encontrado';
      case 2:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias';
      case 3:
        return '${DiceRoller.rollStatic(1, 3)} Relíquias';
      case 4:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias + ${DiceRoller.rollStatic(1, 2)} Objetos';
      case 5:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias + ${DiceRoller.rollStatic(1, 2)} Objetos + ${DiceRoller.rollStatic(1, 2)} Ossadas';
      case 6:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias + 1 Item Mágico';
      default:
        return 'Nada Encontrado';
    }
  }

  String _getNestOwner(int roll) {
    switch (roll) {
      case 1:
        return '${DiceRoller.rollStatic(1, 6)} Águia Gigante';
      case 2:
        return '${DiceRoller.rollStatic(1, 6)} Pégaso';
      case 3:
        return '${DiceRoller.rollStatic(1, 4)} Wyvern';
      case 4:
        return '${DiceRoller.rollStatic(1, 4)} Grifo';
      case 5:
        return '${DiceRoller.rollStatic(1, 4)} Harpia';
      case 6:
        return '${DiceRoller.rollStatic(1, 4)} Mantícora';
      default:
        return '${DiceRoller.rollStatic(1, 6)} Águia Gigante';
    }
  }

  String _getNestCharacteristic(int roll) {
    switch (roll) {
      case 1:
        return 'Plataforma rochosa';
      case 2:
        return 'Oco no topo de árvores';
      case 3:
        return 'Grutas de pedra';
      case 4:
        return 'Ninho de gravetos';
      case 5:
        return 'Contém ${DiceRoller.rollStatic(1, 3)} ovos';
      case 6:
        return 'Contém ${DiceRoller.rollStatic(1, 2)} filhotes';
      default:
        return 'Plataforma rochosa';
    }
  }

  String _getCampType(int roll) {
    switch (roll) {
      case 1:
        return '${DiceRoller.rollStatic(2, 4) * 10} Bandidos';
      case 2:
        return '${DiceRoller.rollStatic(3, 10) * 10} Bárbaros';
      case 3:
        return '${DiceRoller.rollStatic(2, 4)} Cultistas';
      case 4:
        return '${DiceRoller.rollStatic(7, 6)} Mercenários';
      case 5:
        return '${DiceRoller.rollStatic(2, 6)} Patrulha';
      case 6:
        return 'Especial';
      default:
        return '${DiceRoller.rollStatic(2, 4) * 10} Bandidos';
    }
  }

  String _getCampSpecial(int roll) {
    // Implementação baseada na Tabela 4.22
    return 'Especial do acampamento';
  }

  String _getCampTents(int roll) {
    switch (roll) {
      case 1:
        return '1 a cada 25 membros';
      case 2:
        return '1 a cada 10 membros';
      case 3:
        return '1 a cada 5 membros';
      case 4:
        return 'Apenas uma grande tenda';
      case 5:
        return 'Não há tendas';
      case 6:
        return 'Não há tendas';
      default:
        return '1 a cada 25 membros';
    }
  }

  String _getCampWatch(int roll) {
    switch (roll) {
      case 1:
        return 'Guardas dormindo';
      case 2:
        return 'Sentinelas alertas';
      case 3:
        return 'Vigias em ronda';
      case 4:
        return 'Cães de guarda';
      case 5:
        return 'Patrulha montada';
      case 6:
        return 'Sem vigília';
      default:
        return 'Guardas dormindo';
    }
  }

  String _getCampDefenses(int roll) {
    switch (roll) {
      case 1:
        return 'Paliçada';
      case 2:
        return 'Muro de terra';
      case 3:
        return 'Forte abandonado';
      case 4:
        return 'Torre de vigília';
      case 5:
        return 'Sem defesas';
      case 6:
        return 'Sem defesas';
      default:
        return 'Paliçada';
    }
  }

  String _getTribeType(TerrainType terrainType, int roll) {
    // Tabela 4.23 - Tribos
    switch (terrainType) {
      case TerrainType.subterranean:
        switch (roll) {
          case 1:
            return 'Orc';
          case 2:
            return 'Hobgoblin';
          case 3:
            return 'Goblin';
          case 4:
            return 'Drakold';
          case 5:
            return 'Homem das Cavernas';
          case 6:
            return 'Sahuagin';
          default:
            return 'Orc';
        }
      case TerrainType.glaciers:
        switch (roll) {
          case 1:
            return 'Ogro';
          case 2:
            return 'Orc';
          case 3:
            return 'Goblin';
          case 4:
            return 'Drakold';
          case 5:
            return 'Hobgoblin';
          case 6:
            return 'Homem das Cavernas';
          default:
            return 'Ogro';
        }
      case TerrainType.swamps:
        switch (roll) {
          case 1:
            return 'Orc';
          case 2:
            return 'Hobgoblin';
          case 3:
            return 'Goblin';
          case 4:
            return 'Drakold';
          case 5:
            return 'Sibilantes';
          case 6:
            return 'Homem Lagarto';
          default:
            return 'Orc';
        }
      case TerrainType.forests:
        switch (roll) {
          case 1:
            return 'Orc';
          case 2:
            return 'Goblin';
          case 3:
            return 'Ogro';
          case 4:
            return 'Hobgoblin';
          case 5:
            return 'Sibilantes';
          case 6:
            return 'Gnoll';
          default:
            return 'Orc';
        }
      case TerrainType.plains:
        switch (roll) {
          case 1:
            return 'Orc';
          case 2:
            return 'Goblin';
          case 3:
            return 'Ogro';
          case 4:
            return 'Hobgoblin';
          case 5:
            return 'Homem Lagarto';
          case 6:
            return 'Gnoll';
          default:
            return 'Orc';
        }
      case TerrainType.deserts:
        switch (roll) {
          case 1:
            return 'Ogro';
          case 2:
            return 'Goblin';
          case 3:
            return 'Orc';
          case 4:
            return 'Drakold';
          case 5:
            return 'Homem das Cavernas';
          case 6:
            return 'Sibilantes';
          default:
            return 'Ogro';
        }
      case TerrainType.hills:
        switch (roll) {
          case 1:
            return 'Goblin';
          case 2:
            return 'Hobgoblin';
          case 3:
            return 'Ogro';
          case 4:
            return 'Orc';
          case 5:
            return 'Kobold';
          case 6:
            return 'Bugbear';
          default:
            return 'Goblin';
        }
      case TerrainType.mountains:
        switch (roll) {
          case 1:
            return 'Ogro';
          case 2:
            return 'Orc';
          case 3:
            return 'Goblin';
          case 4:
            return 'Trogloditas';
          case 5:
            return 'Kobold';
          case 6:
            return 'Bugbear';
          default:
            return 'Ogro';
        }
      default:
        return 'Orc';
    }
  }

  int _getTribeMembers(String type) {
    switch (type) {
      case 'Bugbear':
        return DiceRoller.rollStatic(6, 6);
      case 'Drakold':
        return DiceRoller.rollStatic(4, 10) * 10;
      case 'Gnoll':
        return DiceRoller.rollStatic(2, 10) * 10;
      case 'Goblin':
        return DiceRoller.rollStatic(4, 10) * 10;
      case 'Hobgoblin':
        return DiceRoller.rollStatic(2, 10) * 10;
      case 'Homem das Cavernas':
        return DiceRoller.rollStatic(3, 10) * 10;
      case 'Homem Lagarto':
        return DiceRoller.rollStatic(1, 4) * 10;
      case 'Kobold':
        return DiceRoller.rollStatic(4, 10) * 10;
      case 'Ogro':
        return DiceRoller.rollStatic(2, 10);
      case 'Orc':
        return DiceRoller.rollStatic(3, 10) * 10;
      case 'Sahuagin':
        return DiceRoller.rollStatic(4, 6);
      case 'Sibilantes':
        return DiceRoller.rollStatic(1, 6) * 10;
      case 'Trogloditas':
        return DiceRoller.rollStatic(1, 4) * 10;
      default:
        return DiceRoller.rollStatic(2, 10) * 10;
    }
  }

  int _getTribeSoldiers(String type, int members) {
    switch (type) {
      case 'Bugbear':
        return (members * 2) ~/ 5;
      case 'Drakold':
        return members ~/ 10;
      case 'Gnoll':
        return (members * 2) ~/ 5;
      case 'Goblin':
        return (members * 2) ~/ 5;
      case 'Hobgoblin':
        return (members * 2) ~/ 5;
      case 'Homem das Cavernas':
        return members ~/ 10;
      case 'Homem Lagarto':
        return (members * 2) ~/ 5;
      case 'Kobold':
        return members ~/ 10;
      case 'Ogro':
        return (members * 3) ~/ 5;
      case 'Orc':
        return (members * 3) ~/ 5;
      case 'Sahuagin':
        return (members * 2) ~/ 5;
      case 'Sibilantes':
        return (members * 2) ~/ 5;
      case 'Trogloditas':
        return (members * 2) ~/ 5;
      default:
        return members ~/ 5;
    }
  }

  int _getTribeLeaders(String type) {
    return 1; // Sempre 1 líder
  }

  int _getTribeReligious(String type, int members) {
    switch (type) {
      case 'Drakold':
        return members ~/ 100;
      case 'Goblin':
        return members ~/ 100;
      case 'Homem Lagarto':
        return members ~/ 20;
      case 'Kobold':
        return members ~/ 100;
      case 'Orc':
        return members ~/ 100;
      case 'Sibilantes':
        return members ~/ 10;
      case 'Trogloditas':
        return members ~/ 20;
      default:
        return 0;
    }
  }

  int _getTribeSpecial(String type, int members) {
    switch (type) {
      case 'Goblin':
        return members ~/ 50;
      case 'Hobgoblin':
        return members ~/ 20;
      case 'Homem Lagarto':
        return members ~/ 10;
      case 'Orc':
        return members ~/ 50;
      case 'Sahuagin':
        return members ~/ 10;
      case 'Sibilantes':
        return members ~/ 15;
      default:
        return 0;
    }
  }

  RiversRoadsIslandsType _getRiversRoadsIslandsType(
    bool isOcean,
    bool hasRiver,
    int roll,
  ) {
    if (isOcean) {
      switch (roll) {
        case 1:
          return RiversRoadsIslandsType.road;
        case 2:
          return RiversRoadsIslandsType.river;
        case 3:
        case 4:
        case 5:
        case 6:
          return RiversRoadsIslandsType.island;
        default:
          return RiversRoadsIslandsType.road;
      }
    } else if (hasRiver) {
      switch (roll) {
        case 1:
        case 2:
          return RiversRoadsIslandsType.road;
        case 3:
        case 4:
        case 5:
          return RiversRoadsIslandsType.river;
        case 6:
          return RiversRoadsIslandsType.island;
        default:
          return RiversRoadsIslandsType.road;
      }
    } else {
      switch (roll) {
        case 1:
        case 2:
        case 3:
          return RiversRoadsIslandsType.road;
        case 4:
        case 5:
        case 6:
          return RiversRoadsIslandsType.river;
        default:
          return RiversRoadsIslandsType.road;
      }
    }
  }

  String _getRiversRoadsIslandsDescription(RiversRoadsIslandsType type) {
    // Tabela 4.25 - Rios, Estradas e Ilhas
    switch (type) {
      case RiversRoadsIslandsType.road:
        return 'Estrada encontrada';
      case RiversRoadsIslandsType.river:
        return 'Rio encontrado';
      case RiversRoadsIslandsType.island:
        return 'Ilha encontrada';
    }
  }

  String _getRiversRoadsIslandsDetails(RiversRoadsIslandsType type) {
    // Tabela 4.25 - Detalhes de Rios, Estradas e Ilhas
    switch (type) {
      case RiversRoadsIslandsType.road:
        return 'Trilha ou estrada pavimentada. Pode conectar a pontos importantes como ruínas ou aldeias.';
      case RiversRoadsIslandsType.river:
        return 'Rio com curso definido. Pode desaguar em rio maior, lago ou oceano.';
      case RiversRoadsIslandsType.island:
        return 'Ilha de tamanho variado. Pode conter recursos, habitantes ou perigos naturais.';
    }
  }

  CastleFortType _getCastleFortType(int roll) {
    switch (roll) {
      case 1:
        return CastleFortType.palisade;
      case 2:
        return CastleFortType.tower;
      case 3:
        return CastleFortType.tower;
      case 4:
        return CastleFortType.fort;
      case 5:
        return CastleFortType.fort;
      case 6:
        return CastleFortType.castle;
      default:
        return CastleFortType.palisade;
    }
  }

  String _getCastleFortDescription(CastleFortType type) {
    // Tabela 4.30 - Castelos e Fortes
    switch (type) {
      case CastleFortType.palisade:
        return 'Paliçada encontrada';
      case CastleFortType.tower:
        return 'Torre encontrada';
      case CastleFortType.fort:
        return 'Forte encontrado';
      case CastleFortType.castle:
        return 'Castelo encontrado';
    }
  }

  String _getCastleFortDetails(CastleFortType type) {
    // Tabela 4.30 - Detalhes de Castelos e Fortes
    switch (type) {
      case CastleFortType.palisade:
        return 'Pequena sem torres';
      case CastleFortType.tower:
        return '2 andares';
      case CastleFortType.fort:
        return '1 torre';
      case CastleFortType.castle:
        return '4 torres, 1d4+1 balestra, 1 fosso';
    }
  }

  TempleSanctuaryType _getTempleSanctuaryType(int roll) {
    switch (roll) {
      case 1:
        return TempleSanctuaryType.ziggurat;
      case 2:
        return TempleSanctuaryType.pyramid;
      case 3:
        return TempleSanctuaryType.obelisk;
      case 4:
        return TempleSanctuaryType.temple;
      case 5:
        return TempleSanctuaryType.sanctuary;
      case 6:
        return TempleSanctuaryType.altar;
      default:
        return TempleSanctuaryType.ziggurat;
    }
  }

  String _getTempleSanctuaryDescription(TempleSanctuaryType type) {
    // Tabela 4.33 - Templos e Santuários
    switch (type) {
      case TempleSanctuaryType.ziggurat:
        return 'Zigurate encontrado';
      case TempleSanctuaryType.pyramid:
        return 'Pirâmide encontrada';
      case TempleSanctuaryType.obelisk:
        return 'Obelisco encontrado';
      case TempleSanctuaryType.temple:
        return 'Templo encontrado';
      case TempleSanctuaryType.sanctuary:
        return 'Santuário encontrado';
      case TempleSanctuaryType.altar:
        return 'Altar encontrado';
    }
  }

  String _getTempleSanctuaryDetails(TempleSanctuaryType type) {
    // Tabela 4.33 - Detalhes de Templos e Santuários
    switch (type) {
      case TempleSanctuaryType.ziggurat:
        return '1 andar, obra terminará em 1d6 anos, perfeito estado, terra ou lama';
      case TempleSanctuaryType.pyramid:
        return '2 andares, construído há 1d10+5 anos, perfeito estado, madeira';
      case TempleSanctuaryType.obelisk:
        return '1d4 andares, construído há 1d4+1 décadas, bem conservado, granito';
      case TempleSanctuaryType.temple:
        return '1 andar + 1 subterrâneo, construído há 1d4 séculos, decadente mas de pé, mármore';
      case TempleSanctuaryType.sanctuary:
        return '2 andares + 2 subterrâneos, construído há 1d6+4 séculos, pode ruir, metal desconhecido';
      case TempleSanctuaryType.altar:
        return '1d4 andares + 1d4 subterrâneos, construído em eras ancestrais, em ruínas, ouro';
    }
  }

  NaturalDangerType _getNaturalDangerType(TerrainType terrainType, int roll) {
    // Tabela 4.38 - Perigos Naturais
    switch (terrainType) {
      case TerrainType.subterranean:
        switch (roll) {
          case 1:
            return NaturalDangerType.softSand;
          case 2:
            return NaturalDangerType.quicksand;
          case 3:
            return NaturalDangerType.suddenTide;
          case 4:
            return NaturalDangerType.mirage;
          case 5:
            return NaturalDangerType.tsunami;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.softSand;
        }
      case TerrainType.glaciers:
        switch (roll) {
          case 1:
            return NaturalDangerType.avalanches;
          case 2:
            return NaturalDangerType.thinIce;
          case 3:
            return NaturalDangerType.softSnow;
          case 4:
            return NaturalDangerType.smoothIce;
          case 5:
            return NaturalDangerType.flooded;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.avalanches;
        }
      case TerrainType.swamps:
        switch (roll) {
          case 1:
            return NaturalDangerType.flooded;
          case 2:
            return NaturalDangerType.quicksand;
          case 3:
            return NaturalDangerType.thornyBushes;
          case 4:
            return NaturalDangerType.thermalSprings;
          case 5:
            return NaturalDangerType.tarPit;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.flooded;
        }
      case TerrainType.forests:
        switch (roll) {
          case 1:
            return NaturalDangerType.thornyBushes;
          case 2:
            return NaturalDangerType.thermalSprings;
          case 3:
            return NaturalDangerType.tarPit;
          case 4:
            return NaturalDangerType.thermalSprings;
          case 5:
            return NaturalDangerType.tarPit;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.thornyBushes;
        }
      case TerrainType.plains:
        switch (roll) {
          case 1:
            return NaturalDangerType.flooded;
          case 2:
            return NaturalDangerType.thornyBushes;
          case 3:
            return NaturalDangerType.thermalSprings;
          case 4:
            return NaturalDangerType.fumaroles;
          case 5:
            return NaturalDangerType.tarPit;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.flooded;
        }
      case TerrainType.deserts:
        switch (roll) {
          case 1:
            return NaturalDangerType.softSand;
          case 2:
            return NaturalDangerType.thornyBushes;
          case 3:
            return NaturalDangerType.sandstorm;
          case 4:
            return NaturalDangerType.sandPit;
          case 5:
            return NaturalDangerType.mirage;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.softSand;
        }
      case TerrainType.hills:
        switch (roll) {
          case 1:
            return NaturalDangerType.flooded;
          case 2:
            return NaturalDangerType.avalanches;
          case 3:
            return NaturalDangerType.thornyBushes;
          case 4:
            return NaturalDangerType.fumaroles;
          case 5:
            return NaturalDangerType.mudVolcano;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.flooded;
        }
      case TerrainType.mountains:
        switch (roll) {
          case 1:
            return NaturalDangerType.altitude;
          case 2:
            return NaturalDangerType.avalanches;
          case 3:
            return NaturalDangerType.volcanicEruptions;
          case 4:
            return NaturalDangerType.fumaroles;
          case 5:
            return NaturalDangerType.mudVolcano;
          case 6:
            return NaturalDangerType.earthquake;
          default:
            return NaturalDangerType.altitude;
        }
      default:
        return NaturalDangerType.earthquake;
    }
  }

  String _getNaturalDangerDescription(NaturalDangerType type) {
    return 'Perigo natural: ${type.description}';
  }

  CivilizationType _getCivilizationType(int roll) {
    switch (roll) {
      case 1:
        return CivilizationType.settlement;
      case 2:
        return CivilizationType.settlement;
      case 3:
        return CivilizationType.village;
      case 4:
        return CivilizationType.town;
      case 5:
        return CivilizationType.city;
      case 6:
        return CivilizationType.metropolis;
      default:
        return CivilizationType.settlement;
    }
  }

  String _getCivilizationDescription(CivilizationType type) {
    // Tabela 4.39 - Civilização
    switch (type) {
      case CivilizationType.settlement:
        return 'Assentamento encontrado';
      case CivilizationType.village:
        return 'Aldeia encontrada';
      case CivilizationType.town:
        return 'Vila encontrada';
      case CivilizationType.city:
        return 'Cidade encontrada';
      case CivilizationType.metropolis:
        return 'Metrópole encontrada';
    }
  }

  String _getCivilizationDetails(CivilizationType type) {
    // Tabela 4.39 - Detalhes de Civilização
    switch (type) {
      case CivilizationType.settlement:
        return 'Minas de extração, entreposto comercial, propriedade rural, instituições de ensino, taverna e hospedaria, povoado';
      case CivilizationType.village:
        return '200-450 habitantes';
      case CivilizationType.town:
        return '500-1000 habitantes';
      case CivilizationType.city:
        return '2000-6000 habitantes';
      case CivilizationType.metropolis:
        return '10000-50000 habitantes';
    }
  }

  SettlementType _getSettlementType(int roll) {
    switch (roll) {
      case 1:
        return SettlementType.extractionMines;
      case 2:
        return SettlementType.commercialOutpost;
      case 3:
        return SettlementType.ruralProperty;
      case 4:
        return SettlementType.educationalInstitutions;
      case 5:
        return SettlementType.tavernAndInn;
      case 6:
        return SettlementType.settlement;
      default:
        return SettlementType.extractionMines;
    }
  }

  String _getSettlementDescription(SettlementType type) {
    // Tabela 4.40 - Assentamentos
    switch (type) {
      case SettlementType.extractionMines:
        return 'Minas de extração encontradas';
      case SettlementType.commercialOutpost:
        return 'Entreposto comercial encontrado';
      case SettlementType.ruralProperty:
        return 'Propriedade rural encontrada';
      case SettlementType.educationalInstitutions:
        return 'Instituições de ensino encontradas';
      case SettlementType.tavernAndInn:
        return 'Taverna e hospedaria encontradas';
      case SettlementType.settlement:
        return 'Povoado encontrado';
    }
  }

  String _getSettlementDetails(SettlementType type) {
    // Tabela 4.40 - Detalhes de Assentamentos
    switch (type) {
      case SettlementType.extractionMines:
        return 'Argila, pedras, ferro, cobre, ouro, gemas';
      case SettlementType.commercialOutpost:
        return 'Caravançará, depósito de madeira, depósito de minérios, depósito de alimentos, depósito de itens gerais, depósito de armas e armaduras';
      case SettlementType.ruralProperty:
        return 'Fazenda de gado, fazenda de porcos, granja de aves, fazenda de plantação de cereais, fazenda de plantação de frutas e vegetais, moinho de vento para grãos';
      case SettlementType.educationalInstitutions:
        return 'Escola técnica de artesãos, escola de guerra para guerreiros, escola religiosa para iniciados, escola de magia para aprendizes, escola para nobres, universidade geral';
      case SettlementType.tavernAndInn:
        return 'Rústica (preços em 50%), rústica (preços em 50%), padrão (preços normais), padrão (preços normais), padrão (preços normais), luxuosa (preços x 2)';
      case SettlementType.settlement:
        return '1d10 x 10 habitantes';
    }
  }

  /// Gera descoberta ancestral com detalhamento completo (Tabela 4.4)
  AncestralDiscovery generateDetailedAncestralDiscovery() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final conditionRoll = DiceRoller.rollStatic(1, 6);
    final materialRoll = DiceRoller.rollStatic(1, 6);
    final stateRoll = DiceRoller.rollStatic(1, 6);
    final guardianRoll = DiceRoller.rollStatic(1, 6);

    final type = _getAncestralThingType(typeRoll);
    final condition = _getAncestralCondition(conditionRoll);
    final material = _getAncestralMaterial(materialRoll);
    final state = _getAncestralState(stateRoll);
    final guardian = _getAncestralGuardian(guardianRoll);

    final description = _generateDetailedAncestralDescription(
      type,
      condition,
      material,
      state,
      guardian,
    );

    final details = _generateDetailedAncestralDetails(
      type,
      condition,
      material,
      state,
      guardian,
    );

    return AncestralDiscovery(
      type: type,
      condition: condition,
      material: material,
      state: state,
      guardian: guardian,
      description: description,
      details: details,
    );
  }

  /// Gera ruína com detalhamento completo (Tabela 4.5)
  Ruin generateDetailedRuin() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);
    final defenseRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRuinType(typeRoll);
    final size = _getRuinSize(sizeRoll);
    final defenses = _getRuinDefenses(defenseRoll);

    final description = _generateDetailedRuinDescription(type, size, defenses);
    final details = _generateDetailedRuinDetails(type, size, defenses);

    return Ruin(
      type: type,
      description: description,
      details: details,
      size: size,
      defenses: defenses,
    );
  }

  /// Gera relíquia com detalhamento completo (Tabela 4.6)
  Relic generateDetailedRelic() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final conditionRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRelicType(typeRoll);
    final condition = _getRelicCondition(conditionRoll);

    final description = _generateDetailedRelicDescription(type, condition);
    final details = _generateDetailedRelicDetails(type, condition);

    return Relic(
      type: type,
      description: description,
      details: details,
      condition: condition,
    );
  }

  /// Gera objeto com detalhamento completo (Tabela 4.8)
  Object generateDetailedObject() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final subtypeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getObjectType(typeRoll);
    final subtype = _getObjectSubtype(type, subtypeRoll);

    final description = _generateDetailedObjectDescription(type, subtype);
    final details = _generateDetailedObjectDetails(type, subtype);

    return Object(
      type: type,
      description: description,
      details: details,
      subtype: subtype,
    );
  }

  /// Gera vestígio com detalhamento completo (Tabela 4.9)
  Vestige generateDetailedVestige() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final detailRoll = DiceRoller.rollStatic(1, 6);

    final type = _getVestigeType(typeRoll);
    final detail = _getVestigeDetail(type, detailRoll);

    final description = _generateDetailedVestigeDescription(type, detail);
    final details = _generateDetailedVestigeDetails(type, detail);

    return Vestige(
      type: type,
      description: description,
      details: details,
      detail: detail,
    );
  }

  /// Gera ossada com detalhamento completo (Tabela 4.11)
  Ossuary generateDetailedOssuary() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getOssuaryType(typeRoll);
    final size = _getOssuarySize(sizeRoll);

    final description = _generateDetailedOssuaryDescription(type, size);
    final details = _generateDetailedOssuaryDetails(type, size);

    return Ossuary(
      type: type,
      description: description,
      details: details,
      size: size,
    );
  }

  /// Gera item mágico com detalhamento completo (Tabela 4.12)
  MagicalItem generateDetailedMagicalItem() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final powerRoll = DiceRoller.rollStatic(1, 6);

    final type = _getMagicalItemType(typeRoll);
    final power = _getMagicalItemPower(type, powerRoll);

    final description = _generateDetailedMagicalItemDescription(type, power);
    final details = _generateDetailedMagicalItemDetails(type, power);

    return MagicalItem(
      type: type,
      description: description,
      details: details,
      power: power,
    );
  }

  /// Gera covil com detalhamento completo (Tabela 4.13)
  Lair generateDetailedLair() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final occupationRoll = DiceRoller.rollStatic(1, 6);

    final type = _getLairType(typeRoll);
    final occupation = _getLairOccupation(occupationRoll);

    final description = _generateDetailedLairDescription(type, occupation);
    final details = _generateDetailedLairDetails(type, occupation);
    final occupant = _getLairOccupant(type);

    return Lair(
      type: type,
      description: description,
      details: details,
      occupation: occupation,
      occupant: occupant,
    );
  }

  /// Gera rios, estradas e ilhas com detalhamento completo (Tabela 4.25)
  RiversRoadsIslands generateDetailedRiversRoadsIslands() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final directionRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRiversRoadsIslandsType(false, false, typeRoll); // Usar assinatura correta
    final direction = _getRiversRoadsIslandsDirection(directionRoll);

    final description = _generateDetailedRiversRoadsIslandsDescription(type, direction);
    final details = _generateDetailedRiversRoadsIslandsDetails(type, direction);

    return RiversRoadsIslands(
      type: type,
      description: description,
      details: details,
      direction: direction,
    );
  }

  /// Gera castelo/forte com detalhamento completo (Tabela 4.30)
  CastleFort generateDetailedCastleFort() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);
    final defenseRoll = DiceRoller.rollStatic(1, 6);

    final type = _getCastleFortType(typeRoll);
    final size = _getCastleFortSize(sizeRoll);
    final defenses = _getCastleFortDefenses(defenseRoll);
    final occupants = _getCastleFortOccupants(type);

    final description = _generateDetailedCastleFortDescription(type, size, defenses);
    final details = _generateDetailedCastleFortDetails(type, size, defenses, occupants);

    return CastleFort(
      type: type,
      description: description,
      details: details,
      size: size,
      defenses: defenses,
      occupants: occupants,
    );
  }

  /// Gera templo/santuário com detalhamento completo (Tabela 4.33)
  TempleSanctuary generateDetailedTempleSanctuary() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final deityRoll = DiceRoller.rollStatic(1, 6);
    final occupantRoll = DiceRoller.rollStatic(1, 6);

    final type = _getTempleSanctuaryType(typeRoll);
    final deity = _getTempleSanctuaryDeity(deityRoll);
    final occupants = _getTempleSanctuaryOccupants(occupantRoll);

    final description = _generateDetailedTempleSanctuaryDescription(type, deity);
    final details = _generateDetailedTempleSanctuaryDetails(type, deity, occupants);

    return TempleSanctuary(
      type: type,
      description: description,
      details: details,
      deity: deity,
      occupants: occupants,
    );
  }

  /// Gera perigo natural com detalhamento completo (Tabela 4.38)
  NaturalDanger generateDetailedNaturalDanger() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final effectRoll = DiceRoller.rollStatic(1, 6);

    final type = _getNaturalDangerType(TerrainType.forests, typeRoll); // Usar parâmetros corretos
    final effects = _getNaturalDangerEffects(type, effectRoll);

    final description = _generateDetailedNaturalDangerDescription(type, effects);
    final details = _generateDetailedNaturalDangerDetails(type, effects);

    return NaturalDanger(
      type: type,
      description: description,
      details: details,
      effects: effects,
    );
  }

  /// Gera civilização com detalhamento completo (Tabela 4.39)
  Civilization generateDetailedCivilization() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final populationRoll = DiceRoller.rollStatic(1, 6);
    final governmentRoll = DiceRoller.rollStatic(1, 6);

    final type = _getCivilizationType(typeRoll);
    final population = _getCivilizationPopulation(populationRoll);
    final government = _getCivilizationGovernment(governmentRoll);

    final description = _generateDetailedCivilizationDescription(type, population);
    final details = _generateDetailedCivilizationDetails(type, population, government);

    return Civilization(
      type: type,
      description: description,
      details: details,
      population: population,
      government: government,
    );
  }

  // Métodos auxiliares para geração de descrições detalhadas
  String _generateDetailedAncestralDescription(
    AncestralThingType type,
    AncestralCondition condition,
    AncestralMaterial material,
    AncestralState state,
    AncestralGuardian guardian,
  ) {
    return '''
Tipo: ${type.description}
Condição: ${condition.description}
Material: ${material.description}
Estado: ${state.description}
Guardião: ${guardian.description}

Rolagens: 1d6 para cada aspecto (Tabela 4.4)
''';
  }

  String _generateDetailedAncestralDetails(
    AncestralThingType type,
    AncestralCondition condition,
    AncestralMaterial material,
    AncestralState state,
    AncestralGuardian guardian,
  ) {
    return '''
Detalhes da Descoberta Ancestral:
• Tipo Ancestral: ${type.description} (Tabela 4.4)
• Condição: ${condition.description}
• Material: ${material.description}
• Estado Geral: ${state.description}
• Guardião: ${guardian.description}

Tabelas Utilizadas:
• Tabela 4.4: Coisa Ancestral
• Tabela 4.5: Ruínas (se aplicável)
• Tabela 4.6: Relíquias (se aplicável)
• Tabela 4.8: Objetos (se aplicável)
• Tabela 4.9: Vestígios (se aplicável)
• Tabela 4.11: Ossadas (se aplicável)
• Tabela 4.12: Itens Mágicos (se aplicável)
''';
  }

  String _generateDetailedRuinDescription(RuinType type, String size, String defenses) {
    return '''
Tipo: ${type.description}
Tamanho: $size
Defesas: $defenses

Rolagens: 1d6 para cada aspecto (Tabela 4.5)
''';
  }

  String _generateDetailedRuinDetails(RuinType type, String size, String defenses) {
    return '''
Detalhes da Ruína:
• Tipo: ${type.description}
• Tamanho: $size
• Defesas: $defenses

Tabelas Utilizadas:
• Tabela 4.5: Ruínas
• Tabela 4.15: Detalhando Salas (se aplicável)
''';
  }

  String _generateDetailedRelicDescription(RelicType type, String condition) {
    return '''
Tipo: ${type.description}
Condição: $condition

Rolagens: 1d6 para cada aspecto (Tabela 4.6)
''';
  }

  String _generateDetailedRelicDetails(RelicType type, String condition) {
    return '''
Detalhes da Relíquia:
• Tipo: ${type.description}
• Condição: $condition

Tabelas Utilizadas:
• Tabela 4.6: Relíquias
• Tabela 4.7: Detalhando Armas, Armaduras e Recipientes
''';
  }

  String _generateDetailedObjectDescription(ObjectType type, String subtype) {
    return '''
Tipo: ${type.description}
Subtipo: $subtype

Rolagens: 1d6 para cada aspecto (Tabela 4.8)
''';
  }

  String _generateDetailedObjectDetails(ObjectType type, String subtype) {
    return '''
Detalhes do Objeto:
• Tipo: ${type.description}
• Subtipo: $subtype

Tabelas Utilizadas:
• Tabela 4.8: Objetos
''';
  }

  String _generateDetailedVestigeDescription(VestigeType type, String detail) {
    return '''
Tipo: ${type.description}
Detalhe: $detail

Rolagens: 1d6 para cada aspecto (Tabela 4.9)
''';
  }

  String _generateDetailedVestigeDetails(VestigeType type, String detail) {
    return '''
Detalhes do Vestígio:
• Tipo: ${type.description}
• Detalhe: $detail

Tabelas Utilizadas:
• Tabela 4.9: Vestígios
• Tabela 4.10: Detalhando Fontes (se aplicável)
''';
  }

  String _generateDetailedOssuaryDescription(OssuaryType type, String size) {
    return '''
Tipo: ${type.description}
Tamanho: $size

Rolagens: 1d6 para cada aspecto (Tabela 4.11)
''';
  }

  String _generateDetailedOssuaryDetails(OssuaryType type, String size) {
    return '''
Detalhes da Ossada:
• Tipo: ${type.description}
• Tamanho: $size

Tabelas Utilizadas:
• Tabela 4.11: Ossadas
''';
  }

  String _generateDetailedMagicalItemDescription(MagicalItemType type, String power) {
    return '''
Tipo: ${type.description}
Poder: $power

Rolagens: 1d6 para cada aspecto (Tabela 4.12)
''';
  }

  String _generateDetailedMagicalItemDetails(MagicalItemType type, String power) {
    return '''
Detalhes do Item Mágico:
• Tipo: ${type.description}
• Poder: $power

Tabelas Utilizadas:
• Tabela 4.12: Itens Mágicos
• LB2: Para desdobramentos mágicos
''';
  }

  String _generateDetailedLairDescription(LairType type, LairOccupation occupation) {
    return '''
Tipo: ${type.description}
Ocupação: ${occupation.description}

Rolagens: 1d6 para cada aspecto (Tabela 4.13)
''';
  }

  String _generateDetailedLairDetails(LairType type, LairOccupation occupation) {
    return '''
Detalhes do Covil:
• Tipo: ${type.description}
• Ocupação: ${occupation.description}

Tabelas Utilizadas:
• Tabela 4.13: Covil de Monstros
• Tabela 4.14: Masmorras (se aplicável)
• Tabela 4.16: Cavernas (se aplicável)
• Tabela 4.18: Tocas (se aplicável)
• Tabela 4.21: Ninhos (se aplicável)
• Tabela 4.22: Acampamentos (se aplicável)
• Tabela 4.23: Tribos (se aplicável)
''';
  }

  String _generateDetailedRiversRoadsIslandsDescription(RiversRoadsIslandsType type, String direction) {
    return '''
Tipo: ${type.description}
Direção: $direction

Rolagens: 1d6 para cada aspecto (Tabela 4.25)
''';
  }

  String _generateDetailedRiversRoadsIslandsDetails(RiversRoadsIslandsType type, String direction) {
    return '''
Detalhes de Rios, Estradas ou Ilhas:
• Tipo: ${type.description}
• Direção: $direction

Tabelas Utilizadas:
• Tabela 4.25: Rios, Estradas ou Ilhas
• Tabela 4.26: Determinando Rios (se aplicável)
• Tabela 4.27: Estradas (se aplicável)
• Tabela 4.28: Ilhas (se aplicável)
• Tabela 4.29: Detalhando Ilhas (se aplicável)
''';
  }

  String _generateDetailedCastleFortDescription(CastleFortType type, String size, String defenses) {
    return '''
Tipo: ${type.description}
Tamanho: $size
Defesas: $defenses

Rolagens: 1d6 para cada aspecto (Tabela 4.30)
''';
  }

  String _generateDetailedCastleFortDetails(CastleFortType type, String size, String defenses, String occupants) {
    return '''
Detalhes do Castelo/Forte:
• Tipo: ${type.description}
• Tamanho: $size
• Defesas: $defenses
• Ocupantes: $occupants

Tabelas Utilizadas:
• Tabela 4.30: Castelos e Fortes
• Tabela 4.31: Detalhando Castelos e Fortes
• Tabela 4.32: Outros Ocupantes
''';
  }

  String _generateDetailedTempleSanctuaryDescription(TempleSanctuaryType type, String deity) {
    return '''
Tipo: ${type.description}
Divindade: $deity

Rolagens: 1d6 para cada aspecto (Tabela 4.33)
''';
  }

  String _generateDetailedTempleSanctuaryDetails(TempleSanctuaryType type, String deity, String occupants) {
    return '''
Detalhes do Templo/Santuário:
• Tipo: ${type.description}
• Divindade: $deity
• Ocupantes: $occupants

Tabelas Utilizadas:
• Tabela 4.33: Templos e Santuários
• Tabela 4.34: Aspectos Religiosos
• Tabela 4.35: Ocupação
• Tabela 4.36: Deuses Antigos
• Tabela 4.37: Nomes de Deuses Antigos
''';
  }

  String _generateDetailedNaturalDangerDescription(NaturalDangerType type, String effects) {
    return '''
Tipo: ${type.description}
Efeitos: $effects

Rolagens: 1d6 para cada aspecto (Tabela 4.38)
''';
  }

  String _generateDetailedNaturalDangerDetails(NaturalDangerType type, String effects) {
    return '''
Detalhes do Perigo Natural:
• Tipo: ${type.description}
• Efeitos: $effects

Tabelas Utilizadas:
• Tabela 4.38: Perigos Naturais
• Apêndice B: Descrições e regras detalhadas
''';
  }

  String _generateDetailedCivilizationDescription(CivilizationType type, String population) {
    return '''
Tipo: ${type.description}
População: $population

Rolagens: 1d6 para cada aspecto (Tabela 4.39)
''';
  }

  String _generateDetailedCivilizationDetails(CivilizationType type, String population, String government) {
    return '''
Detalhes da Civilização:
• Tipo: ${type.description}
• População: $population
• Governo: $government

Tabelas Utilizadas:
• Tabela 4.39: Civilização
• Tabela 4.40: Assentamentos
• Tabela 4.41: Detalhando Povoados
• Tabela 4.42: Atitude com os Visitantes e Temas Centrais
''';
  }

  // Métodos auxiliares para obter tipos e detalhes
  RuinType _getRuinType(int roll) {
    switch (roll) {
      case 1: return RuinType.house;
      case 2: return RuinType.village;
      case 3: return RuinType.city;
      case 4: return RuinType.fort;
      case 5: return RuinType.castle;
      case 6: return RuinType.temple;
      default: return RuinType.house;
    }
  }

  String _getRuinSize(int roll) {
    switch (roll) {
      case 1: return 'Pequeno (1d4 salas)';
      case 2: return 'Médio (1d6 salas)';
      case 3: return 'Grande (2d6 salas)';
      case 4: return 'Muito Grande (3d6 salas)';
      case 5: return 'Enorme (4d6 salas)';
      case 6: return 'Colossal (5d6 salas)';
      default: return 'Médio (1d6 salas)';
    }
  }

  String _getRuinDefenses(int roll) {
    switch (roll) {
      case 1: return 'Nenhuma defesa';
      case 2: return 'Armadilhas simples';
      case 3: return 'Armadilhas complexas';
      case 4: return 'Guardiões';
      case 5: return 'Múltiplas defesas';
      case 6: return 'Fortificações completas';
      default: return 'Armadilhas simples';
    }
  }

  RelicType _getRelicType(int roll) {
    switch (roll) {
      case 1: return RelicType.tools;
      case 2: return RelicType.mechanisms;
      case 3: return RelicType.tombs;
      case 4: return RelicType.armors;
      case 5: return RelicType.weapons;
      case 6: return RelicType.containers;
      default: return RelicType.tools;
    }
  }

  String _getRelicCondition(int roll) {
    switch (roll) {
      case 1: return 'Danificada e inutilizada';
      case 2: return 'Danificada, mas reparável';
      case 3: return 'Perfeitamente funcional';
      case 4: return 'De prata';
      case 5: return 'De mitral';
      case 6: return 'Mágica (LB2 para desdobramentos)';
      default: return 'Danificada, mas reparável';
    }
  }

  ObjectType _getObjectType(int roll) {
    switch (roll) {
      case 1: return ObjectType.utensils;
      case 2: return ObjectType.clothes;
      case 3: return ObjectType.furniture;
      case 4: return ObjectType.toys;
      case 5: return ObjectType.vehicles;
      case 6: return ObjectType.books;
      default: return ObjectType.utensils;
    }
  }

  String _getObjectSubtype(ObjectType type, int roll) {
    switch (type) {
      case ObjectType.utensils:
        switch (roll) {
          case 1: return 'Talheres';
          case 2: return 'Para costura';
          case 3: return 'Para escrever';
          case 4: return 'Instrumento musical';
          case 5: return 'Para navegação';
          case 6: return 'Para primeiros socorros';
          default: return 'Talheres';
        }
      default:
        return 'Subtipo padrão';
    }
  }

  VestigeType _getVestigeType(int roll) {
    switch (roll) {
      case 1: return VestigeType.religious;
      case 2: return VestigeType.signs;
      case 3: return VestigeType.ancient;
      case 4: return VestigeType.source;
      case 5: return VestigeType.structure;
      case 6: return VestigeType.paths;
      default: return VestigeType.religious;
    }
  }

  String _getVestigeDetail(VestigeType type, int roll) {
    switch (type) {
      case VestigeType.religious:
        switch (roll) {
          case 1: return 'Pirâmide';
          case 2: return 'Observatório lunar';
          case 3: return 'Círculo de pedra';
          case 4: return 'Monolito';
          case 5: return 'Totem';
          case 6: return 'Altar';
          default: return 'Pirâmide';
        }
      default:
        return 'Detalhe padrão';
    }
  }

  OssuaryType _getOssuaryType(int roll) {
    switch (roll) {
      case 1: return OssuaryType.small;
      case 2: return OssuaryType.humanoid;
      case 3: return OssuaryType.medium;
      case 4: return OssuaryType.large;
      case 5: return OssuaryType.colossal;
      case 6: return OssuaryType.special;
      default: return OssuaryType.small;
    }
  }

  String _getOssuarySize(int roll) {
    switch (roll) {
      case 1: return 'Pequeno (1d4 indivíduos)';
      case 2: return 'Médio (1d6 indivíduos)';
      case 3: return 'Grande (2d6 indivíduos)';
      case 4: return 'Muito Grande (3d6 indivíduos)';
      case 5: return 'Enorme (4d6 indivíduos)';
      case 6: return 'Colossal (5d6 indivíduos)';
      default: return 'Médio (1d6 indivíduos)';
    }
  }

  MagicalItemType _getMagicalItemType(int roll) {
    switch (roll) {
      case 1: return MagicalItemType.weapons;
      case 2: return MagicalItemType.armors;
      case 3: return MagicalItemType.potions;
      case 4: return MagicalItemType.rings;
      case 5: return MagicalItemType.staves;
      case 6: return MagicalItemType.others;
      default: return MagicalItemType.weapons;
    }
  }

  String _getMagicalItemPower(MagicalItemType type, int roll) {
    switch (type) {
      case MagicalItemType.weapons:
        switch (roll) {
          case 1: return 'Espada Longa -1 Amaldiçoada (Caótica)';
          case 2: return 'Espada Longa +1';
          case 3: return 'Espada Longa +2';
          case 4: return 'Adaga +1';
          case 5: return 'Machado de Batalha +1';
          case 6: return 'Flechas +1 (10 unidades)';
          default: return 'Espada Longa +1';
        }
      default:
        return 'Poder padrão';
    }
  }

  LairType _getLairType(int roll) {
    switch (roll) {
      case 1: return LairType.dungeons;
      case 2: return LairType.caves;
      case 3: return LairType.burrows;
      case 4: return LairType.nests;
      case 5: return LairType.camps;
      case 6: return LairType.tribes;
      default: return LairType.dungeons;
    }
  }

  LairOccupation _getLairOccupation(int roll) {
    switch (roll) {
      case 1: return LairOccupation.emptyAndAbandoned;
      case 2: return LairOccupation.empty;
      case 3: return LairOccupation.halfOccupied;
      case 4: return LairOccupation.halfOccupied;
      case 5: return LairOccupation.occupied;
      case 6: return LairOccupation.occupied;
      default: return LairOccupation.empty;
    }
  }

  RiversRoadsIslandsType _getRiversRoadsIslandsType(int roll, bool isOcean, bool hasRiver) {
    switch (roll) {
      case 1: return RiversRoadsIslandsType.road;
      case 2: return RiversRoadsIslandsType.road;
      case 3: return RiversRoadsIslandsType.river;
      case 4: return RiversRoadsIslandsType.river;
      case 5: return RiversRoadsIslandsType.river;
      case 6: return RiversRoadsIslandsType.island;
      default: return RiversRoadsIslandsType.road;
    }
  }

  String _getRiversRoadsIslandsDirection(int roll) {
    switch (roll) {
      case 1: return '1 para 3 (Mesma Direção)';
      case 2: return '5 para 1 (Mesma Direção)';
      case 3: return '4 para 2 (Mesma Direção)';
      case 4: return '2 para 6 (Curva Esquerda)';
      case 5: return '3 para 5 (Curva Direita)';
      case 6: return '6 para 4 (Especial)';
      default: return '1 para 3 (Mesma Direção)';
    }
  }

  CastleFortType _getCastleFortType(int roll) {
    switch (roll) {
      case 1: return CastleFortType.palisade;
      case 2: return CastleFortType.tower;
      case 3: return CastleFortType.tower;
      case 4: return CastleFortType.fort;
      case 5: return CastleFortType.fort;
      case 6: return CastleFortType.castle;
      default: return CastleFortType.tower;
    }
  }

  String _getCastleFortSize(int roll) {
    switch (roll) {
      case 1: return 'Pequeno';
      case 2: return 'Médio';
      case 3: return 'Grande';
      case 4: return 'Muito Grande';
      case 5: return 'Enorme';
      case 6: return 'Colossal';
      default: return 'Médio';
    }
  }

  String _getCastleFortDefenses(int roll) {
    switch (roll) {
      case 1: return 'Sem defesas';
      case 2: return 'Torres simples';
      case 3: return 'Muralhas';
      case 4: return 'Fosso';
      case 5: return 'Múltiplas defesas';
      case 6: return 'Fortificações completas';
      default: return 'Torres simples';
    }
  }

  String _getCastleFortOccupants(CastleFortType type) {
    switch (type) {
      case CastleFortType.palisade:
        return 'Humanos';
      case CastleFortType.tower:
        return 'Humanos ou Anões';
      case CastleFortType.fort:
        return 'Humanos ou Orcs';
      case CastleFortType.castle:
        return 'Humanos Nobres';
      default:
        return 'Humanos';
    }
  }

  TempleSanctuaryType _getTempleSanctuaryType(int roll) {
    switch (roll) {
      case 1: return TempleSanctuaryType.ziggurat;
      case 2: return TempleSanctuaryType.pyramid;
      case 3: return TempleSanctuaryType.obelisk;
      case 4: return TempleSanctuaryType.temple;
      case 5: return TempleSanctuaryType.sanctuary;
      case 6: return TempleSanctuaryType.altar;
      default: return TempleSanctuaryType.temple;
    }
  }

  String _getTempleSanctuaryDeity(int roll) {
    switch (roll) {
      case 1: return 'Lei (Ordem)';
      case 2: return 'Lei (Ordem)';
      case 3: return 'Natureza (Neutro)';
      case 4: return 'Tempo (Neutro)';
      case 5: return 'Orcus (Caos)';
      case 6: return 'Deuses Antigos';
      default: return 'Natureza (Neutro)';
    }
  }

  String _getTempleSanctuaryOccupants(int roll) {
    switch (roll) {
      case 1: return 'Abandonado';
      case 2: return 'Abandonado com Guardião';
      case 3: return 'Abandonado com Guardião';
      case 4: return 'Religiosos (1d6 x 10)';
      case 5: return 'Religiosos (2d6 x 10)';
      case 6: return 'Religiosos (3d6 x 10)';
      default: return 'Abandonado';
    }
  }

  String _getNaturalDangerEffects(NaturalDangerType type, int roll) {
    switch (type) {
      case NaturalDangerType.quicksand:
        return 'Movimento reduzido, chance de afundar';
      case NaturalDangerType.thornyBushes:
        return 'Dano por movimento, dificulta passagem';
      case NaturalDangerType.thermalSprings:
        return 'Água quente, vapores tóxicos';
      case NaturalDangerType.tarPit:
        return 'Substância pegajosa, difícil de escapar';
      case NaturalDangerType.mudVolcano:
        return 'Erupções de lama, terreno instável';
      case NaturalDangerType.earthquake:
        return 'Danos estruturais, desabamentos';
      default:
        return 'Efeitos variados';
    }
  }

  CivilizationType _getCivilizationType(int roll) {
    switch (roll) {
      case 1: return CivilizationType.settlement;
      case 2: return CivilizationType.settlement;
      case 3: return CivilizationType.village;
      case 4: return CivilizationType.town;
      case 5: return CivilizationType.city;
      case 6: return CivilizationType.metropolis;
      default: return CivilizationType.village;
    }
  }

  String _getCivilizationPopulation(int roll) {
    switch (roll) {
      case 1: return '1d10 x 10 habitantes';
      case 2: return '2d10 x 10 habitantes';
      case 3: return '3d10 x 10 habitantes';
      case 4: return '4d10 x 10 habitantes';
      case 5: return '5d10 x 10 habitantes';
      case 6: return '6d10 x 10 habitantes';
      default: return '2d10 x 10 habitantes';
    }
  }

  String _getCivilizationGovernment(int roll) {
    switch (roll) {
      case 1: return 'Ordeiro - Nobre local';
      case 2: return 'Ordeiro - Político plebeu';
      case 3: return 'Neutro - Ladrão local';
      case 4: return 'Neutro - Guerreiro local';
      case 5: return 'Caótico - Clérigo local';
      case 6: return 'Caótico - Mago local';
      default: return 'Neutro - Guerreiro local';
    }
  }

  String _getLairOccupant(LairType type) {
    switch (type) {
      case LairType.dungeons:
        return 'Vários monstros (tabela 4.14)';
      case LairType.caves:
        return 'Monstros subterrâneos (tabela 4.16)';
      case LairType.burrows:
        return 'Animais gigantes (tabela 4.18)';
      case LairType.nests:
        return 'Criaturas aladas (tabela 4.21)';
      case LairType.camps:
        return 'Humanos ou monstros (tabela 4.22)';
      case LairType.tribes:
        return 'Tribos organizadas (tabela 4.23)';
      default:
        return 'Ocupante variado';
    }
  }
}
