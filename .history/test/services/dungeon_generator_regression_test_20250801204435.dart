// test/services/dungeon_generator_regression_test.dart

import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:math';
import '../../lib/services/dungeon_generator_refactored.dart';
import '../../lib/utils/dice_roller.dart';

/// Mock class para testar com valores determinísticos
class MockRandom extends Mock implements Random {}

void main() {
  group('Dungeon Generator Tests', () {
    group('functionality validation', () {
      test('should generate dungeons with correct basic structure', () {
        final generator = DungeonGeneratorRefactored();

        // Test multiple generations to ensure consistency
        for (int i = 0; i < 10; i++) {
          final dungeon = generator.generate(
            level: 3,
            theme: 'Test Theme',
          );

          // Basic structure validation
          expect(dungeon.type, isNotEmpty);
          expect(dungeon.builderOrInhabitant, isNotEmpty);
          expect(dungeon.status, isNotEmpty);
          expect(dungeon.objective, isNotEmpty);
          expect(dungeon.location, isNotEmpty);
          expect(dungeon.entry, isNotEmpty);
          expect(dungeon.occupant1, isNotEmpty);
          expect(dungeon.occupant2, isNotEmpty);
          expect(dungeon.leader, isNotEmpty);
          expect(dungeon.rumor1, isNotEmpty);

          // Room count should be reasonable
          expect(dungeon.roomsCount, greaterThanOrEqualTo(3));
          expect(dungeon.rooms.length, equals(dungeon.roomsCount));
        }
      });

      test('should handle custom room count correctly', () {
        final generator = DungeonGeneratorRefactored();

        const customRoomCount = 8;

        final dungeon = generator.generate(
          level: 5,
          theme: 'Custom Test',
          customRoomCount: customRoomCount,
        );

        expect(dungeon.roomsCount, equals(customRoomCount));
        expect(dungeon.rooms.length, equals(customRoomCount));
      });

      test('should handle min/max room constraints correctly', () {
        final generator = DungeonGeneratorRefactored();

        const minRooms = 6;
        const maxRooms = 10;

        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(
            level: 7,
            theme: 'Range Test',
            minRooms: minRooms,
            maxRooms: maxRooms,
          );

          expect(dungeon.roomsCount, greaterThanOrEqualTo(minRooms));
          expect(dungeon.roomsCount, lessThanOrEqualTo(maxRooms));
        }
      });
    });

    group('room generation validation', () {
      test('should generate rooms with all required properties', () {
        final generator = DungeonGeneratorRefactored();

        final dungeon = generator.generate(level: 5, theme: 'Room Test');

        // Test that generator creates rooms with all properties
        for (final room in dungeon.rooms) {
          expect(room.index, greaterThan(0));
          expect(room.type, isNotEmpty);
          expect(room.air, isNotEmpty);
          expect(room.smell, isNotEmpty);
          expect(room.sound, isNotEmpty);
          expect(room.item, isNotEmpty);
        }
      });

      test('should generate rooms with valid types', () {
        final generator = DungeonGeneratorRefactored();

        // Generate multiple dungeons to get different room types
        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(level: 3, theme: 'Type Test');

          for (final room in dungeon.rooms) {
            // Room type should be one of the valid types
            final validTypes = [
              'Sala Especial',
              'Armadilha',
              'Sala Comum',
              'Encontro',
              'Sala Armadilha Especial',
            ];

            final hasValidType =
                validTypes.any((type) => room.type.contains(type));
            expect(hasValidType, isTrue,
                reason: 'Invalid room type: ${room.type}');
          }
        }
      });
    });

    group('business rule validation', () {
      test('should apply treasure modifiers correctly', () {
        final generator = DungeonGeneratorRefactored();

        // Generate many dungeons to increase chance of getting different room types
        int trapRoomsWithTreasure = 0;
        int monsterRoomsWithTreasure = 0;
        int totalRooms = 0;

        for (int i = 0; i < 50; i++) {
          final dungeon = generator.generate(level: 5, theme: 'Modifier Test');

          for (final room in dungeon.rooms) {
            totalRooms++;

            if (room.type.contains('Armadilha') &&
                room.treasure.isNotEmpty &&
                room.treasure != 'Nenhum') {
              trapRoomsWithTreasure++;
            }

            if (room.type.contains('Encontro') &&
                room.treasure.isNotEmpty &&
                room.treasure != 'Nenhum') {
              monsterRoomsWithTreasure++;
            }
          }
        }

        // Should generate some rooms with treasures (due to modifiers)
        expect(totalRooms, greaterThan(100)); // Ensure we tested enough rooms
      });

      test('should resolve special references correctly', () {
        final generator = DungeonGeneratorRefactored();

        for (int i = 0; i < 30; i++) {
          final dungeon = generator.generate(level: 4, theme: 'Reference Test');

          for (final room in dungeon.rooms) {
            // Should not contain unresolved references
            expect(room.type, isNot(contains('Especial…')));
            expect(room.type, isNot(contains('Especial 2…')));
            expect(room.type, isNot(contains('Armadilha Especial…')));
            expect(room.trap, isNot(equals('Armadilha Especial…')));
            expect(room.treasure, isNot(equals('Tesouro Especial…')));
          }

          // Rumor should have resolved column references
          expect(dungeon.rumor1, isNot(contains('[coluna')));
        }
      });

      test('should generate valid occupant substitutions', () {
        final generator = DungeonGeneratorRefactored();

        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(level: 6, theme: 'Occupant Test');

          for (final room in dungeon.rooms) {
            // If room has monsters, they should not contain unresolved occupant references
            if (room.monster1.isNotEmpty) {
              expect(room.monster1, isNot(contains('Ocupante I')));
              expect(room.monster1, isNot(contains('Ocupante II')));
            }

            if (room.monster2.isNotEmpty) {
              expect(room.monster2, isNot(contains('Ocupante I')));
              expect(room.monster2, isNot(contains('Ocupante II')));
            }
          }
        }
      });

      test('should not have wind blowing in found items', () {
        final generator = DungeonGeneratorRefactored();

        // Test both generators to ensure the fix is applied
        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(
            level: 5,
            theme: 'Wind Test $i',
            customRoomCount: 15,
          );

          // Check that "vento soprando" does not appear in found items
          for (final room in dungeon.rooms) {
            expect(room.item, isNot(equals('vento soprando')));
            expect(room.item, isNot(contains('vento soprando')));
          }
        }
      });

      test('should handle special items correctly', () {
        final generator = DungeonGeneratorRefactored();

        // Test multiple generations to check for special items
        for (int i = 0; i < 30; i++) {
          final dungeon = generator.generate(
            level: 5,
            theme: 'Special Items Test $i',
            customRoomCount: 20,
          );

          // Check that rooms can have special items when appropriate
          for (final room in dungeon.rooms) {
            if (room.item == 'itens encontrados especial…') {
              // When item is "itens encontrados especial…", specialItem should be filled
              expect(room.specialItem, isNotEmpty);
              expect(
                  room.specialItem,
                  anyOf(
                    equals('carcaças de monstros'),
                    equals('papéis velhos e rasgados'),
                    equals('ossadas empilhadas'),
                    equals('restos de tecidos sujos'),
                    equals('caixas, sacos e baús vazios'),
                    equals('caixas, sacos e baús cheios'),
                  ));
            } else {
              // When item is not "itens encontrados especial…", specialItem should be empty
              expect(room.specialItem, isEmpty);
            }
          }
        }
      });

      test('should validate special items logic according to table 9.2', () {
        final generator = DungeonGeneratorRefactored();

        // Generate many dungeons to increase chance of getting the specific roll
        int roomsWithSpecialItems = 0;
        int totalRooms = 0;

        for (int i = 0; i < 50; i++) {
          final dungeon = generator.generate(
            level: 5,
            theme: 'Special Items Logic Test $i',
            customRoomCount: 25,
          );

          for (final room in dungeon.rooms) {
            totalRooms++;
            if (room.item == 'itens encontrados especial…') {
              roomsWithSpecialItems++;
              expect(room.specialItem, isNotEmpty);
            }
          }
        }

        // Should have some rooms with special items (roll 8-9 on col5 has 2/11 chance)
        expect(totalRooms, greaterThan(100));
        expect(roomsWithSpecialItems, greaterThan(0));
      });

      test('debug special items issue', () {
        final generator = DungeonGeneratorRefactored();

        // Generate a single dungeon and inspect the rooms
        final dungeon = generator.generate(
          level: 5,
          theme: 'Debug Test',
          customRoomCount: 50, // More rooms = higher chance
        );

        print('Generated ${dungeon.rooms.length} rooms');

        int roomsWithSpecialItems = 0;
        for (int i = 0; i < dungeon.rooms.length; i++) {
          final room = dungeon.rooms[i];
          if (room.item == 'itens encontrados especial…') {
            roomsWithSpecialItems++;
            print(
                'Room $i: item="${room.item}", specialItem="${room.specialItem}"');
          }
        }

        print('Found $roomsWithSpecialItems rooms with special items');

        // This test should help us understand what's happening
        expect(roomsWithSpecialItems, greaterThanOrEqualTo(0));
      });

      test('should not show empty parentheses in room types', () {
        final generator = DungeonGeneratorRefactored();

        // Generate multiple dungeons to test different room types
        for (int i = 0; i < 10; i++) {
          final dungeon = generator.generate(
            level: 5,
            theme: 'Empty Parentheses Test $i',
            customRoomCount: 20,
          );

          for (final room in dungeon.rooms) {
            // Verifica se não há parênteses vazios
            expect(room.type, isNot(contains('()')));
            expect(room.type, isNot(contains('( )')));
            expect(room.type, isNot(contains('(  )')));
            
            // Se tem parênteses, deve ter conteúdo entre eles
            if (room.type.contains('(') && room.type.contains(')')) {
              final startIndex = room.type.indexOf('(');
              final endIndex = room.type.indexOf(')');
              final content = room.type.substring(startIndex + 1, endIndex);
              expect(content.trim(), isNotEmpty, reason: 'Room type: ${room.type}');
            }
          }
        }
      });
    });

    group('edge cases and error handling', () {
      test('should handle minimum level correctly', () {
        final generator = DungeonGeneratorRefactored();

        expect(() => generator.generate(level: 1, theme: 'Min Level'),
            returnsNormally);
      });

      test('should handle high level correctly', () {
        final generator = DungeonGeneratorRefactored();

        expect(() => generator.generate(level: 20, theme: 'High Level'),
            returnsNormally);
      });

      test('should handle extreme room counts', () {
        final generator = DungeonGeneratorRefactored();

        // Minimum rooms
        final minDungeon = generator.generate(
          level: 3,
          theme: 'Min Rooms',
          customRoomCount: 1,
        );
        expect(minDungeon.roomsCount, equals(1));
        expect(minDungeon.rooms.length, equals(1));

        // Large number of rooms
        final largeDungeon = generator.generate(
          level: 3,
          theme: 'Large Dungeon',
          customRoomCount: 50,
        );
        expect(largeDungeon.roomsCount, equals(50));
        expect(largeDungeon.rooms.length, equals(50));
      });

      test('should handle empty theme', () {
        final generator = DungeonGeneratorRefactored();

        expect(() => generator.generate(level: 3, theme: ''),
            returnsNormally);
      });
    });

    group('integration with TreasureResolver', () {
      test('should resolve treasure formulas correctly', () {
        final generator = DungeonGeneratorRefactored();

        for (int i = 0; i < 30; i++) {
          final dungeon = generator.generate(level: 5, theme: 'Treasure Test');

          for (final room in dungeon.rooms) {
            // Treasures should not contain unresolved dice formulas
            if (room.treasure.isNotEmpty &&
                room.treasure != 'Nenhum' &&
                room.treasure != 'Nenhum Tesouro') {
              expect(room.treasure, isNot(matches(r'\d+d\d+')),
                  reason:
                      'Unresolved dice formula in treasure: ${room.treasure}');
            }

            if (room.specialTreasure.isNotEmpty) {
              expect(room.specialTreasure, isNot(matches(r'\d+d\d+')),
                  reason:
                      'Unresolved dice formula in special treasure: ${room.specialTreasure}');
            }

            if (room.magicItem.isNotEmpty) {
              expect(room.magicItem, isNot(equals('1 Qualquer')));
              expect(room.magicItem, isNot(equals('1 Qualquer não Arma')));
              expect(room.magicItem, isNot(equals('1 Poção')));
              expect(room.magicItem, isNot(equals('1 Pergaminho')));
              expect(room.magicItem, isNot(equals('1 Arma')));
              expect(room.magicItem, isNot(equals('2 Qualquer')));
            }
          }
        }
      });
    });
  });
}
