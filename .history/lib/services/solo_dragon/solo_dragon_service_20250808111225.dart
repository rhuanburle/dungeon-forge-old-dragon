import 'dart:math';

class RumorEntry {
  final String createdBy;
  final String purpose;
  final String target;

  const RumorEntry({
    required this.createdBy,
    required this.purpose,
    required this.target,
  });

  @override
  String toString() => '$createdBy | $purpose | $target';
}

class SoloDragonService {
  final Random _random;

  SoloDragonService() : _random = Random();
  SoloDragonService.withSeed(int seed) : _random = Random(seed);

  int rollD6() => _random.nextInt(6) + 1;

  static String oracleAnswerFor(int roll) {
    switch (roll) {
      case 1:
        return 'Não, e...';
      case 2:
        return 'Não';
      case 3:
        return 'Não, mas...';
      case 4:
        return 'Sim, mas...';
      case 5:
        return 'Sim';
      case 6:
        return 'Sim, e';
      default:
        throw ArgumentError('Oracle roll must be between 1 and 6');
    }
  }

  List<RumorEntry> generateRumors() {
    // Gera 3 rumores completos para o quadro 3x3
    return List.generate(3, (_) => rollRumor());
  }

  RumorEntry rollRumor() {
    final tens = rollD6();
    final units = rollD6();
    final key = tens * 10 + units; // 11..66
    final row = _rumors[key];
    if (row == null) {
      // Fallback shouldn't happen, but keep a safe default
      return const RumorEntry(
        createdBy: 'um Mago Louco',
        purpose: 'Proteger',
        target: 'tesouro.',
      );
    }
    return row;
  }

  bool rollInvestigationFound() {
    // 1-2 in 1d6 chance
    return rollD6() <= 2;
  }

  DungeonSetup generateDungeonSetupWithRumors() {
    final rumors = generateRumors();
    final board = RumorBoard.fromRumors(rumors);

    final dTypeRoll = rollD6() + rollD6(); // 2..12
    final setup = _dungeonTypeEntrance[dTypeRoll]!;

    // If 2 or 12, eliminate one rumor row as per rule
    if (dTypeRoll == 2 || dTypeRoll == 12) {
      final d6 = rollD6();
      final rowToEliminate = d6 <= 2
          ? 0
          : d6 <= 4
          ? 1
          : 2; // 1-based -> 0-based index
      board.eliminateRow(rowToEliminate);
    }

    return DungeonSetup(
      type: setup.type,
      entrance: setup.entrance,
      rumorBoard: board,
      typeRoll: dTypeRoll,
    );
  }

  /// Gera uma sala baseada nas tabelas A5.4, A5.5 e A5.6 com encadeamento por cores
  SoloRoom generateRoom(RoomContext context) {
    // A5.4: Tipo (2d6)
    final roomTypeRoll = rollD6() + rollD6();
    final roomType = _getRoomType(context, roomTypeRoll);

    // A5.5: Portas (d6 d6 -> 11..66)
    final doorsRoll = rollD6() * 10 + rollD6();
    final doors =
        (_roomEvents[doorsRoll] ??
                const RoomEvents(
                  doors: '1 Porta de madeira',
                  content: '',
                  trap: '',
                  encounter: '',
                  hasTreasure: false,
                ))
            .doors;

    // Encadeamento por cores
    String content = '';
    String trap = '';
    String encounter = '';
    int? contentRoll;
    int? trapRoll;
    int? encounterRoll;
    int? treasureRoll;

    bool contentTriggeredFromDoors = false;
    bool trapTriggeredFromContent = false;
    bool encounterTriggeredFromTrap = false;
    bool treasureTriggeredFromContent = false;

    if (_grayDoors.contains(doorsRoll)) {
      contentTriggeredFromDoors = true;
      contentRoll = rollD6() * 10 + rollD6();
      content =
          (_roomEvents[contentRoll] ??
                  const RoomEvents(
                    doors: '',
                    content: 'Vazio e sujo',
                    trap: '',
                    encounter: '',
                    hasTreasure: false,
                  ))
              .content;

      final isContentGray = _grayContent.contains(contentRoll);
      final isContentYellow = _yellowContent.contains(contentRoll);

      if (isContentYellow) {
        treasureTriggeredFromContent = true;
        treasureRoll = rollD6() + rollD6(); // 2..12
      }

      if (isContentGray || isContentYellow) {
        trapTriggeredFromContent = true;
        trapRoll = rollD6() * 10 + rollD6();
        trap =
            (_roomEvents[trapRoll] ??
                    const RoomEvents(
                      doors: '',
                      content: '',
                      trap: '',
                      encounter: '',
                      hasTreasure: false,
                    ))
                .trap;

        if (_grayTraps.contains(trapRoll)) {
          encounterTriggeredFromTrap = true;
          encounterRoll = rollD6() * 10 + rollD6();
          encounter =
              (_roomEvents[encounterRoll] ??
                      const RoomEvents(
                        doors: '',
                        content: '',
                        trap: '',
                        encounter: '',
                        hasTreasure: false,
                      ))
                  .encounter;
        }
      }
    }

    // A5.6: Tesouro
    String treasure = '';
    if (treasureTriggeredFromContent && treasureRoll != null) {
      treasure = _getTreasure(treasureRoll);
    }

    return SoloRoom(
      type: roomType,
      doors: doors,
      content: content,
      trap: trap,
      encounter: encounter,
      treasure: treasure,
      roomTypeRoll: roomTypeRoll,
      doorsRoll: doorsRoll,
      contentRoll: contentRoll,
      trapRoll: trapRoll,
      encounterRoll: encounterRoll,
      treasureRoll: treasureRoll,
      contentTriggeredFromDoors: contentTriggeredFromDoors,
      trapTriggeredFromContent: trapTriggeredFromContent,
      encounterTriggeredFromTrap: encounterTriggeredFromTrap,
      treasureTriggeredFromContent: treasureTriggeredFromContent,
    );
  }

