// utils/magic_item_resolver.dart

import 'dice_roller.dart';

/// Serviço para resolver itens mágicos específicos
class MagicItemResolver {
  /// Resolve um item mágico baseado no tipo
  static String resolve(String type) {
    final itemType = _determineItemType(type);
    final itemRoll = DiceRoller.roll(1, 100);
    
    return _resolveByType(itemType, itemRoll);
  }

  /// Determina o tipo de item baseado na string
  static MagicItemType _determineItemType(String type) {
    if (type.contains('Qualquer') && type.contains('não Arma')) {
      return MagicItemType.naoArma;
    } else if (type.contains('Qualquer') && type.contains('Arma')) {
      return MagicItemType.armas;
    } else if (type.contains('Qualquer')) {
      // Para "Qualquer", rola 1d100 para determinar o tipo
      final roll = DiceRoller.roll(1, 100);
      if (roll <= 30) {
        return MagicItemType.naoArma;
      } else if (roll <= 60) {
        return MagicItemType.armas;
      } else if (roll <= 85) {
        return MagicItemType.tipo;
      } else {
        return MagicItemType.caoticos;
      }
    } else if (type.contains('Poção')) {
      return MagicItemType.tipo;
    } else if (type.contains('Pergaminho')) {
      return MagicItemType.tipo;
    } else if (type.contains('Arma')) {
      return MagicItemType.armas;
    } else {
      return MagicItemType.todos;
    }
  }

  /// Resolve o item baseado no tipo e roll
  static String _resolveByType(MagicItemType type, int roll) {
    switch (type) {
      case MagicItemType.todos:
        return _resolveTodos(roll);
      case MagicItemType.naoArma:
        return _resolveNaoArma(roll);
      case MagicItemType.armas:
        return _resolveArmas(roll);
      case MagicItemType.tipo:
        return _resolveTipo(roll);
      case MagicItemType.caoticos:
        return _resolveCaoticos(roll);
    }
  }

  /// Resolve itens do tipo "Todos"
  static String _resolveTodos(int roll) {
    if (roll <= 3) return 'Espada Longa -1 Amaldiçoada (Caótica)';
    if (roll <= 7) return 'Espada Longa +1';
    if (roll <= 11) return 'Espada Longa +1/+2 contra licantropos';
    if (roll <= 15) return 'Espada Longa +1/+2 contra orcs';
    if (roll <= 19) return 'Espada Longa +1/+2 contra mortos-vivos';
    if (roll <= 20) return 'Espada Longa +2';
    if (roll <= 22) return 'Arma -1 Amaldiçoada (Caótica)';
    if (roll <= 23) return 'Flehcas +1 (10 unidades)';
    if (roll <= 25) return 'Machado de Batalha +1';
    if (roll <= 27) return 'Martelo de Batalha +1';
    if (roll <= 29) return 'Adaga +1';
    if (roll <= 30) return 'Adaga +2';
    if (roll <= 32) return 'Armadura -1 Amaldiçoada (Caótica)';
    if (roll <= 34) return 'Armadura Acolchoada +1';
    if (roll <= 36) return 'Armadura de Couro +1';
    if (roll <= 37) return 'Armadura de Couro Batido +1';
    if (roll <= 38) return 'Cota de Malha +1';
    if (roll <= 40) return 'Escudo +1';
    if (roll <= 44) return 'Poção Amaldiçoada (Caótica)';
    if (roll <= 60) return 'Poção de Cura';
    if (roll <= 61) return 'Poção da Diminuição';
    if (roll <= 62) return 'Poção da Forma Gasosa';
    if (roll <= 63) return 'Poção da Força Gigante';
    if (roll <= 65) return 'Venenos';
    if (roll <= 67) return 'Pergaminho Amaldiçoado (Caótico)';
    if (roll <= 77) return 'Pergaminho Arcano';
    if (roll <= 81) return 'Pergaminho Divino';
    if (roll <= 83) return 'Pergaminho de Proteção';
    if (roll <= 84) return 'Mapa de Tesouro';
    if (roll <= 85) return 'Anel (Caótico)';
    if (roll <= 86) return 'Anel de Proteção +1';
    if (roll <= 87) return 'Anel do Controle de Animais';
    if (roll <= 88) return 'Anel da Regeneração';
    if (roll <= 89) return 'Anel da Invisibilidade';
    if (roll <= 90) return 'Haste Caótica (Caótico)';
    if (roll <= 91) return 'Varinha de Paralisação';
    if (roll <= 92) return 'Varinha de Bolas de Fogo';
    if (roll <= 93) return 'Cajado da Cura';
    if (roll <= 94) return 'Cajado de Ataque';
    if (roll <= 95) return 'Bastão do Cancelamento';
    if (roll <= 96) return 'Sacola Devoradora(Caótico)';
    if (roll <= 97) return 'Bola de Cristal';
    if (roll <= 98) return 'Manto Élfico';
    if (roll <= 99) return 'Botas Élficas';
    return 'Manoplas da Força do Ogro';
  }

