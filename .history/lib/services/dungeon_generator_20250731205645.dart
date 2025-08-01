// services/dungeon_generator.dart

import 'dart:math';

import '../utils/dice_roller.dart';
import '../models/dungeon.dart';
import '../models/room.dart';
import '../utils/treasure_resolver.dart';

/// Implements the business rules from Livro I – Capítulo "Mestrando em Masmorras".
///
/// Usage:
///   final generator = DungeonGenerator();
///   final dungeon = generator.generate(level: 3, theme: "Recuperar artefato");
class DungeonGenerator {
  /// Generates a [Dungeon] according to the rules.
  Dungeon generate({
    required int level,
    required String theme,
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  }) {
    // Step 1: Super Table (Tabela 9-1) – roll 2d6 for each column.
    final col1 = _col1[DiceRoller.roll(2, 6) - 2];
    final col2 = _col2[DiceRoller.roll(2, 6) - 2];
    final col3 = _col3[DiceRoller.roll(2, 6) - 2];
    final col4 = _col4[DiceRoller.roll(2, 6) - 2];
    final col5 = _col5[DiceRoller.roll(2, 6) - 2];
    final col6 = _col6[DiceRoller.roll(2, 6) - 2];

    final col7 = _col7[DiceRoller.roll(2, 6) - 2];
    final col8 = _col8[DiceRoller.roll(2, 6) - 2];
    final col9Raw = _col9[DiceRoller.roll(2, 6) - 2];

    final col10 = _col10[DiceRoller.roll(2, 6) - 2];
    final col11 = _col11[DiceRoller.roll(2, 6) - 2];
    final col12 = _col12[DiceRoller.roll(2, 6) - 2];

    final col13 = _col13[DiceRoller.roll(2, 6) - 2];
    final col14 = _col14[DiceRoller.roll(2, 6) - 2];
    final col15 = _col15[DiceRoller.roll(2, 6) - 2];

    // Determine rooms count via dice formula contained inside col9Raw, e.g. "Grande – 3d6+4" → parse after dash.
    var roomsCount = customRoomCount ?? _extractRoomsCount(col9Raw);

    // Ajuste baseado em min/max
    if (customRoomCount == null && minRooms != null && maxRooms != null) {
      // Gera valor aleatório dentro do intervalo
      final low = min(minRooms, maxRooms);
      final high = max(minRooms, maxRooms);
      roomsCount = low + DiceRoller.roll(1, high - low + 1) - 1;
    } else {
      // Caso apenas um dos filtros exista aplica como clamp
      if (minRooms != null && roomsCount < minRooms) roomsCount = minRooms;
      if (maxRooms != null && roomsCount > maxRooms) roomsCount = maxRooms;
    }

    // Build rooms using Tabela 9-2.
    final rooms = <Room>[];
    for (int i = 1; i <= roomsCount; i++) {
      rooms.add(_generateRoom(i, level));
    }

    return Dungeon(
      type: col1,
      builderOrInhabitant: col2,
      status: col3,
      objective: '$col4 $col5 $col6',
      location: col7,
      entry: col8,
      roomsCount: roomsCount,
      occupant1: col10,
      occupant2: col11,
      leader: col12,
      rumor1: _buildRumor(col13, col14, col15, col11, col10, col12),
      rooms: rooms,
    );
  }

  //////////////// PRIVATE ////////////////

