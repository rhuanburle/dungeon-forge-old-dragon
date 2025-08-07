import '../enums/exploration_enums.dart';
import '../enums/table_enums.dart';
import '../models/exploration.dart';
import '../utils/dice_roller.dart';
part 'exploration/ancestral_detailed.dart';
part 'exploration/ruins_detailed.dart';
part 'exploration/relics_detailed.dart';
part 'exploration/objects_detailed.dart';
part 'exploration/vestiges_detailed.dart';
part 'exploration/ossuaries_detailed.dart';
part 'exploration/magical_items_detailed.dart';
part 'exploration/lairs_detailed.dart';
part 'exploration/rivers_roads_islands_detailed.dart';
part 'exploration/castle_fort_detailed.dart';
part 'exploration/temple_sanctuary_detailed.dart';
part 'exploration/natural_danger_detailed.dart';
part 'exploration/civilization_detailed.dart';
// Basic generators split
part 'exploration_basic/ancestral_basic.dart';
part 'exploration_basic/ruins_basic.dart';
part 'exploration_basic/relics_basic.dart';
part 'exploration_basic/objects_basic.dart';
part 'exploration_basic/vestiges_basic.dart';
part 'exploration_basic/ossuaries_basic.dart';
part 'exploration_basic/magical_items_basic.dart';
part 'exploration_basic/lairs_basic.dart';
part 'exploration_basic/dungeon_cave_basic.dart';
part 'exploration_basic/burrow_nest_camp_basic.dart';
part 'exploration_basic/tribe_basic.dart';
part 'exploration_basic/rri_basic.dart';
part 'exploration_basic/castle_fort_basic.dart';
part 'exploration_basic/temple_sanctuary_basic.dart';
part 'exploration_basic/natural_danger_basic.dart';
part 'exploration_basic/civilization_basic.dart';

