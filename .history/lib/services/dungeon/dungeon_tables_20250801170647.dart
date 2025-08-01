// lib/services/dungeon/dungeon_tables.dart
// Centralized data tables used by DungeonGenerator.
//
// Keeping the tables in a dedicated file helps to keep
// `dungeon_generator.dart` focused on the generation logic only.
// This also makes it easier to tweak or localise the text in the future
// without touching the algorithm itself.

class DungeonTables {
  DungeonTables._(); // coverage:ignore-line – static-only class

  static const List<String> col1 = [
    'Construção Perdida',
    'Construção Perdida',
    'Labirinto Artificial',
    'Labirinto Artificial',
    'Cavernas Naturais',
    'Cavernas Naturais',
    'Covil Desabitado',
    'Covil Desabitado',
    'Fortaleza Abandonada',
    'Fortaleza Abandonada',
    'Mina Desativada',
    'Mina Desativada',
  ];

  static const List<String> col2 = [
    'Desconhecido',
    'Desconhecido',
    'Cultistas',
    'Cultistas',
    'Civilização Ancestral',
    'Civilização Ancestral',
    'Anões',
    'Anões',
    'Magos',
    'Magos',
    'Gigantes',
    'Gigantes',
  ];

  static const List<String> col3 = [
    'Amaldiçoados',
    'Amaldiçoados',
    'Extintos',
    'Extintos',
    'Ancestrais',
    'Ancestrais',
    'Desaparecidos',
    'Desaparecidos',
    'Perdidos',
    'Perdidos',
    'em outro local',
    'em outro local',
  ];

  static const List<String> col4 = [
    'Defender',
    'Defender',
    'Esconder',
    'Esconder',
    'Proteger',
    'Proteger',
    'Guardar',
    'Guardar',
    'Vigiar',
    'Vigiar',
    'Isolar',
    'Isolar',
  ];

  static const List<String> col5 = [
    'artefato',
    'artefato',
    'livro',
    'livro',
    'espada',
    'espada',
    'gema',
    'gema',
    'elmo',
    'elmo',
    'tesouro',
    'tesouro',
  ];

  static const List<String> col6 = [
    'sendo procurado',
    'sendo procurado',
    'destruído',
    'destruído',
    'desaparecido',
    'desaparecido',
    'roubado',
    'roubado',
    'intacto',
    'intacto',
    'soterrado',
    'soterrado',
  ];

  static const List<String> col7 = [
    'Deserto Escaldante',
    'Deserto Escaldante',
    'Sob uma Cidade',
    'Sob uma Cidade',
    'Montanha Gelada',
    'Montanha Gelada',
    'Floresta Selvagem',
    'Floresta Selvagem',
    'Pântano Fétido',
    'Pântano Fétido',
    'Ilha Isolada',
    'Ilha Isolada',
  ];

  static const List<String> col8 = [
    'Atrás de uma Cachoeira',
    'Atrás de uma Cachoeira',
    'Túnel Secreto',
    'Túnel Secreto',
    'Pequena Gruta',
    'Pequena Gruta',
    'Fissura numa Rocha',
    'Fissura numa Rocha',
    'Covil de um Monstro',
    'Covil de um Monstro',
    'Boca de um Vulcão',
    'Boca de um Vulcão',
  ];

  static const List<String> col9 = [
    'Grande – 3d6+4',
    'Grande – 3d6+4',
    'Média – 2d6+4',
    'Média – 2d6+4',
    'Pequena – 1d6+4',
    'Pequena – 1d6+4',
    'Pequena – 1d6+6',
    'Pequena – 1d6+6',
    'Média – 2d6+6',
    'Média – 2d6+6',
    'Grande – 3d6+6',
    'Grande – 3d6+6',
  ];

  static const List<String> col10 = [
    'Trolls',
    'Trolls',
    'Orcs',
    'Orcs',
    'Esqueletos',
    'Esqueletos',
    'Goblins',
    'Goblins',
    'Bugbears',
    'Bugbears',
    'Ogros',
    'Ogros',
  ];

  static const List<String> col11 = [
    'Kobolds',
    'Kobolds',
    'Limo Cinzento',
    'Limo Cinzento',
    'Zumbis',
    'Zumbis',
    'Ratos Gigantes',
    'Ratos Gigantes',
    'Fungos Pigmeu',
    'Fungos Pigmeu',
    'Homens Lagartos',
    'Homens Lagartos',
  ];

  static const List<String> col12 = [
    'Hobgoblin',
    'Hobgoblin',
    'Cubo Gelatinoso',
    'Cubo Gelatinoso',
    'Cultista',
    'Cultista',
    'Sombra',
    'Sombra',
    'Necromante',
    'Necromante',
    'Dragão',
    'Dragão',
  ];

  static const List<String> col13 = [
    'Um/uma [coluna 11] decapitada/o',
    'Um/uma [coluna 11] decapitada/o',
    'Um camponês bêbado',
    'Um camponês bêbado',
    'Um/uma [coluna 10]',
    'Um/uma [coluna 10]',
    'Um estrangeiro muito rico',
    'Um estrangeiro muito rico',
    'Um místico cego',
    'Um místico cego',
    '[coluna 12]',
    '[coluna 12]',
  ];

  static const List<String> col14 = [
    'foi visto próximo a',
    'foi visto próximo a',
    'foi capturado na/no',
    'foi capturado na/no',
    'deixou rastros na/no',
    'deixou rastros na/no',
    'procurou o sacerdote na/no',
    'procurou o sacerdote na/no',
    'foi morto por um lobisomem na/no',
    'foi morto por um lobisomem na/no',
    'amaldiçoou a/o',
    'amaldiçoou a/o',
  ];

  static const List<String> col15 = [
    'festival religioso do outono',
    'festival religioso do outono',
    'vila no ano passado durante o eclipse',
    'vila no ano passado durante o eclipse',
    'fazenda quando uma ovelha sumiu',
    'fazenda quando uma ovelha sumiu',
    'aldeia vizinha próxima',
    'aldeia vizinha próxima',
    'caravana de comércio da primavera',
    'caravana de comércio da primavera',
    'nevasca do inverno há 3 anos',
    'nevasca do inverno há 3 anos',
  ];
}