  Room _generateRoom(int index, int level) {
    final type = _roomCol1[DiceRoller.roll(2, 6) - 2];
    final air = _roomCol2[DiceRoller.roll(2, 6) - 2];
    final smell = _roomCol3[DiceRoller.roll(2, 6) - 2];
    final sound = _roomCol4[DiceRoller.roll(2, 6) - 2];
    final item = _roomCol5[DiceRoller.roll(2, 6) - 2];
    final specialItem = _roomCol6[DiceRoller.roll(2, 6) - 2];
    final roomCommon = _roomCol7[DiceRoller.roll(2, 6) - 2];
    final roomSpecial = _roomCol8[DiceRoller.roll(2, 6) - 2];
    final roomSpecial2 = _roomCol9[DiceRoller.roll(2, 6) - 2];
    final monster = _roomCol10[DiceRoller.roll(2, 6) - 2];
    final trap = _roomCol11[DiceRoller.roll(2, 6) - 2];
    final specialTrap = _roomCol12[DiceRoller.roll(2, 6) - 2];
    var treasure = _roomCol13[DiceRoller.roll(2, 6) - 2];
    var specialTreasure = _roomCol14[DiceRoller.roll(2, 6) - 2];
    var magicItem = _roomCol15[DiceRoller.roll(2, 6) - 2];

    // Resolve treasure values
    treasure = TreasureResolver.resolve(treasure);
    specialTreasure = TreasureResolver.resolve(specialTreasure);

    // TODO: Adjust monster and treasure according to [level].

    return Room(
      index: index,
      type: type,
      air: air,
      smell: smell,
      sound: sound,
      item: item,
      specialItem: specialItem,
      monster: monster,
      trap: trap,
      specialTrap: specialTrap,
      roomCommon: roomCommon,
      roomSpecial: roomSpecial,
      roomSpecial2: roomSpecial2,
      treasure: treasure,
      specialTreasure: specialTreasure,
      magicItem: magicItem,
    );
  }

  int _extractRoomsCount(String raw) {
    // Expected format: "Grande – 3d6+6" etc. We'll take formula part after dash.
    final parts = raw.split('–');
    if (parts.length < 2) return 5; // Fallback mínimo
    final formula = parts[1].trim();
    final count = DiceRoller.rollFormula(formula);
    // Garante pelo menos 3 salas
    return count < 3 ? 5 : count;
  }

  String _buildRumor(String col13, String col14, String col15, 
      String col11, String col10, String col12) {
    // Constrói o rumor completo juntando as 3 partes
    String rumor = '$col13 $col14 $col15';
    
    // Substitui as referências pelas colunas corretas
    return rumor
        .replaceAll('[coluna 11]', col11)
        .replaceAll('[coluna 10]', col10)
        .replaceAll('[coluna 12]', col12);
  }

