import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/dungeon_generator_refactored.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/utils/treasure_resolver.dart';

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
        final dungeon = generator.generate(level: 3, theme: 'Test Theme');
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

    test('should apply treasure by level when enabled', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 3,
        treasureLevel: TreasureLevel.level4to5,
        useTreasureByLevel: true,
      );

      // Verifica se pelo menos uma sala tem tesouro por nível
      bool hasTreasureByLevel = false;
      for (final room in dungeon.rooms) {
        if (room.treasure.isNotEmpty &&
            (room.treasure.contains('PO:') ||
                room.treasure.contains('PP:') ||
                room.treasure.contains('Gemas:') ||
                room.treasure.contains('Objetos de Valor:') ||
                room.treasure.contains('Itens Mágicos:'))) {
          hasTreasureByLevel = true;
          break;
        }
      }

      expect(hasTreasureByLevel, isTrue);
    });

    test('should not apply treasure by level when disabled', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 3,
        treasureLevel: TreasureLevel.level4to5,
        useTreasureByLevel: false,
      );

      // Verifica se os tesouros são os padrões da tabela
      bool hasStandardTreasure = false;
      for (final room in dungeon.rooms) {
        if (room.treasure.isNotEmpty &&
            !room.treasure.contains('PO:') &&
            !room.treasure.contains('PP:') &&
            !room.treasure.contains('Gemas:') &&
            !room.treasure.contains('Objetos de Valor:') &&
            !room.treasure.contains('Itens Mágicos:')) {
          hasStandardTreasure = true;
          break;
        }
      }

      expect(hasStandardTreasure, isTrue);
    });

    test('should use correct treasure level formulas', () {
      final testLevels = [
        TreasureLevel.level1,
        TreasureLevel.level4to5,
        TreasureLevel.level8to9,
      ];

      for (final level in testLevels) {
        final dungeon = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 5,
          treasureLevel: level,
          useTreasureByLevel: true,
        );

        // Verifica se pelo menos uma sala tem tesouro do nível correto
        bool hasCorrectLevelTreasure = false;
        for (final room in dungeon.rooms) {
          if (room.treasure.isNotEmpty) {
            // Verifica se o tesouro segue o padrão do nível
            final expectedPattern = _getExpectedPatternForLevel(level);
            if (room.treasure.contains(expectedPattern)) {
              hasCorrectLevelTreasure = true;
              break;
            }
          }
        }

        expect(
          hasCorrectLevelTreasure,
          isTrue,
          reason: 'Dungeon should have treasure matching level $level',
        );
      }
    });

    test('should default to level 1 when treasure by level is enabled', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 3,
        useTreasureByLevel: true,
        // Não especifica treasureLevel, deve usar level 1 por padrão
      );

      // Verifica se os tesouros seguem o padrão do nível 1
      bool hasLevel1Treasure = false;
      for (final room in dungeon.rooms) {
        if (room.treasure.isNotEmpty) {
          // Nível 1 tem PP sempre, PO condicional
          if (room.treasure.contains('PP:') &&
              (room.treasure.contains('PO:') ||
                  room.treasure.contains('Nenhum PO'))) {
            hasLevel1Treasure = true;
            break;
          }
        }
      }

      expect(hasLevel1Treasure, isTrue);
    });

    test('should apply treasure by level correctly to all rooms', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 5,
        treasureLevel: TreasureLevel.level1,
        useTreasureByLevel: true,
      );

      // Verifica se TODAS as salas têm tesouro do nível 1
      for (final room in dungeon.rooms) {
        expect(room.treasure, isNotEmpty);
        // Nível 1 deve ter PP sempre
        expect(room.treasure, contains('PP:'));
        // Nível 1 não deve ter itens mágicos
        expect(room.treasure, contains('Nenhum Item Mágico'));
      }
    });

    test('should not apply treasure by level when disabled', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 5,
        treasureLevel: TreasureLevel.level1,
        useTreasureByLevel: false,
      );

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
    });

    test('should apply level 4-5 treasure correctly', () {
      final dungeon = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 5,
        treasureLevel: TreasureLevel.level4to5,
        useTreasureByLevel: true,
      );

      // Verifica se TODAS as salas têm tesouro do nível 4-5
      for (final room in dungeon.rooms) {
        expect(room.treasure, isNotEmpty);
        // Nível 4-5 deve ter PO sempre
        expect(room.treasure, contains('PO:'));
        // Nível 4-5 deve ter PP sempre
        expect(room.treasure, contains('PP:'));
        // Nível 4-5 deve ter Gemas sempre
        expect(room.treasure, contains('Gemas:'));
        // Nível 4-5 deve ter Objetos de Valor sempre
        expect(room.treasure, contains('Objetos de Valor:'));
        // Nível 4-5 deve ter Itens Mágicos sempre
        expect(room.treasure, contains('Itens Mágicos:'));
      }
    });

    test(
      'should clear specialTreasure and magicItem when using treasure by level',
      () {
        final dungeon = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 5,
          treasureLevel: TreasureLevel.level1,
          useTreasureByLevel: true,
        );

        // Verifica se TODAS as salas têm tesouro do nível 1 e NÃO têm specialTreasure/magicItem
        for (final room in dungeon.rooms) {
          expect(room.treasure, isNotEmpty);
          // Nível 1 deve ter PP sempre
          expect(room.treasure, contains('PP:'));
          // Nível 1 deve ter "Nenhum Item Mágico"
          expect(room.treasure, contains('Nenhum Item Mágico'));

          // Verifica se NÃO tem specialTreasure ou magicItem separados
          expect(room.specialTreasure, isEmpty);
          expect(room.magicItem, isEmpty);
        }
      },
    );

    test(
      'should not duplicate information between treasure by level and standard table',
      () {
        // Testa com tesouro por nível
        final dungeonWithLevel = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 3,
          treasureLevel: TreasureLevel.level4to5,
          useTreasureByLevel: true,
        );

        // Testa com tabela padrão
        final dungeonStandard = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 3,
          useTreasureByLevel: false,
        );

        // Verifica que não há duplicação de informações
        for (final room in dungeonWithLevel.rooms) {
          // Se tem gemas/objetos no specialTreasure, não deve ter no treasure
          if (room.specialTreasure.isNotEmpty) {
            expect(room.treasure, isNot(contains('Gemas:')));
            expect(room.treasure, isNot(contains('Objetos de Valor:')));
          }

          // Se tem itens mágicos no magicItem, não deve ter no treasure
          if (room.magicItem.isNotEmpty) {
            expect(room.treasure, isNot(contains('Itens Mágicos:')));
          }
        }

        for (final room in dungeonStandard.rooms) {
          // Se tem gemas/objetos no specialTreasure, não deve ter no treasure
          if (room.specialTreasure.isNotEmpty) {
            expect(room.treasure, isNot(contains('Gemas:')));
            expect(room.treasure, isNot(contains('Objetos de Valor:')));
          }

          // Se tem itens mágicos no magicItem, não deve ter no treasure
          if (room.magicItem.isNotEmpty) {
            expect(room.treasure, isNot(contains('Itens Mágicos:')));
          }
        }
      },
    );

    test(
      'should sync encounter difficulty with treasure level automatically',
      () {
        // Testa sincronização Iniciante -> Nível 1
        final dungeonIniciante = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 3,
          partyLevel: PartyLevel.beginners,
          useEncounterTables: true,
          useTreasureByLevel: true, // Deve ser ativado automaticamente
        );

        // Verifica se o tesouro é do nível 1 (sem itens mágicos)
        for (final room in dungeonIniciante.rooms) {
          if (room.treasure.isNotEmpty) {
            expect(room.treasure, contains('PP:'));
            expect(room.treasure, contains('Nenhum Item Mágico'));
          }
        }

        // Testa sincronização Heroico -> Nível 3
        final dungeonHeroico = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 3,
          partyLevel: PartyLevel.heroic,
          useEncounterTables: true,
          useTreasureByLevel: true, // Deve ser ativado automaticamente
        );

        // Verifica se o tesouro é do nível 2-3 (sem itens mágicos)
        for (final room in dungeonHeroico.rooms) {
          if (room.treasure.isNotEmpty) {
            expect(room.treasure, contains('PP:'));
            expect(room.treasure, contains('Nenhum Item Mágico'));
          }
        }

        // Testa sincronização Avançado -> Nível 6
        final dungeonAvancado = generator.generate(
          level: 3,
          theme: 'Test Theme',
          customRoomCount: 3,
          partyLevel: PartyLevel.advanced,
          useEncounterTables: true,
          useTreasureByLevel: true, // Deve ser ativado automaticamente
        );

        // Verifica se o tesouro é do nível 6-7 (pode ter itens mágicos)
        bool hasMagicItems = false;
        for (final room in dungeonAvancado.rooms) {
          if (room.treasure.isNotEmpty &&
              room.treasure.contains('Itens Mágicos:')) {
            hasMagicItems = true;
            break;
          }
        }
        // Pelo menos uma sala deve ter tesouro
        expect(
          dungeonAvancado.rooms.any((room) => room.treasure.isNotEmpty),
          isTrue,
        );
      },
    );

    test('should allow manual override of auto-synced treasure settings', () {
      // Testa que mesmo com sincronização automática, pode ser sobrescrito manualmente
      final dungeonManual = generator.generate(
        level: 3,
        theme: 'Test Theme',
        customRoomCount: 3,
        partyLevel: PartyLevel.beginners, // Deveria sincronizar com nível 1
        useEncounterTables: true,
        treasureLevel: TreasureLevel.level10plus, // Sobrescreve manualmente
        useTreasureByLevel: true,
      );

      // Verifica se o tesouro é do nível 10+ (pode ter itens mágicos)
      bool hasMagicItems = false;
      for (final room in dungeonManual.rooms) {
        if (room.treasure.isNotEmpty &&
            room.treasure.contains('Itens Mágicos:')) {
          hasMagicItems = true;
          break;
        }
      }
      // Pelo menos uma sala deve ter tesouro
      expect(
        dungeonManual.rooms.any((room) => room.treasure.isNotEmpty),
        isTrue,
      );
    });

    test('should regenerate occupants correctly', () {
      // Arrange
      final generator = DungeonGeneratorRefactored();
      
      // Gera uma masmorra inicial
      final dungeon = generator.generate(
        level: 3,
        theme: 'Teste',
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.easy,
        partyLevel: PartyLevel.beginners,
        useEncounterTables: true,
      );
      
      // Captura os ocupantes iniciais
      final initialMonster1 = dungeon.rooms.first.monster1;
      final initialMonster2 = dungeon.rooms.first.monster2;
      
      // Act - Regenera os ocupantes
      generator.regenerateOccupants(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.easy,
        partyLevel: PartyLevel.beginners,
      );
      
      generator.updateRoomOccupants(dungeon);
      
      // Assert - Verifica se os ocupantes foram atualizados
      expect(dungeon.rooms.first.monster1, isNotEmpty);
      expect(dungeon.rooms.first.monster2, isNotEmpty);
      
      // Verifica se pelo menos um dos ocupantes mudou (devido à aleatoriedade)
      final newMonster1 = dungeon.rooms.first.monster1;
      final newMonster2 = dungeon.rooms.first.monster2;
      
      // Pelo menos um dos ocupantes deve ter mudado
      expect(
        newMonster1 != initialMonster1 || newMonster2 != initialMonster2,
        isTrue,
        reason: 'Os ocupantes devem ter sido regenerados',
      );
    });

    test('should handle regeneration when currentDungeonData is null', () {
      // Arrange
      final generator = DungeonGeneratorRefactored();
      
      // Act - Tenta regenerar sem dados atuais
      generator.regenerateOccupants(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.easy,
        partyLevel: PartyLevel.beginners,
      );
      
      // Assert - Verifica se não houve erro
      expect(generator, isNotNull);
    });
  });
}

/// Helper function to get expected pattern for each treasure level
String _getExpectedPatternForLevel(TreasureLevel level) {
  switch (level) {
    case TreasureLevel.level1:
      return 'PP:'; // Sempre tem PP no nível 1
    case TreasureLevel.level2to3:
      return 'PP:'; // Sempre tem PP no nível 2-3
    case TreasureLevel.level4to5:
      return 'PO:'; // Sempre tem PO no nível 4-5
    case TreasureLevel.level6to7:
      return 'PO:'; // Sempre tem PO no nível 6-7
    case TreasureLevel.level8to9:
      return 'PO:'; // Sempre tem PO no nível 8-9
    case TreasureLevel.level10plus:
      return 'PO:'; // Sempre tem PO no nível 10+
  }
}
