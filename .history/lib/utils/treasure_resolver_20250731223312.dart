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
        results.add(part); // Keep magic items as is for now
        continue;
      }

      // Match patterns like 1d6×100 PP or 1d4 Gemas
      final regex = RegExp(
          r'(\d+)d(\d+)(?:\s*[×x\*]\s*(\d+))?\s*(PP|PO|Gemas|Objetos de Valor)?',
          caseSensitive: false);
      final match = regex.firstMatch(part);
      if (match != null) {
        final diceCount = int.parse(match.group(1)!);
        final diceSides = int.parse(match.group(2)!);
        final multiplierStr = match.group(3);
        final unit = match.group(4) ?? '';

        int value = DiceRoller.roll(diceCount, diceSides);
        if (multiplierStr != null) {
          value *= int.parse(multiplierStr);
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
          results.add('$number ${unit.trim()}'.trim());
        } else {
          // Part didn't match; keep as is
          results.add(part);
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
}