  //// Tabela 9-1 data ////
  static const _col1 = [
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

  static const _col2 = [
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

  static const _col3 = [
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

  static const _col4 = [
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

  static const _col5 = [
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

  static const _col6 = [
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

  static const _col7 = [
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

  static const _col8 = [
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

  static const _col9 = [
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

  static const _col10 = [
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

  static const _col11 = [
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

  static const _col12 = [
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

  static const _col13 = [
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

  static const _col14 = [
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

  static const _col15 = [
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

  //// Tabela 9-2 data (room generation) ////

  static const _roomCol1 = [
    'Sala Especial',
    'Sala Especial',
    'Armadilha',
    'Armadilha',
    'Sala Comum',
    'Sala Comum',
    'Monstro',
    'Monstro',
    'Sala Comum',
    'Sala Comum',
    'Sala Armadilha Especial',
    'Sala Armadilha Especial',
  ];

  static const _roomCol2 = [
    'Corrente de ar quente',
    'Corrente de ar quente',
    'Leve brisa quente',
    'Leve brisa quente',
    'Sem corrente de ar',
    'Sem corrente de ar',
    'Leve brisa fria',
    'Leve brisa fria',
    'Corrente de ar fria',
    'Corrente de ar fria',
    'Vento forte e gelado',
    'Vento forte e gelado',
  ];

  static const _roomCol3 = [
    'Cheiro de carne podre',
    'Cheiro de carne podre',
    'Cheiro de umidade e mofo',
    'Cheiro de umidade e mofo',
    'Sem cheiro especial',
    'Sem cheiro especial',
    'Cheiro de terra',
    'Cheiro de terra',
    'Cheiro de fumaça',
    'Cheiro de fumaça',
    'Cheiro de fezes e urina',
    'Cheiro de fezes e urina',
  ];

  static const _roomCol4 = [
    'Arranhado metálico',
    'Arranhado metálico',
    'Gotejar ritmado',
    'Gotejar ritmado',
    'Nenhum som especial',
    'Nenhum som especial',
    'Vento soprando',
    'Vento soprando',
    'Passos ao longe',
    'Passos ao longe',
    'Sussurros e gemidos',
    'Sussurros e gemidos',
  ];

  static const _roomCol5 = [
    'Completamente vazia',
    'Completamente vazia',
    'Poeira, sujeira e teias',
    'Poeira, sujeira e teias',
    'Móveis velhos',
    'Móveis velhos',
    'Itens encontrados especiais…',
    'Itens encontrados especiais…',
    'Restos de comida e lixo',
    'Restos de comida e lixo',
    'Roupas sujas e fétidas',
    'Roupas sujas e fétidas',
  ];

  static const _roomCol6 = [
    'Carcaças de monstros',
    'Carcaças de monstros',
    'Papéis velhos e rasgados',
    'Papéis velhos e rasgados',
    'Ossadas empilhadas',
    'Ossadas empilhadas',
    'Restos de tecidos sujos',
    'Restos de tecidos sujos',
    'Caixas, sacos e baús vazios',
    'Caixas, sacos e baús vazios',
    'Caixas, sacos e baús cheios',
    'Caixas, sacos e baús cheios',
  ];

  static const _roomCol7 = [
    'Dormitório',
    'Dormitório',
    'Depósito geral',
    'Depósito geral',
    'Especial… completamente vazia',
    'Especial… completamente vazia',
    'Completamente vazia',
    'Completamente vazia',
    'Despensa de comida',
    'Despensa de comida',
    'Cela de prisão',
    'Cela de prisão',
  ];

  static const _roomCol8 = [
    'Sala de treinamento',
    'Sala de treinamento',
    'Refeitório',
    'Refeitório',
    'Laboratório mágico',
    'Laboratório mágico',
    'Biblioteca',
    'Biblioteca',
    'Altar religioso',
    'Altar religioso',
    'Covil abandonado',
    'Covil abandonado',
  ];

  static const _roomCol9 = [
    'Câmara de tortura',
    'Câmara de tortura',
    'Câmara de rituais',
    'Câmara de rituais',
    'Biblioteca',
    'Biblioteca',
    'Especial 2…',
    'Especial 2…',
    'Cripta',
    'Cripta',
    'Arsenal',
    'Arsenal',
  ];

  static const _roomCol10 = [
    'Novo Monstro + Ocupante I',
    'Novo Monstro + Ocupante I',
    'Ocupante I + Ocupante II',
    'Ocupante I + Ocupante II',
    'Ocupante I',
    'Ocupante I',
    'Ocupante II',
    'Ocupante II',
    'Novo Monstro',
    'Novo Monstro',
    'Novo Monstro + Ocupante II',
    'Novo Monstro + Ocupante II',
  ];

  static const _roomCol11 = [
    'Guilhotina Oculta',
    'Guilhotina Oculta',
    'Fosso',
    'Fosso',
    'Dardos Envenenados',
    'Dardos Envenenados',
    'Armadilha Especial…',
    'Armadilha Especial…',
    'Bloco que Cai',
    'Bloco que Cai',
    'Spray Ácido',
    'Spray Ácido',
  ];

  static const _roomCol12 = [
    'Poço de Água',
    'Poço de Água',
    'Desmoronamento',
    'Desmoronamento',
    'Teto Retrátil',
    'Teto Retrátil',
    'Porta Secreta',
    'Porta Secreta',
    'Alarme',
    'Alarme',
    'Portal Dimensional',
    'Portal Dimensional',
  ];

  static const _roomCol13 = [
    'Nenhum Tesouro',
    'Nenhum Tesouro',
    'Nenhum Tesouro',
    'Nenhum Tesouro',
    '1d6 x 100 PP + 1d6 x 10 PO',
    '1d6 x 100 PP + 1d6 x 10 PO',
    '1d6 x 10 PO + 1d4 Gemas',
    '1d6 x 10 PO + 1d4 Gemas',
    'Tesouro Especial…',
    'Tesouro Especial…',
    'Item Mágico',
    'Item Mágico',
  ];

  static const _roomCol14 = [
    'Jogue Novamente + Item Mágico',
    'Jogue Novamente + Item Mágico',
    '1 Qualquer não Arma',
    '1 Qualquer não Arma',
    '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    'Jogue Novamente + Item Mágico 2',
    'Jogue Novamente + Item Mágico 2',
  ];

  static const _roomCol15 = [
    '1 Qualquer',
    '1 Qualquer',
    '1 Qualquer não Arma',
    '1 Qualquer não Arma',
    '1 Poção',
    '1 Poção',
    '1 Pergaminho',
    '1 Pergaminho',
    '1 Arma',
    '1 Arma',
    '2 Qualquer',
    '2 Qualquer',
  ];
}
