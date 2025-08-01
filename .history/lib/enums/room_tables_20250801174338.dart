// enums/room_tables.dart

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
  windBlowing('vento soprando'),
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
  copperSilverGemsValuable('1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor'),
  copperSilverGemsMagicItem('1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico'),
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