  String _getRoomType(RoomContext context, int roll) {
    final types =
        _roomTypes[context] ?? _roomTypes[RoomContext.enteringDungeon]!;
    return types[roll] ?? 'Câmara Padrão';
  }

  String _getTreasure(int roll) {
    final treasure = _treasures[roll];
    if (treasure == null) return '';

    // Resolve quantidades baseadas nas fórmulas
    final gold = _resolveFormula(treasure.goldFormula);
    final silver = _resolveFormula(treasure.silverFormula);
    final gems = _resolveFormula(treasure.gemsFormula);
    final art = _resolveFormula(treasure.artFormula);
    final magic = _resolveFormula(treasure.magicFormula);

    final parts = <String>[];
    if (gold.isNotEmpty) parts.add('PO: $gold');
    if (silver.isNotEmpty) parts.add('PP: $silver');
    if (gems.isNotEmpty) parts.add('Gemas: $gems');
    if (art.isNotEmpty) parts.add('Arte: $art');
    if (magic.isNotEmpty) parts.add('Mágicos: $magic');

    return parts.join(', ');
  }

  String _resolveFormula(String formula) {
    if (formula.isEmpty || formula == '-') return '';

    // Exemplo: "3 em 1d6 para 1d6 PO" -> "3d6 PO"
    if (formula.contains('em 1d6 para')) {
      final parts = formula.split(' em 1d6 para ');
      final count = parts[0];
      final dice = parts[1];
      return '${count}${dice}';
    }

    return formula;
  }
}

class DungeonTypeEntrance {
  final String type;
  final String entrance;
  const DungeonTypeEntrance(this.type, this.entrance);
}

class DungeonSetup {
  final String type;
  final String entrance;
  final int typeRoll;
  final RumorBoard rumorBoard;
  const DungeonSetup({
    required this.type,
    required this.entrance,
    required this.typeRoll,
    required this.rumorBoard,
  });
}

class InvestigationResult {
  final bool found;
  final String? description;

  const InvestigationResult({required this.found, this.description});
}

class SoloRoom {
  final String type;
  final String doors;
  final String content;
  final String trap;
  final String encounter;
  final String treasure;

  // Rolagens
  final int roomTypeRoll; // 2..12
  final int doorsRoll; // 11..66
  final int? contentRoll; // 11..66
  final int? trapRoll; // 11..66
  final int? encounterRoll; // 11..66
  final int? treasureRoll; // 2..12 (A5.6)

  // Sinalizadores
  final bool contentTriggeredFromDoors;
  final bool trapTriggeredFromContent;
  final bool encounterTriggeredFromTrap;
  final bool treasureTriggeredFromContent;

  // Investigação
  final InvestigationResult? investigation;

  const SoloRoom({
    required this.type,
    required this.doors,
    required this.content,
    required this.trap,
    required this.encounter,
    required this.treasure,
    required this.roomTypeRoll,
    required this.doorsRoll,
    this.contentRoll,
    this.trapRoll,
    this.encounterRoll,
    this.treasureRoll,
    required this.contentTriggeredFromDoors,
    required this.trapTriggeredFromContent,
    required this.encounterTriggeredFromTrap,
    required this.treasureTriggeredFromContent,
    this.investigation,
  });

  /// Cria uma cópia da sala com investigação atualizada
  SoloRoom withInvestigation(InvestigationResult investigation) {
    return SoloRoom(
      type: type,
      doors: doors,
      content: content,
      trap: trap,
      encounter: encounter,
      treasure: treasure,
      roomTypeRoll: roomTypeRoll,
      doorsRoll: doorsRoll,
      contentRoll: contentRoll,
      trapRoll: trapRoll,
      encounterRoll: encounterRoll,
      treasureRoll: treasureRoll,
      contentTriggeredFromDoors: contentTriggeredFromDoors,
      trapTriggeredFromContent: trapTriggeredFromContent,
      encounterTriggeredFromTrap: encounterTriggeredFromTrap,
      treasureTriggeredFromContent: treasureTriggeredFromContent,
      investigation: investigation,
    );
  }
}

