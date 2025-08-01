// enums/dungeon_tables.dart

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
