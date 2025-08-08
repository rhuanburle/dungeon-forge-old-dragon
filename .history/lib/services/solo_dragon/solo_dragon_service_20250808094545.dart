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