enum RoomContext {
  enteringDungeon,
  leavingChamber,
  leavingCorridor,
  leavingStairs,
}

class RoomEvents {
  final String doors;
  final String content;
  final String trap;
  final String encounter;
  final bool hasTreasure;

  const RoomEvents({
    required this.doors,
    required this.content,
    required this.trap,
    required this.encounter,
    required this.hasTreasure,
  });
}

class TreasureData {
  final String goldFormula;
  final String silverFormula;
  final String gemsFormula;
  final String artFormula;
  final String magicFormula;

  const TreasureData({
    required this.goldFormula,
    required this.silverFormula,
    required this.gemsFormula,
    required this.artFormula,
    required this.magicFormula,
  });
}

/// Representa o quadro de rumores (3 linhas x 3 colunas [A,B,C])
class RumorBoard {
  final List<RumorEntry> rumors; // exatamente 3 rumores
  final List<bool> eliminatedA; // len 3
  final List<bool> eliminatedB; // len 3
  final List<bool> eliminatedC; // len 3

  RumorBoard._(
    this.rumors,
    this.eliminatedA,
    this.eliminatedB,
    this.eliminatedC,
  );

  factory RumorBoard.fromRumors(List<RumorEntry> rumors) {
    assert(rumors.length == 3);
    return RumorBoard._(
      List<RumorEntry>.from(rumors), // 3 rumores
      List<bool>.filled(3, false),
      List<bool>.filled(3, false),
      List<bool>.filled(3, false),
    );
  }

  void eliminateRow(int rowIndex) {
    // Elimina a linha inteira (A,B,C) se ainda restarem múltiplas opções
    _eliminateWithMigration(ColumnId.a, rowIndex);
    _eliminateWithMigration(ColumnId.b, rowIndex);
    _eliminateWithMigration(ColumnId.c, rowIndex);
  }

  void eliminate(ColumnId column, int rowIndex) {
    _eliminateWithMigration(column, rowIndex);
  }

  // Aplica regra de migração: A1>A2>A3>B1>B2>B3>C1>C2>C3>A1>...
  void _eliminateWithMigration(ColumnId column, int rowIndex) {
    final order = <_Cell>[
      _Cell(ColumnId.a, 0),
      _Cell(ColumnId.a, 1),
      _Cell(ColumnId.a, 2),
      _Cell(ColumnId.b, 0),
      _Cell(ColumnId.b, 1),
      _Cell(ColumnId.b, 2),
      _Cell(ColumnId.c, 0),
      _Cell(ColumnId.c, 1),
      _Cell(ColumnId.c, 2),
    ];
    int idx = order.indexWhere((c) => c.column == column && c.row == rowIndex);
    for (int i = 0; i < order.length; i++) {
      final current = order[(idx + i) % order.length];
      // Skip if this cell is already eliminated or if it's the only remaining in its column (discovery)
      if (_isEliminated(current.column, current.row)) {
        continue;
      }

      _setEliminated(current.column, current.row);
      break;
    }
  }

  bool _isEliminated(ColumnId column, int row) {
    switch (column) {
      case ColumnId.a:
        return eliminatedA[row];
      case ColumnId.b:
        return eliminatedB[row];
      case ColumnId.c:
        return eliminatedC[row];
    }
  }

  void _setEliminated(ColumnId column, int row) {
    switch (column) {
      case ColumnId.a:
        eliminatedA[row] = true;
        break;
      case ColumnId.b:
        eliminatedB[row] = true;
        break;
      case ColumnId.c:
        eliminatedC[row] = true;
        break;
    }
  }

  bool get hasDiscoveryA => _remainingCount(ColumnId.a) == 1;
  bool get hasDiscoveryB => _remainingCount(ColumnId.b) == 1;
  bool get hasDiscoveryC => _remainingCount(ColumnId.c) == 1;
  bool get isFinalMysteryRevealed =>
      hasDiscoveryA && hasDiscoveryB && hasDiscoveryC;

  int _remainingCount(ColumnId column) {
    switch (column) {
      case ColumnId.a:
        return eliminatedA.where((e) => !e).length;
      case ColumnId.b:
        return eliminatedB.where((e) => !e).length;
      case ColumnId.c:
        return eliminatedC.where((e) => !e).length;
    }
  }

  String? get remainingA => _remainingValue(ColumnId.a, (r) => r.createdBy);
  String? get remainingB => _remainingValue(ColumnId.b, (r) => r.purpose);
  String? get remainingC => _remainingValue(ColumnId.c, (r) => r.target);

  String? _remainingValue(ColumnId column, String Function(RumorEntry) pick) {
    for (int i = 0; i < 3; i++) {
      if (!_isEliminated(column, i)) {
        return pick(rumors[i]);
      }
    }
    return null;
  }

