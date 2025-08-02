import 'lib/utils/dice_roller.dart';
import 'lib/enums/dice_enums.dart';

void main() {
  // Criando instância do roller
  final roller = DiceRoller();
  
  // Exemplo 1: Rolagem simples usando enum
  final d20Roll = DiceRoll(type: DiceType.d20);
  final result = roller.roll(d20Roll);
  print('d20 roll: $result'); // Valor entre 1-20

  // Exemplo 2: Rolagem com múltiplos dados e modificador
  final attackRoll = DiceRoll(
    type: DiceType.d8,
    quantity: 2,
    modifier: 5,
  );
  final attackResult = roller.roll(attackRoll);
  print('2d8+5: $attackResult (Min: ${attackRoll.min}, Max: ${attackRoll.max})');

  // Exemplo 3: Criando rolagem a partir de notação RPG
  final fireball = DiceRoll.fromNotation('8d6');
  final fireDamage = roller.roll(fireball);
  print('Fireball damage: $fireDamage');

  // Exemplo 4: Múltiplas rolagens
  final initiativeRolls = roller.rollMultiple(
    DiceRoll(type: DiceType.d20, quantity: 1),
    5, // 5 jogadores
  );
  print('Initiative rolls: $initiativeRolls');

  // Exemplo 5: Usando métodos de compatibilidade
  final simpleRoll = DiceRoller.rollStatic(3, 6);
  print('3d6 (static): $simpleRoll');

  final formulaRoll = DiceRoller.rollFormula('2d6+3');
  print('2d6+3 (formula): $formulaRoll');

  // Exemplo 6: Rolagem com seed para resultados reproduzíveis
  final seededRoller = DiceRoller.withSeed(42);
  final seededResult = seededRoller.roll(DiceRoll(type: DiceType.d6));
  print('Seeded d6 roll: $seededResult');
} 