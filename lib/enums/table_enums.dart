// enums/table_enums.dart

/// ========================================
/// ENUMS PARA TABELA 9.1 - GERAÇÃO DE MASMORRAS
/// ========================================

/// Enum para representar os tipos de masmorra (Coluna 1 - Tabela 9.1)
enum DungeonType {
  lostConstruction('Construção Perdida'),
  artificialLabyrinth('Labirinto Artificial'),
  naturalCaves('Cavernas Naturais'),
  abandonedLair('Covil Desabitado'),
  abandonedFortress('Fortaleza Abandonada'),
  deactivatedMine('Mina Desativada');

  const DungeonType(this.description);
  final String description;
}

/// Enum para representar os construtores/habitantes (Coluna 2 - Tabela 9.1)
enum DungeonBuilder {
  unknown('Desconhecido'),
  cultists('Cultistas'),
  ancestralCivilization('Civilização Ancestral'),
  dwarves('Anões'),
  mages('Magos'),
  giants('Gigantes');

  const DungeonBuilder(this.description);
  final String description;
}

/// Enum para representar o status da masmorra (Coluna 3 - Tabela 9.1)
enum DungeonStatus {
  cursed('Amaldiçoados'),
  extinct('Extintos'),
  ancestral('Ancestrais'),
  disappeared('Desaparecidos'),
  lost('Perdidos'),
  inAnotherLocation('em outro local');

  const DungeonStatus(this.description);
  final String description;
}

/// Enum para representar o objetivo da construção (Coluna 4 - Tabela 9.1)
enum DungeonObjective {
  defend('Defender'),
  hide('Esconder'),
  protect('Proteger'),
  guard('Guardar'),
  watch('Vigiar'),
  isolate('Isolar');

  const DungeonObjective(this.description);
  final String description;
}

/// Enum para representar o que está sendo protegido (Coluna 5 - Tabela 9.1)
enum DungeonTarget {
  artifact('artefato'),
  book('livro'),
  sword('espada'),
  gem('gema'),
  helmet('elmo'),
  treasure('tesouro');

  const DungeonTarget(this.description);
  final String description;
}

/// Enum para representar o estado do alvo (Coluna 6 - Tabela 9.1)
enum DungeonTargetStatus {
  beingSought('sendo procurado'),
  destroyed('destruído'),
  disappeared('desaparecido'),
  stolen('roubado'),
  intact('intacto'),
  buried('soterrado');

  const DungeonTargetStatus(this.description);
  final String description;
}

/// Enum para representar a localização (Coluna 7 - Tabela 9.1)
enum DungeonLocation {
  scorchingDesert('Deserto Escaldante'),
  underCity('Sob uma Cidade'),
  frozenMountain('Montanha Gelada'),
  wildForest('Floresta Selvagem'),
  fetidSwamp('Pântano Fétido'),
  isolatedIsland('Ilha Isolada');

  const DungeonLocation(this.description);
  final String description;
}

/// Enum para representar a entrada da masmorra (Coluna 8 - Tabela 9.1)
enum DungeonEntry {
  behindWaterfall('Atrás de uma Cachoeira'),
  secretTunnel('Túnel Secreto'),
  smallCave('Pequena Gruta'),
  rockFissure('Fissura numa Rocha'),
  monsterLair('Covil de um Monstro'),
  volcanoMouth('Boca de um Vulcão');

  const DungeonEntry(this.description);
  final String description;
}

/// Enum para representar o tamanho da masmorra (Coluna 9 - Tabela 9.1)
enum DungeonSize {
  small('Pequena'),
  medium('Média'),
  large('Grande');

  const DungeonSize(this.description);
  final String description;
}

/// Enum para representar os ocupantes (Colunas 10-12 - Tabela 9.1)
enum DungeonOccupant {
  trolls('Trolls'),
  orcs('Orcs'),
  skeletons('Esqueletos'),
  goblins('Goblins'),
  bugbears('Bugbears'),
  ogres('Ogros'),
  kobolds('Kobolds'),
  grayOoze('Limo Cinzento'),
  zombies('Zumbis'),
  giantRats('Ratos Gigantes'),
  pygmyFungi('Fungos Pigmeu'),
  lizardMen('Homens Lagartos'),
  hobgoblin('Hobgoblin'),
  gelatinousCube('Cubo Gelatinoso'),
  cultist('Cultista'),
  shadow('Sombra'),
  necromancer('Necromante'),
  dragon('Dragão');

