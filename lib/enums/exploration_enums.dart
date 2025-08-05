/// ========================================
/// ENUMS PARA SISTEMA DE EXPLORAÇÃO DOS ERMOS
/// ========================================

/// Enum para representar tipos de descoberta (Tabela 4.3)
enum DiscoveryType {
  ancestralDiscoveries('Descobertas Ancestrais'),
  lairs('Covis'),
  riversRoadsIslands('Rios, Estradas ou Ilhas'),
  castlesForts('Castelos e Fortes'),
  templesSanctuaries('Templos e Santuários'),
  naturalDangers('Perigos Naturais'),
  civilization('Civilização');

  const DiscoveryType(this.description);
  final String description;
}

/// Enum para representar tipos de coisa ancestral (Tabela 4.4)
enum AncestralThingType {
  ruins('Ruínas'),
  relics('Relíquias'),
  objects('Objetos'),
  vestiges('Vestígios'),
  ossuaries('Ossadas'),
  magicalItems('Itens Mágicos');

  const AncestralThingType(this.description);
  final String description;
}

/// Enum para representar condições de coisa ancestral
enum AncestralCondition {
  partiallyCovered('Parcialmente coberto(a)'),
  totallyCovered('Totalmente coberta'),
  overgrown('Sobre'),
  inCrevice('Dentro de uma fenda'),
  inCrater('Em uma enorme cratera'),
  inCave('Dentro de uma caverna');

  const AncestralCondition(this.description);
  final String description;
}

/// Enum para representar materiais de coisa ancestral
enum AncestralMaterial {
  ashes('Cinzas'),
  sandOrEarth('Areia ou Terra'),
  vegetation('Mato'),
  stone('Pedra'),
  vines('Vinhas'),
  webs('Teias');

  const AncestralMaterial(this.description);
  final String description;
}

/// Enum para representar estado de coisa ancestral
enum AncestralState {
  veryDeteriorated('Muito deteriorada'),
  partiallyDeteriorated('Parcialmente deteriorada'),
  ruinedAndFallen('Ruída e tombada'),
  partiallyOperational('Parcialmente operacional'),
  fullyOperational('Totalmente operacional'),
  almostUntouched('Quase intocada');

  const AncestralState(this.description);
  final String description;
}

/// Enum para representar guardiões de coisa ancestral
enum AncestralGuardian {
  none('Nenhum'),
  traps('Armadilhas'),
  giants('Gigantes'),
  undead('Mortos-Vivos'),
  others('Outros'),
  dragons('Dragões');

  const AncestralGuardian(this.description);
  final String description;
}

/// Enum para representar tipos de ruínas (Tabela 4.5)
enum RuinType {
  house('Casa'),
  village('Vila'),
  city('Cidade'),
  fort('Forte'),
  castle('Castelo'),
  temple('Templo');

  const RuinType(this.description);
  final String description;
}

/// Enum para representar tipos de relíquias (Tabela 4.6)
enum RelicType {
  tools('Ferramentas'),
  mechanisms('Mecanismos'),
  tombs('Tumbas'),
  armors('Armaduras'),
  weapons('Armas'),
  containers('Recipientes');

  const RelicType(this.description);
  final String description;
}

/// Enum para representar tipos de objetos (Tabela 4.8)
enum ObjectType {
  utensils('Utensílios'),
  clothes('Roupas'),
  furniture('Móveis'),
  toys('Brinquedos'),
  vehicles('Veículos'),
  books('Livros');

  const ObjectType(this.description);
  final String description;
}

/// Enum para representar tipos de vestígios (Tabela 4.9)
enum VestigeType {
  religious('Religioso'),
  signs('Sinais'),
  ancient('Antigos'),
  source('Fonte'),
  structure('Estrutura'),
  paths('Caminhos');

  const VestigeType(this.description);
  final String description;
}

/// Enum para representar tipos de ossadas (Tabela 4.11)
enum OssuaryType {
  small('Pequeno'),
  humanoid('Humanoide'),
  medium('Médio'),
  large('Grande'),
  colossal('Colossal'),
  special('Especial');

  const OssuaryType(this.description);
  final String description;
}

/// Enum para representar tipos de itens mágicos (Tabela 4.12)
enum MagicalItemType {
  weapons('Armas'),
  armors('Armaduras'),
  potions('Poções'),
  rings('Anéis'),
  staves('Hastes'),
  others('Outros');

  const MagicalItemType(this.description);
  final String description;
}

/// Enum para representar tipos de covis (Tabela 4.13)
enum LairType {
  dungeons('Masmorras'),
  caves('Cavernas'),
  burrows('Tocas'),
  nests('Ninhos'),
  camps('Acampamentos'),
  tribes('Tribos');

  const LairType(this.description);
  final String description;
}

/// Enum para representar ocupação de covis
enum LairOccupation {
  emptyAndAbandoned('Vazio e Abandonado: provavelmente sem encontros'),
  empty('Vazio: chance de 1 em 1d6 do ocupante retornar a cada turno'),
  halfOccupied(
    'Ocupado por Metade dos Monstros: chance de 1 em 1d6 da outra metade retornar a cada turno',
  ),
  halfOccupiedNests(
    'Ocupado por Metade dos Monstros: chance de 2 em 1d6 da outra metade retornar a cada turno',
  ),
  occupied('Ocupado');

