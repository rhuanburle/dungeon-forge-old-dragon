import 'dart:math';
import '../enums/dice_enums.dart';

/// Serviço para rolagem de dados usando o DiceType enum
/// 
/// Este serviço fornece métodos para rolar dados de diferentes formas:
/// - rollSingleDie: rola um único dado
/// - rollMultipleDice: rola múltiplos dados
/// - rollWithModifier: rola dados com modificador
/// - rollComplexDice: rola expressões complexas como "5+1d3"
/// - rollForTable: rola para tabelas específicas
class DiceRollerService {
  final Random _random = Random();

  /// Rola um único dado do tipo especificado
  /// 
  /// [diceType] - O tipo de dado a ser rolado (d2, d3, d4, d6, d8, d10, d12, d20, d100)
  /// Retorna o resultado da rolagem
  int rollSingleDie(DiceType diceType) {
    return _random.nextInt(diceType.sides) + 1;
  }

  /// Rola múltiplos dados do mesmo tipo
  /// 
  /// [diceType] - O tipo de dado a ser rolado
  /// [count] - Quantidade de dados a rolar
  /// Retorna a soma dos resultados
  int rollMultipleDice(DiceType diceType, int count) {
    int total = 0;
    for (int i = 0; i < count; i++) {
      total += rollSingleDie(diceType);
    }
    return total;
  }

  /// Rola dados com um modificador
  /// 
  /// [diceType] - O tipo de dado a ser rolado
  /// [count] - Quantidade de dados a rolar
  /// [modifier] - Modificador a ser adicionado/subtraído
  /// Retorna a soma dos resultados + modificador
  int rollWithModifier(DiceType diceType, int count, int modifier) {
    int diceResult = rollMultipleDice(diceType, count);
    return diceResult + modifier;
  }

  /// Rola expressões complexas de dados
  /// 
  /// Suporta formatos como:
  /// - "5+1d3" (5 + resultado de 1d3)
  /// - "6d6" (6 dados de 6 lados)
  /// - "10d4" (10 dados de 4 lados)
  /// 
  /// [expression] - Expressão de dados no formato string
  /// Retorna o resultado da expressão
  int rollComplexDice(String expression) {
    expression = expression.trim().toLowerCase();
    
    // Padrão: "5+1d3" ou "8+1d4"
    if (expression.contains('+')) {
      final parts = expression.split('+');
      if (parts.length == 2) {
        final base = int.tryParse(parts[0].trim()) ?? 0;
        final diceExpression = parts[1].trim();
        final diceResult = _parseDiceExpression(diceExpression);
        return base + diceResult;
      }
    }
    
    // Padrão: "6d6" ou "10d4"
    return _parseDiceExpression(expression);
  }

  /// Rola dados para tabelas específicas
  /// 
  /// [sides] - Número de lados do dado
  /// [diceCount] - Quantidade de dados (padrão: 1)
  /// [modifier] - Modificador opcional
  /// Retorna o resultado da rolagem
  int rollForTable(int sides, {int diceCount = 1, int modifier = 0}) {
    DiceType diceType = _getDiceTypeFromSides(sides);
    return rollWithModifier(diceType, diceCount, modifier);
  }

  /// Converte número de lados para DiceType
  DiceType _getDiceTypeFromSides(int sides) {
    switch (sides) {
      case 2:
        return DiceType.d2;
      case 3:
        return DiceType.d3;
      case 4:
        return DiceType.d4;
      case 6:
        return DiceType.d6;
      case 8:
        return DiceType.d8;
      case 10:
        return DiceType.d10;
      case 12:
        return DiceType.d12;
      case 20:
        return DiceType.d20;
      case 100:
        return DiceType.d100;
      default:
        throw ArgumentError('Número de lados não suportado: $sides');
    }
  }

  /// Parse de expressões de dados como "6d6" ou "10d4"
  int _parseDiceExpression(String expression) {
    if (expression.contains('d')) {
      final parts = expression.split('d');
      if (parts.length == 2) {
        final count = int.tryParse(parts[0].trim()) ?? 1;
        final sides = int.tryParse(parts[1].trim()) ?? 6;
        final diceType = _getDiceTypeFromSides(sides);
        return rollMultipleDice(diceType, count);
      }
    }
    
    // Se não conseguir parsear, tenta como número simples
    return int.tryParse(expression) ?? 1;
  }

  /// Rola dados para quantidade de monstros baseado na expressão
  /// 
  /// [expression] - Expressão como "(3d6)", "(1d8)", "(2d4)", etc.
  /// Retorna a quantidade de monstros
  int rollForMonsterQuantity(String expression) {
    // Remove parênteses se existirem
    expression = expression.replaceAll(RegExp(r'[()]'), '');
    return rollComplexDice(expression);
  }

  /// Rola dados para quantidade de monstros com modificador de dificuldade
  /// 
  /// [expression] - Expressão como "(3d6)", "(1d8)", "(2d4)", etc.
  /// [difficultyModifier] - Modificador de dificuldade (0.5 = 50% menos, 1.5 = 50% mais)
  /// Retorna a quantidade de monstros ajustada
  int rollForMonsterQuantityWithDifficulty(String expression, double difficultyModifier) {
    int baseQuantity = rollForMonsterQuantity(expression);
    return (baseQuantity * difficultyModifier).round();
  }
} 