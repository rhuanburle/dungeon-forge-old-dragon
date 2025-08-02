// test/utils/treasure_resolver_refactored_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:dungeon_forge/utils/treasure_resolver.dart';
import 'package:dungeon_forge/utils/treasure_parser.dart';
import 'package:dungeon_forge/utils/gem_resolver.dart';
import 'package:dungeon_forge/utils/valuable_object_resolver.dart';
import 'package:dungeon_forge/utils/magic_item_resolver.dart';

void main() {
  group('TreasureResolver Refactored', () {
    test('should resolve basic treasure formulas', () {
      final result = TreasureResolver.resolve('1d6×100 PP + 1d6×10 PO');
      
      expect(result, isNotEmpty);
      expect(result, contains('PP'));
      expect(result, contains('PO'));
      expect(result, isNot(contains('()')));
    });

    test('should resolve gem formulas', () {
      final result = TreasureResolver.resolve('1d4 Gemas');
      
      expect(result, isNotEmpty);
      expect(result, contains('Gemas:'));
      expect(result, contains('('));
      expect(result, contains(')'));
    });

    test('should resolve valuable objects formulas', () {
      final result = TreasureResolver.resolve('1d4 Objetos de Valor');
      
      expect(result, isNotEmpty);
      expect(result, contains('Objetos de Valor:'));
    });

    test('should resolve magic items', () {
      final result = TreasureResolver.resolve('1 Qualquer');
      
      expect(result, isNotEmpty);
      expect(result, isNot(equals('1 Qualquer')));
    });

    test('should handle empty treasure', () {
      final result = TreasureResolver.resolve('Nenhum');
      
      expect(result, equals('Nenhum'));
    });

    test('should handle "Jogue Novamente"', () {
      final result = TreasureResolver.resolve('Jogue Novamente + 1d6×100 PP');
      
      expect(result, isNotEmpty);
      expect(result, contains('PP'));
      expect(result, isNot(contains('Jogue Novamente')));
    });

    test('should handle "1 em 1d6"', () {
      final result = TreasureResolver.resolve('1 em 1d6 1d6×100 PP');
      
      expect(result, isNotEmpty);
      // Pode retornar 'Nenhum' ou o tesouro, dependendo do roll
      expect(result == 'Nenhum' || result.contains('PP'), isTrue);
    });
  });

  group('TreasureParser', () {
    test('should parse dice components', () {
      final components = TreasureParser.parse('1d6×100 PP');
      
      expect(components, hasLength(1));
      expect(components.first.type, equals(TreasureComponentType.dice));
      expect(components.first.unit, equals('PP'));
    });

    test('should parse magic item components', () {
      final components = TreasureParser.parse('1 Qualquer');
      
      expect(components, hasLength(1));
      expect(components.first.type, equals(TreasureComponentType.magicItem));
    });

    test('should ignore standalone numbers', () {
      final components = TreasureParser.parse('5 + 1d6×100 PP');
      
      expect(components, hasLength(1));
      expect(components.first.type, equals(TreasureComponentType.dice));
    });

    test('should parse empty treasure', () {
      final components = TreasureParser.parse('Nenhum');
      
      expect(components, hasLength(1));
      expect(components.first.type, equals(TreasureComponentType.empty));
    });
  });

  group('GemResolver', () {
    test('should resolve gems', () {
      final result = GemResolver.resolve(3);
      
      expect(result, isNotEmpty);
      expect(result, contains(','));
      expect(result.split(','), hasLength(3));
    });

    test('should resolve single gem', () {
      final result = GemResolver.resolve(1);
      
      expect(result, isNotEmpty);
      expect(result, contains('('));
      expect(result, contains(')'));
    });
  });

  group('ValuableObjectResolver', () {
    test('should resolve valuable objects', () {
      final result = ValuableObjectResolver.resolve(2);
      
      expect(result, isNotEmpty);
      expect(result, contains(','));
      expect(result.split(','), hasLength(2));
    });

    test('should resolve single valuable object', () {
      final result = ValuableObjectResolver.resolve(1);
      
      expect(result, isNotEmpty);
      expect(result, isNot(contains(',')));
    });
  });

  group('MagicItemResolver', () {
    test('should resolve magic items', () {
      final result = MagicItemResolver.resolve('1 Qualquer');
      
      expect(result, isNotEmpty);
      expect(result, isNot(equals('1 Qualquer')));
    });

    test('should resolve weapon magic items', () {
      final result = MagicItemResolver.resolve('1 Arma');
      
      expect(result, isNotEmpty);
      expect(result, isNot(equals('1 Arma')));
    });

    test('should resolve potion magic items', () {
      final result = MagicItemResolver.resolve('1 Poção');
      
      expect(result, isNotEmpty);
      expect(result, isNot(equals('1 Poção')));
    });
  });
} 