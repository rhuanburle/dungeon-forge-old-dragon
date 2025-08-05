import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';

void main() {
  group('Cave Column Verification Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.17 Column Alignment Tests', () {
      test('Roll 1: Tipo=Câmara larga, Conteúdo=Jogue na coluna Especial, Especial=Fosso para baixo', () {
        // Roll 1 da tabela 4.17 deve ter:
        // - Tipo: Câmara larga (1d10+10 x 1d10+10 metros)
        // - Conteúdo: Jogue na coluna Especial (deve resolver para um especial)
        // - Especial: Fosso para baixo (3d6+10 metros e 1d4+2 metros de largura)
        
        final cave = service.generateCaveWithDetailedRolls(1, 1, 1, 1);
        print('=== TABELA 4.17 ROLL 1 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é câmara larga
        expect(cave.chamberDetails!, contains('Câmara larga'));
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara larga \(\d+ x \d+ metros\)')));
        
        // Verificar se o conteúdo resolveu para um especial (já que "Jogue na coluna Especial")
        expect(cave.chamberDetails!, anyOf(
          contains('Fosso para baixo'),
          contains('Túnel para cima'),
          contains('Relíquias'),
          contains('Riacho subterrâneo'),
          contains('Lago subterrâneo'),
          contains('Encruzilhada'),
        ));
        
        // Verificar se o especial é fosso para baixo
        expect(cave.chamberDetails!, contains('Fosso para baixo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Fosso para baixo \(\d+ metros e \d+ metros de largura\)')));
        
        print('✅ Roll 1 column alignment verified!');
      });

      test('Roll 2: Tipo=Câmara pequena, Conteúdo=Câmara vazia, Especial=Túnel para cima', () {
        // Roll 2 da tabela 4.17 deve ter:
        // - Tipo: Câmara pequena (1d6+1 x 1d6+1 metros)
        // - Conteúdo: Câmara vazia
        // - Especial: Túnel para cima (3d6+10 metros e 1d3 metros de diâmetro)
        
        final cave = service.generateCaveWithDetailedRolls(1, 2, 2, 2);
        print('=== TABELA 4.17 ROLL 2 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é câmara pequena
        expect(cave.chamberDetails!, contains('Câmara pequena'));
        expect(cave.chamberDetails!, matches(RegExp(r'Câmara pequena \(\d+ x \d+ metros\)')));
        
        // Verificar se o conteúdo é câmara vazia
        expect(cave.chamberDetails!, contains('Câmara vazia'));
        
        // Verificar se o especial é túnel para cima
        expect(cave.chamberDetails!, contains('Túnel para cima'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel para cima \(\d+ metros e \d+ metros de diâmetro\)')));
        
        print('✅ Roll 2 column alignment verified!');
      });

      test('Roll 3: Tipo=Corredor esquerda, Conteúdo=Câmara vazia, Especial=Relíquias', () {
        // Roll 3 da tabela 4.17 deve ter:
        // - Tipo: Corredor em curva para a esquerda (1 metro de diâmetro)
        // - Conteúdo: Câmara vazia
        // - Especial: Relíquias (tabela 4.6)
        
        final cave = service.generateCaveWithDetailedRolls(1, 3, 3, 3);
        print('=== TABELA 4.17 ROLL 3 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é corredor em curva para a esquerda
        expect(cave.chamberDetails!, contains('Corredor em curva para a esquerda'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
        
        // Verificar se o conteúdo é câmara vazia
        expect(cave.chamberDetails!, contains('Câmara vazia'));
        
        // Verificar se o especial é relíquias
        expect(cave.chamberDetails!, contains('Relíquias'));
        expect(cave.chamberDetails!, contains('tabela 4.6'));
        
        print('✅ Roll 3 column alignment verified!');
      });

      test('Roll 4: Tipo=Corredor direita, Conteúdo=Encontro no subterrâneo, Especial=Riacho subterrâneo', () {
        // Roll 4 da tabela 4.17 deve ter:
        // - Tipo: Corredor em curva para a direita (1 metro de diâmetro)
        // - Conteúdo: Encontro no subterrâneo
        // - Especial: Riacho subterrâneo (2d6+1 metros de largura)
        
        final cave = service.generateCaveWithDetailedRolls(1, 4, 4, 4);
        print('=== TABELA 4.17 ROLL 4 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é corredor em curva para a direita
        expect(cave.chamberDetails!, contains('Corredor em curva para a direita'));
        expect(cave.chamberDetails!, contains('1 metro de diâmetro'));
        
        // Verificar se o conteúdo é encontro no subterrâneo
        expect(cave.chamberDetails!, contains('Encontro no subterrâneo'));
        
        // Verificar se o especial é riacho subterrâneo
        expect(cave.chamberDetails!, contains('Riacho subterrâneo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Riacho subterrâneo \(\d+ metros de largura\)')));
        
        print('✅ Roll 4 column alignment verified!');
      });

      test('Roll 5: Tipo=Túnel estreito, Conteúdo=Sem saída, Especial=Lago subterrâneo', () {
        // Roll 5 da tabela 4.17 deve ter:
        // - Tipo: Túnel estreito (1d6+2x10 cm de largura)
        // - Conteúdo: Sem saída (fim da caverna)
        // - Especial: Lago subterrâneo (1d6+1 metros de profundidade)
        
        final cave = service.generateCaveWithDetailedRolls(1, 5, 5, 5);
        print('=== TABELA 4.17 ROLL 5 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é túnel estreito
        expect(cave.chamberDetails!, contains('Túnel estreito'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel estreito \(\d+ cm de largura\)')));
        
        // Verificar se o conteúdo é sem saída
        expect(cave.chamberDetails!, contains('Sem saída'));
        expect(cave.chamberDetails!, contains('fim da caverna'));
        
        // Verificar se o especial é lago subterrâneo
        expect(cave.chamberDetails!, contains('Lago subterrâneo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Lago subterrâneo \(\d+ metros de profundidade\)')));
        
        print('✅ Roll 5 column alignment verified!');
      });

      test('Roll 6: Tipo=Túnel baixo, Conteúdo=Sem saída, Especial=Encruzilhada', () {
        // Roll 6 da tabela 4.17 deve ter:
        // - Tipo: Túnel baixo (1d6+2x10 cm de altura)
        // - Conteúdo: Sem saída (fim da caverna)
        // - Especial: Encruzilhada para 1d3 novas direções
        
        final cave = service.generateCaveWithDetailedRolls(1, 6, 6, 6);
        print('=== TABELA 4.17 ROLL 6 VERIFICATION ===');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Chamber Details:');
        print(cave.chamberDetails);
        
        // Verificar se o tipo é túnel baixo
        expect(cave.chamberDetails!, contains('Túnel baixo'));
        expect(cave.chamberDetails!, matches(RegExp(r'Túnel baixo \(\d+ cm de altura\)')));
        
        // Verificar se o conteúdo é sem saída
        expect(cave.chamberDetails!, contains('Sem saída'));
        expect(cave.chamberDetails!, contains('fim da caverna'));
        
        // Verificar se o especial é encruzilhada
        expect(cave.chamberDetails!, contains('Encruzilhada'));
        expect(cave.chamberDetails!, matches(RegExp(r'Encruzilhada para \d+ novas direções')));
        
        print('✅ Roll 6 column alignment verified!');
      });
    });
  });
} 