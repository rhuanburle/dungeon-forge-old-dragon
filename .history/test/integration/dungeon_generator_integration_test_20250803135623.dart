flutter tes// test/integration/dungeon_generator_integration_test.dart

import 'package:test/test.dart';
import '../../lib/services/dungeon_generator_refactored.dart';
import '../../lib/models/dungeon.dart';
import '../../lib/models/room.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/enums/dice_enums.dart';

void main() {
  group('Dungeon Generator Integration Tests', () {
    late DungeonGeneratorRefactored generator;

    setUp(() {
      generator = DungeonGeneratorRefactored();
    });

    group('complete generation flow', () {
      test('should generate complete dungeon with all components', () {
        final dungeon = generator.generate(level: 5, theme: 'Integration Test');

        // Validate main dungeon properties
        _validateDungeonProperties(dungeon);

        // Validate all rooms
        for (final room in dungeon.rooms) {
          _validateRoomProperties(room);
        }
      });

      test('should generate different dungeons on multiple calls', () {
        final dungeons = <Dungeon>[];

        for (int i = 0; i < 5; i++) {
          dungeons.add(
            generator.generate(level: 3, theme: 'Diversity Test $i'),
          );
        }

        // Should have some variation in types
        final types = dungeons.map((d) => d.type).toSet();
        expect(
          types.length,
          greaterThan(1),
          reason: 'Should generate different dungeon types',
        );

        // Should have some variation in locations
        final locations = dungeons.map((d) => d.location).toSet();
        expect(
          locations.length,
          greaterThan(1),
          reason: 'Should generate different locations',
        );
      });

      test('should respect custom room count parameter', () {
        const customCount = 15;
        final dungeon = generator.generate(
          level: 7,
          theme: 'Custom Count Test',
          customRoomCount: customCount,
        );

        expect(dungeon.roomsCount, equals(customCount));
        expect(dungeon.rooms.length, equals(customCount));
      });

      test('should respect min/max room constraints', () {
        const minRooms = 8;
        const maxRooms = 12;

        for (int i = 0; i < 10; i++) {
          final dungeon = generator.generate(
            level: 4,
            theme: 'Constraint Test $i',
            minRooms: minRooms,
            maxRooms: maxRooms,
          );

          expect(dungeon.roomsCount, greaterThanOrEqualTo(minRooms));
          expect(dungeon.roomsCount, lessThanOrEqualTo(maxRooms));
        }
      });
    });

    group('room generation validation', () {
      test('should generate rooms with proper indices', () {
        final dungeon = generator.generate(level: 6, theme: 'Index Test');

        for (int i = 0; i < dungeon.rooms.length; i++) {
          expect(dungeon.rooms[i].index, equals(i + 1));
        }
      });

      test('should generate rooms with different types', () {
        final dungeon = generator.generate(
          level: 5,
          theme: 'Room Variety Test',
          customRoomCount: 20, // More rooms = more variety
        );

        final roomTypes = dungeon.rooms.map((r) => r.type).toSet();
        expect(
          roomTypes.length,
          greaterThan(1),
          reason: 'Should generate different room types',
        );
      });

      test('should generate proper monster encounters', () {
        // Generate larger dungeon to increase chance of monster encounters
        final dungeon = generator.generate(
          level: 8,
          theme: 'Monster Test',
          customRoomCount: 25,
        );

        final monsterRooms = dungeon.rooms
            .where((r) => r.type.contains('Encontro'))
            .toList();

        // Monster rooms should have at least some valid monsters
        // (not all rooms need monsters, but some should)
        int validMonsterRooms = 0;
        for (final room in monsterRooms) {
          if (room.monster1.isNotEmpty || room.monster2.isNotEmpty) {
            validMonsterRooms++;

            // If monster1 is not empty, it should be a valid monster name
            if (room.monster1.isNotEmpty) {
              expect(room.monster1, isNot(equals('Ocupante I')));
              expect(room.monster1, isNot(equals('Ocupante II')));
            }

            if (room.monster2.isNotEmpty) {
              expect(room.monster2, isNot(equals('Ocupante I')));
              expect(room.monster2, isNot(equals('Ocupante II')));
            }
          }
        }

        // Should have at least some valid monster rooms
        expect(validMonsterRooms, greaterThan(0));
      });

      test('should generate proper trap rooms', () {
        final dungeon = generator.generate(
          level: 6,
          theme: 'Trap Test',
          customRoomCount: 30,
        );

        final trapRooms = dungeon.rooms
            .where(
              (r) => r.type.contains('Armadilha') || r.type.contains('Trap'),
            )
            .toList();

        for (final room in trapRooms) {
          // Trap rooms should have trap descriptions or be properly identified
          final hasTrapDescription =
              room.trap.isNotEmpty ||
              room.specialTrap.isNotEmpty ||
              room.type.contains('Armadilha') ||
              room.type.contains('Especial');
          expect(
            hasTrapDescription,
            isTrue,
            reason:
                'Trap room should have trap description or be identified as trap: ${room.type}',
          );

          // Should not contain unresolved references
          if (room.trap.isNotEmpty) {
            expect(room.trap, isNot(equals('Armadilha Especial…')));
          }
        }
      });

      test('should resolve treasure formulas', () {
        final dungeon = generator.generate(
          level: 10,
          theme: 'Treasure Test',
          customRoomCount: 25,
        );

        for (final room in dungeon.rooms) {
          // Treasures should not contain unresolved dice formulas
          if (room.treasure.isNotEmpty &&
              room.treasure != 'Nenhum' &&
              room.treasure != 'Nenhum Tesouro') {
            expect(room.treasure, isNot(matches(r'\d+d\d+')));
          }

          if (room.specialTreasure.isNotEmpty) {
            expect(room.specialTreasure, isNot(matches(r'\d+d\d+')));
          }

          // Magic items should be specific items, not categories
          if (room.magicItem.isNotEmpty) {
            expect(room.magicItem, isNot(equals('1 Qualquer')));
            expect(room.magicItem, isNot(equals('1 Qualquer não Arma')));
            expect(room.magicItem, isNot(equals('1 Poção')));
            expect(room.magicItem, isNot(equals('1 Pergaminho')));
            expect(room.magicItem, isNot(equals('1 Arma')));
            expect(room.magicItem, isNot(equals('2 Qualquer')));
          }
        }
      });
    });

    group('business rules validation', () {
      test('should apply treasure modifiers for trap rooms', () {
        // Generate many dungeons to test the probability distribution
        int trapRoomsWithTreasure = 0;
        int totalTrapRooms = 0;

        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(
            level: 5,
            theme: 'Trap Modifier Test $i',
            customRoomCount: 15,
          );

          for (final room in dungeon.rooms) {
            if (room.type.contains('Armadilha')) {
              totalTrapRooms++;
              if (room.treasure.isNotEmpty &&
                  room.treasure != 'Nenhum' &&
                  room.treasure != 'Nenhum Tesouro') {
                trapRoomsWithTreasure++;
              }
            }
          }
        }

        // Due to +1 modifier, trap rooms should have higher treasure rate
        if (totalTrapRooms > 0) {
          final treasureRate = trapRoomsWithTreasure / totalTrapRooms;
          expect(
            treasureRate,
            greaterThan(0.1),
            reason:
                'Trap rooms should have reasonable treasure rate due to +1 modifier',
          );
        }
      });

      test('should apply treasure modifiers for monster rooms', () {
        int monsterRoomsWithTreasure = 0;
        int totalMonsterRooms = 0;

        for (int i = 0; i < 20; i++) {
          final dungeon = generator.generate(
            level: 6,
            theme: 'Monster Modifier Test $i',
            customRoomCount: 15,
          );

          for (final room in dungeon.rooms) {
            if (room.type.contains('Encontro')) {
              totalMonsterRooms++;
              if (room.treasure.isNotEmpty &&
                  room.treasure != 'Nenhum' &&
                  room.treasure != 'Nenhum Tesouro') {
                monsterRoomsWithTreasure++;
              }
            }
          }
        }

        // Due to +2 modifier, monster rooms should have higher treasure rate
        if (totalMonsterRooms > 0) {
          final treasureRate = monsterRoomsWithTreasure / totalMonsterRooms;
          expect(
            treasureRate,
            greaterThan(0.2),
            reason:
                'Monster rooms should have reasonable treasure rate due to +2 modifier',
          );
        }
      });

      test('should resolve all special references', () {
        final dungeon = generator.generate(
          level: 7,
          theme: 'Special Reference Test',
          customRoomCount: 20,
        );

        // Main dungeon should not have unresolved references
        expect(dungeon.rumor1, isNot(contains('[coluna')));

        // Rooms should not have unresolved references
        for (final room in dungeon.rooms) {
          expect(room.type, isNot(contains('Especial…')));
          expect(room.type, isNot(contains('Especial 2…')));
          expect(room.type, isNot(contains('Armadilha Especial…')));
          expect(room.trap, isNot(equals('Armadilha Especial…')));
          expect(room.treasure, isNot(equals('Tesouro Especial…')));
        }
      });
    });

    group('edge cases and stress tests', () {
      test('should handle single room dungeon', () {
        final dungeon = generator.generate(
          level: 1,
          theme: 'Single Room',
          customRoomCount: 1,
        );

        expect(dungeon.roomsCount, equals(1));
        expect(dungeon.rooms.length, equals(1));

        final room = dungeon.rooms.first;
        _validateRoomProperties(room);
      });

      test('should handle large dungeons', () {
        final dungeon = generator.generate(
          level: 15,
          theme: 'Large Dungeon',
          customRoomCount: 100,
        );

        expect(dungeon.roomsCount, equals(100));
        expect(dungeon.rooms.length, equals(100));

        // Validate structure of first and last rooms
        _validateRoomProperties(dungeon.rooms.first);
        _validateRoomProperties(dungeon.rooms.last);

        // Check room indices are correct
        expect(dungeon.rooms.first.index, equals(1));
        expect(dungeon.rooms.last.index, equals(100));
      });

      test('should handle high level characters', () {
        final dungeon = generator.generate(level: 20, theme: 'High Level Test');
        _validateDungeonProperties(dungeon);
      });

      test('should handle empty theme', () {
        final dungeon = generator.generate(
          level: 1,
          theme: '',
          customRoomCount: 3,
        );

        expect(dungeon.type, isNotEmpty);
        expect(dungeon.rooms.length, equals(3));
      });

      group('Treasure Level Auto-Configuration Integration', () {
        test(
          'should auto-configure treasure level based on party level in complete flow',
          () {
            final dungeon = generator.generate(
              level: 3,
              theme: 'Test Dungeon',
              customRoomCount: 5,
              terrainType: TerrainType.subterranean,
              partyLevel: PartyLevel.heroic,
              useTreasureByLevel: true,
            );

            // Verifica se a masmorra foi gerada corretamente
            expect(dungeon.type, isNotEmpty);
            expect(dungeon.rooms.length, equals(5));

            // Verifica se todas as salas têm tesouro do nível 2-3
            for (final room in dungeon.rooms) {
              expect(room.treasure, isNotEmpty);
              expect(room.treasure, contains('PP:'));
              expect(room.treasure, contains('Nenhum Item Mágico'));
            }
          },
        );

        test(
          'should work with encounter tables and treasure auto-configuration',
          () {
            final dungeon = generator.generate(
              level: 3,
              theme: 'Encounter Test',
              customRoomCount: 3,
              terrainType: TerrainType.plains,
              partyLevel: PartyLevel.advanced,
              useEncounterTables: true,
              useTreasureByLevel: true,
            );

            // Verifica se a masmorra foi gerada corretamente
            expect(dungeon.type, isNotEmpty);
            expect(dungeon.rooms.length, equals(3));

            // Verifica se todas as salas têm tesouro do nível 6-7
            for (final room in dungeon.rooms) {
              expect(room.treasure, isNotEmpty);
              expect(room.treasure, contains('PO:'));
              expect(room.treasure, contains('PP:'));
              expect(room.treasure, contains('Itens Mágicos:'));
            }
          },
        );

        test(
          'should maintain manual treasure level override in complete flow',
          () {
            final dungeon = generator.generate(
              level: 3,
              theme: 'Manual Override Test',
              customRoomCount: 4,
              terrainType: TerrainType.hills,
              partyLevel: PartyLevel.beginners, // Deveria configurar nível 1
              treasureLevel:
                  TreasureLevel.level10plus, // Mas foi sobrescrito manualmente
              useTreasureByLevel: true,
            );

            // Verifica se a masmorra foi gerada corretamente
            expect(dungeon.type, isNotEmpty);
            expect(dungeon.rooms.length, equals(4));

            // Verifica se todas as salas têm tesouro do nível 10+ (manual)
            for (final room in dungeon.rooms) {
              expect(room.treasure, isNotEmpty);
              expect(room.treasure, contains('PO:'));
              expect(room.treasure, contains('PP:'));
              expect(room.treasure, contains('Itens Mágicos:'));
            }
          },
        );

        test(
          'should not auto-configure when treasure by level is disabled',
          () {
            final dungeon = generator.generate(
              level: 3,
              theme: 'Standard Treasure Test',
              customRoomCount: 3,
              terrainType: TerrainType.forests,
              partyLevel: PartyLevel.advanced, // Deveria configurar nível 6-7
              useTreasureByLevel: false, // Mas está desabilitado
            );

            // Verifica se a masmorra foi gerada corretamente
            expect(dungeon.type, isNotEmpty);
            expect(dungeon.rooms.length, equals(3));

            // Verifica se os tesouros são os padrões da tabela (não por nível)
            bool hasStandardTreasure = false;
            for (final room in dungeon.rooms) {
              if (room.treasure.isNotEmpty) {
                // Tesouros padrão não devem ter o formato "PO:", "PP:", etc.
                if (!room.treasure.contains('PO:') &&
                    !room.treasure.contains('PP:') &&
                    !room.treasure.contains('Gemas:') &&
                    !room.treasure.contains('Objetos de Valor:') &&
                    !room.treasure.contains('Itens Mágicos:')) {
                  hasStandardTreasure = true;
                  break;
                }
              }
            }

            expect(hasStandardTreasure, isTrue);
          },
        );
      });
    });
  });
}

