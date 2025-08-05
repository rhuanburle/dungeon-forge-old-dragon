import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';

void main() {
  group('Cave Tables Verification Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.17 - Verification Tests', () {
      test('Roll 1: Câmara larga + Jogue na coluna Especial + Fosso para baixo', () {
        final cave = service.generateCaveWithDetailedRolls(1, 1, 1, 1);
        print('=== ROLL 1 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é câmara larga
        expect(cave.chamberDetails!, contains('Câmara larga'));
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara larga \(\d+ x \d+ metros\)')));
        
        // Verificar se tem fosso para baixo
        expect(cave.chamberDetails!, contains('Fosso para baixo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Fosso para baixo \(\d+ metros e \d+ metros de largura\)')));
        
        print('✅ Roll 1 verification passed!');
      });

      test('Roll 2: Câmara pequena + Câmara vazia + Túnel para cima', () {
        final cave = service.generateCaveWithDetailedRolls(1, 2, 2, 2);
        print('=== ROLL 2 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é câmara pequena
        expect(cave.chamberDetails!, contains('Câmara pequena'));
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara pequena \(\d+ x \d+ metros\)')));
        
        // Verificar se tem câmara vazia
        expect(cave.chamberDetails!, contains('Câmara vazia'));
        
        // Verificar se tem túnel para cima
        expect(cave.chamberDetails!, contains('Túnel para cima'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel para cima \(\d+ metros e \d+ metros de diâmetro\)')));
        
        print('✅ Roll 2 verification passed!');
      });

      test('Roll 3: Corredor esquerda + Câmara vazia + Relíquias', () {
        final cave = service.generateCaveWithDetailedRolls(1, 3, 3, 3);
        print('=== ROLL 3 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é corredor em curva para a esquerda
        expect(cave.chamberDetails!, contains('Corredor em curva para a esquerda'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
        
        // Verificar se tem câmara vazia
        expect(cave.chamberDetails!, contains('Câmara vazia'));
        
        // Verificar se tem relíquias
        expect(cave.chamberDetails!, contains('Relíquias'));
        expect(cave.chamberDetails!, contains('tabela 4.6'));
        
        print('✅ Roll 3 verification passed!');
      });

      test('Roll 4: Corredor direita + Encontro no subterrâneo + Riacho subterrâneo', () {
        final cave = service.generateCaveWithDetailedRolls(1, 4, 4, 4);
        print('=== ROLL 4 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é corredor em curva para a direita
        expect(cave.chamberDetails!, contains('Corredor em curva para a direita'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
        
        // Verificar se tem encontro no subterrâneo
        expect(cave.chamberDetails!, contains('Encontro no subterrâneo'));
        
        // Verificar se tem riacho subterrâneo
        expect(cave.chamberDetails!, contains('Riacho subterrâneo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Riacho subterrâneo \(\d+ metros de largura\)')));
        
        print('✅ Roll 4 verification passed!');
      });

      test('Roll 5: Túnel estreito + Sem saída + Lago subterrâneo', () {
        final cave = service.generateCaveWithDetailedRolls(1, 5, 5, 5);
        print('=== ROLL 5 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é túnel estreito
        expect(cave.chamberDetails!, contains('Túnel estreito'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel estreito \(\d+ cm de largura\)')));
        
        // Verificar se tem sem saída
        expect(cave.chamberDetails!, contains('Sem saída'));
        expect(cave.chamberDetails!, contains('fim da caverna'));
        
        // Verificar se tem lago subterrâneo
        expect(cave.chamberDetails!, contains('Lago subterrâneo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Lago subterrâneo \(\d+ metros de profundidade\)')));
        
        print('✅ Roll 5 verification passed!');
      });

      test('Roll 6: Túnel baixo + Sem saída + Encruzilhada', () {
        final cave = service.generateCaveWithDetailedRolls(1, 6, 6, 6);
        print('=== ROLL 6 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se é túnel baixo
        expect(cave.chamberDetails!, contains('Túnel baixo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel baixo \(\d+ cm de altura\)')));
        
        // Verificar se tem sem saída
        expect(cave.chamberDetails!, contains('Sem saída'));
        expect(cave.chamberDetails!, contains('fim da caverna'));
        
        // Verificar se tem encruzilhada
        expect(cave.chamberDetails!, contains('Encruzilhada'));
        expect(cave.chamberDetails!, matches(RegExp(r'Encruzilhada para \d+ novas direções')));
        
        print('✅ Roll 6 verification passed!');
      });
    });

    group('Table 4.16 - Verification Tests', () {
      test('Roll 1: Buraco no chão + 1d10 Fungo Pigmeu', () {
        final cave = service.generateCaveWithRoll(1);
        print('=== TABLE 4.16 ROLL 1 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('Buraco no chão'));
        expect(cave.inhabitant, matches(RegExp(r'\d+ Fungo Pigmeu')));
        
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(10));
        
        print('✅ Table 4.16 Roll 1 verification passed!');
      });

      test('Roll 2: Fissura numa grande rocha + 1d6 Aranha Negra Gigante', () {
        final cave = service.generateCaveWithRoll(2);
        print('=== TABLE 4.16 ROLL 2 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('Fissura numa grande rocha'));
        expect(cave.inhabitant, matches(RegExp(r'\d+ Aranha Negra Gigante')));
        
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
        
        print('✅ Table 4.16 Roll 2 verification passed!');
      });

      test('Roll 3: Abertura em arco + 1d2 Urso Pardo', () {
        final cave = service.generateCaveWithRoll(3);
        print('=== TABLE 4.16 ROLL 3 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('Abertura em arco'));
        expect(cave.inhabitant, matches(RegExp(r'\d+ Urso Pardo')));
        
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(2));
        
        print('✅ Table 4.16 Roll 3 verification passed!');
      });

      test('Roll 4: Abertura estreita sob rocha + 1d6 Urso-Coruja', () {
        final cave = service.generateCaveWithRoll(4);
        print('=== TABLE 4.16 ROLL 4 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('Abertura estreita sob rocha'));
        expect(cave.inhabitant, matches(RegExp(r'\d+ Urso-Coruja')));
        
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
        
        print('✅ Table 4.16 Roll 4 verification passed!');
      });

      test('Roll 5: Por cima de um grupo de pedras + 1d4 Ettin', () {
        final cave = service.generateCaveWithRoll(5);
        print('=== TABLE 4.16 ROLL 5 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('Por cima de um grupo de pedras'));
        expect(cave.inhabitant, matches(RegExp(r'\d+ Ettin')));
        
        final number = int.parse(cave.inhabitant.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(4));
        
        print('✅ Table 4.16 Roll 5 verification passed!');
      });

      test('Roll 6: No fundo de um vau + 1 Dragão', () {
        final cave = service.generateCaveWithRoll(6);
        print('=== TABLE 4.16 ROLL 6 ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        
        expect(cave.entry, equals('No fundo de um vau'));
        expect(cave.inhabitant, equals('1 Dragão'));
        
        print('✅ Table 4.16 Roll 6 verification passed!');
      });
    });
  });
} 