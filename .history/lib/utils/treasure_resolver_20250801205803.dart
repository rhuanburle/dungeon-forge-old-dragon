// utils/treasure_resolver.dart

import 'dice_roller.dart';
import 'treasure_parser.dart';
import 'gem_resolver.dart';
import 'valuable_object_resolver.dart';
import 'magic_item_resolver.dart';

/// Resolve treasure strings like
///   "1d6×100 PP + 1d6×10 PO + 1d4 Gemas"
/// and returns a concrete result, e.g.:
///   "300 PP + 40 PO + 3 Gemas".
/// It supports PP, PO, Gemas, Objetos de Valor.
class TreasureResolver {
  static String resolve(String template) {
    final components = TreasureParser.parse(template);
    final results = <String>[];

    for (final component in components) {
      switch (component.type) {
        case TreasureComponentType.empty:
          return 'Nenhum';
        case TreasureComponentType.dice:
        case TreasureComponentType.simple:
          final result = _resolveComponent(component);
          if (result.isNotEmpty) {
            results.add(result);
          }
          break;
        case TreasureComponentType.magicItem:
          final magicItem = MagicItemResolver.resolve(component.rawText!);
          results.add(magicItem);
          break;
        case TreasureComponentType.raw:
          results.add(component.rawText!);
          break;
      }
    }

    return results.join(' + ');
  }

  /// Resolve um componente de tesouro
  static String _resolveComponent(TreasureComponent component) {
    if (component.value == null || component.unit == null) {
      return '';
    }

    final value = component.value!;
    final unit = component.unit!;

    // Resolve specific items for Gemas and Objetos de Valor
    if (unit == 'Gemas') {
      return '$value Gemas: ${GemResolver.resolve(value)}';
    } else if (unit == 'Objetos de Valor') {
      return '$value Objetos de Valor: ${ValuableObjectResolver.resolve(value)}';
    } else {
      return '$value $unit'.trim();
    }
  }


}
