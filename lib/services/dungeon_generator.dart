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
      rooms.add(_generateRoom(i, level, occupantI: col10, occupantII: col11));
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

  Room _generateRoom(int index, int level,
      {String? occupantI, String? occupantII}) {
    // Rola 2d6 para cada coluna da tabela 9.2
    final col1Roll = DiceRoller.roll(2, 6);
    final col2Roll = DiceRoller.roll(2, 6);
    final col3Roll = DiceRoller.roll(2, 6);
    final col4Roll = DiceRoller.roll(2, 6);
    final col5Roll = DiceRoller.roll(2, 6);
    final col6Roll = DiceRoller.roll(2, 6);
    final col7Roll = DiceRoller.roll(2, 6);
    final col8Roll = DiceRoller.roll(2, 6);
    final col9Roll = DiceRoller.roll(2, 6);
    final col10Roll = DiceRoller.roll(2, 6);
    final col11Roll = DiceRoller.roll(2, 6);
    final col12Roll = DiceRoller.roll(2, 6);
    final col13Roll = DiceRoller.roll(2, 6);
    final col14Roll = DiceRoller.roll(2, 6);
    final col15Roll = DiceRoller.roll(2, 6);

    // Determina o tipo de sala baseado na coluna 1
    String type;
    if (col1Roll <= 3) {
      type = 'Sala Especial (coluna 8)';
    } else if (col1Roll <= 5) {
      type = 'Armadilha (coluna 11)';
    } else if (col1Roll <= 7) {
      type = 'Sala Comum (coluna 7)';
    } else if (col1Roll <= 9) {
      type = 'Monstro (coluna 10)';
    } else if (col1Roll <= 11) {
      type = 'Sala Comum (coluna 7)';
    } else {
      type = 'Sala Armadilha Especial (coluna 12)';
    }

    // Determina corrente de ar (coluna 2)
    String air;
    if (col2Roll <= 3) {
      air = 'corrente de ar quente';
    } else if (col2Roll <= 5) {
      air = 'leve brisa quente';
    } else if (col2Roll <= 7) {
      air = 'sem corrente de ar';
    } else if (col2Roll <= 9) {
      air = 'leve brisa fria';
    } else if (col2Roll <= 11) {
      air = 'corrente de ar fria';
    } else {
      air = 'vento forte e gelado';
    }

    // Determina cheiro (coluna 3)
    String smell;
    if (col3Roll <= 3) {
      smell = 'cheiro de carne podre';
    } else if (col3Roll <= 5) {
      smell = 'cheiro de umidade e mofo';
    } else if (col3Roll <= 7) {
      smell = 'sem cheiro especial';
    } else if (col3Roll <= 9) {
      smell = 'cheiro de terra';
    } else if (col3Roll <= 11) {
      smell = 'cheiro de fumaça';
    } else {
      smell = 'cheiro de fezes e urina';
    }

    // Determina som (coluna 4)
    String sound;
    if (col4Roll <= 3) {
      sound = 'arranhado metálico';
    } else if (col4Roll <= 5) {
      sound = 'gotejar ritmado';
    } else if (col4Roll <= 7) {
      sound = 'nenhum som especial';
    } else if (col4Roll <= 9) {
      sound = 'vento soprando';
    } else if (col4Roll <= 11) {
      sound = 'passos ao longe';
    } else {
      sound = 'sussurros e gemidos';
    }

    // Determina itens encontrados (coluna 5)
    String item;
    if (col5Roll <= 3) {
      item = 'completamente vazia';
    } else if (col5Roll <= 5) {
      item = 'poeira, sujeira e teias';
    } else if (col5Roll <= 7) {
      item = 'móveis velhos';
    } else if (col5Roll <= 9) {
      item = 'vento soprando';
    } else if (col5Roll <= 11) {
      item = 'restos de comida e lixo';
    } else {
      item = 'roupas sujas e fétidas';
    }

    // Determina item especial (coluna 6) - só se coluna 5 indicar
    String specialItem = '';
    if (col5Roll == 9) {
      // "itens encontrados especial..."
      if (col6Roll <= 3) {
        specialItem = 'carcaças de monstros';
      } else if (col6Roll <= 5) {
        specialItem = 'papéis velhos e rasgados';
      } else if (col6Roll <= 7) {
        specialItem = 'ossadas empilhadas';
      } else if (col6Roll <= 9) {
        specialItem = 'restos de tecidos sujos';
      } else if (col6Roll <= 11) {
        specialItem = 'caixas, sacos e baús vazios';
      } else {
        specialItem = 'caixas, sacos e baús cheios';
      }
    }

    // Determina sala comum (coluna 7) - só se tipo indicar
    String roomCommon = '';
    if (type.contains('Sala Comum')) {
      if (col7Roll <= 3) {
        roomCommon = 'dormitório';
      } else if (col7Roll <= 5) {
        roomCommon = 'depósito geral';
      } else if (col7Roll <= 7) {
        roomCommon = 'Especial…';
      } else if (col7Roll <= 9) {
        roomCommon = 'completamente vazia';
      } else if (col7Roll <= 11) {
        roomCommon = 'despensa de comida';
      } else {
        roomCommon = 'cela de prisão';
      }
    }

    // Determina sala especial (coluna 8) - só se tipo indicar
    String roomSpecial = '';
    if (type.contains('Sala Especial')) {
      if (col8Roll <= 3) {
        roomSpecial = 'sala de treinamento';
      } else if (col8Roll <= 5) {
        roomSpecial = 'refeitório';
      } else if (col8Roll <= 7) {
        roomSpecial = 'completamente vazia';
      } else if (col8Roll <= 9) {
        roomSpecial = 'Especial 2…';
      } else if (col8Roll <= 11) {
        roomSpecial = 'altar religioso';
      } else {
        roomSpecial = 'covil abandonado';
      }
    }

    // Determina sala especial 2 (coluna 9) - só se coluna 8 indicar
    String roomSpecial2 = '';
    if (roomSpecial == 'Especial 2…') {
      if (col9Roll <= 3) {
        roomSpecial2 = 'câmara de tortura';
      } else if (col9Roll <= 5) {
        roomSpecial2 = 'câmara de rituais';
      } else if (col9Roll <= 7) {
        roomSpecial2 = 'laboratório mágico';
      } else if (col9Roll <= 9) {
        roomSpecial2 = 'biblioteca';
      } else if (col9Roll <= 11) {
        roomSpecial2 = 'cripta';
      } else {
        roomSpecial2 = 'arsenal';
      }
    }

    // Determina monstros (coluna 10) - só se tipo indicar
    String monster1 = '';
    String monster2 = '';
    if (type.contains('Monstro')) {
      String monsterResult;
      if (col10Roll <= 3) {
        monsterResult = 'Novo Monstro + Ocupante I';
      } else if (col10Roll <= 5) {
        monsterResult = 'Ocupante I + Ocupante II';
      } else if (col10Roll <= 7) {
        monsterResult = 'Ocupante I';
      } else if (col10Roll <= 9) {
        monsterResult = 'Ocupante II';
      } else if (col10Roll <= 11) {
        monsterResult = 'Novo Monstro';
      } else {
        monsterResult = 'Novo Monstro + Ocupante II';
      }

      // Substitui ocupantes pelos valores reais da masmorra
      if (occupantII != null) {
        monsterResult = monsterResult.replaceAll('Ocupante II', occupantII);
      }
      if (occupantI != null) {
        monsterResult = monsterResult.replaceAll('Ocupante I', occupantI);
      }

      // Separa os monstros
      if (monsterResult.contains(' + ')) {
        final parts = monsterResult.split(' + ');
        if (parts.length >= 2) {
          monster1 = parts[0].trim();
          monster2 = parts[1].trim();
        } else {
          monster1 = monsterResult;
          monster2 = '';
        }
      } else {
        monster1 = monsterResult;
        monster2 = '';
      }
    }

    // Determina armadilha (coluna 11) - só se tipo indicar
    String trap = '';
    if (type.contains('Armadilha')) {
      if (col11Roll <= 3) {
        trap = 'Guilhotina Oculta';
      } else if (col11Roll <= 5) {
        trap = 'Fosso';
      } else if (col11Roll <= 7) {
        trap = 'Dardos Envenenados';
      } else if (col11Roll <= 9) {
        trap = 'Armadilha Especial…';
      } else if (col11Roll <= 11) {
        trap = 'Bloco que Cai';
      } else {
        trap = 'Spray Ácido';
      }
    }

    // Determina armadilha especial (coluna 12) - só se coluna 11 indicar
    String specialTrap = '';
    if (trap == 'Armadilha Especial…') {
      if (col12Roll <= 3) {
        specialTrap = 'Poço de Água';
      } else if (col12Roll <= 5) {
        specialTrap = 'Desmoronamento';
      } else if (col12Roll <= 7) {
        specialTrap = 'Teto Retrátil';
      } else if (col12Roll <= 9) {
        specialTrap = 'Porta Secreta';
      } else if (col12Roll <= 11) {
        specialTrap = 'Alarme';
      } else {
        specialTrap = 'Portal Dimensional';
      }
    }

    // Determina tesouro (coluna 13)
    String treasure = '';
    String specialTreasure = '';
    String magicItem = '';

    if (col13Roll <= 3) {
      treasure = 'Nenhum';
    } else if (col13Roll <= 5) {
      treasure = 'Nenhum';
    } else if (col13Roll <= 7) {
      treasure = '1d6 x 100 PP + 1d6 x 10 PO';
    } else if (col13Roll <= 9) {
      treasure = '1d6 x 10 PO + 1d4 Gemas';
    } else if (col13Roll <= 11) {
      treasure = 'Tesouro Especial…';
      // Rola na coluna 14 para tesouro especial
      if (col14Roll <= 2) {
        specialTreasure = 'Jogue Novamente + Item Mágico';
      } else if (col14Roll <= 4) {
        specialTreasure = '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas';
      } else if (col14Roll <= 6) {
        specialTreasure = '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas';
      } else if (col14Roll <= 8) {
        specialTreasure =
            '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor';
      } else if (col14Roll <= 10) {
        specialTreasure =
            '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico';
      } else {
        specialTreasure = 'Jogue Novamente + Item Mágico 2';
      }
    } else {
      treasure = 'Item Mágico';
    }

    // Determina item mágico (coluna 15) - só se necessário
    if (treasure == 'Item Mágico' || specialTreasure.contains('Item Mágico')) {
      if (col15Roll <= 3) {
        magicItem = '1 Qualquer';
      } else if (col15Roll <= 5) {
        magicItem = '1 Qualquer não Arma';
      } else if (col15Roll <= 7) {
        magicItem = '1 Poção';
      } else if (col15Roll <= 9) {
        magicItem = '1 Pergaminho';
      } else if (col15Roll <= 11) {
        magicItem = '1 Arma';
      } else {
        magicItem = '2 Qualquer';
      }
    }

    // Resolve treasure values only if they contain dice formulas
    if (treasure.contains('d') || treasure.contains('Jogue Novamente')) {
      treasure = TreasureResolver.resolve(treasure);
    }
    if (specialTreasure.contains('d') ||
        specialTreasure.contains('Jogue Novamente')) {
      specialTreasure = TreasureResolver.resolve(specialTreasure);
    }

    // Resolve magic item if present
    if (magicItem.isNotEmpty) {
      magicItem = TreasureResolver.resolve(magicItem);
    }

    return Room(
      index: index,
      type: type,
      air: air,
      smell: smell,
      sound: sound,
      item: item,
      specialItem: specialItem,
      monster1: monster1,
      monster2: monster2,
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

  String _buildRumor(String col13, String col14, String col15, String col11,
      String col10, String col12) {
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
}
