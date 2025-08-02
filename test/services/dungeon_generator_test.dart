import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/dungeon_generator_refactored.dart';

void main() {
  group('DungeonGenerator Tests', () {
    late DungeonGeneratorRefactored generator;

    setUp(() {
      generator = DungeonGeneratorRefactored();
    });

    test('should generate dungeons with varied room counts', () {
      final results = <int>{};

      // Gera várias masmorras para verificar variação
      for (int i = 0; i < 10; i++) {
        final dungeon = generator.generate(
          level: 3,
          theme: 'Test Theme',
        );
        results.add(dungeon.roomsCount);
        print('Masmorra ${i + 1}: ${dungeon.roomsCount} salas');
      }

      // Deve haver pelo menos algumas variações diferentes
      expect(results.length, greaterThan(1));
      print('Números de salas gerados: $results');
    });

    test('should handle custom room count', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 5,
      );
      expect(dungeon.roomsCount, equals(5));
    });

    test('should handle min/max room constraints', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        minRooms: 10,
        maxRooms: 15,
      );
      expect(dungeon.roomsCount, greaterThanOrEqualTo(10));
      expect(dungeon.roomsCount, lessThanOrEqualTo(15));
    });
  });
}