  /// Retorna o rumor na linha especificada
  RumorEntry getRumorAt(int rowIndex) => rumors[rowIndex];

  /// Retorna se uma célula específica está eliminada
  bool isEliminated(ColumnId column, int row) => _isEliminated(column, row);
}

enum ColumnId { a, b, c }

class _Cell {
  final ColumnId column;
  final int row;
  _Cell(this.column, this.row);
}

// A5.3 Tipos & Entrada da Masmorra (2d6)
const Map<int, DungeonTypeEntrance> _dungeonTypeEntrance = {
  2: DungeonTypeEntrance('Construída', 'No subsolo da fortaleza'),
  3: DungeonTypeEntrance('Construída', 'Uma escada dentro da torre'),
  4: DungeonTypeEntrance('Construída', 'Túnel secreto em um beco'),
  5: DungeonTypeEntrance('Construída', 'Abaixo do altar do templo'),
  6: DungeonTypeEntrance('Construída', 'Nos esgotos da cidade'),
  7: DungeonTypeEntrance('Sua Escolha', 'Escolha livremente'),
  8: DungeonTypeEntrance('Natural', 'Pequena gruta na colina'),
  9: DungeonTypeEntrance('Natural', 'No fundo de um covil'),
  10: DungeonTypeEntrance('Natural', 'Fissura numa grande pedra'),
  11: DungeonTypeEntrance('Natural', 'Na boca de um vulcão adormecido'),
  12: DungeonTypeEntrance('Natural', 'Atrás de uma cachoeira'),
};

// A5.4: Cômodos da Masmorra (2d6)
const Map<RoomContext, Map<int, String>> _roomTypes = {
  RoomContext.enteringDungeon: {
    2: 'Escada que sobe',
    3: 'Corredor reto',
    4: 'Grande câmara com pilastras e estátuas',
    5: 'Corredor em L esquerda',
    6: 'Câmara padrão',
    7: 'Câmara padrão',
    8: 'Câmara padrão',
    9: 'Corredor em L direita',
    10: 'Câmara estreita',
    11: 'Corredor reto',
    12: 'Escada que desce',
  },
  RoomContext.leavingChamber: {
    2: 'Escada que sobe',
    3: 'Corredor largo',
    4: 'Grande câmara com pilastras e estátuas',
    5: 'Câmara padrão',
    6: 'Corredor em L esquerda',
    7: 'Corredor reto',
    8: 'Corredor em L direita',
    9: 'Câmara padrão',
    10: 'Câmara estreita',
    11: 'Corredor largo',
    12: 'Escada que desce',
  },
  RoomContext.leavingCorridor: {
    2: 'Corredor reto',
    3: 'Grande câmara com pilastras e estátuas',
    4: 'Grande câmara com pilastras e estátuas',
    5: 'Corredor em L esquerda',
    6: 'Câmara padrão',
    7: 'Câmara padrão',
    8: 'Câmara padrão',
    9: 'Corredor em L direita',
    10: 'Escada que desce',
    11: 'Câmara estreita',
    12: 'Corredor reto',
  },
  RoomContext.leavingStairs: {
    2: 'Corredor largo',
    3: 'Corredor reto',
    4: 'Grande câmara com pilastras e estátuas',
    5: 'Corredor em L esquerda',
    6: 'Câmara padrão',
    7: 'Câmara padrão',
    8: 'Câmara padrão',
    9: 'Corredor em L direita',
    10: 'Câmara estreita',
    11: 'Corredor reto',
    12: 'Corredor largo',
  },
};

