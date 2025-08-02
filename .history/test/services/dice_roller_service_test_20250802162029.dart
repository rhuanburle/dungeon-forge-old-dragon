import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/services/dice_roller_service.dart';
import 'package:dungeon_forge/enums/dice_enums.dart';

void main() {
  group('DiceRollerService', () {
    late DiceRollerService diceRoller;

    setUp(() {
      diceRoller = DiceRollerService();
    });

    group('rollSingleDie', () {
      test('deve rolar 1d6 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d6);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(6));
      });

      test('deve rolar 1d8 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d8);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(8));
      });

      test('deve rolar 1d10 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d10);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(10));
      });

      test('deve rolar 1d12 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d12);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(12));
      });

      test('deve rolar 1d20 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d20);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(20));
      });

      test('deve rolar 1d100 corretamente', () {
        final result = diceRoller.rollSingleDie(DiceType.d100);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(100));
      });
    });

    group('rollMultipleDice', () {
      test('deve rolar 2d6 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d6, 2);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(2)); // mínimo 2d6 = 2
        expect(result, lessThanOrEqualTo(12)); // máximo 2d6 = 12
      });

      test('deve rolar 3d6 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d6, 3);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(3)); // mínimo 3d6 = 3
        expect(result, lessThanOrEqualTo(18)); // máximo 3d6 = 18
      });

      test('deve rolar 4d4 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d4, 4);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(4)); // mínimo 4d4 = 4
        expect(result, lessThanOrEqualTo(16)); // máximo 4d4 = 16
      });

      test('deve rolar 1d8 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d8, 1);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(8));
      });

      test('deve rolar 2d4 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d4, 2);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(2)); // mínimo 2d4 = 2
        expect(result, lessThanOrEqualTo(8)); // máximo 2d4 = 8
      });

      test('deve rolar 1d2 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d2, 1);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(2));
      });

      test('deve rolar 1d3 corretamente', () {
        final result = diceRoller.rollMultipleDice(DiceType.d3, 1);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(3));
      });
    });

    group('rollWithModifier', () {
      test('deve rolar 1d6 + 2 corretamente', () {
        final result = diceRoller.rollWithModifier(DiceType.d6, 1, 2);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(3)); // mínimo 1d6 + 2 = 3
        expect(result, lessThanOrEqualTo(8)); // máximo 1d6 + 2 = 8
      });

      test('deve rolar 2d6 + 1 corretamente', () {
        final result = diceRoller.rollWithModifier(DiceType.d6, 2, 1);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(3)); // mínimo 2d6 + 1 = 3
        expect(result, lessThanOrEqualTo(13)); // máximo 2d6 + 1 = 13
      });

      test('deve rolar 1d8 - 1 corretamente', () {
        final result = diceRoller.rollWithModifier(DiceType.d8, 1, -1);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(0)); // mínimo 1d8 - 1 = 0
        expect(result, lessThanOrEqualTo(7)); // máximo 1d8 - 1 = 7
      });
    });

    group('rollComplexDice', () {
      test('deve rolar 5+1d3 cabeças (Hidra) corretamente', () {
        final result = diceRoller.rollComplexDice('5+1d3');
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(6)); // mínimo 5+1d3 = 6
        expect(result, lessThanOrEqualTo(8)); // máximo 5+1d3 = 8
      });

      test('deve rolar 8+1d4 cabeças (Hidra) corretamente', () {
        final result = diceRoller.rollComplexDice('8+1d4');
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(9)); // mínimo 8+1d4 = 9
        expect(result, lessThanOrEqualTo(12)); // máximo 8+1d4 = 12
      });

      test('deve rolar 6d6 corretamente', () {
        final result = diceRoller.rollComplexDice('6d6');
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(6)); // mínimo 6d6 = 6
        expect(result, lessThanOrEqualTo(36)); // máximo 6d6 = 36
      });

      test('deve rolar 10d4 corretamente', () {
        final result = diceRoller.rollComplexDice('10d4');
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(10)); // mínimo 10d4 = 10
        expect(result, lessThanOrEqualTo(40)); // máximo 10d4 = 40
      });
    });

    group('rollForTable', () {
      test('deve rolar para tabela 1d6 (fácil)', () {
        final result = diceRoller.rollForTable(6);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(6));
      });

      test('deve rolar para tabela 1d8 (extraplanar)', () {
        final result = diceRoller.rollForTable(8);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(8));
      });

      test('deve rolar para tabela 1d10 (médio)', () {
        final result = diceRoller.rollForTable(10);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(10));
      });

      test('deve rolar para tabela 1d12 (desafiador)', () {
        final result = diceRoller.rollForTable(12);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(12));
      });

      test('deve rolar para tabela 2d6 (humanos)', () {
        final result = diceRoller.rollForTable(6, diceCount: 2);
        
        expect(result, isA<int>());
        expect(result, greaterThanOrEqualTo(2)); // mínimo 2d6 = 2
        expect(result, lessThanOrEqualTo(12)); // máximo 2d6 = 12
      });
    });
  });
} 