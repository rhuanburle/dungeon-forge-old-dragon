import 'dart:math';

class RumorEntry {
  final String createdBy;
  final String purpose;
  final String target;

  const RumorEntry({required this.createdBy, required this.purpose, required this.target});

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
    return [rollRumor(), rollRumor(), rollRumor()];
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
}

// Tabela A5.2: Rumores (d6 + d6)
const Map<int, RumorEntry> _rumors = {
  11: RumorEntry(createdBy: 'um Mago Louco', purpose: 'Proteger', target: 'tesouro.'),
  12: RumorEntry(createdBy: 'um Mago Ancestral', purpose: 'Esconder', target: 'monstro.'),
  13: RumorEntry(createdBy: 'um Clérigo Cego', purpose: 'Aprisionar', target: 'espada.'),
  14: RumorEntry(createdBy: 'um Clérigo Poderoso', purpose: 'Deter', target: 'grimório.'),
  15: RumorEntry(createdBy: 'um Clérigo Proscrito', purpose: 'Impedir', target: 'Ídolo.'),
  16: RumorEntry(createdBy: 'um Guerreiro Poderoso', purpose: 'Descobrir', target: 'deus.'),
  21: RumorEntry(createdBy: 'um Guerreiro Rico', purpose: 'Derrotar', target: 'documento.'),
  22: RumorEntry(createdBy: 'um Rei Antigo', purpose: 'Explorar', target: 'demônio.'),
  23: RumorEntry(createdBy: 'um Rei Poderoso', purpose: 'Vigiar', target: 'lich.'),
  24: RumorEntry(createdBy: 'um Rei Furioso', purpose: 'Atrair', target: 'joia.'),
  25: RumorEntry(createdBy: 'um Rei', purpose: 'Contratar', target: 'trono.'),
  26: RumorEntry(createdBy: 'uma Sacerdotisa', purpose: 'Selecionar', target: 'escravo.'),
  31: RumorEntry(createdBy: 'um Sábio', purpose: 'Eliminar', target: 'vampiro.'),
  32: RumorEntry(createdBy: 'um Demônio', purpose: 'Cultuar', target: 'profecia.'),
  33: RumorEntry(createdBy: 'a Arak-Takna', purpose: 'Invocar', target: 'líder religioso.'),
  34: RumorEntry(createdBy: 'um Dragão', purpose: 'Restaurar', target: 'Arak-Takna.'),
  35: RumorEntry(createdBy: 'um Orc', purpose: 'Enviar', target: 'Orcus.'),
  36: RumorEntry(createdBy: 'um Vampiro', purpose: 'Explodir', target: 'Cthulhu.'),
  41: RumorEntry(createdBy: 'um Lich', purpose: 'Criar', target: 'ovo de dragão.'),
  42: RumorEntry(createdBy: 'um Druida', purpose: 'Formar', target: 'portal.'),
  43: RumorEntry(createdBy: 'um Sacerdote', purpose: 'Idolatrar', target: 'rival.'),
  44: RumorEntry(createdBy: 'o próprio Orcus', purpose: 'Conjurar', target: 'seita.'),
  45: RumorEntry(createdBy: 'um Herói', purpose: 'Afastar', target: 'armadura.'),
  46: RumorEntry(createdBy: 'um Antigo Vilão', purpose: 'Libertar', target: 'mapa.'),
  51: RumorEntry(createdBy: 'um Comerciante', purpose: 'Aguardar', target: 'goblin.'),
  52: RumorEntry(createdBy: 'um Ladrão ambicioso', purpose: 'Transportar', target: 'drider.'),
  53: RumorEntry(createdBy: 'um Ladrão enriquecido', purpose: 'Seguir', target: 'criatura.'),
  54: RumorEntry(createdBy: 'um Príncipe', purpose: 'Recuperar', target: 'magia.'),
  55: RumorEntry(createdBy: 'uma Rainha', purpose: 'Confinar', target: 'elmo.'),
  56: RumorEntry(createdBy: 'um Senhor do Crime', purpose: 'Invocar', target: 'guilda.'),
  61: RumorEntry(createdBy: 'um Cultista', purpose: 'Reviver', target: 'ettin.'),
  62: RumorEntry(createdBy: 'um Bardo', purpose: 'Expulsar', target: 'orc.'),
  63: RumorEntry(createdBy: 'uma Bruxa', purpose: 'Raptar', target: 'opositor.'),
  64: RumorEntry(createdBy: 'um Ser Amaldiçoado', purpose: 'Definhar', target: 'confraria.'),
  65: RumorEntry(createdBy: 'uma Marilith', purpose: 'Apagar', target: 'adaga.'),
  66: RumorEntry(createdBy: 'um Devorador de Cérebro', purpose: 'Sumir', target: 'gigante.'),
};

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

/// Representa o quadro de rumores (3 linhas x 3 colunas [A,B,C])
class RumorBoard {
  final List<RumorEntry> rows; // exatamente 3
  final List<bool> eliminatedA; // len 3
  final List<bool> eliminatedB; // len 3
  final List<bool> eliminatedC; // len 3

  RumorBoard._(this.rows, this.eliminatedA, this.eliminatedB, this.eliminatedC);

  factory RumorBoard.fromRumors(List<RumorEntry> rumors) {
    assert(rumors.length == 3);
    return RumorBoard._(
      List<RumorEntry>.from(rumors),
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
      if (!_isEliminated(current.column, current.row)) {
        _setEliminated(current.column, current.row);
        break;
      }
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
        return pick(rows[i]);
      }
    }
    return null;
  }
}

enum ColumnId { a, b, c }

class _Cell {
  final ColumnId column;
  final int row;
  _Cell(this.column, this.row);
}


