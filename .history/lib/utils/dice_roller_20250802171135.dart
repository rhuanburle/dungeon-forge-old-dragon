// utils/dice_roller.dart

import 'dart:math';
import '../models/dice_roll.dart';

/// Classe responsável por executar as rolagens
class DiceRoller {
  final Random _random;

  DiceRoller() : _random = Random();

  DiceRoller.withSeed(int seed) : _random = Random(seed);

  /// Executa uma rolagem única
  int roll(DiceRoll diceRoll) {
    var total = 0;
    for (var i = 0; i < diceRoll.quantity; i++) {
      total += _random.nextInt(diceRoll.type.sides) + 1;
    }
    return total + diceRoll.modifier;
  }

  /// Executa múltiplas rolagens do mesmo tipo
  List<int> rollMultiple(DiceRoll diceRoll, int times) {
    return List.generate(times, (_) => roll(diceRoll));
  }

  // Métodos estáticos para compatibilidade com código existente
  static final _rand = Random();

  /// Rolls [times] dice, each with [sides] sides.
  /// Returns the total value rolled.
  static int roll(int times, int sides) {
    int total = 0;
    for (int i = 0; i < times; i++) {
      total += _rand.nextInt(sides) + 1; // 1..sides inclusive
    }
    return total;
  }

  /// Parses and rolls a notation like `3d6+4` or `1d6*100`.
  /// Supports:
  ///   – Addition (+N)
  ///   – Multiplication (*N or ×N)
  /// Returns the computed result.
  /// Throws FormatException on malformed input.
  static int rollFormula(String formula) {
    final diceRegex = RegExp(r'^(\d+)d(\d+)([+x\*×]?)(\d+)?');
    final match = diceRegex.firstMatch(formula.replaceAll(" ", ""));
    if (match == null) throw FormatException('Invalid dice formula: $formula');

    final times = int.parse(match.group(1)!);
    final sides = int.parse(match.group(2)!);
    final operator = match.group(3);
    final operandStr = match.group(4);

    int base = roll(times, sides);

    if (operator != null && operator.isNotEmpty && operandStr != null) {
      final operand = int.parse(operandStr);
      switch (operator) {
        case '+':
          base += operand;
          break;
        case '*':
        case 'x':
        case '×':
          base *= operand;
          break;
        default:
          throw FormatException('Unsupported operator in formula: $operator');
      }
    }
    return base;
  }
}
