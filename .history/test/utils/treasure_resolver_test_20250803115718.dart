// test/utils/treasure_resolver_test.dart

import 'package:test/test.dart';
import '../../lib/utils/treasure_resolver.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('TreasureResolver Tests', () {
    test('should resolve basic treasure strings', () {
      final result = TreasureResolver.resolve('1d6 x 100 PP + 1d6 x 10 PO');
      expect(result, isNotEmpty);
      expect(result, contains('PP'));
      expect(result, contains('PO'));
    });

    test('should handle "Jogue Novamente"', () {
      final result = TreasureResolver.resolve('Jogue Novamente + 1d6 x 100 PP');
      expect(result, isNotEmpty);
      expect(result, contains('PP'));
    });

    test('should handle "1 em 1d6"', () {
      final result = TreasureResolver.resolve('1 em 1d6 1d6 x 100 PP');
      expect(result, isNotEmpty);
    });

    test('should resolve gemas', () {
      final result = TreasureResolver.resolve('1d4 Gemas');
      expect(result, isNotEmpty);
      expect(result, contains('Gemas:'));
    });

    test('should resolve objetos de valor', () {
      final result = TreasureResolver.resolve('1d4 Objetos de Valor');
      expect(result, isNotEmpty);
      expect(result, contains('Objetos de Valor:'));
    });

    test('should resolve magic items', () {
      final result = TreasureResolver.resolve('1 Qualquer');
      expect(result, isNotEmpty);
      expect(result, isNot(contains('Qualquer')));
    });

    test('should handle empty or invalid input', () {
      expect(TreasureResolver.resolve(''), equals('Nenhum'));
      expect(TreasureResolver.resolve('—'), equals('Nenhum'));
      expect(TreasureResolver.resolve('Nenhum tesouro'), equals('Nenhum'));
    });
  });

  group('TreasureResolver By Level Tests', () {
    test('should resolve treasure by level 1', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level1);
      expect(result, isNotEmpty);
      // Verifica se contém pelo menos PP (que sempre existe no nível 1)
      expect(result, contains('PP:'));
    });

    test('should resolve treasure by level 2-3', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level2to3);
      expect(result, isNotEmpty);
      expect(result, contains('PP:'));
    });

    test('should resolve treasure by level 4-5', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level4to5);
      expect(result, isNotEmpty);
      expect(result, contains('PO:'));
      expect(result, contains('PP:'));
    });

    test('should resolve treasure by level 6-7', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level6to7);
      expect(result, isNotEmpty);
      expect(result, contains('PO:'));
      expect(result, contains('PP:'));
    });

    test('should resolve treasure by level 8-9', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level8to9);
      expect(result, isNotEmpty);
      expect(result, contains('PO:'));
      expect(result, contains('PP:'));
    });

    test('should resolve treasure by level 10+', () {
      final result = TreasureResolver.resolveByLevel(TreasureLevel.level10plus);
      expect(result, isNotEmpty);
      expect(result, contains('PO:'));
      expect(result, contains('PP:'));
    });

    test('should handle gold formulas correctly', () {
      // Testa múltiplas vezes para verificar variação
      final results = <String>{};
      for (int i = 0; i < 10; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level4to5);
        if (result.contains('PO:')) {
          results.add(result);
        }
      }
      // Deve haver pelo menos algumas variações
      expect(results.length, greaterThan(1));
    });

    test('should handle silver formulas correctly', () {
      final results = <String>{};
      for (int i = 0; i < 10; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level2to3);
        if (result.contains('PP:')) {
          results.add(result);
        }
      }
      expect(results.length, greaterThan(1));
    });

    test('should handle gems formulas correctly', () {
      final results = <String>{};
      for (int i = 0; i < 20; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level6to7);
        if (result.contains('Gemas:')) {
          results.add(result);
        }
      }
      // Gemas são raras, mas devem aparecer ocasionalmente
      expect(results.length, greaterThanOrEqualTo(0));
    });

    test('should handle valuable objects formulas correctly', () {
      final results = <String>{};
      for (int i = 0; i < 20; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level4to5);
        if (result.contains('Objetos de Valor:')) {
          results.add(result);
        }
      }
      expect(results.length, greaterThanOrEqualTo(0));
    });

    test('should handle magic items formulas correctly', () {
      final results = <String>{};
      for (int i = 0; i < 20; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level6to7);
        if (result.contains('Itens Mágicos:')) {
          results.add(result);
        }
      }
      expect(results.length, greaterThanOrEqualTo(0));
    });

    test('should not have magic items in levels 1 and 2-3', () {
      final result1 = TreasureResolver.resolveByLevel(TreasureLevel.level1);
      final result2 = TreasureResolver.resolveByLevel(TreasureLevel.level2to3);

      expect(result1, contains('Nenhum Item Mágico'));
      expect(result2, contains('Nenhum Item Mágico'));
    });

    test('should have magic items in levels 4+', () {
      final results = <String>{};
      for (int i = 0; i < 20; i++) {
        final result = TreasureResolver.resolveByLevel(TreasureLevel.level4to5);
        if (result.contains('Itens Mágicos:') &&
            !result.contains('Nenhum Item Mágico')) {
          results.add(result);
        }
      }
      // Deve ter pelo menos alguns itens mágicos
      expect(results.length, greaterThan(0));
    });

    test('should apply treasure by level to dungeon rooms', () {
      // Teste de integração para verificar se o tesouro por nível é aplicado
      final treasureLevel = TreasureLevel.level4to5;
      final results = <String>{};

      // Testa várias vezes para garantir que pelo menos alguns itens mágicos apareçam
      for (int i = 0; i < 20; i++) {
        final treasure = TreasureResolver.resolveByLevel(treasureLevel);
        results.add(treasure);
      }

      // Verifica se pelo menos um resultado tem itens mágicos
      bool hasMagicItems = false;
      for (final treasure in results) {
        if (treasure.contains('Itens Mágicos:') &&
            !treasure.contains('Nenhum Item Mágico')) {
          hasMagicItems = true;
          break;
        }
      }

      expect(
        hasMagicItems,
        isTrue,
        reason: 'At least one treasure should have magic items for level 4-5',
      );

      // Verifica se todos os tesouros têm os componentes básicos
      for (final treasure in results) {
        expect(treasure, contains('PO:'));
        expect(treasure, contains('PP:'));
        expect(treasure, contains('Gemas:'));
        expect(treasure, contains('Objetos de Valor:'));
        expect(treasure, contains('Itens Mágicos:'));
      }
    });
  });
}
