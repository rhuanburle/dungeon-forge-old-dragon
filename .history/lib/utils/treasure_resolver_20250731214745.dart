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
        results.add('$value ${unit.trim()}'.trim());
      } else {
        // Check if it's just a number without dice (like "4" in "4 + 400 PO")
        final numberRegex = RegExp(r'^(\d+)\s*(PP|PO|Gemas|Objetos de Valor)?$', caseSensitive: false);
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
}