// A5.5: Eventos (d6+d6)
const Map<int, RoomEvents> _roomEvents = {
  11: RoomEvents(
    doors: '1 Porta de madeira apodrecida',
    content: 'Vazio e estranhamente limpo',
    trap: 'Agulha perfura mão na maçaneta',
    encounter: 'Bandidos',
    hasTreasure: true,
  ),
  12: RoomEvents(
    doors: '2 Portas de madeira reforçadas e trancadas',
    content: 'Pentagrama de invocação no chão',
    trap: 'Armadilha de urso aprisiona o pé',
    encounter: 'Bugbear',
    hasTreasure: true,
  ),
  13: RoomEvents(
    doors: '3 Portas de madeira bloqueadas por dentro',
    content: 'Móveis apodrecidos e totalmente destruídos',
    trap: 'Bloco de pedra cai do teto',
    encounter: 'Esqueleto',
    hasTreasure: false,
  ),
  14: RoomEvents(
    doors: '1 Porta de aço enferrujado e bloqueada',
    content: 'Antiga biblioteca com livros empoeirados',
    trap: 'Dardo sai de fissura na parede',
    encounter: 'Sibilante',
    hasTreasure: true,
  ),
  15: RoomEvents(
    doors: '2 Portas de aço destrancadas',
    content: 'Uma cripta com 1d3 caixões de pedra',
    trap: 'Estaca sai do piso e perfura o personagem',
    encounter: 'Devorador de Cérebro',
    hasTreasure: true,
  ),
  16: RoomEvents(
    doors: '1 Porta de aço trancada por dentro',
    content: 'Vazio e sujo. Abandonado.',
    trap: 'Fio cortante invisível no nível da canela',
    encounter: 'Drider',
    hasTreasure: false,
  ),
  21: RoomEvents(
    doors: '1 Porta semioculta na parede',
    content: 'Uma antiga prisão desativada',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Drakold',
    hasTreasure: false,
  ),
  22: RoomEvents(
    doors: '2 Portas de grades de aço enferrujado',
    content: 'Um poço de água misteriosa',
    trap: 'A sala se enche de gás',
    encounter: 'Zumbi',
    hasTreasure: false,
  ),
  23: RoomEvents(
    doors: '1 Porta ricamente ornamentada',
    content: 'Um laboratório com frascos coloridos',
    trap: 'Jatos de fogo saem do teto, queimando todos',
    encounter: 'Fungo Violeta',
    hasTreasure: true,
  ),
  24: RoomEvents(
    doors: '1 Porta dupla de madeira apodrecida',
    content: 'Depósito de barris, baús e sacas de comida',
    trap: 'Uma lâmina ceifadora para cortar cabeças',
    encounter: 'Rato Gigante',
    hasTreasure: false,
  ),
  25: RoomEvents(
    doors: '1 Porta dupla de madeira destrancada',
    content: 'Uma piscina com água verde e gosmenta',
    trap:
        'A porta de entrada ativa um portal para uma sala não explorada e aleatória',
    encounter: 'Bandidos',
    hasTreasure: true,
  ),
  26: RoomEvents(
    doors: '1 Porta dupla de madeira trancada',
    content: 'Vazio e sujo. Abandonado.',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Minotauro',
    hasTreasure: false,
  ),
  31: RoomEvents(
    doors: '2 Portas de madeira apodrecida',
    content: 'Um pequeno altar a uma divindade desconhecida',
    trap: 'Vagarosamente, o teto começa a descer',
    encounter: 'Aparição',
    hasTreasure: false,
  ),
  32: RoomEvents(
    doors: '3 Portas de madeira reforçadas e trancadas',
    content: 'Parede desabada bloqueia parcialmente a passagem',
    trap: 'A sala começa a ser inundada de areia',
    encounter: 'Kobolds',
    hasTreasure: false,
  ),
  33: RoomEvents(
    doors: '1 Porta de madeira bloqueada por dentro',
    content: '4 Pilastras organizadas simetricamente',
    trap: 'Spray ácido ao passar na porta',
    encounter: 'Ghoul',
    hasTreasure: false,
  ),
  34: RoomEvents(
    doors: '1 Porta de aço destrancada',
    content: 'Camas desfeitas e roupa de cama jogada no chão',
    trap: 'Dardos envenenados são expulsos das paredes',
    encounter: 'Esqueleto',
    hasTreasure: true,
  ),
  35: RoomEvents(
    doors: '1 Porta de aço e trancada por dentro',
    content: 'Um tapete cobre totalmente o piso',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Bugbear',
    hasTreasure: false,
  ),
  36: RoomEvents(
    doors: '1 Porta semioculta na parede',
    content: 'Parcialmente inundado por infiltração do teto',
    trap: 'A sala começa e se encher de água',
    encounter: 'Cultistas',
    hasTreasure: false,
  ),
  41: RoomEvents(
    doors: '1 Porta de grades de aço enferrujado',
    content: 'Sala de armas com várias espadas',
    trap: 'Um fosso com estacas se abre ao pisar',
    encounter: 'Zumbi',
    hasTreasure: true,
  ),
  42: RoomEvents(
    doors: '1 Porta ricamente ornamentada',
    content: 'Vazio e sujo. Abandonado.',
    trap: 'Piso se abre e se converte em lâminas',
    encounter: 'Goblin',
    hasTreasure: true,
  ),
  43: RoomEvents(
    doors: '1 Porta dupla de madeira destrancada',
    content: 'Um cadáver de alguém recém-morto',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Goblin',
    hasTreasure: false,
  ),
  44: RoomEvents(
    doors: '1 Porta dupla de madeira trancada',
    content: 'Velas, velas e mais velas. Todas acesas',
    trap: 'Um cordão no piso ativa centenas de sinetas e alarmes',
    encounter: 'Troll',
    hasTreasure: false,
  ),
  45: RoomEvents(
    doors: '1 Porta de madeira apodrecida',
    content: 'Plantas mortas por todos os lados',
    trap: 'A porta de entrada abre um alçapão com pedras',
    encounter: 'Ogro',
    hasTreasure: false,
  ),
  46: RoomEvents(
    doors: '3 Portas de madeira apodrecida',
    content: 'Ossos humanos e humanoides espalhados',
    trap: 'Espinhos saem de buracos em toda a sala',
    encounter: 'Fungo Pigmeu',
    hasTreasure: true,
  ),
  51: RoomEvents(
    doors: '1 Porta de madeira reforçada e trancada',
    content: 'Textos em idiomas antigos rabiscados',
    trap:
        'A porta de entrada ativa um portal para uma sala não explorada e aleatória',
    encounter: 'Kobolds',
    hasTreasure: true,
  ),
  52: RoomEvents(
    doors: '1 Porta de madeira bloqueada por dentro',
    content: 'Móveis feitos de ossos de animais',
    trap: 'Dardo sai de fissura na parede',
    encounter: 'Otyugh',
    hasTreasure: true,
  ),
  53: RoomEvents(
    doors: '2 Portas de aço enferrujado e bloqueadas',
    content: 'Covil de besta selvagem com muitos ossos roídos',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Orc',
    hasTreasure: true,
  ),
  54: RoomEvents(
    doors: '2 Portas de aço trancadas por dentro',
    content: 'Vazio e sujo. Abandonado.',
    trap: 'Uma área de escuridão mágica',
    encounter: 'Fungo Violeta',
    hasTreasure: true,
  ),
  55: RoomEvents(
    doors: '1 Porta dupla de madeira apodrecida',
    content: 'Fungos brilhantes em todas as paredes',
    trap: 'Quatro pêndulos cortantes balançam',
    encounter: 'Drakold',
    hasTreasure: false,
  ),
  56: RoomEvents(
    doors: '1 Porta de madeira apodrecida',
    content: 'O teto ruiu. Parcialmente bloqueado',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Monstro Ferrugem',
    hasTreasure: false,
  ),
  61: RoomEvents(
    doors: '1 Porta de madeira reforçada e trancada',
    content: 'Um aventureiro terrivelmente petrificado',
    trap: 'Vagarosamente, o teto começa a descer',
    encounter: 'Orc',
    hasTreasure: false,
  ),
  62: RoomEvents(
    doors: '1 Porta de madeira bloqueada por dentro',
    content: 'Um pequeno altar a uma divindade do panteão',
    trap: 'Fio cortante invisível no nível da canela',
    encounter: 'Goblin',
    hasTreasure: true,
  ),
  63: RoomEvents(
    doors: '1 Porta dupla de madeira destrancada',
    content: 'Uma antiga sala de tortura abandonada',
    trap: 'Uma placa no solo faz "clic"',
    encounter: 'Cultistas',
    hasTreasure: false,
  ),
  64: RoomEvents(
    doors: '3 Portas de aço enferrujado e bloqueadas',
    content:
        'Depósito de material de escavação. Pás, picaretas e muitas pedras',
    trap: 'Um fosso escondido magicamente',
    encounter: 'Otyugh',
    hasTreasure: true,
  ),
  65: RoomEvents(
    doors: '1 Porta de aço destrancada',
    content: 'Portal místico aparentemente desativado',
    trap: 'Encontro! Jogue na coluna ao lado!',
    encounter: 'Rato Gigante',
    hasTreasure: true,
  ),
  66: RoomEvents(
    doors: '2 Portas de madeira bloqueadas por dentro',
    content: 'Vazio e estranhamente limpo',
    trap: 'A sala começa a se encher de água',
    encounter: 'Minotauro',
    hasTreasure: false,
  ),
};

