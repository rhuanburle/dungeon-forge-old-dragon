// utils/treasure_resolver.dart

import 'dice_roller.dart';

/// Resolve treasure strings like
///   "1d6×100 PP + 1d6×10 PO + 1d4 Gemas"
/// and returns a concrete result, e.g.:
///   "300 PP + 40 PO + 3 Gemas".
/// It supports PP, PO, Gemas, Objetos de Valor.
class TreasureResolver {
  static String resolve(String template) {
    template = template.trim();
    if (template.isEmpty || template == '—') return 'Nenhum';

    if (template.toLowerCase().startsWith('nenhum')) {
      return 'Nenhum';
    }

    // Handle "Jogue Novamente" - resolve it recursively
    if (template.contains('Jogue Novamente')) {
      // Remove "Jogue Novamente + " and resolve the rest
      final cleanTemplate = template.replaceAll('Jogue Novamente + ', '');
      return resolve(cleanTemplate);
    }

    // Handle "1 em 1d6" - roll to see if there's treasure
    if (template.contains('1 em 1d6')) {
      final roll = DiceRoller.roll(1, 6);
      if (roll == 1) {
        // Extract the treasure part after "1 em 1d6"
        final parts = template.split('1 em 1d6');
        if (parts.length > 1) {
          return resolve(parts[1].trim());
        }
      }
      return 'Nenhum';
    }

    final parts = template.split('+');
    final results = <String>[];

    for (var rawPart in parts) {
      final part = rawPart.trim();
      if (part.isEmpty) continue;

      // Handle magic items (like "1 Qualquer", "2 Qualquer", etc.)
      if (part.contains('Qualquer') ||
          part.contains('Poção') ||
          part.contains('Pergaminho') ||
          part.contains('Arma')) {
        results.add(_resolveMagicItem(part)); // Resolve magic items
        continue;
      }

      // Match patterns like 1d6×100 PP or 1d4 Gemas
      final regex = RegExp(
          r'(\d+)d(\d+)(?:\s*[×x\*]\s*([\d,]+))?\s*(PP|PO|Gemas|Objetos de Valor)?',
          caseSensitive: false);
      final match = regex.firstMatch(part);
      if (match != null) {
        final diceCount = int.parse(match.group(1)!);
        final diceSides = int.parse(match.group(2)!);
        final multiplierStr = match.group(3);
        final unit = match.group(4) ?? '';

        int value = DiceRoller.roll(diceCount, diceSides);
        if (multiplierStr != null) {
          // Remove pontos de milhares antes de converter
          final cleanMultiplier = multiplierStr.replaceAll('.', '');
          value *= int.parse(cleanMultiplier);
        }

        // Resolve specific items for Gemas and Objetos de Valor
        if (unit == 'Gemas') {
          results.add('$value Gemas: ${_resolveGemas(value)}');
        } else if (unit == 'Objetos de Valor') {
          results
              .add('$value Objetos de Valor: ${_resolveObjetosDeValor(value)}');
        } else {
          results.add('$value ${unit.trim()}'.trim());
        }
      } else {
        // Check if it's just a number without dice (like "4" in "4 + 400 PO")
        final numberRegex = RegExp(r'^(\d+)\s*(PP|PO|Gemas|Objetos de Valor)?$',
            caseSensitive: false);
        final numberMatch = numberRegex.firstMatch(part);
        if (numberMatch != null) {
          final number = numberMatch.group(1)!;
          final unit = numberMatch.group(2) ?? '';
          // Só adiciona se tiver uma unidade definida
          if (unit.isNotEmpty) {
            results.add('$number ${unit.trim()}'.trim());
          } else {
            // Se não tiver unidade, ignora o número solto
            continue;
          }
        } else {
          // Part didn't match; check if it's just a standalone number
          final standaloneNumberRegex = RegExp(r'^\d+$');
          if (standaloneNumberRegex.hasMatch(part)) {
            // Ignora números soltos sem unidade
            continue;
          } else {
            // Part didn't match; keep as is (but only if it's not just a number)
            results.add(part);
          }
        }
      }
    }

    return results.join(' + ');
  }

  /// Resolve gemas to specific gem types
  static String _resolveGemas(int count) {
    final gemas = <String>[];
    for (int i = 0; i < count; i++) {
      final roll = DiceRoller.roll(2, 6);
      String categoria;
      String valor;

      if (roll <= 3) {
        categoria = 'Preciosa';
        valor = '500 PO';
      } else if (roll <= 5) {
        categoria = 'Ornamental';
        valor = '50 PO';
      } else if (roll <= 9) {
        categoria = 'Decorativa';
        valor = '10 PO';
      } else if (roll <= 11) {
        categoria = 'Semipreciosa';
        valor = '100 PO';
      } else {
        categoria = 'Joia';
        valor = '1.000 PO';
      }

      gemas.add('$categoria ($valor)');
    }
    return gemas.join(', ');
  }