/// Função utilitária para calcular e substituir fórmulas de dados nos textos
String _calculateDiceFormulas(String text) {
  // Regex para encontrar padrões como "1d4+1", "2d6", "1d10+5", etc.
  final dicePattern = RegExp(r'(\d+)d(\d+)([+-]\d+)?');

  return text.replaceAllMapped(dicePattern, (match) {
    final quantity = int.parse(match.group(1)!);
    final sides = int.parse(match.group(2)!);
    final modifier = match.group(3) != null ? int.parse(match.group(3)!) : 0;

    // Calcular o resultado
    int result = 0;
    for (int i = 0; i < quantity; i++) {
      result += DiceRoller.rollStatic(1, sides);
    }
    result += modifier;

    return result.toString();
  });
}

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
  AncestralDiscovery generateAncestralDiscovery() =>
      generateAncestralDiscoveryBasicImpl(this);

  /// Gera ruínas (Tabela 4.5)
  Ruin generateRuin() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);
    final defenseRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRuinType(typeRoll);
    final size = _getRuinSizeWithRolls(sizeRoll, type);
    final defenses = _getRuinDefenses(defenseRoll, type);

    final description = '${type.description} encontrada';
    final details = _getRuinDetailsWithRolls(type, typeRoll, size);

    return Ruin(
      type: type,
      description: description,
      details: details,
      size: size,
      defenses: defenses,
    );
  }

  /// Gera relíquias (Tabela 4.6)
  Relic generateRelic() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final conditionRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRelicType(typeRoll);
    final condition = _getRelicCondition(conditionRoll);
    final itemDetails = _getRelicItemDetails(type, typeRoll, condition);

    final description = '${type.description} encontrada';
    final details = _getRelicDetailsWithRolls(
      type,
      typeRoll,
      condition,
      itemDetails,
    );

    return Relic(
      type: type,
      description: description,
      details: details,
      condition: condition,
    );
  }

  /// Gera objetos (Tabela 4.8)
  Object generateObject() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final subtypeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getObjectType(typeRoll);
    final subtype = _getObjectSubtype(type, subtypeRoll);

    final description = '${type.description} encontrado';
    final details = _getObjectDetails(type, typeRoll);

    return Object(
      type: type,
      description: description,
      details: details,
      subtype: subtype,
    );
  }

  /// Gera vestígios (Tabela 4.9)
  Vestige generateVestige() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final detailRoll = DiceRoller.rollStatic(1, 6);

    final type = _getVestigeType(typeRoll);
    final detail = _getVestigeDetail(type, detailRoll);

    final description = '${type.description} encontrado';
    final details = _getVestigeDetails(type, typeRoll);

    return Vestige(
      type: type,
      description: description,
      details: details,
      detail: detail,
    );
  }

  /// Gera ossadas (Tabela 4.11)
  Ossuary generateOssuary() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getOssuaryType(typeRoll);
    final size = _getOssuarySizeByType(type, sizeRoll);

    final description = '${type.description} encontradas';
    final details = _getOssuaryDetails(type, typeRoll);

    return Ossuary(
      type: type,
      description: description,
      details: details,
      size: size,
    );
  }

  /// Gera itens mágicos (Tabela 4.12)
  MagicalItem generateMagicalItem() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final powerRoll = DiceRoller.rollStatic(1, 6);

    final type = _getMagicalItemType(typeRoll);
    final power = _getMagicalItemPowerWithRolls(powerRoll, type);

    final description = '${type.description} encontrado';
    final details = _getMagicalItemDetailsWithRolls(type, typeRoll, power);

    return MagicalItem(
      type: type,
      description: description,
      details: details,
      power: power,
    );
  }

  /// Gera covis (Tabela 4.13)
  Lair generateLair() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final occupationRoll = DiceRoller.rollStatic(1, 6);

    final type = _getLairType(typeRoll);
    final occupation = _getLairOccupation(occupationRoll);
    final occupant = _getLairOccupant(type);

    final description =
        '${type.description} ${occupation.description.toLowerCase()}';
    final details = _getLairDetails(type, occupation);

    return Lair(
      type: type,
      description: description,
      details: details,
      occupation: occupation,
      occupant: occupant,
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

    // Gerar detalhes das salas (Tabela 4.15)
    final roomDetails = _generateRoomDetails(rooms);

    return Dungeon(
      entry: entry,
      floors: floors,
      rooms: rooms,
      guardian: guardian,
      description: 'Masmorra com $floors andares e $rooms salas',
      roomDetails: roomDetails,
    );
  }

  /// Gera caverna (Tabela 4.16)
  Cave generateCave() {
    final roll = DiceRoller.rollStatic(1, 6);
    final entry = _getCaveEntry(roll);
    final inhabitant = _getCaveInhabitant(roll);

    // Gerar detalhes das câmaras (Tabela 4.17)
    final chamberDetails = _generateCaveChamberDetails();

    return Cave(
      entry: entry,
      inhabitant: inhabitant,
      description: 'Caverna com $entry habitada por $inhabitant',
      chamberDetails: chamberDetails,
    );
  }

  /// Gera caverna com roll específico (para testes)
  Cave generateCaveWithRoll(int roll) {
    final entry = _getCaveEntry(roll);
    final inhabitant = _getCaveInhabitant(roll);

    // Gerar detalhes das câmaras (Tabela 4.17)
    final chamberDetails = _generateCaveChamberDetails();

    return Cave(
      entry: entry,
      inhabitant: inhabitant,
      description: 'Caverna com $entry habitada por $inhabitant',
      chamberDetails: chamberDetails,
    );
  }

  /// Gera caverna com rolls específicos para todas as tabelas (para testes)
  Cave generateCaveWithDetailedRolls(
    int entryRoll,
    int chamberTypeRoll,
    int contentRoll,
    int specialRoll,
  ) {
    final entry = _getCaveEntry(entryRoll);
    final inhabitant = _getCaveInhabitant(entryRoll);

    // Gerar detalhes das câmaras com rolls específicos (Tabela 4.17)
    final chamberDetails = _generateCaveChamberDetailsWithRolls(
      chamberTypeRoll,
      contentRoll,
      specialRoll,
    );

    return Cave(
      entry: entry,
      inhabitant: inhabitant,
      description: 'Caverna com $entry habitada por $inhabitant',
      chamberDetails: chamberDetails,
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

  /// Gera toca com roll específico (para testes)
  Burrow generateBurrowWithRoll(
    int entryRoll,
    int occupantRoll,
    int treasureRoll,
  ) {
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

  /// Gera ninho com roll específico (para testes)
  Nest generateNestWithRoll(int roll) {
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

  /// Gera acampamento com rolls específicos (para testes)
  Camp generateCampWithRolls(
    int typeRoll,
    int specialRoll,
    int tentsRoll,
    int watchRoll,
    int defensesRoll,
  ) {
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

  /// Gera tribo com roll específico (para testes)
  Tribe generateTribeWithRoll(TerrainType terrainType, int roll) {
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

  /// Gera rios, estradas e ilhas (Tabela 4.29)
  RiversRoadsIslands generateRiversRoadsIslands({
    required bool isOcean,
    required bool hasRiver,
  }) {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getRiversRoadsIslandsType(isOcean, hasRiver, roll);
    final description = _getRiversRoadsIslandsDescription(type);
    final details = _getRiversRoadsIslandsDetails(type);
    final direction = _getRiversRoadsIslandsDirection(roll);

    return RiversRoadsIslands(
      type: type,
      description: description,
      details: details,
      direction: direction,
    );
  }

  /// Gera castelo ou forte (Tabela 4.30)
  CastleFort generateCastleFort() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getCastleFortType(roll);
    final description = _getCastleFortDescription(type);
    final details = _getCastleFortDetails(type);
    final size = _getCastleFortSize(roll);
    final defenses = _getCastleFortDefenses(roll);

    // Detalhamento (Tabela 4.31)
    final detailRoll = DiceRoller.rollStatic(1, 6);
    final occupants = _getCastleFortOccupants(type, detailRoll);
    final age = _getCastleFortAge(detailRoll);
    final condition = _getCastleFortCondition(detailRoll);
    final lord = _getCastleFortLord(detailRoll);
    final garrison = _getCastleFortGarrison(detailRoll);
    final special = _getCastleFortSpecial(detailRoll);
    final rumors = _getCastleFortRumors(roll);

    return CastleFort(
      type: type,
      description: description,
      details: details,
      size: size,
      defenses: defenses,
      occupants: occupants,
      age: age,
      condition: condition,
      lord: lord,
      garrison: garrison,
      special: special,
      rumors: rumors,
    );
  }

  /// Gera templo ou santuário (Tabela 4.33)
  TempleSanctuary generateTempleSanctuary() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getTempleSanctuaryType(roll);
    final description = _getTempleSanctuaryDescription(type);
    final details = _getTempleSanctuaryDetails(type);
    final deity = _getTempleSanctuaryDeity(roll);
    final occupants = _getTempleSanctuaryOccupants(roll);

    return TempleSanctuary(
      type: type,
      description: description,
      details: details,
      deity: deity,
      occupants: occupants,
    );
  }

  /// Gera perigo natural (Tabela 4.38)
  NaturalDanger generateNaturalDanger(TerrainType terrainType) {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getNaturalDangerType(terrainType, roll);
    final description = _getNaturalDangerDescription(type);
    final details = _getNaturalDangerDetails(type);
    final effects = _getNaturalDangerEffects(type);

    return NaturalDanger(
      type: type,
      description: description,
      details: details,
      effects: effects,
    );
  }

  /// Gera civilização (Tabela 4.39)
  Civilization generateCivilization() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getCivilizationType(roll);
    final description = _getCivilizationDescription(type);
    final details = _getCivilizationDetails(type);
    final population = _getCivilizationPopulation(roll);
    final government = _getCivilizationGovernment(roll);

    return Civilization(
      type: type,
      description: description,
      details: details,
      population: population,
      government: government,
      characteristics: '',
      attitudeAndThemes: '',
    );
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

  String _getAncestralDescription(
    AncestralThingType type,
    AncestralCondition condition,
    AncestralMaterial material,
    AncestralState state,
    AncestralGuardian guardian,
  ) {
    return '${type.description} ${condition.description} ${material.description}, ${state.description}. ${guardian.description}.';
  }

  String _getAncestralDetails(
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
            return '${DiceRoller.rollStatic(2, 4)} casas';
          case 2:
            return '${DiceRoller.rollStatic(2, 6)} casas';
          case 3:
            return '${DiceRoller.rollStatic(4, 4)} casas';
          case 4:
            return '${DiceRoller.rollStatic(4, 6)} casas';
          case 5:
            return '${DiceRoller.rollStatic(4, 8)} casas';
          case 6:
            return '${DiceRoller.rollStatic(8, 6)} casas';
          default:
            return '${DiceRoller.rollStatic(2, 4)} casas';
        }
      case RuinType.city:
        switch (roll) {
          case 1:
            return '${DiceRoller.rollStatic(10, 6)} casas';
          case 2:
            return '${DiceRoller.rollStatic(20, 6)} casas';
          case 3:
            return '${DiceRoller.rollStatic(10, 6)} casas + paliçada';
          case 4:
            return '${DiceRoller.rollStatic(20, 6)} casas + muralha';
          case 5:
            return '${DiceRoller.rollStatic(30, 6)} casas + muralha';
          case 6:
            return '${DiceRoller.rollStatic(30, 6)} casas + muralha + forte';
          default:
            return '${DiceRoller.rollStatic(10, 6)} casas';
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

  String _getRuinDetailsWithRolls(RuinType type, int roll, String size) {
    final baseDetails = _getRuinDetails(type, roll);

    return '''
Detalhes da Ruína:
• Tipo: ${type.description}
• Tamanho: $size
• Detalhes: $baseDetails

Tabelas Utilizadas:
• Tabela 4.5: Ruínas
• Rolagens de dados já resolvidas: $size
''';
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

  String _getRelicItemDetails(RelicType type, int roll, String condition) {
    // Se a condição é mágica, usar itens mágicos existentes
    if (condition.contains('mágica')) {
      return _getMagicalItemForRelic(type, roll);
    }

    // Se é de prata ou mitral, usar itens especiais
    if (condition.contains('prata') || condition.contains('mitral')) {
      return _getSpecialMaterialItem(type, roll, condition);
    }

    // Para itens normais, usar tabela 4.7
    return _getNormalRelicItem(type, roll, condition);
  }

  String _getMagicalItemForRelic(RelicType type, int roll) {
    switch (type) {
      case RelicType.weapons:
        return _getMagicalWeapon(roll);
      case RelicType.armors:
        return _getMagicalArmor(roll);
      case RelicType.containers:
        return _getMagicalContainer(roll);
      default:
        return 'Item mágico (LB2 para desdobramentos)';
    }
  }

  String _getMagicalWeapon(int roll) {
    switch (roll) {
      case 1:
        return 'Espada Longa -1 Amaldiçoada (Caótica)';
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
        return 'Arma mágica';
    }
  }

  String _getMagicalArmor(int roll) {
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
        return 'Armadura mágica';
    }
  }

  String _getMagicalContainer(int roll) {
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
        return 'Item mágico (LB2 para desdobramentos)';
      default:
        return 'Recipiente mágico';
    }
  }

  String _getSpecialMaterialItem(RelicType type, int roll, String condition) {
    final material = condition.contains('prata') ? 'prata' : 'mitral';
    switch (type) {
      case RelicType.weapons:
        return 'Arma de $material';
      case RelicType.armors:
        return 'Armadura de $material';
      case RelicType.containers:
        return 'Recipiente de $material';
      default:
        return 'Item de $material';
    }
  }

  String _getNormalRelicItem(RelicType type, int roll, String condition) {
    final baseItem = _getRelicDetails(type, roll);

    // Aplicar condição da tabela 4.7
    if (condition.contains('danificada e inutilizada')) {
      return '$baseItem danificada e inutilizada.';
    } else if (condition.contains('danificada, mas reparável')) {
      return '$baseItem danificada, mas reparável.';
    } else if (condition.contains('perfeitamente funcional')) {
      return '$baseItem perfeitamente funcional.';
    } else if (condition.contains('totalmente vazio')) {
      return '$baseItem totalmente vazio.';
    } else if (condition.contains('comida estragada')) {
      return '$baseItem com comida estragada.';
    } else if (condition.contains('comida conservada')) {
      return '$baseItem com comida conservada.';
    } else if (condition.contains('bebida alcóolica')) {
      return '$baseItem com bebida alcóolica.';
    } else if (condition.contains('tesouro do tipo B')) {
      return '$baseItem com tesouro do tipo B.';
    } else if (condition.contains('item mágico')) {
      return '$baseItem com item mágico (LB2 para desdobramentos).';
    }

    return baseItem;
  }

  String _getRelicDetailsWithRolls(
    RelicType type,
    int roll,
    String condition,
    String itemDetails,
  ) {
    return '''
Detalhes da Relíquia:
• Tipo: ${type.description}
• Condição: $condition
• Item: $itemDetails

Tabelas Utilizadas:
• Tabela 4.6: Relíquias
• Tabela 4.7: Detalhando Armas, Armaduras e Recipientes
• LB2: Para itens mágicos (se aplicável)
''';
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
        final sourceType = _getSourceType(roll);
        final waterType = _getSourceWaterType(DiceRoller.rollStatic(1, 6));
        return '$sourceType ($waterType)';
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
            return 'Revestido de metal';
          case 2:
            return 'Apenas os crânios';
          case 3:
            return 'Humanoides com asas';
          case 4:
            return 'Dentro de armaduras';
          case 5:
            return 'Ossadas incompletas';
          case 6:
            return 'Com tesouro do tipo B';
          default:
            return 'Revestido de metal';
        }
    }
  }

  /* removed unused: _getMagicalItemDetails
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
            // Jogue 2 vezes nesta tabela
            final roll1 = DiceRoller.rollStatic(1, 6);
            final roll2 = DiceRoller.rollStatic(1, 6);
            final item1 = _getMagicalItemForRelic(RelicType.weapons, roll1);
            final item2 = _getMagicalItemForRelic(RelicType.weapons, roll2);
            return '$item1 e $item2';
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
            // Jogue 2 vezes nesta tabela
            final roll1 = DiceRoller.rollStatic(1, 6);
            final roll2 = DiceRoller.rollStatic(1, 6);
            final item1 = _getMagicalItemForRelic(RelicType.containers, roll1);
            final item2 = _getMagicalItemForRelic(RelicType.containers, roll2);
            return '$item1 e $item2';
          default:
            return 'Sacola Devoradora (Caótica)';
        }
    }
  }
  */

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
        return LairOccupation.halfOccupiedNests; // Ninhos têm chance diferente
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
        return 2; // 1 andar e 1 subnível
      case 3:
        return 2;
      case 4:
        return 3; // 2 andares e 1 subnível
      case 5:
        return DiceRoller.rollStatic(1, 4) + 1; // 1d4+1 andares
      case 6:
        return DiceRoller.rollStatic(1, 6) + 1; // 1d6+1 andares
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

  String _generateRoomDetails(int numberOfRooms) {
    final details = <String>[];

    for (int i = 0; i < numberOfRooms; i++) {
      final typeRoll = DiceRoller.rollStatic(1, 6);
      final contentRoll = DiceRoller.rollStatic(1, 6);
      final specialRoll = DiceRoller.rollStatic(1, 6);
      final occurrenceRoll = DiceRoller.rollStatic(1, 6);

      final type = _getRoomType(typeRoll);
      final content = _getRoomContent(contentRoll);
      final special = _getRoomSpecial(specialRoll);
      final occurrence = _getRoomOccurrence(occurrenceRoll);

      details.add('Sala ${i + 1}: $type com $content, $special, $occurrence');
    }

    return details.join('\n');
  }

  String _getRoomType(int roll) {
    switch (roll) {
      case 1:
        return 'Sala quadrada normal';
      case 2:
        return 'Corredor reto';
      case 3:
        return 'Corredor em curva para a esquerda';
      case 4:
        return 'Corredor em curva para a direita';
      case 5:
        return 'Sala retangular';
      case 6:
        return 'Grande salão';
      default:
        return 'Sala quadrada normal';
    }
  }

  String _getRoomContent(int roll) {
    switch (roll) {
      case 1:
        return 'Sala vazia';
      case 2:
        return 'Sala vazia';
      case 3:
        return 'Estátuas ou colunas antigas';
      case 4:
        return 'Móveis domésticos';
      case 5:
        return 'Altar religioso';
      case 6:
        // Jogue na coluna Especial - resolver automaticamente
        final specialRoll = DiceRoller.rollStatic(1, 6);
        return _getRoomSpecial(specialRoll);
      default:
        return 'Sala vazia';
    }
  }

  String _getRoomSpecial(int roll) {
    switch (roll) {
      case 1:
        return 'Sala vazia';
      case 2:
        return 'Encontro';
      case 3:
        return 'Encontro';
      case 4:
        return 'Armadilha';
      case 5:
        return 'Armadilha';
      case 6:
        // Jogue na coluna Ocorrência - resolver automaticamente
        final occurrenceRoll = DiceRoller.rollStatic(1, 6);
        return _getRoomOccurrence(occurrenceRoll);
      default:
        return 'Sala vazia';
    }
  }

  String _getRoomOccurrence(int roll) {
    switch (roll) {
      case 1:
        return 'Alarme dispara';
      case 2:
        return 'Fonte de água';
      case 3:
        return 'Porta secreta';
      case 4:
        return 'Desmoronamento';
      case 5:
        return 'Corpos em decomposição';
      case 6:
        return 'Porta dimensional';
      default:
        return 'Alarme dispara';
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

  String _generateCaveChamberDetails() {
    final chamberRoll = DiceRoller.rollStatic(1, 6);
    final contentRoll = DiceRoller.rollStatic(1, 6);
    final specialRoll = DiceRoller.rollStatic(1, 6);

    final chamber = _getCaveChamberType(chamberRoll);
    final content = _getCaveChamberContent(contentRoll);
    final special = _getCaveChamberSpecial(specialRoll);

    return '''
Detalhes da Caverna:
• Tipo de Câmara: $chamber
• Conteúdo: $content
• Especial: $special

Tabelas Utilizadas:
• Tabela 4.17: Detalhando Cavernas
• Rolagens de dados já resolvidas
''';
  }

  String _generateCaveChamberDetailsWithRolls(
    int chamberRoll,
    int contentRoll,
    int specialRoll,
  ) {
    final chamber = _getCaveChamberType(chamberRoll);
    final content = _getCaveChamberContent(contentRoll);
    final special = _getCaveChamberSpecial(specialRoll);

    return '''
Detalhes da Caverna:
• Tipo de Câmara: $chamber
• Conteúdo: $content
• Especial: $special

Tabelas Utilizadas:
• Tabela 4.17: Detalhando Cavernas
• Rolagens de dados já resolvidas
''';
  }

  String _getCaveChamberType(int roll) {
    switch (roll) {
      case 1:
        final width = DiceRoller.rollStatic(1, 10) + 10;
        final length = DiceRoller.rollStatic(1, 10) + 10;
        return 'Câmara larga ($width x $length metros)';
      case 2:
        final size = DiceRoller.rollStatic(1, 6) + 1;
        return 'Câmara pequena ($size x $size metros)';
      case 3:
        return 'Corredor em curva para a esquerda (1 metro de diâmetro)';
      case 4:
        return 'Corredor em curva para a direita (1 metro de diâmetro)';
      case 5:
        final width = DiceRoller.rollStatic(1, 6) + 2;
        return 'Túnel estreito (${width * 10} cm de largura)';
      case 6:
        final height = DiceRoller.rollStatic(1, 6) + 2;
        return 'Túnel baixo (${height * 10} cm de altura)';
      default:
        final size = DiceRoller.rollStatic(1, 6) + 1;
        return 'Câmara pequena ($size x $size metros)';
    }
  }

  String _getCaveChamberContent(int roll) {
    switch (roll) {
      case 1:
        // Jogue na coluna Especial - resolver automaticamente
        final specialRoll = DiceRoller.rollStatic(1, 6);
        return _getCaveChamberSpecial(specialRoll);
      case 2:
        return 'Câmara vazia';
      case 3:
        return 'Câmara vazia';
      case 4:
        return 'Encontro no subterrâneo';
      case 5:
        return 'Sem saída (fim da caverna)';
      case 6:
        return 'Sem saída (fim da caverna)';
      default:
        return 'Câmara vazia';
    }
  }

  String _getCaveChamberSpecial(int roll) {
    switch (roll) {
      case 1:
        final depth = DiceRoller.rollStatic(3, 6) + 10;
        final width = DiceRoller.rollStatic(1, 4) + 2;
        return 'Fosso para baixo ($depth metros e $width metros de largura)';
      case 2:
        final height = DiceRoller.rollStatic(3, 6) + 10;
        final diameter = DiceRoller.rollStatic(1, 3);
        return 'Túnel para cima ($height metros e $diameter metros de diâmetro)';
      case 3:
        return 'Relíquias (tabela 4.6)';
      case 4:
        final width = DiceRoller.rollStatic(2, 6) + 1;
        return 'Riacho subterrâneo ($width metros de largura)';
      case 5:
        final depth = DiceRoller.rollStatic(1, 6) + 1;
        return 'Lago subterrâneo ($depth metros de profundidade)';
      case 6:
        final directions = DiceRoller.rollStatic(1, 3);
        return 'Encruzilhada para $directions novas direções';
      default:
        final depth = DiceRoller.rollStatic(3, 6) + 10;
        final width = DiceRoller.rollStatic(1, 4) + 2;
        return 'Fosso para baixo ($depth metros e $width metros de largura)';
    }
  }

  String _getBurrowEntry(int roll) {
    switch (roll) {
      case 1:
        final diameter = DiceRoller.rollStatic(2, 4) + 2;
        final depth = DiceRoller.rollStatic(3, 6) + 10;
        return 'Fenda Profunda no solo com ${diameter} metros de diâmetro e ${depth} metros de profundidade';
      case 2:
        final diameter = DiceRoller.rollStatic(1, 4) + 1;
        final depth = DiceRoller.rollStatic(1, 6) + 3;
        return 'Fenda Rasa no solo com ${diameter} metros de diâmetro e ${depth} metros de profundidade';
      case 3:
        final cells = DiceRoller.rollStatic(1, 10) * 3;
        return 'Colmeia Gigante em fenda na rocha com ${cells} células hexagonais';
      case 4:
        final cells = DiceRoller.rollStatic(1, 10) * 3;
        return 'Colmeia Gigante em túnel escavado com ${cells} células hexagonais';
      case 5:
        final diameter = DiceRoller.rollStatic(2, 4);
        final depth = DiceRoller.rollStatic(2, 6) + 2;
        return 'Toca Escavada na terra com ${diameter} metros de diâmetro e ${depth} metros de profundidade';
      case 6:
        final height = DiceRoller.rollStatic(1, 4) + 1;
        return 'Formigueiro Gigante com ${height} metros de altura';
      default:
        final diameter = DiceRoller.rollStatic(2, 4) + 2;
        final depth = DiceRoller.rollStatic(3, 6) + 10;
        return 'Fenda Profunda no solo com ${diameter} metros de diâmetro e ${depth} metros de profundidade';
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
        return '${DiceRoller.rollStatic(1, 2)} Relíquias (tabela 4.6)';
      case 3:
        return '${DiceRoller.rollStatic(1, 3)} Relíquias (tabela 4.6)';
      case 4:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias (tabela 4.6) + ${DiceRoller.rollStatic(1, 2)} Objetos (tabela 4.8)';
      case 5:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias (tabela 4.6) + ${DiceRoller.rollStatic(1, 2)} Objetos (tabela 4.8) + ${DiceRoller.rollStatic(1, 2)} Ossadas (tabela 4.11)';
      case 6:
        return '${DiceRoller.rollStatic(1, 2)} Relíquias (tabela 4.6) + 1 Item Mágico (tabela 4.12)';
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
    // Tabela 4.22 - Especial
    switch (roll) {
      case 1:
        return '${DiceRoller.rollStatic(2, 10) * 10} Elfos';
      case 2:
        return '${DiceRoller.rollStatic(4, 10) * 10} Anões';
      case 3:
      case 4:
      case 5:
      case 6:
        return 'Jogue na tabela 4.23';
      default:
        return '${DiceRoller.rollStatic(2, 10) * 10} Elfos';
    }
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
          return RiversRoadsIslandsType.river;
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
    // Implementação detalhada baseada nas tabelas específicas
    switch (type) {
      case RiversRoadsIslandsType.road:
        return _getDetailedRoadInfo();
      case RiversRoadsIslandsType.river:
        return _getDetailedRiverInfo();
      case RiversRoadsIslandsType.island:
        return _getDetailedIslandInfo();
    }
  }

  String _getDetailedRoadInfo() {
    // Tabela 4.27 - Estradas
    final findingRoll = DiceRoller.rollStatic(1, 6);
    final continuationRoll = DiceRoller.rollStatic(1, 6);
    final specialRoll = DiceRoller.rollStatic(1, 6);

    final finding = _getRoadFinding(findingRoll);
    final continuation = _getRoadContinuation(continuationRoll);
    final special = _getRoadSpecial(specialRoll);

    // Verificar se é trilha ou estrada pavimentada
    final isTrail = DiceRoller.rollStatic(1, 4) <= 4; // 1-4 = trilha
    final roadType = isTrail
        ? 'Trilha aberta na vegetação'
        : 'Estrada pavimentada';

    return '''
Detalhes da Estrada:
• Tipo: $roadType
• Direção: $finding
• Continuação: $continuation
• Especial: $special

Tabelas Utilizadas:
• Tabela 4.27: Estradas
• Rolagens de dados já resolvidas
''';
  }

  String _getDetailedRiverInfo() {
    // Tabela 4.26 - Rios
    final findingRoll = DiceRoller.rollStatic(1, 6);
    final continuationRoll = DiceRoller.rollStatic(1, 6);
    final specialRoll = DiceRoller.rollStatic(1, 6);

    final finding = _getRiverFinding(findingRoll);
    final continuation = _getRiverContinuation(continuationRoll);
    final special = _getRiverSpecial(specialRoll);

    return '''
Detalhes do Rio:
• Direção: $finding
• Continuação: $continuation
• Especial: $special

Tabelas Utilizadas:
• Tabela 4.26: Rios
• Rolagens de dados já resolvidas
''';
  }

  String _getDetailedIslandInfo() {
    // Tabela 4.28 - Ilhas
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);
    final detailsRoll = DiceRoller.rollStatic(1, 6);

    final type = _getIslandType(typeRoll);
    final size = _getIslandSize(typeRoll, sizeRoll);
    final details = _getIslandDetails(typeRoll, detailsRoll);

    return '''
Detalhes da Ilha:
• Tipo: $type
• Tamanho: $size
• Detalhes: $details

Tabelas Utilizadas:
• Tabela 4.28: Ilhas
• Tabela 4.29: Detalhando Ilhas
• Rolagens de dados já resolvidas
''';
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
        return _calculateDiceFormulas('4 torres, 1d4+1 balestra, 1 fosso');
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
        final yearsToComplete = DiceRoller.rollStatic(1, 6);
        return '1 andar, obra terminará em $yearsToComplete anos, perfeito estado, terra ou lama';
      case TempleSanctuaryType.pyramid:
        final yearsAgo = DiceRoller.rollStatic(1, 10) + 5;
        return '2 andares, construído há $yearsAgo anos, perfeito estado, madeira';
      case TempleSanctuaryType.obelisk:
        final floors = DiceRoller.rollStatic(1, 4);
        final decades = DiceRoller.rollStatic(1, 4) + 1;
        return '$floors andares, construído há ${decades * 10} anos, bem conservado, granito';
      case TempleSanctuaryType.temple:
        final centuries = DiceRoller.rollStatic(1, 4);
        return '1 andar + 1 subterrâneo, construído há ${centuries * 100} anos, decadente mas de pé, mármore';
      case TempleSanctuaryType.sanctuary:
        final centuries = DiceRoller.rollStatic(1, 6) + 4;
        return '2 andares + 2 subterrâneos, construído há ${centuries * 100} anos, pode ruir, metal desconhecido';
      case TempleSanctuaryType.altar:
        final floors = DiceRoller.rollStatic(1, 4);
        final underground = DiceRoller.rollStatic(1, 4);
        return '$floors andares + $underground subterrâneos, construído em eras ancestrais, em ruínas, ouro';
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
    final detailRoll = DiceRoller.rollStatic(1, 6);

    switch (type) {
      case SettlementType.extractionMines:
        switch (detailRoll) {
          case 1:
            return 'Minas de Argila';
          case 2:
            return 'Minas de Pedras';
          case 3:
            return 'Minas de Ferro';
          case 4:
            return 'Minas de Cobre';
          case 5:
            return 'Minas de Ouro';
          case 6:
            return 'Minas de Gemas';
          default:
            return 'Minas de Argila';
        }
      case SettlementType.commercialOutpost:
        switch (detailRoll) {
          case 1:
            return 'Caravançará';
          case 2:
            return 'Depósito de Madeira';
          case 3:
            return 'Depósito de Minérios';
          case 4:
            return 'Depósito de Alimentos';
          case 5:
            return 'Depósito de Itens Gerais';
          case 6:
            return 'Depósito de Armas e Armaduras';
          default:
            return 'Caravançará';
        }
      case SettlementType.ruralProperty:
        switch (detailRoll) {
          case 1:
            return 'Fazenda de Gado';
          case 2:
            return 'Fazenda de Porcos';
          case 3:
            return 'Granja de Aves';
          case 4:
            return 'Fazenda de Plantação de Cereais';
          case 5:
            return 'Fazenda de Plantação de Frutas e Vegetais';
          case 6:
            return 'Moinho de Vento para Grãos';
          default:
            return 'Fazenda de Gado';
        }
      case SettlementType.educationalInstitutions:
        switch (detailRoll) {
          case 1:
            return 'Escola Técnica de Artesãos';
          case 2:
            return 'Escola de Guerra para Guerreiros';
          case 3:
            return 'Escola Religiosa para Iniciados';
          case 4:
            return 'Escola de Magia para Aprendizes';
          case 5:
            return 'Escola para Nobres';
          case 6:
            return 'Universidade Geral';
          default:
            return 'Escola Técnica de Artesãos';
        }
      case SettlementType.tavernAndInn:
        switch (detailRoll) {
          case 1:
          case 2:
            return 'Taverna Rústica (preços em 50%)';
          case 3:
          case 4:
          case 5:
            return 'Taverna Padrão (preços normais)';
          case 6:
            return 'Taverna Luxuosa (preços x 2)';
          default:
            return 'Taverna Padrão (preços normais)';
        }
      case SettlementType.settlement:
        final population = DiceRoller.rollStatic(1, 10) * 10;
        return 'Povoado com $population habitantes';
    }
  }

  /// Gera descoberta ancestral com detalhamento completo (Tabela 4.4)
  AncestralDiscovery generateDetailedAncestralDiscovery() =>
      generateDetailedAncestralDiscoveryImpl(this);

  /// Gera ruína com detalhamento completo (Tabela 4.5)
  Ruin generateDetailedRuin() => generateDetailedRuinImpl(this);

  /// Gera relíquia com detalhamento completo (Tabela 4.6)
  Relic generateDetailedRelic() => generateDetailedRelicImpl(this);

  /// Gera objeto com detalhamento completo (Tabela 4.8)
  Object generateDetailedObject() => generateDetailedObjectImpl(this);

  /// Gera vestígio com detalhamento completo (Tabela 4.9)
  Vestige generateDetailedVestige() => generateDetailedVestigeImpl(this);

  /// Gera ossada com detalhamento completo (Tabela 4.11)
  Ossuary generateDetailedOssuary() => generateDetailedOssuaryImpl(this);

  /// Gera item mágico com detalhamento completo (Tabela 4.12)
  MagicalItem generateDetailedMagicalItem() =>
      generateDetailedMagicalItemImpl(this);

  /// Gera covil com detalhamento completo (Tabela 4.13)
  Lair generateDetailedLair() => generateDetailedLairImpl(this);

  /// Gera rios, estradas e ilhas com detalhamento completo (Tabela 4.25)
  RiversRoadsIslands generateDetailedRiversRoadsIslands() =>
      generateDetailedRiversRoadsIslandsImpl(this);

  /// Gera castelo/forte com detalhamento completo (Tabela 4.30)
  CastleFort generateDetailedCastleFort() =>
      generateDetailedCastleFortImpl(this);

  /// Gera templo/santuário com detalhamento completo (Tabelas 4.33-4.37)
  TempleSanctuary generateDetailedTempleSanctuary() =>
      generateDetailedTempleSanctuaryImpl(this);

  /// Gera perigo natural com detalhamento completo (Tabela 4.38)
  NaturalDanger generateDetailedNaturalDanger() =>
      generateDetailedNaturalDangerImpl(this);

  /// Gera civilização com detalhamento completo (Tabela 4.39)
  Civilization generateDetailedCivilization() =>
      generateDetailedCivilizationImpl(this);

  String _getTechLevel(int roll) {
    switch (roll) {
      case 1:
        return 'Tribal/Selvagem';
      case 2:
        return 'Era do bronze';
      case 3:
      case 4:
      case 5:
        return 'Medieval';
      case 6:
        return 'Renascimento';
      default:
        return 'Medieval';
    }
  }

  String _getAppearance(int roll) {
    switch (roll) {
      case 1:
        return 'Cabanas de palha';
      case 2:
        return 'Cabanas de barro';
      case 3:
        return 'Casas rústicas de madeira';
      case 4:
        return 'Casas rústicas de pedra';
      case 5:
      case 6:
        return 'Casas de madeira e pedra';
      default:
        return 'Casas rústicas de madeira';
    }
  }

  String _getAlignment(int roll) {
    switch (roll) {
      case 1:
      case 2:
        return 'Ordeiro';
      case 3:
      case 4:
        return 'Neutro';
      case 5:
      case 6:
        return 'Caótico';
      default:
        return 'Neutro';
    }
  }

  String _getRuler(int roll) {
    switch (roll) {
      case 1:
        return 'Nobre local';
      case 2:
        return 'Político plebeu local';
      case 3:
        return 'Ladrão';
      case 4:
        return 'Guerreiro';
      case 5:
        return 'Clérigo';
      case 6:
        return 'Mago';
      default:
        return 'Guerreiro';
    }
  }

  String _getRulerLevel(int roll) {
    switch (roll) {
      case 3:
        return '1d4+10 níveis';
      case 4:
        return '1d6+10 níveis';
      case 5:
      case 6:
        return '1d4+10 níveis';
      default:
        return '';
    }
  }

  String _getRace(int roll) {
    switch (roll) {
      case 1:
      case 2:
      case 3:
      case 4:
        return 'Humano';
      case 5:
        return 'Multirracial (humano + raça especial)';
      case 6:
        return 'Multirracial (jogue 2 vezes em Especial)';
      default:
        return 'Humano';
    }
  }

  String _getSpecial(int roll) {
    switch (roll) {
      case 1:
        return 'Anões';
      case 2:
        return 'Elfos';
      case 3:
        return 'Halflings';
      case 4:
        return 'Gnomos';
      case 5:
      case 6:
        return 'Multirracial';
      default:
        return '';
    }
  }

  String _getAttitude(int roll) {
    switch (roll) {
      case 1:
        return 'Extrema curiosidade';
      case 2:
        return 'Hospitalidade sincera';
      case 3:
        return 'Ansiedade para fazer negócios';
      case 4:
        return 'Indiferença total';
      case 5:
        return 'Misteriosa e estranha';
      case 6:
        return 'Hostilidade aberta e total';
      default:
        return 'Indiferença total';
    }
  }

  String _getTemaPovoado(int roll) {
    switch (roll) {
      case 1:
        return 'Pacata, rural e isolada';
      case 2:
        return 'Entreposto comercial rural';
      case 3:
        return 'Amaldiçoada ou chantageada por inimigos poderosos';
      case 4:
        return 'Erguida em torno da torre de um mago';
      case 5:
        return 'Em reconstrução pós-incêndio';
      case 6:
        return 'Sofrendo ataques de monstros';
      default:
        return 'Pacata, rural e isolada';
    }
  }

  String _getTemaCidade(int roll) {
    switch (roll) {
      case 1:
        return 'Sede do governo central';
      case 2:
        return 'Cidade livre com forte apelo comercial';
      case 3:
        return 'Tomada pelas guildas de criminosos';
      case 4:
        return 'Possui o templo principal de uma região';
      case 5:
        return 'Em reconstrução pós-guerra';
      case 6:
        return 'Cercada por inimigos';
      default:
        return 'Sede do governo central';
    }
  }

  String _generateDetailedCivilizationDetailsFull(
    CivilizationType type,
    String population,
    String government,
    String tech,
    String appearance,
    String alignment,
    String ruler,
    String rulerLevel,
    String race,
    String special,
    String attitude,
    String temaPovoado,
    String temaCidade,
  ) {
    return '''
Detalhes da Civilização:
• Tipo: ${type.description}
• População: $population
• Governo: $government
• Nível Tecnológico: $tech
• Aparência: $appearance
• Alinhamento do Governo: $alignment
• Governante: $ruler${rulerLevel.isNotEmpty ? ' ($rulerLevel)' : ''}
• Raça Dominante: $race
• Especial: $special
• Atitude com Visitantes: $attitude
• Tema (Povoado/Aldeia/Vila): $temaPovoado
• Tema (Cidade/Metrópole): $temaCidade

Tabelas Utilizadas:
• Tabela 4.39: Civilização
• Tabela 4.40: Assentamentos
• Tabela 4.41: Detalhando Povoados
• Tabela 4.42: Atitude com os Visitantes e Temas Centrais
''';
  }

  String _generateCivilizationCharacteristics(
    String tech,
    String appearance,
    String alignment,
    String ruler,
    String rulerLevel,
    String race,
    String special,
  ) {
    return '''
Características da Civilização:
• Nível Tecnológico: $tech
• Aparência: $appearance
• Alinhamento do Governo: $alignment
• Governante: $ruler${rulerLevel.isNotEmpty ? ' ($rulerLevel)' : ''}
• Raça Dominante: $race
• Especial: $special

Tabelas Utilizadas:
• Tabela 4.39: Civilização
• Tabela 4.40: Assentamentos
• Tabela 4.41: Detalhando Povoados
''';
  }

  String _generateCivilizationAttitudeAndThemes(
    String attitude,
    String temaPovoado,
    String temaCidade,
  ) {
    return '''
Atitude e Temas:
• Atitude com Visitantes: $attitude
• Tema (Povoado/Aldeia/Vila): $temaPovoado
• Tema (Cidade/Metrópole): $temaCidade

Tabela 4.42: Atitude com os Visitantes e Temas Centrais
''';
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

  /// Gera detalhes específicos baseados no tipo de descoberta ancestral
  Map<String, String?> _generateAncestralSpecificDetails(
    AncestralThingType type,
  ) {
    switch (type) {
      case AncestralThingType.ruins:
        return _generateRuinSpecificDetails();
      case AncestralThingType.relics:
        return _generateRelicSpecificDetails();
      case AncestralThingType.objects:
        return _generateObjectSpecificDetails();
      case AncestralThingType.vestiges:
        return _generateVestigeSpecificDetails();
      case AncestralThingType.ossuaries:
        return _generateOssuarySpecificDetails();
      case AncestralThingType.magicalItems:
        return _generateMagicalItemSpecificDetails();
    }
  }

  Map<String, String?> _generateRuinSpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);
    final defenseRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRuinType(typeRoll);
    final size = _getRuinSizeWithRolls(sizeRoll, type);
    final defenses = _getRuinDefenses(defenseRoll, type);

    return {
      'type': type.description,
      'size': size,
      'condition': null,
      'power': null,
      'subtype': defenses,
    };
  }

  Map<String, String?> _generateRelicSpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final conditionRoll = DiceRoller.rollStatic(1, 6);

    final type = _getRelicType(typeRoll);
    final condition = _getRelicCondition(conditionRoll);

    return {
      'type': type.description,
      'size': null,
      'condition': condition,
      'power': null,
      'subtype': null,
    };
  }

  Map<String, String?> _generateObjectSpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final subtypeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getObjectType(typeRoll);
    final subtype = _getObjectSubtype(type, subtypeRoll);

    return {
      'type': type.description,
      'size': null,
      'condition': null,
      'power': null,
      'subtype': subtype,
    };
  }

  Map<String, String?> _generateVestigeSpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final detailRoll = DiceRoller.rollStatic(1, 6);

    final type = _getVestigeType(typeRoll);
    final detail = _getVestigeDetail(type, detailRoll);

    return {
      'type': type.description,
      'size': null,
      'condition': null,
      'power': null,
      'subtype': detail,
    };
  }

  Map<String, String?> _generateOssuarySpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final sizeRoll = DiceRoller.rollStatic(1, 6);

    final type = _getOssuaryType(typeRoll);
    final size = _getOssuarySizeByType(type, sizeRoll);

    return {
      'type': type.description,
      'size': size,
      'condition': null,
      'power': null,
      'subtype': null,
    };
  }

  Map<String, String?> _generateMagicalItemSpecificDetails() {
    final typeRoll = DiceRoller.rollStatic(1, 6);
    final powerRoll = DiceRoller.rollStatic(1, 6);

    final type = _getMagicalItemType(typeRoll);
    final power = _getMagicalItemPower(type, powerRoll);

    return {
      'type': type.description,
      'size': null,
      'condition': null,
      'power': power,
      'subtype': null,
    };
  }

  String _generateDetailedRuinDescription(
    RuinType type,
    String size,
    String defenses,
  ) {
    return '''
Tipo: ${type.description}
Tamanho: $size
Defesas: $defenses

Rolagens: 1d6 para cada aspecto (Tabela 4.5)
''';
  }

  String _generateDetailedRuinDetails(
    RuinType type,
    String size,
    String defenses,
  ) {
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

  String _generateDetailedMagicalItemDescription(
    MagicalItemType type,
    String power,
  ) {
    return '''
Tipo: ${type.description}
Poder: $power

Rolagens: 1d6 para cada aspecto (Tabela 4.12)
''';
  }

  String _generateDetailedMagicalItemDetails(
    MagicalItemType type,
    String power,
  ) {
    return '''
Detalhes do Item Mágico:
• Tipo: ${type.description}
• Poder: $power

Tabelas Utilizadas:
• Tabela 4.12: Itens Mágicos
• LB2: Para desdobramentos mágicos
''';
  }

  String _generateDetailedLairDescription(
    LairType type,
    LairOccupation occupation,
  ) {
    return '''
Tipo: ${type.description}
Ocupação: ${occupation.description}

Rolagens: 1d6 para cada aspecto (Tabela 4.13)
''';
  }

  String _generateDetailedLairDetails(
    LairType type,
    LairOccupation occupation,
  ) {
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

  String _generateDetailedRiversRoadsIslandsDescription(
    RiversRoadsIslandsType type,
    String direction,
  ) {
    return '''
Tipo: ${type.description}
Direção: $direction

Rolagens: 1d6 para cada aspecto (Tabela 4.25)
''';
  }

  String _generateDetailedRiversRoadsIslandsDetails(
    RiversRoadsIslandsType type,
    String direction,
  ) {
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

  String _generateDetailedCastleFortDescription(
    CastleFortType type,
    String size,
    String defenses,
  ) {
    return '''
Tipo: ${type.description}
Tamanho: $size
Defesas: $defenses

Rolagens: 1d6 para cada aspecto (Tabela 4.30)
''';
  }

  String _generateDetailedCastleFortDetails(
    CastleFortType type,
    String size,
    String defenses,
    String occupants,
  ) {
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

  String _generateDetailedTempleSanctuaryDescription(
    TempleSanctuaryType type,
    String religiousAspects,
  ) {
    return '''
Tipo: ${type.description}
Aspectos Religiosos: $religiousAspects

Rolagens: 1d6 para cada aspecto (Tabelas 4.33-4.37)
''';
  }

  String _generateDetailedTempleSanctuaryDetails(
    TempleSanctuaryType type,
    String religiousAspects,
    String occupation,
  ) {
    return '''
Detalhes do Templo/Santuário:
• Tipo: ${type.description}
• Aspectos Religiosos: $religiousAspects
• Ocupação: $occupation

Tabelas Utilizadas:
• Tabela 4.33: Templos e Santuários
• Tabela 4.34: Aspectos Religiosos
• Tabela 4.35: Ocupação
• Tabela 4.36: Deuses Antigos
• Tabela 4.37: Nomes de Deuses Antigos
''';
  }

  String _generateDetailedNaturalDangerDescription(
    NaturalDangerType type,
    String effects,
  ) {
    return '''
Tipo: ${type.description}
Efeitos: $effects

Rolagens: 1d6 para cada aspecto (Tabela 4.38)
''';
  }

  String _generateDetailedNaturalDangerDetails(
    NaturalDangerType type,
    String effects,
  ) {
    return '''
Detalhes do Perigo Natural:
• Tipo: ${type.description}
• Efeitos: $effects

Tabelas Utilizadas:
• Tabela 4.38: Perigos Naturais
• Apêndice B: Descrições e regras detalhadas
''';
  }

  String _generateDetailedCivilizationDescription(
    CivilizationType type,
    String population,
  ) {
    return '''
Tipo: ${type.description}
População: $population

Rolagens: 1d6 para cada aspecto (Tabela 4.39)
''';
  }

  // removed unused: _generateDetailedCivilizationDetails

  // Métodos auxiliares para obter tipos e detalhes
  RuinType _getRuinType(int roll) {
    switch (roll) {
      case 1:
        return RuinType.house;
      case 2:
        return RuinType.village;
      case 3:
        return RuinType.city;
      case 4:
        return RuinType.fort;
      case 5:
        return RuinType.castle;
      case 6:
        return RuinType.temple;
      default:
        return RuinType.house;
    }
  }

  String _getRuinSize(int roll) {
    switch (roll) {
      case 1:
        return 'Pequeno (${DiceRoller.rollStatic(1, 4)} salas)';
      case 2:
        return 'Médio (${DiceRoller.rollStatic(1, 6)} salas)';
      case 3:
        return 'Grande (${DiceRoller.rollStatic(2, 6)} salas)';
      case 4:
        return 'Muito Grande (${DiceRoller.rollStatic(3, 6)} salas)';
      case 5:
        return 'Enorme (${DiceRoller.rollStatic(4, 6)} salas)';
      case 6:
        return 'Colossal (${DiceRoller.rollStatic(5, 6)} salas)';
    }
  }

  String _getRuinSizeWithRolls(int roll, RuinType type) {
    // Tabela 4.5 - Ruínas
    switch (type) {
      case RuinType.house:
        return _getHouseSize(roll);
      case RuinType.village:
        return _getVillageSize(roll);
      case RuinType.city:
        return _getCitySize(roll);
      case RuinType.fort:
        return _getFortSize(roll);
      case RuinType.castle:
        return _getCastleSize(roll);
      case RuinType.temple:
        return _getTempleSize(roll);
    }
  }

  String _getHouseSize(int roll) {
    // Tabela 4.5 - Coluna "Casa"
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
        return 'Casa';
    }
  }

  String _getVillageSize(int roll) {
    // Tabela 4.5 - Coluna "Vila"
    switch (roll) {
      case 1:
        final houses = DiceRoller.rollStatic(2, 4);
        return '$houses casas';
      case 2:
        final houses = DiceRoller.rollStatic(2, 6);
        return '$houses casas';
      case 3:
        final houses = DiceRoller.rollStatic(4, 4);
        return '$houses casas';
      case 4:
        final houses = DiceRoller.rollStatic(4, 6);
        return '$houses casas';
      case 5:
        final houses = DiceRoller.rollStatic(4, 8);
        return '$houses casas';
      case 6:
        final houses = DiceRoller.rollStatic(8, 6);
        return '$houses casas';
    }
  }

  String _getCitySize(int roll) {
    // Tabela 4.5 - Coluna "Cidade"
    switch (roll) {
      case 1:
        final houses = DiceRoller.rollStatic(10, 6);
        return '$houses casas';
      case 2:
        final houses = DiceRoller.rollStatic(20, 6);
        return '$houses casas';
      case 3:
        final houses = DiceRoller.rollStatic(10, 6);
        return '$houses casas + paliçada';
      case 4:
        final houses = DiceRoller.rollStatic(20, 6);
        return '$houses casas + muralha';
      case 5:
        final houses = DiceRoller.rollStatic(30, 6);
        return '$houses casas + muralha';
      case 6:
        final houses = DiceRoller.rollStatic(30, 6);
        return '$houses casas + muralha + forte';
    }
  }

  String _getFortSize(int roll) {
    // Tabela 4.5 - Coluna "Forte"
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
    }
  }

  String _getCastleSize(int roll) {
    // Tabela 4.5 - Coluna "Castelo"
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
    }
  }

  String _getTempleSize(int roll) {
    // Tabela 4.5 - Coluna "Templo"
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
    }
  }

  String _getRuinDefenses(int roll, RuinType type) {
    // Tabela 4.5 - Defesas específicas por tipo de ruína
    // O roll determina a linha da tabela, o type determina a coluna
    switch (roll) {
      case 1: // Linha 1
        switch (type) {
          case RuinType.house:
            return 'Cabana';
          case RuinType.village:
            return '${DiceRoller.rollStatic(2, 4)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(10, 6)} casas';
          case RuinType.fort:
            return 'Torre';
          case RuinType.castle:
            return 'Castelo + paliçada';
          case RuinType.temple:
            return 'Pequeno altar';
        }
      case 2: // Linha 2
        switch (type) {
          case RuinType.house:
            return 'Casebre';
          case RuinType.village:
            return '${DiceRoller.rollStatic(2, 6)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(20, 6)} casas';
          case RuinType.fort:
            return 'Torre + muralha';
          case RuinType.castle:
            return 'Castelo + paliçada + fosso';
          case RuinType.temple:
            return 'Santuário';
        }
      case 3: // Linha 3
        switch (type) {
          case RuinType.house:
            return 'Casa grande';
          case RuinType.village:
            return '${DiceRoller.rollStatic(4, 4)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(10, 6)} casas + paliçada';
          case RuinType.fort:
            return 'Forte pequeno';
          case RuinType.castle:
            return 'Castelo + 2 torres + paliçada + fosso';
          case RuinType.temple:
            return 'Igreja pequena';
        }
      case 4: // Linha 4
        switch (type) {
          case RuinType.house:
            return 'Mansão';
          case RuinType.village:
            return '${DiceRoller.rollStatic(4, 6)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(20, 6)} casas + muralha';
          case RuinType.fort:
            return 'Forte + torre';
          case RuinType.castle:
            return 'Castelo + 4 torres + paliçada + fosso';
          case RuinType.temple:
            return 'Igreja grande';
        }
      case 5: // Linha 5
        switch (type) {
          case RuinType.house:
            return 'Fazenda';
          case RuinType.village:
            return '${DiceRoller.rollStatic(4, 8)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(30, 6)} casas + muralha';
          case RuinType.fort:
            return 'Forte + 2 torres';
          case RuinType.castle:
            return 'Castelo + 4 torres + muralha + fosso';
          case RuinType.temple:
            return 'Catedral';
        }
      case 6: // Linha 6
        switch (type) {
          case RuinType.house:
            return 'Palácio';
          case RuinType.village:
            return '${DiceRoller.rollStatic(8, 6)} casas';
          case RuinType.city:
            return '${DiceRoller.rollStatic(30, 6)} casas + muralha + forte';
          case RuinType.fort:
            return 'Forte + 2 torres + muralha';
          case RuinType.castle:
            return 'Castelo + 6 torres + 2 muralhas + fosso';
          case RuinType.temple:
            return 'Mosteiro';
        }
    }
  }

  RelicType _getRelicType(int roll) {
    switch (roll) {
      case 1:
        return RelicType.tools;
      case 2:
        return RelicType.mechanisms;
      case 3:
        return RelicType.tombs;
      case 4:
        return RelicType.armors;
      case 5:
        return RelicType.weapons;
      case 6:
        return RelicType.containers;
      default:
        return RelicType.tools;
    }
  }

  String _getRelicCondition(int roll) {
    switch (roll) {
      case 1:
        return 'Danificada e inutilizada';
      case 2:
        return 'Danificada, mas reparável';
      case 3:
        return 'Perfeitamente funcional';
      case 4:
        return 'De prata';
      case 5:
        return 'De mitral';
      case 6:
        return 'Mágica (LB2 para desdobramentos)';
      default:
        return 'Danificada, mas reparável';
    }
  }

  ObjectType _getObjectType(int roll) {
    switch (roll) {
      case 1:
        return ObjectType.utensils;
      case 2:
        return ObjectType.clothes;
      case 3:
        return ObjectType.furniture;
      case 4:
        return ObjectType.toys;
      case 5:
        return ObjectType.vehicles;
      case 6:
        return ObjectType.books;
      default:
        return ObjectType.utensils;
    }
  }

  String _getObjectSubtype(ObjectType type, int roll) {
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
      default:
        return 'Subtipo padrão';
    }
  }

  VestigeType _getVestigeType(int roll) {
    switch (roll) {
      case 1:
        return VestigeType.religious;
      case 2:
        return VestigeType.signs;
      case 3:
        return VestigeType.ancient;
      case 4:
        return VestigeType.source;
      case 5:
        return VestigeType.structure;
      case 6:
        return VestigeType.paths;
      default:
        return VestigeType.religious;
    }
  }

  String _getVestigeDetail(VestigeType type, int roll) {
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
            return 'Cerâmica';
          case 6:
            return 'Cestos de palha';
          default:
            return 'Pontas de flecha';
        }
      case VestigeType.source:
        final sourceType = _getSourceType(roll);
        final waterType = _getSourceWaterType(DiceRoller.rollStatic(1, 6));
        return '$sourceType ($waterType)';
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
      default:
        return 'Detalhe padrão';
    }
  }

  OssuaryType _getOssuaryType(int roll) {
    switch (roll) {
      case 1:
        return OssuaryType.small;
      case 2:
        return OssuaryType.humanoid;
      case 3:
        return OssuaryType.medium;
      case 4:
        return OssuaryType.large;
      case 5:
        return OssuaryType.colossal;
      case 6:
        return OssuaryType.special;
      default:
        return OssuaryType.small;
    }
  }

  // Método removido - implementação incorreta da tabela 4.11
  // A tabela 4.11 usa tipo (coluna 1) e depois tamanho específico (colunas 2-7)

  MagicalItemType _getMagicalItemType(int roll) {
    switch (roll) {
      case 1:
        return MagicalItemType.weapons;
      case 2:
        return MagicalItemType.armors;
      case 3:
        return MagicalItemType.potions;
      case 4:
        return MagicalItemType.rings;
      case 5:
        return MagicalItemType.staves;
      case 6:
        return MagicalItemType.others;
      default:
        return MagicalItemType.weapons;
    }
  }

  String _getMagicalItemPower(MagicalItemType type, int roll) {
    switch (type) {
      case MagicalItemType.weapons:
        switch (roll) {
          case 1:
            return 'Espada Longa -1 Amaldiçoada (Caótica)';
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
            return 'Espada Longa +1';
        }
      default:
        return 'Poder padrão';
    }
  }

  String _getMagicalItemPowerWithRolls(int roll, MagicalItemType type) {
    switch (type) {
      case MagicalItemType.weapons:
        return _getMagicalWeaponPower(roll);
      case MagicalItemType.armors:
        return _getMagicalArmorPower(roll);
      case MagicalItemType.potions:
        return _getMagicalPotionPower(roll);
      case MagicalItemType.rings:
        return _getMagicalRingPower(roll);
      case MagicalItemType.staves:
        return _getMagicalStaffPower(roll);
      case MagicalItemType.others:
        return _getMagicalOtherPower(roll);
      default:
        return _getMagicalItemPower(type, roll);
    }
  }

  String _getMagicalWeaponPower(int roll) {
    switch (roll) {
      case 1:
        return 'Espada Longa -1 Amaldiçoada (Caótica)';
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
        return 'Arma mágica';
    }
  }

  String _getMagicalArmorPower(int roll) {
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
        return 'Armadura mágica';
    }
  }

  String _getMagicalPotionPower(int roll) {
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
        return 'Poção mágica';
    }
  }

  String _getMagicalRingPower(int roll) {
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
        // Jogue 2 vezes nesta tabela
        final roll1 = DiceRoller.rollStatic(1, 6);
        final roll2 = DiceRoller.rollStatic(1, 6);
        final item1 = _getMagicalRingPower(roll1);
        final item2 = _getMagicalRingPower(roll2);
        return '$item1 e $item2';
      default:
        return 'Anel mágico';
    }
  }

  String _getMagicalStaffPower(int roll) {
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
        return 'Varinha mágica';
    }
  }

  String _getMagicalOtherPower(int roll) {
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
        // Jogue 2 vezes nesta tabela
        final roll1 = DiceRoller.rollStatic(1, 6);
        final roll2 = DiceRoller.rollStatic(1, 6);
        final item1 = _getMagicalOtherPower(roll1);
        final item2 = _getMagicalOtherPower(roll2);
        return '$item1 e $item2';
      default:
        return 'Item mágico';
    }
  }

  String _getMagicalItemDetailsWithRolls(
    MagicalItemType type,
    int roll,
    String power,
  ) {
    return '''
Detalhes do Item Mágico:
• Tipo: ${type.description}
• Poder: $power

Tabelas Utilizadas:
• Tabela 4.12: Itens Mágicos
• LB2: Para desdobramentos mágicos (se aplicável)
''';
  }

  String _getRiversRoadsIslandsDirection(int roll) {
    switch (roll) {
      case 1:
        return '1 para 3';
      case 2:
        return '5 para 1';
      case 3:
        return '4 para 2';
      case 4:
        return '2 para 6';
      case 5:
        return '3 para 5';
      case 6:
        return '6 para 4';
      default:
        return '1 para 3';
    }
  }

  String _getCastleFortSize(int roll) {
    switch (roll) {
      case 1:
        return 'Pequeno';
      case 2:
        return 'Médio';
      case 3:
        return 'Grande';
      case 4:
        return 'Muito Grande';
      case 5:
        return 'Enorme';
      case 6:
        return 'Colossal';
      default:
        return 'Médio';
    }
  }

  String _getCastleFortDefenses(int roll) {
    switch (roll) {
      case 1:
        return 'Sem defesas';
      case 2:
        return 'Torres simples';
      case 3:
        return 'Muralhas';
      case 4:
        return 'Fosso';
      case 5:
        return 'Múltiplas defesas';
      case 6:
        return 'Fortificações completas';
      default:
        return 'Torres simples';
    }
  }

  String _getCastleFortOccupants(CastleFortType type, int detailRoll) {
    // Tabela 4.31 - Ocupantes baseado no detalhamento
    switch (detailRoll) {
      case 1:
        return 'Abandonado';
      case 2:
      case 3:
      case 4:
      case 5:
        return 'Humanos';
      case 6:
        // Outros ocupantes - Tabela 4.32
        final terrainRoll = DiceRoller.rollStatic(1, 6);
        return _getOtherOccupantsByTerrain(terrainRoll);
      default:
        return 'Humanos';
    }
  }

  String _getOtherOccupantsByTerrain(int terrainRoll) {
    // Tabela 4.32 - Outros Ocupantes por Terreno
    // Como não sabemos o terreno específico, mostramos todas as opções
    switch (terrainRoll) {
      case 1: // Planície ou Floresta
        return 'Planície/Floresta: Humanos | Colina/Montanha: Humanos | Pântano: Humanos | Deserto: Humanos | Geleira: Humanos | Oceano: Humanos';
      case 2: // Colina ou Montanha
        return 'Planície/Floresta: Elfos | Colina/Montanha: Anões | Pântano: Elfos | Deserto: Goblin | Geleira: Anões | Oceano: Orc';
      case 3: // Pântano
        return 'Planície/Floresta: Sibilantes | Colina/Montanha: Ogro | Pântano: Goblin | Deserto: Orc | Geleira: Orc | Oceano: Hobgoblin';
      case 4: // Deserto
        return 'Planície/Floresta: Gnoll | Colina/Montanha: Orc | Pântano: Hobgoblin | Deserto: Drakold | Geleira: Goblin | Oceano: Goblin';
      case 5: // Geleira
        return 'Planície/Floresta: Hobgoblin | Colina/Montanha: Kawamung | Pântano: Sibilantes | Deserto: Kawamung | Geleira: Ogro | Oceano: Homem Lagarto';
      case 6: // Oceano
        return 'Planície/Floresta: Kawamung | Colina/Montanha: Trogloditas | Pântano: Homem Lagarto | Deserto: Sibilantes | Geleira: Hobgoblin | Oceano: Sahuagin';
      default:
        return 'Humanos';
    }
  }

  // Métodos para detalhamento de castelos e fortes (Tabela 4.31)
  String _getCastleFortAge(int roll) {
    switch (roll) {
      case 1:
        return _calculateDiceFormulas('Obra terminará em 1d6 anos');
      case 2:
        return _calculateDiceFormulas('Construído há 1d10+5 anos');
      case 3:
        return _calculateDiceFormulas('Construído há 1d4+1 décadas');
      case 4:
        return _calculateDiceFormulas('Construído há 1d4 séculos');
      case 5:
        return _calculateDiceFormulas('Construído há 1d6+4 séculos');
      case 6:
        return 'Construído em eras ancestrais';
      default:
        return _calculateDiceFormulas('Construído há 1d4+1 décadas');
    }
  }

  String _getCastleFortCondition(int roll) {
    switch (roll) {
      case 1:
        return 'Perfeito estado de conservação';
      case 2:
        return 'Perfeito estado de conservação';
      case 3:
        return 'Bem conservado';
      case 4:
        return 'Decadente, mas ainda de pé';
      case 5:
        return 'Pode ruir a qualquer momento';
      case 6:
        return 'Em ruínas';
      default:
        return 'Bem conservado';
    }
  }

  String _getCastleFortLord(int roll) {
    switch (roll) {
      case 1:
        return 'Humano nobre';
      case 2:
        return _calculateDiceFormulas('Ladrão 1d4+10 níveis');
      case 3:
        return _calculateDiceFormulas('Guerreiro 1d6+10 níveis');
      case 4:
        return _calculateDiceFormulas('Guerreiro 1d10+10 níveis');
      case 5:
        return _calculateDiceFormulas('Clérigo 1d4+10 níveis');
      case 6:
        return _calculateDiceFormulas('Mago 1d4+10 níveis');
      default:
        return _calculateDiceFormulas('Guerreiro 1d6+10 níveis');
    }
  }

  String _getCastleFortGarrison(int roll) {
    switch (roll) {
      case 1:
        final count = DiceRoller.rollStatic(1, 6) * 10;
        return '$count soldados';
      case 2:
        final count = DiceRoller.rollStatic(2, 6) * 10;
        return '$count soldados';
      case 3:
        final count = DiceRoller.rollStatic(3, 6) * 10;
        return '$count soldados';
      case 4:
        final count = DiceRoller.rollStatic(5, 6) * 10;
        return '$count soldados';
      case 5:
        final count = DiceRoller.rollStatic(7, 6) * 10;
        return '$count soldados';
      case 6:
        final count = DiceRoller.rollStatic(10, 6) * 10;
        return '$count soldados';
      default:
        final count = DiceRoller.rollStatic(2, 6) * 10;
        return '$count soldados';
    }
  }

  String _getCastleFortSpecial(int roll) {
    switch (roll) {
      case 1:
        return 'Nenhum';
      case 2:
        return 'Está sob cerco';
      case 3:
        return 'Local religioso sagrado';
      case 4:
        return 'Aprisiona portal ancestral';
      case 5:
        return 'Assombrado pelo lorde construtor';
      case 6:
        return _calculateDiceFormulas(
          'Construído sobre masmorra de 1d4-1 andares',
        );
      default:
        return 'Nenhum';
    }
  }

  String _getCastleFortRumors(int roll) {
    switch (roll) {
      case 1:
        return 'Nenhum rumor';
      case 2:
        return 'Nenhum rumor';
      case 3:
        return _calculateDiceFormulas('Tem 1d3 rumores');
      case 4:
        return _calculateDiceFormulas('Tem 1d3+1 rumores');
      case 5:
        return _calculateDiceFormulas('Tem 1d3+1 rumores');
      case 6:
        return _calculateDiceFormulas('Tem 1d4+1 rumores');
      default:
        return 'Nenhum rumor';
    }
  }

  String _getTempleSanctuaryDeity(int roll) {
    switch (roll) {
      case 1:
        return 'Lei (Ordem)';
      case 2:
        return 'Lei (Ordem)';
      case 3:
        return 'Natureza (Neutro)';
      case 4:
        return 'Tempo (Neutro)';
      case 5:
        return 'Orcus (Caos)';
      case 6:
        return 'Deuses Antigos';
      default:
        return 'Natureza (Neutro)';
    }
  }

  String _getTempleSanctuaryOccupants(int roll) {
    switch (roll) {
      case 1:
        return 'Abandonado';
      case 2:
        return 'Abandonado com Guardião';
      case 3:
        return 'Abandonado com Guardião';
      case 4:
        final count = DiceRoller.rollStatic(1, 6) * 10;
        return 'Religiosos ($count)';
      case 5:
        final count = DiceRoller.rollStatic(2, 6) * 10;
        return 'Religiosos ($count)';
      case 6:
        final count = DiceRoller.rollStatic(3, 6) * 10;
        return 'Religiosos ($count)';
      default:
        return 'Abandonado';
    }
  }

  // Tabela 4.34 - Aspectos Religiosos
  String _getReligiousAspects(int roll) {
    switch (roll) {
      case 1:
        return 'Divindade: Lei (Ordem)\nDivindade de Caos: Orcus\nObjeto de Adoração: Itens sagrados\nItem Sagrado: Relíquia religiosa\nLocal Sagrado: Onde a divindade se materializou';
      case 2:
        return 'Divindade: Lei (Ordem)\nDivindade de Caos: Orcus\nObjeto de Adoração: Itens sagrados\nItem Sagrado: Uma arma\nLocal Sagrado: Onde a divindade venceu';
      case 3:
        return 'Divindade: Natureza (Neutro)\nDivindade de Caos: Arak-Takna\nObjeto de Adoração: Mártir ou santos sepultados\nItem Sagrado: Uma armadura\nLocal Sagrado: Onde a divindade realizou milagre';
      case 4:
        return 'Divindade: Tempo (Neutro)\nDivindade de Caos: Arak-Takna\nObjeto de Adoração: Criatura mística aprisionada\nItem Sagrado: Escrituras sacras\nLocal Sagrado: Local de observação astrológica';
      case 5:
        return 'Divindade: Caos\nDivindade de Caos: Demogorgon\nObjeto de Adoração: Local sagrado\nItem Sagrado: Fonte de águas mágicas\nLocal Sagrado: Onde a divindade ascendeu';
      case 6:
        final ancientDeity = _generateAncientDeity();
        return 'Divindade: Deuses Antigos\nObjeto de Adoração: Centro de sacrifícios\nItem Sagrado: Item mágico\nLocal Sagrado: Onde a divindade foi derrotada\n\nDetalhes do Deus Antigo:\n$ancientDeity';
      default:
        return 'Divindade: Natureza (Neutro)\nDivindade de Caos: Arak-Takna\nObjeto de Adoração: Mártir ou santos sepultados\nItem Sagrado: Uma armadura\nLocal Sagrado: Onde a divindade realizou milagre';
    }
  }

  // Tabela 4.35 - Ocupação
  String _getTempleSanctuaryOccupation(int roll) {
    switch (roll) {
      case 1:
        return 'Ocupantes: Abandonado\nSeguidores: Nenhum\nLiderança: Não há';
      case 2:
        final followers = DiceRoller.rollStatic(1, 6) * 10;
        final clericLevel = 2 + DiceRoller.rollStatic(1, 4);
        final guardian = _generateGuardian();
        return 'Ocupantes: Abandonado com Guardião\nSeguidores: $followers\nLiderança: Clérigo $clericLevel níveis\nGuardião: $guardian';
      case 3:
        final followers = DiceRoller.rollStatic(2, 6) * 10;
        final clericLevel = 4 + DiceRoller.rollStatic(1, 6);
        final guardian = _generateGuardian();
        return 'Ocupantes: Abandonado com Guardião\nSeguidores: $followers\nLiderança: Clérigo $clericLevel níveis\nGuardião: $guardian';
      case 4:
        final followers = DiceRoller.rollStatic(3, 6) * 10;
        final clericLevel = 5 + DiceRoller.rollStatic(1, 6);
        return 'Ocupantes: Religiosos\nSeguidores: $followers\nLiderança: Clérigo $clericLevel níveis';
      case 5:
        final followers = DiceRoller.rollStatic(5, 6) * 10;
        final clericLevel = 10 + DiceRoller.rollStatic(2, 6);
        return 'Ocupantes: Religiosos\nSeguidores: $followers\nLiderança: Clérigo $clericLevel níveis';
      case 6:
        final followers = DiceRoller.rollStatic(7, 6) * 10;
        final guardian = _generateGuardian();
        return 'Ocupantes: Religiosos\nSeguidores: $followers\nLiderança: Guardião\nGuardião: $guardian';
      default:
        return 'Ocupantes: Abandonado\nSeguidores: Nenhum\nLiderança: Não há';
    }
  }

  // Tabela A1.1 - Guardiões
  String _generateGuardian() {
    final guardianRoll = DiceRoller.rollStatic(1, 6);
    final guardianType = _getGuardianType(guardianRoll);
    final guardian = generateGuardian(guardianType);
    return '${guardian.description}\n${guardian.details}';
  }

  // Tabela 4.36 - Deuses Antigos
  String _generateAncientDeity() {
    final alignmentRoll = DiceRoller.rollStatic(1, 6);
    final aspectRoll = DiceRoller.rollStatic(1, 6);
    final appearanceRoll = DiceRoller.rollStatic(1, 6);
    final animalRoll = DiceRoller.rollStatic(1, 6);
    final descriptionRoll = DiceRoller.rollStatic(1, 6);

    final alignment = _getAncientDeityAlignment(alignmentRoll);
    final aspects = _getAncientDeityAspects(alignmentRoll, aspectRoll);
    final appearance = _getAncientDeityAppearance(appearanceRoll, animalRoll);
    final description = _getAncientDeityDescription(descriptionRoll);
    final name = _generateAncientDeityName();

    return 'Nome: $name\nAlinhamento: $alignment\nAspecto: $aspects\nAparência: $appearance\nDescrição: $description';
  }

  String _getAncientDeityAlignment(int roll) {
    switch (roll) {
      case 1:
        return 'Ordem 1 aspecto';
      case 2:
        return 'Ordem 2 aspectos';
      case 3:
        return 'Neutro 1 aspecto';
      case 4:
        return 'Neutro 2 aspectos';
      case 5:
        return 'Caos 1 aspecto';
      case 6:
        return 'Caos 2 aspectos';
      default:
        return 'Neutro 1 aspecto';
    }
  }

  String _getAncientDeityAspects(int alignmentRoll, int aspectRoll) {
    if (alignmentRoll <= 2) {
      // Ordem
      switch (aspectRoll) {
        case 1:
          return 'Fertilidade';
        case 2:
          return 'Colheita';
        case 3:
          return 'Magia';
        case 4:
          return 'Música';
        case 5:
          return 'Incêndio';
        case 6:
          return 'Tempestade';
        default:
          return 'Fertilidade';
      }
    } else if (alignmentRoll <= 4) {
      // Neutro
      switch (aspectRoll) {
        case 1:
          return 'Morte';
        case 2:
          return 'Misericórdia';
        case 3:
          return 'Sexo';
        case 4:
          return 'Magia';
        case 5:
          return 'Música';
        case 6:
          return 'Peste';
        default:
          return 'Morte';
      }
    } else {
      // Caos
      switch (aspectRoll) {
        case 1:
          return 'Conhecimento';
        case 2:
          return 'Sorte';
        case 3:
          return 'Dor';
        case 4:
          return 'Incêndio';
        case 5:
          return 'Tempestade';
        case 6:
          return 'Peste';
        default:
          return 'Conhecimento';
      }
    }
  }

  String _getAncientDeityAppearance(int appearanceRoll, int animalRoll) {
    switch (appearanceRoll) {
      case 1:
        final animal = _getAncientDeityAnimal(animalRoll);
        return 'Animal ($animal)';
      case 2:
        return 'Cogumelo';
      case 3:
        return 'Olho';
      case 4:
        return 'Árvore';
      case 5:
        return 'Homem Velho';
      case 6:
        return 'Dragão';
      default:
        return 'Animal (Sapo)';
    }
  }

  String _getAncientDeityAnimal(int roll) {
    switch (roll) {
      case 1:
        return 'Sapo';
      case 2:
        return 'Cobra';
      case 3:
        return 'Polvo';
      case 4:
        return 'Porco';
      case 5:
        return 'Macaco';
      case 6:
        return 'Rato';
      default:
        return 'Sapo';
    }
  }

  String _getAncientDeityDescription(int roll) {
    switch (roll) {
      case 1:
        return 'Gigante';
      case 2:
        return 'Espinhoso';
      case 3:
        return 'Ferido';
      case 4:
        return 'Metálico';
      case 5:
        return 'Adormecido';
      case 6:
        return 'Rochoso';
      default:
        return 'Gigante';
    }
  }

  // Tabela 4.37 - Nomes de Deuses Antigos
  String _generateAncientDeityName() {
    final formatRoll = DiceRoller.rollStatic(1, 6);
    final aRoll = DiceRoller.rollStatic(1, 6);
    final bRoll = DiceRoller.rollStatic(1, 6);
    final cRoll = DiceRoller.rollStatic(1, 6);

    final a = _getAncientDeityNamePart(aRoll);
    final b = _getAncientDeityNamePartB(bRoll);
    final c = _getAncientDeityNamePartC(cRoll);

    // Debug: verificar se as partes estão corretas
    print(
      'Format: $formatRoll, A: $a ($aRoll), B: $b ($bRoll), C: $c ($cRoll)',
    );

    switch (formatRoll) {
      case 1:
        return a + b;
      case 2:
        return b + c;
      case 3:
        return c + a;
      case 4:
        return a + b + c;
      case 5:
        return b + c + a;
      case 6:
        return c + a + b;
      default:
        return a + b;
    }
  }

  String _getAncientDeityNamePart(int roll) {
    switch (roll) {
      case 1:
        return 'ASH';
      case 2:
        return 'BET';
      case 3:
        return 'CHO';
      case 4:
        return 'DUK';
      case 5:
        return 'GAR';
      case 6:
        return 'MAN';
      default:
        return 'ASH';
    }
  }

  String _getAncientDeityNamePartB(int roll) {
    switch (roll) {
      case 1:
        return 'HUN';
      case 2:
        return 'KAN';
      case 3:
        return 'ISH';
      case 4:
        return 'MAR';
      case 5:
        return 'TUS';
      case 6:
        return 'TER';
      default:
        return 'HUN';
    }
  }

  String _getAncientDeityNamePartC(int roll) {
    switch (roll) {
      case 1:
        return 'NOR';
      case 2:
        return 'PUK';
      case 3:
        return 'NES';
      case 4:
        return 'XAR';
      case 5:
        return 'KUN';
      case 6:
        return 'SAT';
      default:
        return 'NOR';
    }
  }

  String _getNaturalDangerEffects(NaturalDangerType type) {
    switch (type) {
      case NaturalDangerType.quicksand:
        return 'Movimento reduzido, chance de afundar. Taxa: 20% do corpo por turno.';
      case NaturalDangerType.thornyBushes:
        return 'Dano por movimento, dificulta passagem. 1 ponto a cada 1,5m.';
      case NaturalDangerType.thermalSprings:
        return 'Água quente, vapores tóxicos. Pode ser fatal se muito quente.';
      case NaturalDangerType.tarPit:
        return 'Substância pegajosa, difícil de escapar. Movimento reduzido à metade.';
      case NaturalDangerType.mudVolcano:
        return _calculateDiceFormulas(
          'Erupções de lama, terreno instável. Lama ácida causa 1d4 de dano regressivo.',
        );
      case NaturalDangerType.earthquake:
        return 'Danos estruturais, desabamentos. JPD para manter equilíbrio.';
      case NaturalDangerType.softSand:
        return 'Movimento reduzido pela metade. Impossível marchar ou correr.';
      case NaturalDangerType.suddenTide:
        return 'Submerso, equipamentos perdidos. Fogueiras apagadas.';
      case NaturalDangerType.mirage:
        return 'Efeitos psicológicos em viajantes vulneráveis. JPS fácil para desacreditar.';
      case NaturalDangerType.tsunami:
        return '10d6 de dano se JPD bem-sucedida. Falha: morte por afogamento.';
      case NaturalDangerType.avalanches:
        return '10d6 de dano se JPD bem-sucedida. Falha: morte por soterramento.';
      case NaturalDangerType.thinIce:
        return 'Quebra ao caminhar. Afogamento e congelamento. Impossível marchar ou correr.';
      case NaturalDangerType.softSnow:
        return 'Movimento reduzido pela metade. Impossível marchar ou correr.';
      case NaturalDangerType.smoothIce:
        return 'Deslocamento praticamente impossível sem equipamentos especiais.';
      case NaturalDangerType.flooded:
        return 'Permite apenas movimento de natação. Consome 1 ponto de jornada extra.';
      case NaturalDangerType.sandstorm:
        return _calculateDiceFormulas(
          '1d4 de dano por turno. Cegueira e sufocamento possíveis.',
        );
      case NaturalDangerType.sandPit:
        return 'Difícil identificação. Taxa de afundamento: 25% por turno.';
      case NaturalDangerType.volcanicEruptions:
        return 'Complexo de eventos mortalmente perigosos. Lava, cinzas, tremores.';
      case NaturalDangerType.fumaroles:
        return '1d4 pontos de dano devido ao vapor. Gases sulfurosos possíveis.';
      case NaturalDangerType.altitude:
        return 'Falta de oxigênio causa exaustão. Custa 2 pontos de jornada.';
      default:
        return 'Efeitos variados conforme o tipo de perigo.';
    }
  }

  String _getCivilizationPopulationByType(CivilizationType type) {
    switch (type) {
      case CivilizationType.settlement:
        // Assentamento: 200, 250, 300, 350, 400, 450 habitantes
        final populationRoll = DiceRoller.rollStatic(1, 6);
        switch (populationRoll) {
          case 1:
            return '200 habitantes';
          case 2:
            return '250 habitantes';
          case 3:
            return '300 habitantes';
          case 4:
            return '350 habitantes';
          case 5:
            return '400 habitantes';
          case 6:
            return '450 habitantes';
          default:
            return '300 habitantes';
        }
      case CivilizationType.village:
        // Aldeia: 500, 600, 700, 800, 900, 1000 habitantes
        final populationRoll = DiceRoller.rollStatic(1, 6);
        switch (populationRoll) {
          case 1:
            return '500 habitantes';
          case 2:
            return '600 habitantes';
          case 3:
            return '700 habitantes';
          case 4:
            return '800 habitantes';
          case 5:
            return '900 habitantes';
          case 6:
            return '1000 habitantes';
          default:
            return '700 habitantes';
        }
      case CivilizationType.town:
        // Vila: 2000, 3000, 4000, 5000, 6000, 6000+1d4×1000 habitantes
        final populationRoll = DiceRoller.rollStatic(1, 6);
        switch (populationRoll) {
          case 1:
            return '2000 habitantes';
          case 2:
            return '3000 habitantes';
          case 3:
            return '4000 habitantes';
          case 4:
            return '5000 habitantes';
          case 5:
            return '6000 habitantes';
          case 6:
            final extra = DiceRoller.rollStatic(1, 4) * 1000;
            return '${6000 + extra} habitantes';
          default:
            return '4000 habitantes';
        }
      case CivilizationType.city:
        // Cidade: 10000, 20000, 30000, 40000, 50000, 60000+1d4×10000 habitantes
        final populationRoll = DiceRoller.rollStatic(1, 6);
        switch (populationRoll) {
          case 1:
            return '10000 habitantes';
          case 2:
            return '20000 habitantes';
          case 3:
            return '30000 habitantes';
          case 4:
            return '40000 habitantes';
          case 5:
            return '50000 habitantes';
          case 6:
            final extra = DiceRoller.rollStatic(1, 4) * 10000;
            return '${60000 + extra} habitantes';
          default:
            return '30000 habitantes';
        }
      case CivilizationType.metropolis:
        // Metrópole: 100000, 200000, 300000, 400000, 500000, 600000+1d4×100000 habitantes
        final populationRoll = DiceRoller.rollStatic(1, 6);
        switch (populationRoll) {
          case 1:
            return '100000 habitantes';
          case 2:
            return '200000 habitantes';
          case 3:
            return '300000 habitantes';
          case 4:
            return '400000 habitantes';
          case 5:
            return '500000 habitantes';
          case 6:
            final extra = DiceRoller.rollStatic(1, 4) * 100000;
            return '${600000 + extra} habitantes';
          default:
            return '300000 habitantes';
        }
      default:
        return '1000 habitantes';
    }
  }

  String _getCivilizationPopulation(int roll) {
    switch (roll) {
      case 1:
        final count = DiceRoller.rollStatic(1, 10) * 10;
        return '$count habitantes';
      case 2:
        final count = DiceRoller.rollStatic(2, 10) * 10;
        return '$count habitantes';
      case 3:
        final count = DiceRoller.rollStatic(3, 10) * 10;
        return '$count habitantes';
      case 4:
        final count = DiceRoller.rollStatic(4, 10) * 10;
        return '$count habitantes';
      case 5:
        final count = DiceRoller.rollStatic(5, 10) * 10;
        return '$count habitantes';
      case 6:
        final count = DiceRoller.rollStatic(6, 10) * 10;
        return '$count habitantes';
      default:
        final count = DiceRoller.rollStatic(2, 10) * 10;
        return '$count habitantes';
    }
  }

  String _getCivilizationGovernment(int roll) {
    switch (roll) {
      case 1:
        return 'Ordeiro - Nobre local';
      case 2:
        return 'Ordeiro - Político plebeu';
      case 3:
        return 'Neutro - Ladrão local';
      case 4:
        return 'Neutro - Guerreiro local';
      case 5:
        return 'Caótico - Clérigo local';
      case 6:
        return 'Caótico - Mago local';
      default:
        return 'Neutro - Guerreiro local';
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

  String _getLairDetails(LairType type, LairOccupation occupation) {
    // Implementação baseada no tipo de covil e ocupação
    switch (type) {
      case LairType.dungeons:
        final dungeon = generateDungeon();
        return '''
Detalhes da Masmorra:
• Entrada: ${dungeon.entry}
• Andares: ${dungeon.floors}
• Salas: ${dungeon.rooms}
• Guardião: ${dungeon.guardian}
• Detalhes das Salas: ${dungeon.roomDetails}

Tabelas Utilizadas:
• Tabela 4.14: Masmorras
• Tabela 4.15: Detalhando Salas
• Rolagens de dados já resolvidas
''';
      case LairType.caves:
        final cave = generateCave();
        return '''
Detalhes da Caverna:
• Entrada: ${cave.entry}
• Morador: ${cave.inhabitant}
• Detalhes das Câmaras: ${cave.chamberDetails}

Tabelas Utilizadas:
• Tabela 4.16: Cavernas
• Tabela 4.17: Detalhando Cavernas
• Rolagens de dados já resolvidas
''';
      case LairType.burrows:
        final burrow = generateBurrow();
        return '''
Detalhes da Toca:
• Entrada: ${burrow.entry}
• Ocupante: ${burrow.occupant}
• Tesouro: ${burrow.treasure}

Tabelas Utilizadas:
• Tabela 4.18: Tocas
• Tabela 4.19: Ocupantes das Tocas
• Tabela 4.20: Tesouros em Fundo de Tocas
• Rolagens de dados já resolvidas
''';
      case LairType.nests:
        final nest = generateNest();
        return '''
Detalhes do Ninho:
• Dono: ${nest.owner}
• Característica: ${nest.characteristic}

Tabelas Utilizadas:
• Tabela 4.21: Ninhos
• Rolagens de dados já resolvidas
''';
      case LairType.camps:
        final campType = _getCampType(DiceRoller.rollStatic(1, 6));
        final campSpecial = _getCampSpecial(DiceRoller.rollStatic(1, 6));
        final campTents = _getCampTents(DiceRoller.rollStatic(1, 6));
        final campWatch = _getCampWatch(DiceRoller.rollStatic(1, 6));
        final campDefenses = _getCampDefenses(DiceRoller.rollStatic(1, 6));

        return '''
Detalhes do Acampamento:
• Tipo: $campType
• Especial: $campSpecial
• Tendas: $campTents
• Vigília: $campWatch
• Defesas: $campDefenses

Tabelas Utilizadas:
• Tabela 4.22: Acampamentos
• Rolagens de dados já resolvidas
''';
      case LairType.tribes:
        final tribe = generateTribe(TerrainType.forests); // Usar terreno padrão
        return '''
Detalhes da Tribo:
• Tipo: ${tribe.type}
• Membros: ${tribe.members}
• Soldados: ${tribe.soldiers}
• Líderes: ${tribe.leaders}
• Religiosos: ${tribe.religious}
• Especiais: ${tribe.special}

Tabelas Utilizadas:
• Tabela 4.23: Tribos
• Tabela 4.24: Detalhando Membros
• Rolagens de dados já resolvidas
''';
      default:
        return 'Covil com características variadas.';
    }
  }

  String _getNaturalDangerDetails(NaturalDangerType type) {
    switch (type) {
      case NaturalDangerType.quicksand:
        return 'Área de areia movediça que pode engolir viajantes. Taxa de afundamento: 20% do corpo a cada turno. Após 5 turnos, morte por soterramento.';
      case NaturalDangerType.thornyBushes:
        return 'Vegetação espinhosa que dificulta a passagem. Dano: 1 ponto a cada 1,5m de avanço. Deslocamento reduzido a 2/3 do normal.';
      case NaturalDangerType.thermalSprings:
        return 'Fontes de água quente subterrânea que jorram para a superfície. Podem ser perigosas se muito quentes ou ácidas.';
      case NaturalDangerType.tarPit:
        return 'Áreas com abundância de terra encharcada, lama e água. Movimento cai à metade do valor normal.';
      case NaturalDangerType.mudVolcano:
        return 'Cones de lama endurecida que expelem gases e lama ácida em erupções aleatórias.';
      case NaturalDangerType.earthquake:
        return 'Tremor de terra que pode causar desabamentos. JPD necessária para manter equilíbrio.';
      case NaturalDangerType.softSand:
        return 'Camada de areia não compactada sobre o solo. Reduz movimento pela metade.';
      case NaturalDangerType.suddenTide:
        return 'Maré que pode subir até 15 metros em 10 minutos. Afoga pessoas e carrega equipamentos.';
      case NaturalDangerType.mirage:
        return 'Imagens ilusórias formadas naturalmente no horizonte. JPS fácil para desacreditá-la.';
      case NaturalDangerType.tsunami:
        return 'Onda gigante de força descomunal. JPD necessária para sobreviver. Falha significa morte por afogamento.';
      case NaturalDangerType.avalanches:
        return 'Enormes deslizamentos de terra, pedras, neve ou lama. JPD bem-sucedida: 10d6 de dano. Falha: morte por soterramento.';
      case NaturalDangerType.thinIce:
        return 'Camadas muito finas sobre corpos de águas. Quebra ao caminhar, causando afogamento e congelamento.';
      case NaturalDangerType.softSnow:
        return 'Camada de neve não compactada sobre o solo. Reduz movimento pela metade.';
      case NaturalDangerType.smoothIce:
        return 'Camada de gelo lisa e escorregadia. Deslocamento sem preparo praticamente impossível.';
      case NaturalDangerType.flooded:
        return 'Áreas alagadas causadas por enchentes ou corpos de água. Permite apenas movimento de natação. Consome 1 ponto de jornada extra.';
      case NaturalDangerType.sandstorm:
        return 'Enormes nuvens de areia carregadas por fortes ventos. Duração: até 2+1d4 turnos.';
      case NaturalDangerType.sandPit:
        return 'Fosso na areia em forma de cone com paredes íngremes. Difícil identificação.';
      case NaturalDangerType.volcanicEruptions:
        return 'Vulcão em erupção com explosão de lava, cinzas e pedras. Eventos mortalmente perigosos.';
      case NaturalDangerType.fumaroles:
        return 'Colunas de vapor e gases que saem de fendas no solo. Causam 1d4 pontos de dano.';
      case NaturalDangerType.altitude:
        return 'Altitudes acima de 2.000 metros. Falta de oxigênio causa exaustão. Custa 2 pontos de jornada. Aclimatação possível com tempo.';
      default:
        return 'Perigo natural com características variadas.';
    }
  }

  /// ========================================
  /// MÉTODOS PARA GUARDIÕES (Tabela A1.1)
  /// ========================================

  /// Gera um guardião baseado no tipo
  Guardian generateGuardian(GuardianType type) {
    switch (type) {
      case GuardianType.none:
        return Guardian(
          type: type,
          description: 'Nenhum guardião presente',
          details: 'O local não possui proteção ativa.',
        );
      case GuardianType.traps:
        return _generateTrapGuardian();
      case GuardianType.giants:
        return _generateGiantGuardian();
      case GuardianType.undead:
        return _generateUndeadGuardian();
      case GuardianType.others:
        return _generateOtherGuardian();
      case GuardianType.dragons:
        return _generateDragonGuardian();
    }
  }

  /// Gera um guardião de armadilhas
  Guardian _generateTrapGuardian() {
    final trapRoll = DiceRoller.rollStatic(1, 6);
    final trap = _getTrapType(trapRoll);
    final damage = _getTrapDamage(trap);
    final details = _getTrapDetails(trap);

    return Guardian(
      type: GuardianType.traps,
      description: 'Armadilhas: ${trap.description}',
      details: 'Dano: $damage\n$details',
    );
  }

  /// Gera um guardião gigante
  Guardian _generateGiantGuardian() {
    final giantRoll = DiceRoller.rollStatic(1, 6);
    final giant = _getGiantType(giantRoll);
    final details = _getGiantDetails(giant);

    return Guardian(
      type: GuardianType.giants,
      description: 'Gigante: ${giant.description}',
      details: details,
    );
  }

  /// Gera um guardião morto-vivo
  Guardian _generateUndeadGuardian() {
    final undeadRoll = DiceRoller.rollStatic(1, 6);
    final undead = _getUndeadType(undeadRoll);
    final details = _getUndeadDetails(undead);

    return Guardian(
      type: GuardianType.undead,
      description: 'Morto-Vivo: ${undead.description}',
      details: details,
    );
  }

  /// Gera um guardião outro
  Guardian _generateOtherGuardian() {
    final otherRoll = DiceRoller.rollStatic(1, 6);
    final other = _getOtherGuardianType(otherRoll);
    final details = _getOtherGuardianDetails(other);

    return Guardian(
      type: GuardianType.others,
      description: 'Outro: ${other.description}',
      details: details,
    );
  }

  /// Gera um guardião dragão
  Guardian _generateDragonGuardian() {
    final dragonRoll = DiceRoller.rollStatic(1, 6);
    final dragon = _getDragonType(dragonRoll);
    final details = _getDragonDetails(dragon);

    return Guardian(
      type: GuardianType.dragons,
      description: 'Dragão: ${dragon.description}',
      details: details,
    );
  }

  /// Obtém o tipo de armadilha baseado na rolagem
  TrapType _getTrapType(int roll) {
    switch (roll) {
      case 1:
        return TrapType.poisonedDarts;
      case 2:
        return TrapType.pitWithStakes;
      case 3:
        return TrapType.fallingBlock;
      case 4:
        return TrapType.hiddenGuillotine;
      case 5:
        return TrapType.acidSpray;
      case 6:
        return TrapType.retractableCeiling;
      default:
        return TrapType.poisonedDarts;
    }
  }

  /// Obtém o dano da armadilha
  String _getTrapDamage(TrapType trap) {
    switch (trap) {
      case TrapType.poisonedDarts:
        return _calculateDiceFormulas('1d6 dardos / 1d4 de dano cada');
      case TrapType.pitWithStakes:
        return _calculateDiceFormulas('2d6 de dano');
      case TrapType.fallingBlock:
        return _calculateDiceFormulas('1d10 de dano');
      case TrapType.hiddenGuillotine:
        return _calculateDiceFormulas('1d8 de dano');
      case TrapType.acidSpray:
        return _calculateDiceFormulas('1d4 de dano ácido');
      case TrapType.retractableCeiling:
        return _calculateDiceFormulas('Morte em 1d8 turnos');
    }
  }

  /// Obtém os detalhes da armadilha
  String _getTrapDetails(TrapType trap) {
    switch (trap) {
      case TrapType.poisonedDarts:
        return 'Dardos são expelidos por buracos nas paredes. Você determina o efeito do veneno.';
      case TrapType.pitWithStakes:
        return 'Buraco no chão com estacas afiadas. Há 1-2 chances em 1d6 de não haver estacas.';
      case TrapType.fallingBlock:
        return 'Bloco que cai do teto da masmorra.';
      case TrapType.hiddenGuillotine:
        return 'Lâmina escondida que corta rapidamente.';
      case TrapType.acidSpray:
        return 'Atinge todos até 6 metros da armadilha.';
      case TrapType.retractableCeiling:
        return 'Teto desce até esmagar todos. Desarmar Armadilhas necessário.';
    }
  }

  /// Obtém o tipo de gigante baseado na rolagem
  GiantType _getGiantType(int roll) {
    switch (roll) {
      case 1:
        return GiantType.ettin;
      case 2:
        return GiantType.hillGiant;
      case 3:
        return GiantType.mountainGiant;
      case 4:
        return GiantType.stormGiant;
      case 5:
        return GiantType.fireGiant;
      case 6:
        return GiantType.iceGiant;
      default:
        return GiantType.ettin;
    }
  }

  /// Obtém os detalhes do gigante
  String _getGiantDetails(GiantType giant) {
    switch (giant) {
      case GiantType.ettin:
        return 'Criatura com duas cabeças, força bruta e resistência.';
      case GiantType.hillGiant:
        return 'Gigante das colinas, usa clavas e pedras como armas.';
      case GiantType.mountainGiant:
        return 'Gigante das montanhas, resistente ao frio e à altitude.';
      case GiantType.stormGiant:
        return 'Gigante das tempestades, controla raios e trovões.';
      case GiantType.fireGiant:
        return 'Gigante do fogo, imune ao calor e usa armas flamejantes.';
      case GiantType.iceGiant:
        return 'Gigante do gelo, imune ao frio e usa armas congelantes.';
    }
  }

  /// Obtém o tipo de morto-vivo baseado na rolagem
  UndeadType _getUndeadType(int roll) {
    switch (roll) {
      case 1:
        return UndeadType.specter;
      case 2:
        return UndeadType.ghost;
      case 3:
        return UndeadType.banshee;
      case 4:
        return UndeadType.mummy;
      case 5:
        return UndeadType.vampire;
      case 6:
        return UndeadType.lich;
      default:
        return UndeadType.specter;
    }
  }

  /// Obtém os detalhes do morto-vivo
  String _getUndeadDetails(UndeadType undead) {
    switch (undead) {
      case UndeadType.specter:
        return 'Espírito incorpóreo que pode atravessar paredes e drenar vida.';
      case UndeadType.ghost:
        return 'Alma atormentada que assombra o local de sua morte.';
      case UndeadType.banshee:
        return 'Espírito feminino que grita e causa terror.';
      case UndeadType.mummy:
        return 'Cadáver preservado com poderes mágicos.';
      case UndeadType.vampire:
        return 'Morto-vivo que se alimenta de sangue e tem poderes sobrenaturais.';
      case UndeadType.lich:
        return 'Mago morto-vivo que mantém seus poderes mágicos.';
    }
  }

  /// Obtém o tipo de outro guardião baseado na rolagem
  OtherGuardianType _getOtherGuardianType(int roll) {
    switch (roll) {
      case 1:
        return OtherGuardianType.cerberus;
      case 2:
        return OtherGuardianType.sphinx;
      case 3:
        return OtherGuardianType.efreeti;
      case 4:
        return OtherGuardianType.ironGolem;
      case 5:
        return OtherGuardianType.blackPudding;
      case 6:
        return OtherGuardianType.shoggoth;
      default:
        return OtherGuardianType.cerberus;
    }
  }

  /// Obtém os detalhes do outro guardião
  String _getOtherGuardianDetails(OtherGuardianType other) {
    switch (other) {
      case OtherGuardianType.cerberus:
        return 'Cão de três cabeças que guarda portais e entradas.';
      case OtherGuardianType.sphinx:
        return 'Criatura mística que propõe enigmas e desafios.';
      case OtherGuardianType.efreeti:
        return 'Gênio do fogo com poderes mágicos poderosos.';
      case OtherGuardianType.ironGolem:
        return 'Construto de ferro imune à magia e muito resistente.';
      case OtherGuardianType.blackPudding:
        return 'Massa viscosa que dissolve metal e carne.';
      case OtherGuardianType.shoggoth:
        return 'Criatura amorfa e alienígena de poder incomensurável.';
    }
  }

  /// Obtém o tipo de dragão baseado na rolagem
  DragonType _getDragonType(int roll) {
    switch (roll) {
      case 1:
        return DragonType.blueDragon;
      case 2:
        return DragonType.whiteDragon;
      case 3:
        return DragonType.goldDragon;
      case 4:
        return DragonType.blackDragon;
      case 5:
        return DragonType.greenDragon;
      case 6:
        return DragonType.redDragon;
      default:
        return DragonType.blueDragon;
    }
  }

  /// Obtém os detalhes do dragão
  String _getDragonDetails(DragonType dragon) {
    switch (dragon) {
      case DragonType.blueDragon:
        return 'Dragão azul que respira eletricidade e habita desertos.';
      case DragonType.whiteDragon:
        return 'Dragão branco que respira gelo e habita regiões frias.';
      case DragonType.goldDragon:
        return 'Dragão dourado, o mais sábio e poderoso dos dragões metálicos.';
      case DragonType.blackDragon:
        return 'Dragão negro que respira ácido e habita pântanos.';
      case DragonType.greenDragon:
        return 'Dragão verde que respira gás venenoso e habita florestas.';
      case DragonType.redDragon:
        return 'Dragão vermelho que respira fogo e é o mais agressivo.';
    }
  }

  /// Gera um guardião aleatório
  Guardian generateRandomGuardian() {
    final roll = DiceRoller.rollStatic(1, 6);
    final type = _getGuardianType(roll);
    return generateGuardian(type);
  }

  /// Obtém o tipo de guardião baseado na rolagem
  GuardianType _getGuardianType(int roll) {
    switch (roll) {
      case 1:
        return GuardianType.none;
      case 2:
        return GuardianType.traps;
      case 3:
        return GuardianType.giants;
      case 4:
        return GuardianType.undead;
      case 5:
        return GuardianType.others;
      case 6:
        return GuardianType.dragons;
      default:
        return GuardianType.none;
    }
  }

  String _getOssuarySizeByType(OssuaryType type, int roll) {
    switch (type) {
      case OssuaryType.small:
        return _getSmallOssuary(roll);
      case OssuaryType.humanoid:
        return _getHumanoidOssuary(roll);
      case OssuaryType.medium:
        return _getMediumOssuary(roll);
      case OssuaryType.large:
        return _getLargeOssuary(roll);
      case OssuaryType.colossal:
        return _getColossalOssuary(roll);
      case OssuaryType.special:
        return _getSpecialOssuary(roll);
    }
  }

  String _getSmallOssuary(int roll) {
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
  }

  String _getHumanoidOssuary(int roll) {
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
  }

  String _getMediumOssuary(int roll) {
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
  }

  String _getLargeOssuary(int roll) {
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
  }

  String _getColossalOssuary(int roll) {
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
  }

  String _getSpecialOssuary(int roll) {
    switch (roll) {
      case 1:
        return 'Revestido de metal';
      case 2:
        return 'Apenas os crânios';
      case 3:
        return 'Humanoides com asas';
      case 4:
        return 'Dentro de armaduras';
      case 5:
        return 'Ossadas incompletas';
      case 6:
        return 'Com tesouro do tipo B';
      default:
        return 'Revestido de metal';
    }
  }

  // Tabela 4.10 - Detalhando Fontes
  String _getSourceType(int roll) {
    switch (roll) {
      case 1:
        return 'Chafariz';
      case 2:
        return 'Estátua de mulher';
      case 3:
        return 'Estátua monstruosa';
      case 4:
        return 'Nascente no chão';
      case 5:
        return 'Poço';
      case 6:
        return 'Gêiser';
      default:
        return 'Chafariz';
    }
  }

  String _getSourceWaterType(int roll) {
    switch (roll) {
      case 1:
      case 2:
      case 3:
      case 4:
        return 'Água potável';
      case 5:
        return 'Água contaminada com febre do esgoto';
      case 6:
        return 'Água envenenada';
      default:
        return 'Água potável';
    }
  }

  // Tabela 4.27 - Estradas
  String _getRoadFinding(int roll) {
    switch (roll) {
      case 1:
        return '1 para 3';
      case 2:
        return '5 para 1';
      case 3:
        return '4 para 2';
      case 4:
        return '2 para 6';
      case 5:
        return '3 para 5';
      case 6:
        return '6 para 4';
      default:
        return '1 para 3';
    }
  }

  String _getRoadContinuation(int roll) {
    switch (roll) {
      case 1:
      case 2:
      case 3:
        return 'Mesma Direção';
      case 4:
        return 'Curva Esquerda';
      case 5:
        return 'Curva Direita';
      case 6:
        return 'Especial...';
      default:
        return 'Mesma Direção';
    }
  }

  String _getRoadSpecial(int roll) {
    switch (roll) {
      case 1:
        return 'Bifurcação para 1 nova direção';
      case 2:
        return 'Encruzilhada para 2 novas direções';
      case 3:
        final bridgeRoll = DiceRoller.rollStatic(1, 6);
        return bridgeRoll <= 4
            ? 'Cruza um rio sem ponte'
            : 'Cruza um rio com ponte';
      case 4:
        return 'Estrada termina no ermo';
      case 5:
        return 'Estrada termina em ruína';
      case 6:
        return 'Estrada termina em aldeia';
      default:
        return 'Bifurcação para 1 nova direção';
    }
  }

  // Tabela 4.26 - Rios
  String _getRiverFinding(int roll) {
    switch (roll) {
      case 1:
        return '1 para 3';
      case 2:
        return '5 para 1';
      case 3:
        return '4 para 2';
      case 4:
        return '2 para 6';
      case 5:
        return '3 para 5';
      case 6:
        return '6 para 4';
      default:
        return '1 para 3';
    }
  }

  String _getRiverContinuation(int roll) {
    switch (roll) {
      case 1:
      case 2:
      case 3:
        return 'Mesma Direção';
      case 4:
        return 'Curva Esquerda';
      case 5:
        return 'Curva Direita';
      case 6:
        return 'Especial...';
      default:
        return 'Mesma Direção';
    }
  }

  String _getRiverSpecial(int roll) {
    switch (roll) {
      case 1:
        return 'Corredeiras';
      case 2:
        return 'Cachoeira';
      case 3:
        return 'Deságua em rio maior';
      case 4:
        return 'Recebe um afluente';
      case 5:
        return 'Deságua em lago';
      case 6:
        return 'Forma um cânion';
      default:
        return 'Corredeiras';
    }
  }

  // Tabela 4.28 - Ilhas
  String _getIslandType(int roll) {
    switch (roll) {
      case 1:
        return 'Pedras estéreis';
      case 2:
        return 'Banco de areia';
      case 3:
        return 'Ilhota';
      case 4:
        return 'Ilha Pequena';
      case 5:
        return 'Ilha Média';
      case 6:
        return 'Ilha Grande';
      default:
        return 'Pedras estéreis';
    }
  }

  String _getIslandSize(int typeRoll, int sizeRoll) {
    switch (typeRoll) {
      case 1:
        return '${DiceRoller.rollStatic(1, 6) + 2} metros';
      case 2:
        final width = DiceRoller.rollStatic(2, 10);
        return '${width} x 20 metros';
      case 3:
        final width = DiceRoller.rollStatic(1, 10);
        return '${width} x 10 metros';
      case 4:
        final width = DiceRoller.rollStatic(5, 10);
        return '${width} x 10 metros';
      case 5:
        final width = DiceRoller.rollStatic(5, 10);
        return '${width} x 100 metros';
      case 6:
        final width = DiceRoller.rollStatic(2, 6) + 5;
        return '${width} km';
      default:
        return '${DiceRoller.rollStatic(1, 6) + 2} metros';
    }
  }

  String _getIslandDetails(int typeRoll, int detailsRoll) {
    // Tabela 4.29 - Detalhando Ilhas
    // Gerar múltiplos detalhamentos baseado no tipo de ilha
    final numberOfDetails = _getIslandNumberOfDetails(typeRoll);
    final details = <String>[];

    for (int i = 0; i < numberOfDetails; i++) {
      final detailTypeRoll = DiceRoller.rollStatic(1, 6);
      final detailSubRoll = DiceRoller.rollStatic(1, 6);

      final detailType = _getIslandDetailType(detailTypeRoll);
      final detailSub = _getIslandDetailSub(detailTypeRoll, detailSubRoll);

      details.add('$detailType: $detailSub');
    }

    return details.join('\n• ');
  }

  int _getIslandNumberOfDetails(int typeRoll) {
    switch (typeRoll) {
      case 1: // Pedras estéreis
        return 0;
      case 2: // Banco de areia
        return 1;
      case 3: // Ilhota
        return DiceRoller.rollStatic(1, 2);
      case 4: // Ilha Pequena
        return DiceRoller.rollStatic(1, 3);
      case 5: // Ilha Média
        return DiceRoller.rollStatic(1, 4);
      case 6: // Ilha Grande
        return DiceRoller.rollStatic(1, 4) + 2;
      default:
        return 1;
    }
  }

  String _getIslandDetailType(int roll) {
    switch (roll) {
      case 1:
        return 'Problemas';
      case 2:
        return 'Provisões';
      case 3:
        return 'Relevo Dominante';
      case 4:
        return 'Tema';
      case 5:
        return 'Habitantes';
      case 6:
        return 'Especial';
      default:
        return 'Problemas';
    }
  }

  String _getIslandDetailSub(int typeRoll, int subRoll) {
    switch (typeRoll) {
      case 1: // Problemas
        switch (subRoll) {
          case 1:
            return 'Areia movediça';
          case 2:
            return 'Espinheiro';
          case 3:
            return 'Recifes pontiagudos';
          case 4:
            return 'Nativos canibais';
          case 5:
            return 'Plantas carnívoras';
          case 6:
            return 'Piratas/Bandidos';
          default:
            return 'Areia movediça';
        }
      case 2: // Provisões
        switch (subRoll) {
          case 1:
            return 'Peixes e crustáceos (Pescar)';
          case 2:
            return 'Frutas (forragear)';
          case 3:
            return 'Ovos de aves (forragear)';
          case 4:
            return 'Animais (caçar)';
          case 5:
            return 'Animais (caçar)';
          case 6:
            return 'Água de coco (Buscar água)';
          default:
            return 'Peixes e crustáceos (Pescar)';
        }
      case 3: // Relevo Dominante
        switch (subRoll) {
          case 1:
            return 'Colina';
          case 2:
            return 'Montanha';
          case 3:
            return 'Planície';
          case 4:
            return 'Pântanos';
          case 5:
            return 'Florestas';
          case 6:
            return 'Deserto';
          default:
            return 'Colina';
        }
      case 4: // Tema
        switch (subRoll) {
          case 1:
            return 'Vale perdido';
          case 2:
            return 'Ilha Fungoide';
          case 3:
            return 'Ilha Gigante';
          case 4:
            return 'Paraíso dos Insetos';
          case 5:
            return 'Ilha dos Mortos-Vivos';
          case 6:
            return 'Ilha Pirata';
          default:
            return 'Vale perdido';
        }
      case 5: // Habitantes
        switch (subRoll) {
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
      case 6: // Especial
        switch (subRoll) {
          case 1:
            return 'Mina de Metal';
          case 2:
            return 'Mina de Gemas';
          case 3:
            return 'Antigo Naufrágio';
          case 4:
            return 'Poço de betume';
          case 5:
            return 'Ruínas';
          case 6:
            return 'Vulcão';
          default:
            return 'Mina de Metal';
        }
      default:
        return 'Areia movediça';
    }
  }
}