  const DungeonOccupant(this.description);
  final String description;
}

/// Enum para representar os tipos de rumor (Colunas 13-15 - Tabela 9.1)
enum RumorSubject {
  decapitatedOccupant('Um/uma [coluna 11] decapitada/o'),
  drunkPeasant('Um camponês bêbado'),
  primaryOccupant('Um/uma [coluna 10]'),
  richForeigner('Um estrangeiro muito rico'),
  blindMystic('Um místico cego'),
  leader('[coluna 12]');

  const RumorSubject(this.description);
  final String description;
}

enum RumorAction {
  seenNear('foi visto próximo a'),
  capturedIn('foi capturado na/no'),
  leftTrailsIn('deixou rastros na/no'),
  soughtPriestIn('procurou o sacerdote na/no'),
  killedByWerewolfIn('foi morto por um lobisomem na/no'),
  cursed('amaldiçoou a/o');

  const RumorAction(this.description);
  final String description;
}

enum RumorLocation {
  autumnReligiousFestival('festival religioso do outono'),
  villageLastYearDuringEclipse('vila no ano passado durante o eclipse'),
  farmWhenSheepDisappeared('fazenda quando uma ovelha sumiu'),
  nearbyVillage('aldeia vizinha próxima'),
  springTradeCaravan('caravana de comércio da primavera'),
  winterBlizzard3YearsAgo('nevasca do inverno há 3 anos');

  const RumorLocation(this.description);
  final String description;
}

/// ========================================
/// ENUMS PARA TABELA 9.2 - SALAS E CÂMARAS
/// ========================================

/// Enum para representar os tipos de sala (Coluna 1 - Tabela 9.2)
enum RoomType {
  specialRoom('Sala Especial'),
  trap('Armadilha'),
  commonRoom('Sala Comum'),
  monster('Encontro'),
  specialTrap('Sala Armadilha Especial');

  const RoomType(this.description);
  final String description;
}

/// Enum para representar as correntes de ar (Coluna 2 - Tabela 9.2)
enum AirCurrent {
  hotDraft('corrente de ar quente'),
  lightHotBreeze('leve brisa quente'),
  noAirCurrent('sem corrente de ar'),
  lightColdBreeze('leve brisa fria'),
  coldDraft('corrente de ar fria'),
  strongIcyWind('vento forte e gelado');

  const AirCurrent(this.description);
  final String description;
}

/// Enum para representar os odores (Coluna 3 - Tabela 9.2)
enum Smell {
  rottenMeat('cheiro de carne podre'),
  humidityMold('cheiro de umidade e mofo'),
  noSpecialSmell('sem cheiro especial'),
  earthSmell('cheiro de terra'),
  smokeSmell('cheiro de fumaça'),
  fecesUrine('cheiro de fezes e urina');

  const Smell(this.description);
  final String description;
}

/// Enum para representar os sons (Coluna 4 - Tabela 9.2)
enum Sound {
  metallicScratch('arranhado metálico'),
  rhythmicDrip('gotejar ritmado'),
  noSpecialSound('nenhum som especial'),
  windBlowing('vento soprando'),
  distantFootsteps('passos ao longe'),
  whispersMoans('sussurros e gemidos');

  const Sound(this.description);
  final String description;
}

/// Enum para representar os itens encontrados (Coluna 5 - Tabela 9.2)
enum FoundItem {
  completelyEmpty('completamente vazia'),
  dustDirtWebs('poeira, sujeira e teias'),
  oldFurniture('móveis velhos'),
  specialItems('itens encontrados especial…'),
  foodRemainsGarbage('restos de comida e lixo'),
  dirtyFetidClothes('roupas sujas e fétidas');

  const FoundItem(this.description);
  final String description;
}