// A5.6: Tesouros em Cômodos (2d6)
const Map<int, TreasureData> _treasures = {
  2: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '3 em 1d6 para 3d6 PP',
    gemsFormula: '3 em 1d6',
    artFormula: '2 em 1d6',
    magicFormula: '2 em 1d6',
  ),
  3: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 3d6 PP',
    gemsFormula: '2 em 1d6',
    artFormula: '2 em 1d6',
    magicFormula: '1 em 1d6',
  ),
  4: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 2d6 PP',
    gemsFormula: '1 em 1d6',
    artFormula: '1 em 1d6',
    magicFormula: '2 em 1d6 para 1 poção',
  ),
  5: TreasureData(
    goldFormula: '2 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 1d6 PP',
    gemsFormula: '-',
    artFormula: '-',
    magicFormula: '1 em 1d6 para 1 poção',
  ),
  6: TreasureData(
    goldFormula: '1 em 1d6 para 1d6 PO',
    silverFormula: '1 em 1d6 para 1d6 PP',
    gemsFormula: '-',
    artFormula: '-',
    magicFormula: '-',
  ),
  7: TreasureData(
    goldFormula: '-',
    silverFormula: '-',
    gemsFormula: '-',
    artFormula: '-',
    magicFormula: '-',
  ),
  8: TreasureData(
    goldFormula: '1 em 1d6 para 1d6 PO',
    silverFormula: '1 em 1d6 para 1d6 PP',
    gemsFormula: '-',
    artFormula: '-',
    magicFormula: '-',
  ),
  9: TreasureData(
    goldFormula: '2 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 1d6 PP',
    gemsFormula: '-',
    artFormula: '-',
    magicFormula: '1 em 1d6 para 1 poção',
  ),
  10: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 2d6 PP',
    gemsFormula: '1 em 1d6',
    artFormula: '1 em 1d6',
    magicFormula: '2 em 1d6 para 1 poção',
  ),
  11: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '2 em 1d6 para 3d6 PP',
    gemsFormula: '2 em 1d6',
    artFormula: '2 em 1d6',
    magicFormula: '1 em 1d6',
  ),
  12: TreasureData(
    goldFormula: '3 em 1d6 para 1d6 PO',
    silverFormula: '3 em 1d6 para 3d6 PP',
    gemsFormula: '3 em 1d6',
    artFormula: '2 em 1d6',
    magicFormula: '2 em 1d6',
  ),
};