  /// Resolve itens do tipo "Não Arma"
  static String _resolveNaoArma(int roll) {
    if (roll <= 3) return 'Armadura -1 Amaldiçoada (Caótica)';
    if (roll <= 6) return 'Armadura Acolchoada +1';
    if (roll <= 8) return 'Armadura de Couro +1';
    if (roll <= 10) return 'Armadura de Couro Batido +1';
    if (roll <= 14) return 'Cota de Malha +1';
    if (roll <= 20) return 'Escudo +1';
    if (roll <= 30) return 'Poção de Cura';
    if (roll <= 35) return 'Poção da Diminuição';
    if (roll <= 40) return 'Poção da Forma Gasosa';
    if (roll <= 45) return 'Poção da Força Gigante';
    if (roll <= 50) return 'Venenos';
    if (roll <= 54) return 'Pergaminho Amaldiçoado (Caótico)';
    if (roll <= 73) return 'Pergaminho Arcano';
    if (roll <= 79) return 'Pergaminho Divino';
    if (roll <= 81) return 'Pergaminho de Proteção';
    if (roll <= 84) return 'Mapa de Tesouro';
    if (roll <= 85) return 'Anel (Caótico)';
    if (roll <= 86) return 'Anel de Proteção +1';
    if (roll <= 87) return 'Anel do Controle de Animais';
    if (roll <= 88) return 'Anel da Regeneração';
    if (roll <= 89) return 'Anel da Invisibilidade';
    if (roll <= 90) return 'Haste Caótica (Caótico)';
    if (roll <= 91) return 'Varinha de Paralisação';
    if (roll <= 92) return 'Varinha de Bolas de Fogo';
    if (roll <= 93) return 'Cajado da Cura';
    if (roll <= 94) return 'Cajado de Ataque';
    if (roll <= 95) return 'Bastão do Cancelamento';
    if (roll <= 96) return 'Sacola Devoradora(Caótico)';
    if (roll <= 97) return 'Bola de Cristal';
    if (roll <= 98) return 'Manto Élfico';
    if (roll <= 99) return 'Botas Élficas';
    return 'Manoplas da Força do Ogro';
  }

  /// Resolve itens do tipo "Armas"
  static String _resolveArmas(int roll) {
    if (roll <= 10) return 'Espada Longa -1 Amaldiçoada (Caótica)';
    if (roll <= 30) return 'Espada Longa +1';
    if (roll <= 40) return 'Espada Longa +1/+2 contra licantropos';
    if (roll <= 50) return 'Espada Longa +1/+2 contra orcs';
    if (roll <= 60) return 'Espada Longa +1/+2 contra mortos-vivos';
    if (roll <= 65) return 'Espada Longa +2';
    if (roll <= 75) return 'Arma -1 Amaldiçoada (Caótica)';
    if (roll <= 81) return 'Flehcas +1 (10 unidades)';
    if (roll <= 87) return 'Machado de Batalha +1';
    if (roll <= 93) return 'Martelo de Batalha +1';
    if (roll <= 98) return 'Adaga +1';
    return 'Adaga +2';
  }

