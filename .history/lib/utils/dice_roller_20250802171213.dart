// utils/dice_roller.dart

import 'dart:math';

/// Utility that encapsulates common dice-rolling behaviour.
/// Allows rolling like 2d6, 3d6+4, 1d6×100 etc.
class DiceRoller {
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