// Tabela A5.2: Rumores (d6 + d6)
const Map<int, RumorEntry> _rumors = {
  11: RumorEntry(
    createdBy: 'um Mago Louco',
    purpose: 'Proteger',
    target: 'tesouro.',
  ),
  12: RumorEntry(
    createdBy: 'um Mago Ancestral',
    purpose: 'Esconder',
    target: 'monstro.',
  ),
  13: RumorEntry(
    createdBy: 'um Clérigo Cego',
    purpose: 'Aprisionar',
    target: 'espada.',
  ),
  14: RumorEntry(
    createdBy: 'um Clérigo Poderoso',
    purpose: 'Deter',
    target: 'grimório.',
  ),
  15: RumorEntry(
    createdBy: 'um Clérigo Proscrito',
    purpose: 'Impedir',
    target: 'Ídolo.',
  ),
  16: RumorEntry(
    createdBy: 'um Guerreiro Poderoso',
    purpose: 'Descobrir',
    target: 'deus.',
  ),
  21: RumorEntry(
    createdBy: 'um Guerreiro Rico',
    purpose: 'Derrotar',
    target: 'documento.',
  ),
  22: RumorEntry(
    createdBy: 'um Rei Antigo',
    purpose: 'Explorar',
    target: 'demônio.',
  ),
  23: RumorEntry(
    createdBy: 'um Rei Poderoso',
    purpose: 'Vigiar',
    target: 'lich.',
  ),
  24: RumorEntry(
    createdBy: 'um Rei Furioso',
    purpose: 'Atrair',
    target: 'joia.',
  ),
  25: RumorEntry(createdBy: 'um Rei', purpose: 'Contratar', target: 'trono.'),
  26: RumorEntry(
    createdBy: 'uma Sacerdotisa',
    purpose: 'Selecionar',
    target: 'escravo.',
  ),
  31: RumorEntry(
    createdBy: 'um Sábio',
    purpose: 'Eliminar',
    target: 'vampiro.',
  ),
  32: RumorEntry(
    createdBy: 'um Demônio',
    purpose: 'Cultuar',
    target: 'profecia.',
  ),
  33: RumorEntry(
    createdBy: 'a Arak-Takna',
    purpose: 'Invocar',
    target: 'líder religioso.',
  ),
  34: RumorEntry(
    createdBy: 'um Dragão',
    purpose: 'Restaurar',
    target: 'Arak-Takna.',
  ),
  35: RumorEntry(createdBy: 'um Orc', purpose: 'Enviar', target: 'Orcus.'),
  36: RumorEntry(
    createdBy: 'um Vampiro',
    purpose: 'Explodir',
    target: 'Cthulhu.',
  ),
  41: RumorEntry(
    createdBy: 'um Lich',
    purpose: 'Criar',
    target: 'ovo de dragão.',
  ),
  42: RumorEntry(createdBy: 'um Druida', purpose: 'Formar', target: 'portal.'),
  43: RumorEntry(
    createdBy: 'um Sacerdote',
    purpose: 'Idolatrar',
    target: 'rival.',
  ),
  44: RumorEntry(
    createdBy: 'o próprio Orcus',
    purpose: 'Conjurar',
    target: 'seita.',
  ),
  45: RumorEntry(
    createdBy: 'um Herói',
    purpose: 'Afastar',
    target: 'armadura.',
  ),
  46: RumorEntry(
    createdBy: 'um Antigo Vilão',
    purpose: 'Libertar',
    target: 'mapa.',
  ),
  51: RumorEntry(
    createdBy: 'um Comerciante',
    purpose: 'Aguardar',
    target: 'goblin.',
  ),
  52: RumorEntry(
    createdBy: 'um Ladrão ambicioso',
    purpose: 'Transportar',
    target: 'drider.',
  ),
  53: RumorEntry(
    createdBy: 'um Ladrão enriquecido',
    purpose: 'Seguir',
    target: 'criatura.',
  ),
  54: RumorEntry(
    createdBy: 'um Príncipe',
    purpose: 'Recuperar',
    target: 'magia.',
  ),
  55: RumorEntry(createdBy: 'uma Rainha', purpose: 'Confinar', target: 'elmo.'),
  56: RumorEntry(
    createdBy: 'um Senhor do Crime',
    purpose: 'Invocar',
    target: 'guilda.',
  ),
  61: RumorEntry(
    createdBy: 'um Cultista',
    purpose: 'Reviver',
    target: 'ettin.',
  ),
  62: RumorEntry(createdBy: 'um Bardo', purpose: 'Expulsar', target: 'orc.'),
  63: RumorEntry(
    createdBy: 'uma Bruxa',
    purpose: 'Raptar',
    target: 'opositor.',
  ),
  64: RumorEntry(
    createdBy: 'um Ser Amaldiçoado',
    purpose: 'Definhar',
    target: 'confraria.',
  ),
  65: RumorEntry(
    createdBy: 'uma Marilith',
    purpose: 'Apagar',
    target: 'adaga.',
  ),
  66: RumorEntry(
    createdBy: 'um Devorador de Cérebro',
    purpose: 'Sumir',
    target: 'gigante.',
  ),
};

