import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Dungeon Tables Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.14 - Masmorras', () {
      test('should generate dungeon with correct entry types', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon.entry, anyOf(
          'Pequena gruta',
          'Túnel secreto',
          'Fissura numa grande rocha',
          'Buraco no chão',
          'Atrás de trepadeiras',
          'Tronco de uma árvore oca',
        ));
        
        print('Dungeon Entry: ${dungeon.entry}');
      });

      test('should generate dungeon with correct floor counts', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon.floors, greaterThan(0));
        expect(dungeon.floors, lessThanOrEqualTo(7)); // 1d6+1 max
        
        print('Dungeon Floors: ${dungeon.floors}');
      });

      test('should generate dungeon with correct room counts', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon.rooms, greaterThan(0));
        expect(dungeon.rooms, lessThanOrEqualTo(35)); // 5d6+5 max
        
        print('Dungeon Rooms: ${dungeon.rooms}');
      });

      test('should generate dungeon with correct guardian types', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon.guardian, anyOf(
          'Nenhum',
          'Armadilhas',
          'Gigantes',
          'Mortos-Vivos',
          'Outros',
          'Dragões',
        ));
        
        print('Dungeon Guardian: ${dungeon.guardian}');
      });

      test('should follow table 4.14 structure correctly', () {
        // Testar múltiplas vezes para verificar a estrutura
        for (int i = 0; i < 10; i++) {
          final dungeon = service.generateDungeon();
          
          expect(dungeon.entry, isNotEmpty);
          expect(dungeon.floors, greaterThan(0));
          expect(dungeon.rooms, greaterThan(0));
          expect(dungeon.guardian, isNotEmpty);
          expect(dungeon.description, isNotEmpty);
          
          // Verificar se a descrição contém os números resolvidos
          expect(dungeon.description, matches(RegExp(r'\d+ andares e \d+ salas')));
        }
        
        print('✅ All dungeon structures follow table 4.14 correctly!');
      });
    });

    group('Table 4.15 - Detalhando Salas', () {
      test('should generate room details for each room', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon.roomDetails, isNotNull);
        expect(dungeon.roomDetails!, isNotEmpty);
        
        // Verificar se há detalhes para cada sala
        final roomLines = dungeon.roomDetails!.split('\n');
        expect(roomLines.length, equals(dungeon.rooms));
        
        print('Room Details:');
        print(dungeon.roomDetails);
      });

      test('should have correct room types', () {
        final dungeon = service.generateDungeon();
        final roomDetails = dungeon.roomDetails!;
        
        expect(roomDetails, anyOf(
          contains('Sala quadrada normal'),
          contains('Corredor reto'),
          contains('Corredor em curva para a esquerda'),
          contains('Corredor em curva para a direita'),
          contains('Sala retangular'),
          contains('Grande salão'),
        ));
      });

      test('should have correct room contents', () {
        final dungeon = service.generateDungeon();
        final roomDetails = dungeon.roomDetails!;
        
        expect(roomDetails, anyOf(
          contains('Sala vazia'),
          contains('Estátuas ou colunas antigas'),
          contains('Móveis domésticos'),
          contains('Altar religioso'),
          contains('Jogue na coluna Especial'),
        ));
      });

      test('should have correct room specials', () {
        final dungeon = service.generateDungeon();
        final roomDetails = dungeon.roomDetails!;
        
        expect(roomDetails, anyOf(
          contains('Sala vazia'),
          contains('Encontro'),
          contains('Armadilha'),
          contains('Jogue na coluna Ocorrência'),
        ));
      });

      test('should have correct room occurrences', () {
        final dungeon = service.generateDungeon();
        final roomDetails = dungeon.roomDetails!;
        
        expect(roomDetails, anyOf(
          contains('Alarme dispara'),
          contains('Fonte de água'),
          contains('Porta secreta'),
          contains('Desmoronamento'),
          contains('Corpos em decomposição'),
          contains('Porta dimensional'),
        ));
      });

      test('should generate different room details for each room', () {
        final dungeon = service.generateDungeon();
        final roomDetails = dungeon.roomDetails!;
        final roomLines = roomDetails.split('\n');
        
        // Verificar se há variação nos detalhes das salas
        final uniqueDetails = roomLines.toSet();
        expect(uniqueDetails.length, greaterThan(1));
        
        print('Unique room details: ${uniqueDetails.length} out of ${roomLines.length}');
      });
    });

    group('Integration Test', () {
      test('should generate complete dungeon with room details', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon, isA<Dungeon>());
        expect(dungeon.entry, isNotEmpty);
        expect(dungeon.floors, greaterThan(0));
        expect(dungeon.rooms, greaterThan(0));
        expect(dungeon.guardian, isNotEmpty);
        expect(dungeon.description, isNotEmpty);
        expect(dungeon.roomDetails, isNotNull);
        expect(dungeon.roomDetails!, isNotEmpty);
        
        print('Complete Dungeon:');
        print('Entry: ${dungeon.entry}');
        print('Floors: ${dungeon.floors}');
        print('Rooms: ${dungeon.rooms}');
        print('Guardian: ${dungeon.guardian}');
        print('Description: ${dungeon.description}');
        print('Room Details:');
        print(dungeon.roomDetails);
      });
    });
  });
} 