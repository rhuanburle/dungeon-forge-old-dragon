import 'dart:math';

import '../enums/dice_enums.dart';

// Classe que representa uma rolagem de dados
class DiceRoll {
  final DiceType type;
  final int quantity;
  final int modifier;

  const DiceRoll({required this.type, this.quantity = 1, this.modifier = 0})
    : assert(quantity > 0, 'Quantity must be at least 1'),
      assert(modifier >= 0, 'Modifier must be non-negative');

  // Método de fábrica para criar rolagens com notação RPG
  factory DiceRoll.fromNotation(String notation) {
    final exp = notation.replaceAll(' ', '').toLowerCase();
    final regex = RegExp(r'^(\d+)?d(\d+)([+-]\d+)?$');
    final match = regex.firstMatch(exp);

    if (match == null)
      throw FormatException('Invalid dice notation: $notation');

    final qty = int.tryParse(match[1] ?? '1') ?? 1;
    final sides = int.parse(match[2]!);
    final mod = int.tryParse(match[3] ?? '0') ?? 0;

    final type = DiceType.values.firstWhere(
      (d) => d.sides == sides,
      orElse: () => throw ArgumentError('Unsupported dice type: d$sides'),
    );

    return DiceRoll(type: type, quantity: qty, modifier: mod);
  }

  // Calcula o valor mínimo possível
  int get min => quantity * 1 + modifier;

  // Calcula o valor máximo possível
  int get max => quantity * type.sides + modifier;

  @override
  String toString() {
    final modStr = modifier != 0 ? '${modifier >= 0 ? '+' : ''}$modifier' : '';
    return '${quantity}d${type.sides}$modStr';
  }
}

// Classe responsável por executar as rolagens
class DiceRoller {
  final Random _random;

  DiceRoller() : _random = Random();

  DiceRoller.withSeed(int seed) : _random = Random(seed);

  // Executa uma rolagem única
  int roll(DiceRoll diceRoll) {
    var total = 0;
    for (var i = 0; i < diceRoll.quantity; i++) {
      total += _random.nextInt(diceRoll.type.sides) + 1;
    }
    return total + diceRoll.modifier;
  }

  // Executa múltiplas rolagens do mesmo tipo
  List<int> rollMultiple(DiceRoll diceRoll, int times) {
    return List.generate(times, (_) => roll(diceRoll));
  }

  // Métodos de conveniência para compatibilidade com código existente
  static int rollStatic(int times, int sides) {
    final roller = DiceRoller();
    final diceType = DiceType.values.firstWhere(
      (d) => d.sides == sides,
      orElse: () => throw ArgumentError('Unsupported dice type: d$sides'),
    );
    return roller.roll(DiceRoll(type: diceType, quantity: times));
  }

  static int rollFormula(String formula) {
    final roller = DiceRoller();
    return roller.roll(DiceRoll.fromNotation(formula));
  }
}