  /// Resolve objetos de valor to specific items
  static String _resolveObjetosDeValor(int count) {
    final objetos = <String>[];
    for (int i = 0; i < count; i++) {
      // Primeiro rola para determinar o tipo
      final tipoRoll = DiceRoller.roll(2, 6);
      String tipo;

      if (tipoRoll <= 3) {
        tipo = 'Obras de Arte';
      } else if (tipoRoll <= 5) {
        tipo = 'Utensílios';
      } else if (tipoRoll <= 7) {
        tipo = 'Mercadoria';
      } else if (tipoRoll <= 9) {
        tipo = 'Mercadoria';
      } else if (tipoRoll <= 11) {
        tipo = 'Louças';
      } else {
        tipo = 'Joias';
      }

      // Depois rola para determinar o item específico
      final itemRoll = DiceRoller.roll(2, 6);
      String item;

      switch (tipo) {
        case 'Obras de Arte':
          switch (itemRoll) {
            case 2:
            case 3:
              item = 'Móveis com Marchetaria';
              break;
            case 4:
            case 5:
              item = 'Tapeçaria Fina';
              break;
            case 6:
            case 7:
              item = 'Livro Raro';
              break;
            case 8:
            case 9:
              item = 'Escultura';
              break;
            case 10:
            case 11:
              item = 'Tela Pintada';
              break;
            default:
              item = 'Estatueta em Bronze';
          }
          break;
        case 'Utensílios':
          switch (itemRoll) {
            case 2:
            case 3:
              item = 'Religiosos de Cobre';
              break;
            case 4:
            case 5:
              item = 'Talheres de Prata';
              break;
            case 6:
            case 7:
              item = 'Candelabros de Prata';
              break;
            case 8:
            case 9:
              item = 'Cutelaria Fina';
              break;
            case 10:
            case 11:
              item = 'Cálices de Ouro';
              break;
            default:
              item = 'Religiosos de Ouro';
          }
          break;
        case 'Mercadoria':
          switch (itemRoll) {
            case 2:
            case 3:
              item = 'Peles de Animais Raros';
              break;
            case 4:
            case 5:
              item = 'Objetos de Marfim';
              break;
            case 6:
            case 7:
              item = 'Sacas de Especiaria';
              break;
            case 8:
            case 9:
              item = 'Sacas de Incenso';
              break;
            case 10:
            case 11:
              item = 'Tecidos Nobres';
              break;
            default:
              item = 'Metros de Fina Seda';
          }
          break;
        case 'Louças':
          switch (itemRoll) {
            case 2:
            case 3:
              item = 'Objetos de Vidro Soprado';
              break;
            case 4:
            case 5:
              item = 'Copos de Vidro e com Prata';
              break;
            case 6:
            case 7:
              item = 'Baixelas de Louça';
              break;
            case 8:
            case 9:
              item = 'Baixelas de Porcelana com ouro';
              break;
            case 10:
            case 11:
              item = 'Vaso de Porcelana';
              break;
            default:
              item = 'Cálices de Vidro com pedraria';
          }
          break;
        case 'Joias':
          switch (itemRoll) {
            case 2:
            case 3:
              item = 'Cordão de Prata';
              break;
            case 4:
            case 5:
              item = 'Brincos de Pérola';
              break;
            case 6:
            case 7:
              item = 'Bracelete de Prata';
              break;
            case 8:
            case 9:
              item = 'Pingente de Pedraria';
              break;
            case 10:
            case 11:
              item = 'Camafeu de Ouro';
              break;
            default:
              item = 'Tiara com Pedraria';
          }
          break;
        default:
          item = 'Item de Valor';
      }

      objetos.add(item);
    }
    return objetos.join(', ');
  }

  /// Resolve magic items based on the type and roll
  static String _resolveMagicItem(String type) {
    // Primeiro determina o tipo de item baseado no tipo
    String itemType;

    if (type.contains('Qualquer') && type.contains('não Arma')) {
      itemType = 'Não Arma';
    } else if (type.contains('Qualquer') && type.contains('Arma')) {
      itemType = 'Armas';
    } else if (type.contains('Qualquer')) {
      // Para "Qualquer", rola 1d100 para determinar o tipo
      final roll = DiceRoller.roll(1, 100);
      if (roll <= 30) {
        itemType = 'Não Arma';
      } else if (roll <= 60) {
        itemType = 'Armas';
      } else if (roll <= 85) {
        itemType = 'Tipo';
      } else {
        itemType = 'Caóticos';
      }
    } else if (type.contains('Poção')) {
      itemType = 'Tipo';
    } else if (type.contains('Pergaminho')) {
      itemType = 'Tipo';
    } else if (type.contains('Arma')) {
      itemType = 'Armas';
    } else {
      // Default para "Qualquer"
      itemType = 'Todos';
    }

    // Agora rola 1d100 para determinar o item específico
    final itemRoll = DiceRoller.roll(1, 100);

    // Determina o item baseado no tipo e roll
    switch (itemType) {
      case 'Todos':
        return _resolveMagicItemTodos(itemRoll);
      case 'Não Arma':
        return _resolveMagicItemNaoArma(itemRoll);
      case 'Armas':
        return _resolveMagicItemArmas(itemRoll);
      case 'Tipo':
        return _resolveMagicItemTipo(itemRoll);
      case 'Caóticos':
        return _resolveMagicItemCaoticos(itemRoll);
      default:
        return 'Item Mágico Desconhecido';
    }
  }

  static String _resolveMagicItemTodos(int roll) {
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

  static String _resolveMagicItemNaoArma(int roll) {
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

  static String _resolveMagicItemArmas(int roll) {
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

  static String _resolveMagicItemTipo(int roll) {
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

  static String _resolveMagicItemCaoticos(int roll) {
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
