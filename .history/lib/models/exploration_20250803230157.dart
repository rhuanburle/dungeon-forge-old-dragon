import '../enums/exploration_enums.dart';
import '../enums/table_enums.dart';

/// Modelo para resultado de exploração de hex
class ExplorationResult {
  final bool hasDiscovery;
  final DiscoveryType? discoveryType;
  final String description;

  const ExplorationResult({
    required this.hasDiscovery,
    this.discoveryType,
    required this.description,
  });
}

/// Modelo para descoberta ancestral
class AncestralDiscovery {
  final AncestralThingType type;
  final AncestralCondition condition;
  final AncestralMaterial material;
  final AncestralState state;
  final AncestralGuardian guardian;
  final String description;
  final String details;

  const AncestralDiscovery({
    required this.type,
    required this.condition,
    required this.material,
    required this.state,
    required this.guardian,
    required this.description,
    required this.details,
  });
}

/// Modelo para ruínas
class Ruin {
  final RuinType type;
  final String description;
  final String details;
  final String size;
  final String defenses;

  const Ruin({
    required this.type,
    required this.description,
    required this.details,
    required this.size,
    required this.defenses,
  });
}

/// Modelo para relíquias
class Relic {
  final RelicType type;
  final String description;
  final String details;
  final String condition;

  const Relic({
    required this.type,
    required this.description,
    required this.details,
    required this.condition,
  });
}

/// Modelo para objetos
class Object {
  final ObjectType type;
  final String description;
  final String details;
  final String subtype;

  const Object({
    required this.type,
    required this.description,
    required this.details,
    required this.subtype,
  });
}

/// Modelo para vestígios
class Vestige {
  final VestigeType type;
  final String description;
  final String details;
  final String detail;

  const Vestige({
    required this.type,
    required this.description,
    required this.details,
    required this.detail,
  });
}

/// Modelo para ossadas
class Ossuary {
  final OssuaryType type;
  final String description;
  final String details;
  final String size;

  const Ossuary({
    required this.type,
    required this.description,
    required this.details,
    required this.size,
  });
}

/// Modelo para itens mágicos
class MagicalItem {
  final MagicalItemType type;
  final String description;
  final String details;
  final String power;

  const MagicalItem({
    required this.type,
    required this.description,
    required this.details,
    required this.power,
  });
}

/// Modelo para covis
class Lair {
  final LairType type;
  final String description;
  final String details;
  final LairOccupation occupation;
  final String occupant;

  const Lair({
    required this.type,
    required this.description,
    required this.details,
    required this.occupation,
    required this.occupant,
  });
}

/// Modelo para masmorras
class Dungeon {
  final String entry;
  final int floors;
  final int rooms;
  final String guardian;
  final String description;
  final String? roomDetails;

  const Dungeon({
    required this.entry,
    required this.floors,
    required this.rooms,
    required this.guardian,
    required this.description,
    this.roomDetails,
  });
}

/// Modelo para cavernas
class Cave {
  final String entry;
  final String inhabitant;
  final String description;

  const Cave({
    required this.entry,
    required this.inhabitant,
    required this.description,
  });
}

/// Modelo para tocas
class Burrow {
  final String entry;
  final String occupant;
  final String treasure;
  final String description;

  const Burrow({
    required this.entry,
    required this.occupant,
    required this.treasure,
    required this.description,
  });
}

/// Modelo para ninhos
class Nest {
  final String owner;
  final String characteristic;
  final String description;

  const Nest({
    required this.owner,
    required this.characteristic,
    required this.description,
  });
}

/// Modelo para acampamentos
class Camp {
  final String type;
  final String special;
  final String tents;
  final String watch;
  final String defenses;
  final String description;

  const Camp({
    required this.type,
    required this.special,
    required this.tents,
    required this.watch,
    required this.defenses,
    required this.description,
  });
}

/// Modelo para tribos
class Tribe {
  final String type;
  final int members;
  final int soldiers;
  final int leaders;
  final int religious;
  final int special;
  final String description;

  const Tribe({
    required this.type,
    required this.members,
    required this.soldiers,
    required this.leaders,
    required this.religious,
    required this.special,
    required this.description,
  });
}

/// Modelo para rios, estradas e ilhas
class RiversRoadsIslands {
  final RiversRoadsIslandsType type;
  final String description;
  final String details;
  final String direction;

  const RiversRoadsIslands({
    required this.type,
    required this.description,
    required this.details,
    required this.direction,
  });
}

/// Modelo para castelos e fortes
class CastleFort {
  final CastleFortType type;
  final String description;
  final String details;
  final String size;
  final String defenses;
  final String occupants;

  const CastleFort({
    required this.type,
    required this.description,
    required this.details,
    required this.size,
    required this.defenses,
    required this.occupants,
  });
}

/// Modelo para templos e santuários
class TempleSanctuary {
  final TempleSanctuaryType type;
  final String description;
  final String details;
  final String deity;
  final String occupants;

  const TempleSanctuary({
    required this.type,
    required this.description,
    required this.details,
    required this.deity,
    required this.occupants,
  });
}

/// Modelo para perigos naturais
class NaturalDanger {
  final NaturalDangerType type;
  final String description;
  final String details;
  final String effects;

  const NaturalDanger({
    required this.type,
    required this.description,
    required this.details,
    required this.effects,
  });
}

/// Modelo para civilização
class Civilization {
  final CivilizationType type;
  final String description;
  final String details;
  final String population;
  final String government;

  const Civilization({
    required this.type,
    required this.description,
    required this.details,
    required this.population,
    required this.government,
  });
}

/// Modelo para assentamentos
class Settlement {
  final SettlementType type;
  final String description;
  final String details;

  const Settlement({
    required this.type,
    required this.description,
    required this.details,
  });
}

/// ========================================
/// MODELOS PARA GUARDIÕES (Tabela A1.1)
/// ========================================

/// Modelo para guardiões
class Guardian {
  final GuardianType type;
  final String description;
  final String details;

  const Guardian({
    required this.type,
    required this.description,
    required this.details,
  });
}

/// Modelo para armadilhas
class Trap {
  final TrapType type;
  final String description;
  final String damage;
  final String details;

  const Trap({
    required this.type,
    required this.description,
    required this.damage,
    required this.details,
  });
}

/// Modelo para gigantes
class Giant {
  final GiantType type;
  final String description;
  final String details;

  const Giant({
    required this.type,
    required this.description,
    required this.details,
  });
}

/// Modelo para mortos-vivos
class Undead {
  final UndeadType type;
  final String description;
  final String details;

  const Undead({
    required this.type,
    required this.description,
    required this.details,
  });
}

/// Modelo para outros guardiões
class OtherGuardian {
  final OtherGuardianType type;
  final String description;
  final String details;

  const OtherGuardian({
    required this.type,
    required this.description,
    required this.details,
  });
}

/// Modelo para dragões
class Dragon {
  final DragonType type;
  final String description;
  final String details;

  const Dragon({
    required this.type,
    required this.description,
    required this.details,
  });
}
