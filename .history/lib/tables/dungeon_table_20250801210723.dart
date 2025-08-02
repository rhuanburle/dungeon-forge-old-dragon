// tables/dungeon_table.dart

/// Representa a Tabela 9.1 - Gerando Masmorras (Old Dragon)
class DungeonTable {
  // Coluna 1 - Tipos de Masmorra
  static const List<String> _column1 = [
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

  // Coluna 2 - Construído(a)/Habitado(a) por
  static const List<String> _column2 = [
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

  // Coluna 3 - que estão
  static const List<String> _column3 = [
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

  // Coluna 4 - Objetivo da Construção
  static const List<String> _column4 = [
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

  // Coluna 5 - um/uma
  static const List<String> _column5 = [
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

  // Coluna 6 - que está
  static const List<String> _column6 = [
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

  // Coluna 7 - Localização
  static const List<String> _column7 = [
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

  // Coluna 8 - Entrada da Masmorra
  static const List<String> _column8 = [
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

  // Coluna 9 - Salas/Câmaras (fórmulas)
  static const List<String> _column9 = [
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

  // Coluna 10 - Ocupante I
  static const List<String> _column10 = [
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

  // Coluna 11 - Ocupante II
  static const List<String> _column11 = [
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

  // Coluna 12 - Liderados por um/uma
  static const List<String> _column12 = [
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

  // Coluna 13 - Rumor 1 - Quem
  static const List<String> _column13 = [
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

  // Coluna 14 - Rumor 2 - Que
  static const List<String> _column14 = [
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

  // Coluna 15 - Rumor 3 - Onde
  static const List<String> _column15 = [
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