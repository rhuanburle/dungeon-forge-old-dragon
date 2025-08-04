import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';

void main() {
  group('Detailed Cave Tables Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.16 - Detailed Cave Entry Tests', () {
      test('should generate correct entry for roll 1', () {
        final cave = service.generateCaveWithRoll(1);
        print('Testing roll 1 - Entry: ${cave.entry}');
        expect(cave.entry, equals('Buraco no chão'));
      });

      test('should generate correct entry for roll 2', () {
        final cave = service.generateCaveWithRoll(2);
        print('Testing roll 2 - Entry: ${cave.entry}');
        expect(cave.entry, equals('Fissura numa grande rocha'));
      });

      test('should generate correct entry for roll 3', () {
        final cave = service.generateCaveWithRoll(3);
        print('Testing roll 3 - Entry: ${cave.entry}');
        expect(cave.entry, equals('Abertura em arco'));
      });

      test('should generate correct entry for roll 4', () {
        final cave = service.generateCaveWithRoll(4);
        print('Testing roll 4 - Entry: ${cave.entry}');
        expect(cave.entry, equals('Abertura estreita sob rocha'));
      });

      test('should generate correct entry for roll 5', () {
        final cave = service.generateCaveWithRoll(5);
        print('Testing roll 5 - Entry: ${cave.entry}');
        expect(cave.entry, equals('Por cima de um grupo de pedras'));
      });

      test('should generate correct entry for roll 6', () {
        final cave = service.generateCaveWithRoll(6);
        print('Testing roll 6 - Entry: ${cave.entry}');
        expect(cave.entry, equals('No fundo de um vau'));
      });
    });

    group('Table 4.16 - Detailed Cave Inhabitant Tests', () {
      test('should generate correct inhabitant for roll 1 (1d10 Fungo Pigmeu)', () {
        final cave = service.generateCaveWithRoll(1);
        print('Testing inhabitant roll 1 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, matches(RegExp(r'\d+ Fungo Pigmeu')));
        
        // Verificar se o número está entre 1 e 10
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(10));
      });

      test('should generate correct inhabitant for roll 2 (1d6 Aranha Negra Gigante)', () {
        final cave = service.generateCaveWithRoll(2);
        print('Testing inhabitant roll 2 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, matches(RegExp(r'\d+ Aranha Negra Gigante')));
        
        // Verificar se o número está entre 1 e 6
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
      });

      test('should generate correct inhabitant for roll 3 (1d2 Urso Pardo)', () {
        final cave = service.generateCaveWithRoll(3);
        print('Testing inhabitant roll 3 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, matches(RegExp(r'\d+ Urso Pardo')));
        
        // Verificar se o número está entre 1 e 2
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(2));
      });

      test('should generate correct inhabitant for roll 4 (1d6 Urso-Coruja)', () {
        final cave = service.generateCaveWithRoll(4);
        print('Testing inhabitant roll 4 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, matches(RegExp(r'\d+ Urso-Coruja')));
        
        // Verificar se o número está entre 1 e 6
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
      });

      test('should generate correct inhabitant for roll 5 (1d4 Ettin)', () {
        final cave = service.generateCaveWithRoll(5);
        print('Testing inhabitant roll 5 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, matches(RegExp(r'\d+ Ettin')));
        
        // Verificar se o número está entre 1 e 4
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(4));
      });

      test('should generate correct inhabitant for roll 6 (1 Dragão)', () {
        final cave = service.generateCaveWithRoll(6);
        print('Testing inhabitant roll 6 - Inhabitant: ${cave.inhabitant}');
        expect(cave.inhabitant, equals('1 Dragão'));
      });
    });

    group('Table 4.17 - Detailed Chamber Type Tests', () {
      test('should generate correct chamber type for roll 1 (Câmara larga)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 1, 2, 1);
        print('Testing chamber type roll 1 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Câmara larga'));
        
        // Verificar se tem dimensões corretas (1d10+10 x 1d10+10)
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara larga \(\d+ x \d+ metros\)')));
      });

      test('should generate correct chamber type for roll 2 (Câmara pequena)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 2, 2, 2);
        print('Testing chamber type roll 2 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Câmara pequena'));
        
        // Verificar se tem dimensões corretas (1d6+1 x 1d6+1)
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara pequena \(\d+ x \d+ metros\)')));
      });

      test('should generate correct chamber type for roll 3 (Corredor esquerda)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 3, 2, 3);
        print('Testing chamber type roll 3 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Corredor em curva para a esquerda'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
      });

      test('should generate correct chamber type for roll 4 (Corredor direita)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 4, 4, 4);
        print('Testing chamber type roll 4 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Corredor em curva para a direita'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
      });

      test('should generate correct chamber type for roll 5 (Túnel estreito)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 5, 5, 5);
        print('Testing chamber type roll 5 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Túnel estreito'));
        
        // Verificar se tem largura correta (1d6+2x10 cm)
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel estreito \(\d+ cm de largura\)')));
      });

      test('should generate correct chamber type for roll 6 (Túnel baixo)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 6, 6, 6);
        print('Testing chamber type roll 6 - Chamber: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Túnel baixo'));
        
        // Verificar se tem altura correta (1d6+2x10 cm)
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel baixo \(\d+ cm de altura\)')));
      });
    });

    group('Table 4.17 - Detailed Chamber Content Tests', () {
      test('should generate correct content for roll 1 (Jogue na coluna Especial)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 1, 1, 1);
        print('Testing content roll 1 - Content: ${cave.chamberDetails}');
        // Roll 1 deve resolver automaticamente para um especial
        expect(cave.chamberDetails!, contains('Fosso para baixo'));
      });

      test('should generate correct content for roll 2 (Câmara vazia)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 2, 2, 2);
        print('Testing content roll 2 - Content: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Câmara vazia'));
      });

      test('should generate correct content for roll 3 (Câmara vazia)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 3, 3, 3);
        print('Testing content roll 3 - Content: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Câmara vazia'));
      });

      test('should generate correct content for roll 4 (Encontro no subterrâneo)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 4, 4, 4);
        print('Testing content roll 4 - Content: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Encontro no subterrâneo'));
      });

      test('should generate correct content for roll 5 (Sem saída)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 5, 5, 5);
        print('Testing content roll 5 - Content: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Sem saída'));
      });

      test('should generate correct content for roll 6 (Sem saída)', () {
        final cave = service.generateCaveWithDetailedRolls(1, 6, 6, 6);
        print('Testing content roll 6 - Content: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Sem saída'));
      });
    });

    group('Table 4.17 - Detailed Chamber Special Tests', () {
      test('should generate correct special for roll 1 (Fosso para baixo)', () {
        final cave = service.generateCave();
        print('Testing special roll 1 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Fosso para baixo'));
        
        // Verificar se tem dimensões corretas (3d6+10 metros e 1d4+2 metros)
        expect(cave.chamberDetails!, matches(RegExp(r'Fosso para baixo \(\d+ metros e \d+ metros de largura\)')));
      });

      test('should generate correct special for roll 2 (Túnel para cima)', () {
        final cave = service.generateCave();
        print('Testing special roll 2 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Túnel para cima'));
        
        // Verificar se tem dimensões corretas (3d6+10 metros e 1d3 metros)
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel para cima \(\d+ metros e \d+ metros de diâmetro\)')));
      });

      test('should generate correct special for roll 3 (Relíquias)', () {
        final cave = service.generateCave();
        print('Testing special roll 3 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Relíquias'));
        expect(cave.chamberDetails!, contains('tabela 4.6'));
      });

      test('should generate correct special for roll 4 (Riacho subterrâneo)', () {
        final cave = service.generateCave();
        print('Testing special roll 4 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Riacho subterrâneo'));
        
        // Verificar se tem largura correta (2d6+1 metros)
        expect(cave.chamberDetails!, matches(RegExp(r'Riacho subterrâneo \(\d+ metros de largura\)')));
      });

      test('should generate correct special for roll 5 (Lago subterrâneo)', () {
        final cave = service.generateCave();
        print('Testing special roll 5 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Lago subterrâneo'));
        
        // Verificar se tem profundidade correta (1d6+1 metros)
        expect(cave.chamberDetails!, matches(RegExp(r'Lago subterrâneo \(\d+ metros de profundidade\)')));
      });

      test('should generate correct special for roll 6 (Encruzilhada)', () {
        final cave = service.generateCave();
        print('Testing special roll 6 - Special: ${cave.chamberDetails}');
        expect(cave.chamberDetails!, contains('Encruzilhada'));
        
        // Verificar se tem número de direções correto (1d3)
        expect(cave.chamberDetails!, matches(RegExp(r'Encruzilhada para \d+ novas direções')));
      });
    });
  });
} 