  /// Resolve itens do tipo "Tipo"
  static String _resolveTipo(int roll) {
    if (roll <= 19) return 'Espada Longa -1 Amaldiçoada (Caótica)';
    if (roll <= 35) return 'Espada Longa +1';
    if (roll <= 55) return 'Espada Longa +1/+2 contra licantropos';
    if (roll <= 75) return 'Espada Longa +1/+2 contra orcs';
    if (roll <= 95) return 'Espada Longa +1/+2 contra mortos-vivos';
    if (roll <= 16) return 'Armadura -1 Amaldiçoada (Caótica)';
    if (roll <= 40) return 'Armadura Acolchoada +1';
    if (roll <= 60) return 'Armadura de Couro +1';
    if (roll <= 70) return 'Armadura de Couro Batido +1';
    if (roll <= 80) return 'Cota de Malha +1';
    if (roll <= 89) return 'Escudo +1';
    if (roll <= 10) return 'Poção Amaldiçoada (Caótica)';
    if (roll <= 85) return 'Poção de Cura';
    if (roll <= 88) return 'Poção da Diminuição';
    if (roll <= 91) return 'Poção da Forma Gasosa';
    if (roll <= 94) return 'Poção da Força Gigante';
    if (roll <= 00) return 'Venenos';
    if (roll <= 10) return 'Pergaminho Amaldiçoado (Caótico)';
    if (roll <= 65) return 'Pergaminho Arcano';
    if (roll <= 85) return 'Pergaminho Divino';
    if (roll <= 95) return 'Pergaminho de Proteção';
    if (roll <= 00) return 'Mapa de Tesouro';
    if (roll <= 20) return 'Anel (Caótico)';
    if (roll <= 40) return 'Anel de Proteção +1';
    if (roll <= 60) return 'Anel do Controle de Animais';
    if (roll <= 80) return 'Anel da Regeneração';
    if (roll <= 00) return 'Anel da Invisibilidade';
    if (roll <= 17) return 'Haste Caótica (Caótico)';
    if (roll <= 33) return 'Varinha de Paralisação';
    if (roll <= 50) return 'Varinha de Bolas de Fogo';
    if (roll <= 66) return 'Cajado da Cura';
    if (roll <= 83) return 'Cajado de Ataque';
    if (roll <= 00) return 'Bastão do Cancelamento';
    if (roll <= 20) return 'Sacola Devoradora(Caótico)';
    if (roll <= 40) return 'Bola de Cristal';
    if (roll <= 60) return 'Manto Élfico';
    if (roll <= 80) return 'Botas Élficas';
    return 'Manoplas da Força do Ogro';
  }

  /// Resolve itens do tipo "Caóticos"
  static String _resolveCaoticos(int roll) {
    if (roll <= 19) return 'Espada Longa -1 Amaldiçoada (Caótica)';
    if (roll <= 31) return 'Arma -1 Amaldiçoada (Caótica)';
    if (roll <= 44) return 'Armadura -1 Amaldiçoada (Caótica)';
    if (roll <= 69) return 'Poção Amaldiçoada (Caótica)';
    if (roll <= 81) return 'Pergaminho Amaldiçoado (Caótico)';
    if (roll <= 88) return 'Anel (Caótico)';
    if (roll <= 94) return 'Haste Caótica (Caótico)';
    if (roll <= 00) return 'Sacola Devoradora(Caótico)';
    return 'Item Caótico Desconhecido';
  }
}

/// Tipos de itens mágicos
enum MagicItemType {
  todos,
  naoArma,
  armas,
  tipo,
  caoticos,
} 