/// Validates that a dungeon has all required properties properly set
void _validateDungeonProperties(Dungeon dungeon) {
  expect(dungeon.type, isNotEmpty, reason: 'Dungeon type should not be empty');
  expect(
    dungeon.builderOrInhabitant,
    isNotEmpty,
    reason: 'Builder/inhabitant should not be empty',
  );
  expect(dungeon.status, isNotEmpty, reason: 'Status should not be empty');
  expect(
    dungeon.objective,
    isNotEmpty,
    reason: 'Objective should not be empty',
  );
  expect(dungeon.location, isNotEmpty, reason: 'Location should not be empty');
  expect(dungeon.entry, isNotEmpty, reason: 'Entry should not be empty');
  expect(
    dungeon.occupant1,
    isNotEmpty,
    reason: 'Occupant1 should not be empty',
  );
  expect(
    dungeon.occupant2,
    isNotEmpty,
    reason: 'Occupant2 should not be empty',
  );
  expect(dungeon.leader, isNotEmpty, reason: 'Leader should not be empty');
  expect(dungeon.rumor1, isNotEmpty, reason: 'Rumor1 should not be empty');
  expect(
    dungeon.roomsCount,
    greaterThan(0),
    reason: 'Should have at least one room',
  );
  expect(
    dungeon.rooms.length,
    equals(dungeon.roomsCount),
    reason: 'Room count should match rooms list length',
  );
}

/// Validates that a room has all required properties properly set
void _validateRoomProperties(Room room) {
  expect(room.index, greaterThan(0), reason: 'Room index should be positive');
  expect(room.type, isNotEmpty, reason: 'Room type should not be empty');
  expect(room.air, isNotEmpty, reason: 'Air current should not be empty');
  expect(room.smell, isNotEmpty, reason: 'Smell should not be empty');
  expect(room.sound, isNotEmpty, reason: 'Sound should not be empty');
  expect(room.item, isNotEmpty, reason: 'Found item should not be empty');

  // Ensure room type doesn't contain unresolved references
  expect(
    room.type,
    isNot(contains('…')),
    reason: 'Room type should not contain unresolved references',
  );

  // Validate that strings are not just whitespace
  expect(room.type.trim(), isNotEmpty);
  expect(room.air.trim(), isNotEmpty);
  expect(room.smell.trim(), isNotEmpty);
  expect(room.sound.trim(), isNotEmpty);
  expect(room.item.trim(), isNotEmpty);
}
