// test/utils/dice_roller_test.dart

import 'package:test/test.dart';
import 'dart:math';
import '../../lib/utils/dice_roller.dart';

void main() {
  group('DiceRoller', () {
    group('roll', () {
      test('should return value between 1 and sides * times (inclusive)', () {
        for (int i = 0; i < 100; i++) {
          final result = DiceRoller.roll(2, 6);
          expect(result, greaterThanOrEqualTo(2));
          expect(result, lessThanOrEqualTo(12));
        }
      });

      test('should handle single die roll', () {
        for (int i = 0; i < 100; i++) {
          final result = DiceRoller.roll(1, 6);
          expect(result, greaterThanOrEqualTo(1));
          expect(result, lessThanOrEqualTo(6));
        }
      });

      test('should handle multiple dice', () {
        for (int i = 0; i < 100; i++) {
          final result = DiceRoller.roll(3, 6);
          expect(result, greaterThanOrEqualTo(3));
          expect(result, lessThanOrEqualTo(18));
        }
      });

      test('should handle different die sizes', () {
        for (int i = 0; i < 50; i++) {
          final result = DiceRoller.roll(1, 20);
          expect(result, greaterThanOrEqualTo(1));
          expect(result, lessThanOrEqualTo(20));
        }
      });
    });

    group('rollFormula', () {
      test('should parse and roll simple dice formula', () {
        for (int i = 0; i < 50; i++) {
          final result = DiceRoller.rollFormula('2d6');
          expect(result, greaterThanOrEqualTo(2));
          expect(result, lessThanOrEqualTo(12));
        }
      });

      test('should handle addition operator', () {
        for (int i = 0; i < 50; i++) {
          final result = DiceRoller.rollFormula('3d6+4');
          expect(result, greaterThanOrEqualTo(7)); // 3 + 4
          expect(result, lessThanOrEqualTo(22)); // 18 + 4
        }
      });

      test('should handle multiplication operators', () {
        for (int i = 0; i < 20; i++) {
          final result = DiceRoller.rollFormula('1d6*100');
          expect(result, greaterThanOrEqualTo(100));
          expect(result, lessThanOrEqualTo(600));
        }

        for (int i = 0; i < 20; i++) {
          final result = DiceRoller.rollFormula('1d6×100');
          expect(result, greaterThanOrEqualTo(100));
          expect(result, lessThanOrEqualTo(600));
        }

        for (int i = 0; i < 20; i++) {
          final result = DiceRoller.rollFormula('1d6x100');
          expect(result, greaterThanOrEqualTo(100));
          expect(result, lessThanOrEqualTo(600));
        }
      });

      test('should handle spaces in formula', () {
        for (int i = 0; i < 20; i++) {
          final result = DiceRoller.rollFormula('3d6 + 4');
          expect(result, greaterThanOrEqualTo(7));
          expect(result, lessThanOrEqualTo(22));
        }
      });

      test('should throw FormatException for invalid formulas', () {
        expect(() => DiceRoller.rollFormula('invalid'), throwsFormatException);
        expect(() => DiceRoller.rollFormula('d6'), throwsFormatException);
        expect(() => DiceRoller.rollFormula('2d'), throwsFormatException);
        expect(() => DiceRoller.rollFormula(''), throwsFormatException);
      });

      test('should handle specific formulas used in the app', () {
        // Testa fórmulas específicas usadas no gerador
        final formulas = [
          '3d6+4',
          '2d6+4',
          '1d6+4',
          '1d6+6',
          '2d6+6',
          '3d6+6',
          '1d6×100',
          '1d6×10',
          '1d4',
        ];

        for (final formula in formulas) {
          expect(() => DiceRoller.rollFormula(formula), returnsNormally);
        }
      });
    });
  });
}