/// Enum para representar itens especiais (Coluna 6 - Tabela 9.2)
enum SpecialItem {
  monsterCarcasses('carcaças de monstros'),
  oldTornPapers('papéis velhos e rasgados'),
  piledBones('ossadas empilhadas'),
  dirtyFabricRemains('restos de tecidos sujos'),
  emptyBoxesBagsChests('caixas, sacos e baús vazios'),
  fullBoxesBagsChests('caixas, sacos e baús cheios');

  const SpecialItem(this.description);
  final String description;
}

/// Enum para representar salas comuns (Coluna 7 - Tabela 9.2)
enum CommonRoom {
  dormitory('dormitório'),
  generalDeposit('depósito geral'),
  special('Especial…'),
  completelyEmpty('completamente vazia'),
  foodPantry('despensa de comida'),
  prisonCell('cela de prisão');

  const CommonRoom(this.description);
  final String description;
}

/// Enum para representar salas especiais (Coluna 8 - Tabela 9.2)
enum SpecialRoom {
  trainingRoom('sala de treinamento'),
  diningRoom('refeitório'),
  completelyEmpty('completamente vazia'),
  special2('Especial 2…'),
  religiousAltar('altar religioso'),
  abandonedDen('covil abandonado');

  const SpecialRoom(this.description);
  final String description;
}

/// Enum para representar salas especiais 2 (Coluna 9 - Tabela 9.2)
enum SpecialRoom2 {
  tortureChamber('câmara de tortura'),
  ritualChamber('câmara de rituais'),
  magicalLaboratory('laboratório mágico'),
  library('biblioteca'),
  crypt('cripta'),
  arsenal('arsenal');

  const SpecialRoom2(this.description);
  final String description;
}

/// Enum para representar monstros (Coluna 10 - Tabela 9.2)
enum Monster {
  newMonsterPlusOccupantI('Novo Monstro + Ocupante I'),
  occupantIPlusOccupantII('Ocupante I + Ocupante II'),
  occupantI('Ocupante I'),
  occupantII('Ocupante II'),
  newMonster('Novo Monstro'),
  newMonsterPlusOccupantII('Novo Monstro + Ocupante II');

  const Monster(this.description);
  final String description;
}

/// Enum para representar armadilhas (Coluna 11 - Tabela 9.2)
enum Trap {
  hiddenGuillotine('Guilhotina Oculta'),
  pit('Fosso'),
  poisonedDarts('Dardos Envenenados'),
  specialTrap('Armadilha Especial…'),
  fallingBlock('Bloco que Cai'),
  acidSpray('Spray Ácido');

  const Trap(this.description);
  final String description;
}

/// Enum para representar armadilhas especiais (Coluna 12 - Tabela 9.2)
enum SpecialTrap {
  waterWell('Poço de Água'),
  collapse('Desmoronamento'),
  retractableCeiling('Teto Retrátil'),
  secretDoor('Porta Secreta'),
  alarm('Alarme'),
  dimensionalPortal('Portal Dimensional');

  const SpecialTrap(this.description);
  final String description;
}

/// Enum para representar tesouros (Coluna 13 - Tabela 9.2)
enum Treasure {
  noTreasure('Nenhum Tesouro'),
  copperSilver('1d6 x 100 PP + 1d6 x 10 PO'),
  silverGems('1d6 x 10 PO + 1d4 Gemas'),
  specialTreasure('Tesouro Especial…'),
  magicItem('Item Mágico');

  const Treasure(this.description);
  final String description;
}

/// Enum para representar tesouros especiais (Coluna 14 - Tabela 9.2)
enum SpecialTreasure {
  rollAgainPlusMagicItem('Jogue Novamente + Item Mágico'),
  copperSilverGems('1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas'),
  copperSilverGems2('1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas'),
  copperSilverGemsValuable(
      '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor'),
  copperSilverGemsMagicItem(
      '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico'),
  rollAgainPlusMagicItem2('Jogue Novamente + Item Mágico 2');

  const SpecialTreasure(this.description);
  final String description;
}

/// Enum para representar itens mágicos (Coluna 15 - Tabela 9.2)
enum MagicItem {
  any1('1 Qualquer'),
  any1NotWeapon('1 Qualquer não Arma'),
  potion1('1 Poção'),
  scroll1('1 Pergaminho'),
  weapon1('1 Arma'),
  any2('2 Qualquer');

  const MagicItem(this.description);
  final String description;
}
