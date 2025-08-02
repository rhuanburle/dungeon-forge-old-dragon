import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/room_size_calculator.dart';

void main() {
  group('RoomSizeCalculator Tests', () {
    late RoomSizeCalculator calculator;

    setUp(() {
      calculator = RoomSizeCalculator();
    });

    test('should parse different size formulas correctly', () {
      // Testa várias fórmulas da tabela
      final formulas = [
        '1d6 + 4 salas',
        '1d6 + 6 salas',
        '2d6 + 4 salas',
        '2d6 + 6 salas',
        '3d6 + 4 salas',
        '3d6 + 6 salas',
        '3d6 + 8 salas',
        '4d6 + 10 salas',
        '5d6 + 12 salas',
        '6d6 + 14 salas',
      ];

      for (final formula in formulas) {
        final roomCount = calculator.calculateRoomCount(formula);

        // Verifica se o número está dentro dos limites esperados
        expect(roomCount, greaterThan(0));
        expect(roomCount, lessThanOrEqualTo(50));

        print('Fórmula: $formula -> $roomCount salas');
      }
    });

    test('should handle custom room count', () {
      final result = calculator.calculateRoomCount(
        '1d6 + 4 salas',
        customRoomCount: 5,
      );
      expect(result, equals(5));
    });

    test('should apply min/max constraints', () {
      final result = calculator.calculateRoomCount(
        '1d6 + 4 salas',
        minRooms: 10,
        maxRooms: 15,
      );
      expect(result, greaterThanOrEqualTo(10));
      expect(result, lessThanOrEqualTo(15));
    });

    test('should generate varied room counts', () {
      final results = <int>{};

      // Gera várias masmorras para verificar variação
      for (int i = 0; i < 20; i++) {
        final roomCount = calculator.calculateRoomCount('2d6 + 4 salas');
        results.add(roomCount);
      }

      // Deve haver pelo menos algumas variações diferentes
      expect(results.length, greaterThan(1));
      print('Números de salas gerados: $results');
    });
  });
}
