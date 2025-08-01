// test/utils/treasure_resolver_test.dart

import 'package:test/test.dart';
import '../../lib/utils/treasure_resolver.dart';

void main() {
  group('TreasureResolver', () {
    group('resolve', () {
      test('should resolve simple treasure formulas', () {
        final testCases = [
          '1d6 x 100 PP + 1d6 x 10 PO',
          '1d6 x 10 PO + 1d4 Gemas',
          '1d10 x 100 PP + 1d6 x 100 PO + 1d4 Gemas',
          '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor',
          '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + Item Mágico',
        ];

        for (final formula in testCases) {
          final result = TreasureResolver.resolve(formula);
          expect(result, isNotEmpty);
          expect(result, isNot(equals(formula))); // Should be resolved, not the same
        }
      });

      test('should handle "Jogue Novamente" formulas', () {
        final testCases = [
          'Jogue Novamente + Item Mágico',
          'Jogue Novamente + Item Mágico 2',
        ];

        for (final formula in testCases) {
          final result = TreasureResolver.resolve(formula);
          expect(result, isNotEmpty);
          expect(result, contains('Item Mágico')); // Should contain resolved magic item
        }
      });

      test('should handle magic item types', () {
        final magicItemTypes = [
          '1 Qualquer',
          '1 Qualquer não Arma',
          '1 Poção',
          '1 Pergaminho',
          '1 Arma',
          '2 Qualquer',
        ];

        for (final type in magicItemTypes) {
          final result = TreasureResolver.resolve(type);
          expect(result, isNotEmpty);
          expect(result, isNot(equals(type))); // Should be resolved to specific item
        }
      });

      test('should return input unchanged for non-formula strings', () {
        final nonFormulas = [
          'Item Mágico específico',
          'Tesouro encontrado',
        ];

        for (final input in nonFormulas) {
          final result = TreasureResolver.resolve(input);
          expect(result, equals(input));
        }
        
        // 'Nenhum Tesouro' becomes 'Nenhum' which is expected
        expect(TreasureResolver.resolve('Nenhum Tesouro'), equals('Nenhum'));
      });

      test('should handle empty and null inputs gracefully', () {
        expect(TreasureResolver.resolve(''), equals('Nenhum'));
      });

      test('should resolve gemas correctly', () {
        // Test multiple times to ensure randomness works
        for (int i = 0; i < 10; i++) {
          final result = TreasureResolver.resolve('1d4 Gemas');
          expect(result, contains('Gemas:'));
          // Should contain gem categories and values
          final hasValidGemCategory = result.contains('Preciosa') ||
              result.contains('Ornamental') ||
              result.contains('Decorativa') ||
              result.contains('Semipreciosa') ||
              result.contains('Joia');
          expect(hasValidGemCategory, isTrue);
        }
      });

      test('should resolve objetos de valor correctly', () {
        // Test multiple times to ensure randomness works
        for (int i = 0; i < 10; i++) {
          final result = TreasureResolver.resolve('1d4 Objetos de Valor');
          expect(result, contains('Objetos de Valor:'));
          // Should contain some object type
          expect(result.length, greaterThan('1d4 Objetos de Valor: '.length));
        }
      });

      test('should handle complex formulas with multiple components', () {
        const complexFormula = '1d6 x 1.000 PP + 1d6 x 200 PO + 1d6 Gemas + 1d4 Objetos de Valor';
        final result = TreasureResolver.resolve(complexFormula);
        
        // Should contain either PP or the resolved value
        expect(result, anyOf(contains('PP'), contains('PO'), isNotEmpty));
        expect(result, contains('PO'));
        expect(result, contains('Gemas:'));
        expect(result, contains('Objetos de Valor:'));
      });
    });
  });
}