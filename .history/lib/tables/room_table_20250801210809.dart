// tables/room_table.dart

/// Representa a Tabela 9.2 - Salas e Câmaras de Masmorras (Old Dragon)
class RoomTable {
  // Coluna 1 - Tipo de Sala
  static const List<String> _column1 = [
    'Sala Especial (coluna 8)',
    'Sala Especial (coluna 8)',
    'Armadilha (coluna 11)',
    'Armadilha (coluna 11)',
    'Sala Comum (coluna 7)',
    'Sala Comum (coluna 7)',
    'Monstro (coluna 10)',
    'Monstro (coluna 10)',
    'Sala Comum (coluna 7)',
    'Sala Comum (coluna 7)',
    'Sala Armadilha Especial (coluna 12)',
    'Sala Armadilha Especial (coluna 12)',
  ];

  // Coluna 2 - Correntes de Ar
  static const List<String> _column2 = [
    'corrente de ar quente',
    'corrente de ar quente',
    'leve brisa quente',
    'leve brisa quente',
    'sem corrente de ar',
    'sem corrente de ar',
    'leve brisa fria',
    'leve brisa fria',
    'corrente de ar fria',
    'corrente de ar fria',
    'vento forte e gelado',
    'vento forte e gelado',
  ];

  // Coluna 3 - Odores Sentidos
  static const List<String> _column3 = [
    'cheiro de carne podre',
    'cheiro de carne podre',
    'cheiro de umidade e mofo',
    'cheiro de umidade e mofo',
    'sem cheiro especial',
    'sem cheiro especial',
    'cheiro de terra',
    'cheiro de terra',
    'cheiro de fumaça',
    'cheiro de fumaça',
    'cheiro de fezes e urina',
    'cheiro de fezes e urina',
  ];

  // Coluna 4 - Barulhos Ouvidos
  static const List<String> _column4 = [
    'arranhado metálico',
    'arranhado metálico',
    'gotejar ritmado',
    'gotejar ritmado',
    'nenhum som especial',
    'nenhum som especial',
    'vento soprando',
    'vento soprando',
    'passos ao longe',
    'passos ao longe',
    'sussurros e gemidos',
    'sussurros e gemidos',
  ];

  // Coluna 5 - Itens Encontrados
  static const List<String> _column5 = [
    'completamente vazia',
    'completamente vazia',
    'poeira, sujeira e teias',
    'poeira, sujeira e teias',
    'móveis velhos',
    'móveis velhos',
    'itens encontrados especial…',
    'itens encontrados especial…',
    'restos de comida e lixo',
    'restos de comida e lixo',
    'roupas sujas e fétidas',
    'roupas sujas e fétidas',
  ];

  // Coluna 6 - Itens Encontrados Especial
  static const List<String> _column6 = [
    'carcaças de monstros',
    'carcaças de monstros',
    'papéis velhos e rasgados',
    'papéis velhos e rasgados',
    'ossadas empilhadas',
    'ossadas empilhadas',
    'restos de tecidos sujos',
    'restos de tecidos sujos',
    'caixas, sacos e baús vazios',
    'caixas, sacos e baús vazios',
    'caixas, sacos e baús cheios',
    'caixas, sacos e baús cheios',
  ];

  // Coluna 7 - Sala Comum
  static const List<String> _column7 = [
    'dormitório',
    'dormitório',
    'depósito geral',
    'depósito geral',
    'Especial…',
    'Especial…',
    'completamente vazia',
    'completamente vazia',
    'despensa de comida',
    'despensa de comida',
    'cela de prisão',
    'cela de prisão',
  ];

  // Coluna 8 - Sala Especial
  static const List<String> _column8 = [
    'sala de treinamento',
    'sala de treinamento',
    'refeitório',
    'refeitório',
    'completamente vazia',
    'completamente vazia',
    'Especial 2…',
    'Especial 2…',
    'altar religioso',
    'altar religioso',
    'covil abandonado',
    'covil abandonado',
  ];

  // Coluna 9 - Sala Especial 2
  static const List<String> _column9 = [
    'câmara de tortura',
    'câmara de tortura',
    'câmara de rituais',
    'câmara de rituais',
    'laboratório mágico',
    'laboratório mágico',
    'biblioteca',
    'biblioteca',
    'cripta',
    'cripta',
    'arsenal',
    'arsenal',
  ];

  // Coluna 10 - Monstros
  static const List<String> _column10 = [
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

  // Coluna 11 - Armadilha
  static const List<String> _column11 = [
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

  // Coluna 12 - Armadilha Especial
  static const List<String> _column12 = [
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

  // Coluna 13 - Tesouro
  static const List<String> _column13 = [
    'Nenhum',
    'Nenhum',
    'Nenhum',
    'Nenhum',
    '1d6 x 100 PP + 1d6 x 10 PO',
    '1d6 x 100 PP + 1d6 x 10 PO',
    '1d6 x 10 PO + 1d4 Gemas',
    '1d6 x 10 PO + 1d4 Gemas',
    'Tesouro Especial…',
    'Tesouro Especial…',
    'Item Mágico',
    'Item Mágico',
  ];

  // Coluna 14 - Tesouro Especial
  static const List<String> _column14 = [
    'Jogue Novamente + Item Mágico',
    'Jogue Novamente + Item Mágico',
    '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas',
    '1d6 x 100 PP + 1d6 x 10 PO + 1d4 Gemas',
    '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
    'Jogue Novamente + Item Mágico',
    'Jogue Novamente + Item Mágico',
  ];

  // Coluna 15 - Item Mágico
  static const List<String> _column15 = [
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

  /// Obtém o resultado da coluna 1 baseado no roll
  static String getColumn1(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column1[roll - 2];
  }

  /// Obtém o resultado da coluna 2 baseado no roll
  static String getColumn2(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column2[roll - 2];
  }

  /// Obtém o resultado da coluna 3 baseado no roll
  static String getColumn3(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column3[roll - 2];
  }

  /// Obtém o resultado da coluna 4 baseado no roll
  static String getColumn4(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column4[roll - 2];
  }

  /// Obtém o resultado da coluna 5 baseado no roll
  static String getColumn5(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column5[roll - 2];
  }

  /// Obtém o resultado da coluna 6 baseado no roll
  static String getColumn6(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column6[roll - 2];
  }

  /// Obtém o resultado da coluna 7 baseado no roll
  static String getColumn7(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column7[roll - 2];
  }

  /// Obtém o resultado da coluna 8 baseado no roll
  static String getColumn8(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column8[roll - 2];
  }

  /// Obtém o resultado da coluna 9 baseado no roll
  static String getColumn9(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column9[roll - 2];
  }

  /// Obtém o resultado da coluna 10 baseado no roll
  static String getColumn10(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column10[roll - 2];
  }

  /// Obtém o resultado da coluna 11 baseado no roll
  static String getColumn11(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column11[roll - 2];
  }

  /// Obtém o resultado da coluna 12 baseado no roll
  static String getColumn12(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column12[roll - 2];
  }

  /// Obtém o resultado da coluna 13 baseado no roll
  static String getColumn13(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column13[roll - 2];
  }

  /// Obtém o resultado da coluna 14 baseado no roll
  static String getColumn14(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column14[roll - 2];
  }

  /// Obtém o resultado da coluna 15 baseado no roll
  static String getColumn15(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column15[roll - 2];
  }
} 