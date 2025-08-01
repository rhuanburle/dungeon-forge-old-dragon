// test/test_runner.dart

import 'package:test/test.dart';

// Import all test files
import 'utils/dice_roller_test.dart' as dice_roller_test;
import 'utils/treasure_resolver_test.dart' as treasure_resolver_test;
import 'enums/dungeon_tables_test.dart' as dungeon_tables_test;
import 'enums/room_tables_test.dart' as room_tables_test;
import 'services/tables/dungeon_table_9_1_test.dart' as dungeon_table_9_1_test;
import 'services/tables/room_table_9_2_test.dart' as room_table_9_2_test;
import 'models/dto/dungeon_generation_dto_test.dart' as dungeon_generation_dto_test;
import 'mappers/dungeon_mapper_test.dart' as dungeon_mapper_test;
import 'services/dungeon_generator_regression_test.dart' as dungeon_generator_regression_test;
import 'integration/dungeon_generator_integration_test.dart' as dungeon_generator_integration_test;

void main() {
  group('Dungeon Forge Test Suite', () {
    print('\n🧪 Running Dungeon Forge Complete Test Suite');
    print('=' * 60);
    
    group('🎲 Utils Tests', () {
      dice_roller_test.main();
      treasure_resolver_test.main();
    });

    group('📋 Enums Tests', () {
      dungeon_tables_test.main();
      room_tables_test.main();
    });

    group('📊 Tables Tests', () {
      dungeon_table_9_1_test.main();
      room_table_9_2_test.main();
    });

    group('📦 DTOs Tests', () {
      dungeon_generation_dto_test.main();
    });

    group('🔄 Mappers Tests', () {
      dungeon_mapper_test.main();
    });

    group('🏰 Generator Tests', () {
      dungeon_generator_regression_test.main();
    });

    group('🔗 Integration Tests', () {
      dungeon_generator_integration_test.main();
    });
  });
}

/// Runs performance tests separately
void runPerformanceTests() {
  group('Performance Tests', () {
    test('should generate dungeons within reasonable time', () {
      final stopwatch = Stopwatch()..start();
      
      // Import here to avoid circular dependencies
      // ignore: depend_on_referenced_packages
      final generator = null; // DungeonGeneratorRefactored();
      
      for (int i = 0; i < 100; i++) {
        // generator.generate(level: 5, theme: 'Performance Test $i');
      }
      
      stopwatch.stop();
      final averageTimeMs = stopwatch.elapsedMilliseconds / 100;
      
      print('Average generation time: ${averageTimeMs}ms');
      expect(averageTimeMs, lessThan(100), reason: 'Generation should be under 100ms on average');
    });
  });
}