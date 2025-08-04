import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Cave Tables Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.16 - Cavernas', () {
      test('should generate cave with correct entry types', () {
        final cave = service.generateCave();
        
        expect(cave.entry, anyOf(
          'Buraco no chão',
          'Fissura numa grande rocha',
          'Abertura em arco',
          'Abertura estreita sob rocha',
          'Por cima de um grupo de pedras',
          'No fundo de um vau',
        ));
        
        print('Cave Entry: ${cave.entry}');
      });

      test('should generate cave with correct inhabitant types', () {
        final cave = service.generateCave();
        
        expect(cave.inhabitant, anyOf(
          contains('Fungo Pigmeu'),
          contains('Aranha Negra Gigante'),
          contains('Urso Pardo'),
          contains('Urso-Coruja'),
          contains('Ettin'),
          contains('Dragão'),
        ));
        
        print('Cave Inhabitant: ${cave.inhabitant}');
      });

      test('should follow table 4.16 structure correctly', () {
        // Testar múltiplas vezes para verificar a estrutura
        for (int i = 0; i < 10; i++) {
          final cave = service.generateCave();
          
          expect(cave.entry, isNotEmpty);
          expect(cave.inhabitant, isNotEmpty);
          expect(cave.description, isNotEmpty);
          
          // Verificar se a descrição contém os números resolvidos
          expect(cave.description, matches(RegExp(r'\d+ ')));
        }
        
        print('✅ All cave structures follow table 4.16 correctly!');
      });
    });

    group('Table 4.17 - Detalhando Cavernas', () {
      test('should generate chamber details for cave', () {
        final cave = service.generateCave();
        
        expect(cave.chamberDetails, isNotNull);
        expect(cave.chamberDetails!, isNotEmpty);
        
        print('Chamber Details:');
        print(cave.chamberDetails);
      });

      test('should have correct chamber types', () {
        final cave = service.generateCave();
        final chamberDetails = cave.chamberDetails!;
        
        expect(chamberDetails, anyOf(
          contains('Câmara larga'),
          contains('Câmara pequena'),
          contains('Corredor em curva para a esquerda'),
          contains('Corredor em curva para a direita'),
          contains('Túnel estreito'),
          contains('Túnel baixo'),
        ));
      });

      test('should have correct chamber contents', () {
        final cave = service.generateCave();
        final chamberDetails = cave.chamberDetails!;
        
        expect(chamberDetails, anyOf(
          contains('Câmara vazia'),
          contains('Encontro no subterrâneo'),
          contains('Sem saída'),
          contains('Fosso para baixo'),
          contains('Túnel para cima'),
          contains('Relíquias'),
          contains('Riacho subterrâneo'),
          contains('Lago subterrâneo'),
          contains('Encruzilhada'),
        ));
      });

      test('should have correct chamber specials', () {
        final cave = service.generateCave();
        final chamberDetails = cave.chamberDetails!;
        
        expect(chamberDetails, anyOf(
          contains('Fosso para baixo'),
          contains('Túnel para cima'),
          contains('Relíquias'),
          contains('Riacho subterrâneo'),
          contains('Lago subterrâneo'),
          contains('Encruzilhada'),
        ));
      });

      test('should resolve all dice rolls in chamber details', () {
        final cave = service.generateCave();
        final chamberDetails = cave.chamberDetails!;
        
        // Verificar se não há strings de rolagem não resolvidas
        expect(chamberDetails, isNot(matches(RegExp(r'\d+d\d+'))));
        
        print('✅ All dice rolls resolved in chamber details!');
      });
    });

    group('Integration Test', () {
      test('should generate complete cave with chamber details', () {
        final cave = service.generateCave();
        
        expect(cave, isA<Cave>());
        expect(cave.entry, isNotEmpty);
        expect(cave.inhabitant, isNotEmpty);
        expect(cave.description, isNotEmpty);
        expect(cave.chamberDetails, isNotNull);
        expect(cave.chamberDetails!, isNotEmpty);
        
        print('Complete Cave:');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
        print('Description: ${cave.description}');
        print('Chamber Details:');
        print(cave.chamberDetails!);
      });
    });
  });
} 