// Células coloridas por coluna (A5.5)
const Set<int> _grayDoors = {
  11,
  12,
  14,
  15,
  21,
  22,
  24,
  25,
  31,
  32,
  34,
  35,
  41,
  42,
  44,
  45,
  51,
  52,
  54,
  55,
  61,
  62,
  64,
  65,
};
const Set<int> _grayContent = {13, 31, 36, 51, 56};
const Set<int> _grayTraps = {11, 14, 16, 22, 25, 34, 41, 52, 54, 62, 64};
const Set<int> _yellowContent = {12, 15, 23, 26, 35, 42, 46, 53, 61, 65};

extension SoloDragonServiceRooms on SoloDragonService {
  /// Gera uma sala baseada nas tabelas A5.4, A5.5 e A5.6 com encadeamento por cores
  SoloRoom generateRoom(RoomContext context) {
    // A5.4: Tipo (2d6)
    final roomTypeRoll = rollD6() + rollD6();
    final roomType = _getRoomType(context, roomTypeRoll);

    // A5.5: Portas (d6 d6 -> 11..66)
    final doorsRoll = rollD6() * 10 + rollD6();
    final doors =
        (_roomEvents[doorsRoll] ??
                const RoomEvents(
                  doors: '1 Porta de madeira',
                  content: '',
                  trap: '',
                  encounter: '',
                  hasTreasure: false,
                ))
            .doors;

    // Encadeamento por cores
    String content = '';
    String trap = '';
    String encounter = '';
    int? contentRoll;
    int? trapRoll;
    int? encounterRoll;
    int? treasureRoll;

    bool contentTriggeredFromDoors = false;
    bool trapTriggeredFromContent = false;
    bool encounterTriggeredFromTrap = false;
    bool treasureTriggeredFromContent = false;

    if (_grayDoors.contains(doorsRoll)) {
      contentTriggeredFromDoors = true;
      contentRoll = rollD6() * 10 + rollD6();
      content =
          (_roomEvents[contentRoll] ??
                  const RoomEvents(
                    doors: '',
                    content: 'Vazio e sujo',
                    trap: '',
                    encounter: '',
                    hasTreasure: false,
                  ))
              .content;

      final isContentGray = _grayContent.contains(contentRoll);
      final isContentYellow = _yellowContent.contains(contentRoll);

      if (isContentYellow) {
        treasureTriggeredFromContent = true;
        treasureRoll = rollD6() + rollD6(); // 2..12
      }

      if (isContentGray || isContentYellow) {
        trapTriggeredFromContent = true;
        trapRoll = rollD6() * 10 + rollD6();
        trap =
            (_roomEvents[trapRoll] ??
                    const RoomEvents(
                      doors: '',
                      content: '',
                      trap: '',
                      encounter: '',
                      hasTreasure: false,
                    ))
                .trap;

        if (_grayTraps.contains(trapRoll)) {
          encounterTriggeredFromTrap = true;
          encounterRoll = rollD6() * 10 + rollD6();
          encounter =
              (_roomEvents[encounterRoll] ??
                      const RoomEvents(
                        doors: '',
                        content: '',
                        trap: '',
                        encounter: '',
                        hasTreasure: false,
                      ))
                  .encounter;
        }
      }
    }

    // A5.6: Tesouro
    String treasure = '';
    if (treasureTriggeredFromContent && treasureRoll != null) {
      treasure = _getTreasure(treasureRoll);
    }

    return SoloRoom(
      type: roomType,
      doors: doors,
      content: content,
      trap: trap,
      encounter: encounter,
      treasure: treasure,
      roomTypeRoll: roomTypeRoll,
      doorsRoll: doorsRoll,
      contentRoll: contentRoll,
      trapRoll: trapRoll,
      encounterRoll: encounterRoll,
      treasureRoll: treasureRoll,
      contentTriggeredFromDoors: contentTriggeredFromDoors,
      trapTriggeredFromContent: trapTriggeredFromContent,
      encounterTriggeredFromTrap: encounterTriggeredFromTrap,
      treasureTriggeredFromContent: treasureTriggeredFromContent,
    );
  }
}