  const LairOccupation(this.description);
  final String description;
}

/// Enum para representar tipos de rios, estradas e ilhas (Tabela 4.25)
enum RiversRoadsIslandsType {
  road('Estrada'),
  river('Rio'),
  island('Ilha');

  const RiversRoadsIslandsType(this.description);
  final String description;
}

/// Enum para representar tipos de castelos e fortes (Tabela 4.30)
enum CastleFortType {
  palisade('Paliçada'),
  tower('Torre'),
  fort('Forte'),
  castle('Castelo');

  const CastleFortType(this.description);
  final String description;
}

/// Enum para representar tipos de templos e santuários (Tabela 4.33)
enum TempleSanctuaryType {
  ziggurat('Zigurate'),
  pyramid('Pirâmide'),
  obelisk('Obelisco'),
  temple('Templo'),
  sanctuary('Santuário'),
  altar('Altar');

  const TempleSanctuaryType(this.description);
  final String description;
}

/// Enum para representar perigos naturais (Tabela 4.38)
enum NaturalDangerType {
  softSand('Areia fofa'),
  quicksand('Areia movediça'),
  suddenTide('Maré repentina'),
  mirage('Miragem'),
  tsunami('Tsunami'),
  earthquake('Terremoto'),
  avalanches('Avalanches e deslizamentos'),
  thinIce('Gelo fino'),
  softSnow('Neve fofa'),
  smoothIce('Gelo liso'),
  flooded('Alagados'),
  thornyBushes('Espinheiro'),
  thermalSprings('Fontes termais'),
  tarPit('Poço de piche'),
  sandstorm('Tempestade de areia'),
  sandPit('Fosso de areia'),
  volcanicEruptions('Erupções vulcânicas'),
  fumaroles('Fumarolas'),
  mudVolcano('Vulcão de lama'),
  altitude('Altitude');

  const NaturalDangerType(this.description);
  final String description;
}

/// Enum para representar tipos de civilização (Tabela 4.39)
enum CivilizationType {
  settlement('Assentamento'),
  village('Aldeia'),
  town('Vila'),
  city('Cidade'),
  metropolis('Metrópole');

  const CivilizationType(this.description);
  final String description;
}

/// Enum para representar tipos de assentamento (Tabela 4.40)
enum SettlementType {
  extractionMines('Minas de extração'),
  commercialOutpost('Entreposto comercial'),
  ruralProperty('Propriedade rural'),
  educationalInstitutions('Instituições de ensino'),
  tavernAndInn('Taverna e hospedaria'),
  settlement('Povoado');

  const SettlementType(this.description);
  final String description;
}

/// ========================================
/// ENUMS PARA GUARDIÕES (Tabela A1.1)
/// ========================================

/// Enum para representar tipos de guardiões
enum GuardianType {
  none('Nenhum'),
  traps('Armadilhas'),
  giants('Gigantes'),
  undead('Mortos-Vivos'),
  others('Outros'),
  dragons('Dragões');

  const GuardianType(this.description);
  final String description;
}

/// Enum para representar tipos de armadilhas
enum TrapType {
  poisonedDarts('Dardos envenenados'),
  pitWithStakes('Fosso com estacas'),
  fallingBlock('O bloco que cai'),
  hiddenGuillotine('Guilhotina oculta'),
  acidSpray('Spray ácido'),
  retractableCeiling('Teto retrátil');

  const TrapType(this.description);
  final String description;
}

/// Enum para representar tipos de gigantes
enum GiantType {
  ettin('Ettin'),
  hillGiant('Gigante da Colina'),
  mountainGiant('Gigante da Montanha'),
  stormGiant('Gigante da Tempestade'),
  fireGiant('Gigante do Fogo'),
  iceGiant('Gigante do Gelo');

  const GiantType(this.description);
  final String description;
}

/// Enum para representar tipos de mortos-vivos
enum UndeadType {
  specter('Espectro'),
  ghost('Fantasma'),
  banshee('Banshee'),
  mummy('Múmia'),
  vampire('Vampiro'),
  lich('Lich');

  const UndeadType(this.description);
  final String description;
}

/// Enum para representar tipos de outros guardiões
enum OtherGuardianType {
  cerberus('Cérbero'),
  sphinx('Esfinge'),
  efreeti('Efreeti'),
  ironGolem('Golem de Ferro'),
  blackPudding('Pudim Negro'),
  shoggoth('Shoggoth');

  const OtherGuardianType(this.description);
  final String description;
}

/// Enum para representar tipos de dragões
enum DragonType {
  blueDragon('Dragão Azul'),
  whiteDragon('Dragão Branco'),
  goldDragon('Dragão Dourado'),
  blackDragon('Dragão Negro'),
  greenDragon('Dragão Verde'),
  redDragon('Dragão Vermelho');

  const DragonType(this.description);
  final String description;
}
