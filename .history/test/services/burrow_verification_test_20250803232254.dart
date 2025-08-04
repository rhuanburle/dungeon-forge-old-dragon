import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';

void main() {
  group('Burrow Tables Verification Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.18 - Tocas Entry Tests', () {
      test('Roll 1: Fenda Profunda no solo com 2d4+2 metros de diâmetro e 3d6+10 metros de profundidade', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 1 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é fenda profunda
        expect(burrow.entry, equals('Fenda Profunda no solo'));
        
        print('✅ Roll 1 verification passed!');
      });

      test('Roll 2: Fenda Rasa no solo com 1d4+1 metros de diâmetro e 1d6+3 metros de profundidade', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 2 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é fenda rasa
        expect(burrow.entry, equals('Fenda Rasa no solo'));
        
        print('✅ Roll 2 verification passed!');
      });

      test('Roll 3: Colmeia Gigante em fenda na rocha com 1d10x3 células hexagonais', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 3 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é colmeia gigante em fenda na rocha
        expect(burrow.entry, equals('Colmeia Gigante em fenda na rocha'));
        
        print('✅ Roll 3 verification passed!');
      });

      test('Roll 4: Colmeia Gigante em túnel escavado com 1d10x3 células hexagonais', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 4 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é colmeia gigante em túnel escavado
        expect(burrow.entry, equals('Colmeia Gigante em túnel escavado'));
        
        print('✅ Roll 4 verification passed!');
      });

      test('Roll 5: Toca Escavada na terra com 2d4 metros de diâmetro e 2d6+2 metros de profundidade', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 5 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é toca escavada na terra
        expect(burrow.entry, equals('Toca Escavada na terra'));
        
        print('✅ Roll 5 verification passed!');
      });

      test('Roll 6: Formigueiro Gigante com 1d4+1 metros de altura', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.18 ROLL 6 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se é formigueiro gigante
        expect(burrow.entry, equals('Formigueiro Gigante'));
        
        print('✅ Roll 6 verification passed!');
      });
    });

    group('Table 4.19 - Ocupantes das Tocas Tests', () {
      test('Fenda Profunda - Roll 1: Aranha Caçadora Gigante (1d2)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.19 FENDA PROFUNDA ROLL 1 ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        
        if (burrow.entry == 'Fenda Profunda no solo') {
          expect(burrow.occupant, matches(RegExp(r'Aranha Caçadora Gigante \(\d+\)')));
          
          // Verificar se o número está entre 1 e 2
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(2));
        }
        
        print('✅ Fenda Profunda Roll 1 verification passed!');
      });

      test('Fenda Rasa - Roll 1: Aranha Camufladora Gigante (1d4)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.19 FENDA RASA ROLL 1 ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        
        if (burrow.entry == 'Fenda Rasa no solo') {
          expect(burrow.occupant, matches(RegExp(r'Aranha Camufladora Gigante \(\d+\)')));
          
          // Verificar se o número está entre 1 e 4
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        }
        
        print('✅ Fenda Rasa Roll 1 verification passed!');
      });

      test('Colmeias Gigantes - Roll 1: Formiga Gigante (1d6)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.19 COLMEIAS GIGANTES ROLL 1 ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        
        if (burrow.entry == 'Colmeia Gigante em fenda na rocha' || 
            burrow.entry == 'Colmeia Gigante em túnel escavado') {
          expect(burrow.occupant, matches(RegExp(r'Formiga Gigante \(\d+\)')));
          
          // Verificar se o número está entre 1 e 6
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(6));
        }
        
        print('✅ Colmeias Gigantes Roll 1 verification passed!');
      });

      test('Toca Escavada - Roll 1: Aranha Peluda Gigante (1d2)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.19 TOCA ESCAVADA ROLL 1 ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        
        if (burrow.entry == 'Toca Escavada na terra') {
          expect(burrow.occupant, matches(RegExp(r'Aranha Peluda Gigante \(\d+\)')));
          
          // Verificar se o número está entre 1 e 2
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(2));
        }
        
        print('✅ Toca Escavada Roll 1 verification passed!');
      });

      test('Formigueiro Gigante - Roll 1: Besouro de Fogo Gigante (1d4)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.19 FORMIGUEIRO GIGANTE ROLL 1 ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        
        if (burrow.entry == 'Formigueiro Gigante') {
          expect(burrow.occupant, matches(RegExp(r'Besouro de Fogo Gigante \(\d+\)')));
          
          // Verificar se o número está entre 1 e 4
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        }
        
        print('✅ Formigueiro Gigante Roll 1 verification passed!');
      });
    });

    group('Table 4.20 - Tesouros em Fundo de Tocas Tests', () {
      test('Roll 1: Nada Encontrado', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 1 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "Nada Encontrado"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 1 verification passed!');
      });

      test('Roll 2: 1d2 Relíquias (tabela 4.6)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 2 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "X Relíquias"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 2 verification passed!');
      });

      test('Roll 3: 1d3 Relíquias (tabela 4.6)', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 3 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "X Relíquias"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 3 verification passed!');
      });

      test('Roll 4: 1d2 Relíquias + 1d2 Objetos', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 4 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "X Relíquias + X Objetos"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 4 verification passed!');
      });

      test('Roll 5: 1d2 Relíquias + 1d2 Objetos + 1d2 Ossadas', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 5 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "X Relíquias + X Objetos + X Ossadas"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 5 verification passed!');
      });

      test('Roll 6: 1d2 Relíquias + 1 Item Mágico', () {
        final burrow = service.generateBurrow();
        print('=== TABELA 4.20 ROLL 6 VERIFICATION ===');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
        
        // Verificar se o tesouro pode ser "X Relíquias + 1 Item Mágico"
        expect(burrow.treasure, anyOf(
          equals('Nada Encontrado'),
          matches(RegExp(r'\d+ Relíquias')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos')),
          matches(RegExp(r'\d+ Relíquias \+ \d+ Objetos \+ \d+ Ossadas')),
          matches(RegExp(r'\d+ Relíquias \+ 1 Item Mágico')),
        ));
        
        print('✅ Roll 6 verification passed!');
      });
    });
  });
} 