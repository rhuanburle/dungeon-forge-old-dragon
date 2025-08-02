// utils/gem_resolver.dart

import 'dice_roller.dart';

/// Serviço para resolver gemas específicas
class GemResolver {
  /// Resolve uma quantidade de gemas para tipos específicos
  static String resolve(int count) {
    final gemas = <String>[];

    for (int i = 0; i < count; i++) {
      final roll = DiceRoller.rollStatic(2, 6);
      final gem = _resolveSingleGem(roll);
      gemas.add(gem);
    }

    return gemas.join(', ');
  }

  /// Resolve uma gema individual baseada no roll
  static String _resolveSingleGem(int roll) {
    final gemData = _getGemData(roll);
    return '${gemData.category} (${gemData.value})';
  }

  /// Obtém os dados da gema baseado no roll
  static GemData _getGemData(int roll) {
    switch (roll) {
      case 2:
      case 3:
        return GemData('Preciosa', '500 PO');
      case 4:
      case 5:
        return GemData('Ornamental', '50 PO');
      case 6:
      case 7:
      case 8:
      case 9:
        return GemData('Decorativa', '10 PO');
      case 10:
      case 11:
        return GemData('Semipreciosa', '100 PO');
      case 12:
        return GemData('Joia', '1.000 PO');
      default:
        return GemData('Decorativa', '10 PO');
    }
  }
}

/// Dados de uma gema
class GemData {
  final String category;
  final String value;

  const GemData(this.category, this.value);

  @override
  String toString() {
    return '$category ($value)';
  }
}
