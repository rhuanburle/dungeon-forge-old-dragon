import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';

void main() {
  group('Complete Burrow Tables Verification Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.19 - Complete Ocupantes das Tocas Tests', () {
      group('Fenda Profunda - All Occupants', () {
        test('Roll 1: Aranha Caçadora Gigante (1d2)', () {
          final burrow = service.generateBurrowWithRoll(1, 1, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Caçadora Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(2));
        });

        test('Roll 2: Centopeia Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(1, 2, 1);
          expect(burrow.occupant, matches(RegExp(r'Centopeia Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 3: Escorpião Gigante (1d6)', () {
          final burrow = service.generateBurrowWithRoll(1, 3, 1);
          expect(burrow.occupant, matches(RegExp(r'Escorpião Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(6));
        });

        test('Roll 4: Víbora Gigante (1d4)', () {
          final burrow = service.generateBurrowWithRoll(1, 4, 1);
          expect(burrow.occupant, matches(RegExp(r'Víbora Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 5: Aranha Negra Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(1, 5, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Negra Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });

        test('Roll 6: Lagarto Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(1, 6, 1);
          expect(burrow.occupant, matches(RegExp(r'Lagarto Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });
      });

      group('Fenda Rasa - All Occupants', () {
        test('Roll 1: Aranha Camufladora Gigante (1d4)', () {
          final burrow = service.generateBurrowWithRoll(2, 1, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Camufladora Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 2: Besouro de Fogo Gigante (1d4)', () {
          final burrow = service.generateBurrowWithRoll(2, 2, 1);
          expect(burrow.occupant, matches(RegExp(r'Besouro de Fogo Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 3: Besouro Bombardeiro Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(2, 3, 1);
          expect(burrow.occupant, matches(RegExp(r'Besouro Bombardeiro Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });

        test('Roll 4: Centopeia Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(2, 4, 1);
          expect(burrow.occupant, matches(RegExp(r'Centopeia Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 5: Sapo Gigante (2d6)', () {
          final burrow = service.generateBurrowWithRoll(2, 5, 1);
          expect(burrow.occupant, matches(RegExp(r'Sapo Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(12));
        });

        test('Roll 6: Rato Gigante (2d8)', () {
          final burrow = service.generateBurrowWithRoll(2, 6, 1);
          expect(burrow.occupant, matches(RegExp(r'Rato Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(16));
        });
      });

      group('Colmeias Gigantes - All Occupants', () {
        test('Roll 1: Formiga Gigante (1d6)', () {
          final burrow = service.generateBurrowWithRoll(3, 1, 1);
          expect(burrow.occupant, matches(RegExp(r'Formiga Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(6));
        });

        test('Roll 2: Mosca Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(3, 2, 1);
          expect(burrow.occupant, matches(RegExp(r'Mosca Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 3: Vespa Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(3, 3, 1);
          expect(burrow.occupant, matches(RegExp(r'Vespa Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 4: Stirge (1d4)', () {
          final burrow = service.generateBurrowWithRoll(3, 4, 1);
          expect(burrow.occupant, matches(RegExp(r'Stirge \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 5: Abelhas Assassinas (2d4)', () {
          final burrow = service.generateBurrowWithRoll(3, 5, 1);
          expect(burrow.occupant, matches(RegExp(r'Abelhas Assassinas \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 6: Aranha Negra Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(3, 6, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Negra Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });
      });

      group('Toca Escavada - All Occupants', () {
        test('Roll 1: Aranha Peluda Gigante (1d2)', () {
          final burrow = service.generateBurrowWithRoll(5, 1, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Peluda Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(2));
        });

        test('Roll 2: Aranha Camufladora Gigante (1d4)', () {
          final burrow = service.generateBurrowWithRoll(5, 2, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Camufladora Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 3: Centopeia Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(5, 3, 1);
          expect(burrow.occupant, matches(RegExp(r'Centopeia Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });

        test('Roll 4: Besouro Bombardeiro Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(5, 4, 1);
          expect(burrow.occupant, matches(RegExp(r'Besouro Bombardeiro Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });

        test('Roll 5: Lagarto Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(5, 5, 1);
          expect(burrow.occupant, matches(RegExp(r'Lagarto Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });

        test('Roll 6: Rato Gigante (2d8)', () {
          final burrow = service.generateBurrowWithRoll(5, 6, 1);
          expect(burrow.occupant, matches(RegExp(r'Rato Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(16));
        });
      });

      group('Formigueiro Gigante - All Occupants', () {
        test('Roll 1: Besouro de Fogo Gigante (1d4)', () {
          final burrow = service.generateBurrowWithRoll(6, 1, 1);
          expect(burrow.occupant, matches(RegExp(r'Besouro de Fogo Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(4));
        });

        test('Roll 2: Formiga Gigante (1d6)', () {
          final burrow = service.generateBurrowWithRoll(6, 2, 1);
          expect(burrow.occupant, matches(RegExp(r'Formiga Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(6));
        });

        test('Roll 3: Escorpião Gigante (1d6)', () {
          final burrow = service.generateBurrowWithRoll(6, 3, 1);
          expect(burrow.occupant, matches(RegExp(r'Escorpião Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(6));
        });

        test('Roll 4: Aranha Negra Gigante (1d3)', () {
          final burrow = service.generateBurrowWithRoll(6, 4, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Negra Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(3));
        });

        test('Roll 5: Aranha Peluda Gigante (1d2)', () {
          final burrow = service.generateBurrowWithRoll(6, 5, 1);
          expect(burrow.occupant, matches(RegExp(r'Aranha Peluda Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(1));
          expect(number, lessThanOrEqualTo(2));
        });

        test('Roll 6: Centopeia Gigante (2d4)', () {
          final burrow = service.generateBurrowWithRoll(6, 6, 1);
          expect(burrow.occupant, matches(RegExp(r'Centopeia Gigante \(\d+\)')));
          final number = int.parse(burrow.occupant.split('(')[1].split(')')[0]);
          expect(number, greaterThanOrEqualTo(2));
          expect(number, lessThanOrEqualTo(8));
        });
      });
    });

    group('Table 4.20 - Complete Tesouros Tests', () {
      test('Roll 1: Nada Encontrado', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 1);
        expect(burrow.treasure, equals('Nada Encontrado'));
      });

      test('Roll 2: 1d2 Relíquias (tabela 4.6)', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 2);
        expect(burrow.treasure, matches(RegExp(r'\d+ Relíquias \(tabela 4\.6\)')));
        final number = int.parse(burrow.treasure.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(2));
      });

      test('Roll 3: 1d3 Relíquias (tabela 4.6)', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 3);
        expect(burrow.treasure, matches(RegExp(r'\d+ Relíquias \(tabela 4\.6\)')));
        final number = int.parse(burrow.treasure.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(3));
      });

      test('Roll 4: 1d2 Relíquias + 1d2 Objetos', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 4);
        expect(burrow.treasure, matches(RegExp(r'\d+ Relíquias \(tabela 4\.6\) \+ \d+ Objetos \(tabela 4\.8\)')));
      });

      test('Roll 5: 1d2 Relíquias + 1d2 Objetos + 1d2 Ossadas', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 5);
        expect(burrow.treasure, matches(RegExp(r'\d+ Relíquias \(tabela 4\.6\) \+ \d+ Objetos \(tabela 4\.8\) \+ \d+ Ossadas \(tabela 4\.11\)')));
      });

      test('Roll 6: 1d2 Relíquias + 1 Item Mágico', () {
        final burrow = service.generateBurrowWithRoll(1, 1, 6);
        expect(burrow.treasure, matches(RegExp(r'\d+ Relíquias \(tabela 4\.6\) \+ 1 Item Mágico \(tabela 4\.12\)')));
      });
    });
  });
} 