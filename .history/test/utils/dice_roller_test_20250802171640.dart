// test/utils/dice_roller_test.dart

import 'package:test/test.dart';
import 'dart:math';
import '../../lib/utils/dice_roller.dart';
import '../../lib/enums/dice_enums.dart';

void main() {
  group('DiceRoll', () {
    test('should create dice roll with correct properties', () {
      final diceRoll = DiceRoll(type: DiceType.d20, quantity: 2, modifier: 5);
      expect(diceRoll.type, equals(DiceType.d20));
      expect(diceRoll.quantity, equals(2));
      expect(diceRoll.modifier, equals(5));
    });

    test('should calculate min and max values correctly', () {
      final diceRoll = DiceRoll(type: DiceType.d6, quantity: 3, modifier: 2);
      expect(diceRoll.min, equals(5)); // 3 * 1 + 2
      expect(diceRoll.max, equals(20)); // 3 * 6 + 2
    });

    test('should create from notation correctly', () {
      final diceRoll = DiceRoll.fromNotation('2d6+3');
      expect(diceRoll.type, equals(DiceType.d6));
      expect(diceRoll.quantity, equals(2));
      expect(diceRoll.modifier, equals(3));
    });

    test('should handle notation without quantity', () {
      final diceRoll = DiceRoll.fromNotation('d20');
      expect(diceRoll.type, equals(DiceType.d20));
      expect(diceRoll.quantity, equals(1));
      expect(diceRoll.modifier, equals(0));
    });

    test('should handle notation without modifier', () {
      final diceRoll = DiceRoll.fromNotation('3d8');
      expect(diceRoll.type, equals(DiceType.d8));
      expect(diceRoll.quantity, equals(3));
      expect(diceRoll.modifier, equals(0));
    });

    test('should throw FormatException for invalid notation', () {
      expect(() => DiceRoll.fromNotation('invalid'), throwsFormatException);
      expect(() => DiceRoll.fromNotation('d'), throwsFormatException);
      expect(() => DiceRoll.fromNotation('2d'), throwsFormatException);
    });

    test('should throw ArgumentError for unsupported dice type', () {
      expect(() => DiceRoll.fromNotation('1d7'), throwsArgumentError);
    });

    test('should convert to string correctly', () {
      expect(DiceRoll(type: DiceType.d6).toString(), equals('1d6'));
      expect(DiceRoll(type: DiceType.d20, quantity: 2).toString(), equals('2d20'));
      expect(DiceRoll(type: DiceType.d8, quantity: 3, modifier: 5).toString(), equals('3d8+5'));
    });
  });

  group('DiceRoller', () {
    late DiceRoller roller;

    setUp(() {
      roller = DiceRoller();
    });

    test('should roll single dice correctly', () {
      final diceRoll = DiceRoll(type: DiceType.d20);
      for (int i = 0; i < 100; i++) {
        final result = roller.roll(diceRoll);
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(20));
      }
    });

    test('should roll multiple dice correctly', () {
      final diceRoll = DiceRoll(type: DiceType.d6, quantity: 3);
      for (int i = 0; i < 100; i++) {
        final result = roller.roll(diceRoll);
        expect(result, greaterThanOrEqualTo(3));
        expect(result, lessThanOrEqualTo(18));
      }
    });

    test('should apply modifier correctly', () {
      final diceRoll = DiceRoll(type: DiceType.d8, quantity: 2, modifier: 5);
      for (int i = 0; i < 100; i++) {
        final result = roller.roll(diceRoll);
        expect(result, greaterThanOrEqualTo(7)); // 2 + 5
        expect(result, lessThanOrEqualTo(21)); // 16 + 5
      }
    });

    test('should roll multiple times correctly', () {
      final diceRoll = DiceRoll(type: DiceType.d6);
      final results = roller.rollMultiple(diceRoll, 5);
      expect(results.length, equals(5));
      for (final result in results) {
        expect(result, greaterThanOrEqualTo(1));
        expect(result, lessThanOrEqualTo(6));
      }
    });

    test('should work with seed for reproducible results', () {
      final seededRoller1 = DiceRoller.withSeed(42);
      final seededRoller2 = DiceRoller.withSeed(42);
      final diceRoll = DiceRoll(type: DiceType.d20);
      final result1 = seededRoller1.roll(diceRoll);
      final result2 = seededRoller2.roll(diceRoll);
      expect(result1, equals(result2));
    });
  });

  group('DiceRoller static methods (compatibility)', () {
    test('should roll static method correctly', () {
      for (int i = 0; i < 100; i++) {
        final result = DiceRoller.rollStatic(2, 6);
        expect(result, greaterThanOrEqualTo(2));
        expect(result, lessThanOrEqualTo(12));
      }
    });

    test('should handle rollFormula correctly', () {
      for (int i = 0; i < 50; i++) {
        final result = DiceRoller.rollFormula('3d6+4');
        expect(result, greaterThanOrEqualTo(7)); // 3 + 4
        expect(result, lessThanOrEqualTo(22)); // 18 + 4
      }
    });

    test('should handle simple formulas', () {
      for (int i = 0; i < 50; i++) {
        final result = DiceRoller.rollFormula('2d6');
        expect(result, greaterThanOrEqualTo(2));
        expect(result, lessThanOrEqualTo(12));
      }
    });

    test('should throw for unsupported dice in static method', () {
      expect(() => DiceRoller.rollStatic(1, 7), throwsArgumentError);
    });
  });
}
