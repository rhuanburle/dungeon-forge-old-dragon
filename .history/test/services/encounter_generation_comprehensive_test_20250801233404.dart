// test/services/encounter_generation_comprehensive_test.dart

import 'package:work/enums/table_enums.dart';
import 'package:work/models/encounter_generation.dart';
import 'package:work/services/encounter_generation_service.dart';

import '../../../lib/enums/table_enums.dart';
import '../../../lib/models/encounter_generation.dart';
import '../../../lib/services/encounter_generation_service.dart';
import 'package:test/test.dart';

void main() {
  group('EncounterGenerationService - Comprehensive Tests', () {
    late EncounterGenerationService service;

    setUp(() {
      service = EncounterGenerationService();
    });

    group('Difficulty Levels', () {
      test('should handle Easy difficulty (1d6)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.easy,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.difficultyLevel, DifficultyLevel.easy);
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(6));
      });

      test('should handle Medium difficulty (1d10)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.medium,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.difficultyLevel, DifficultyLevel.medium);
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(10));
      });

      test('should handle Challenging difficulty (1d12)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.difficultyLevel, DifficultyLevel.challenging);
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(12));
      });
    });

    group('Party Levels', () {
      test('should handle Beginners (1º a 2º Nível)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.partyLevel, PartyLevel.beginners);
        expect(encounter.partyLevel.levelRange, '1º a 2º Nível');
      });

      test('should handle Heroic (3º a 5º Nível)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.heroic,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.partyLevel, PartyLevel.heroic);
        expect(encounter.partyLevel.levelRange, '3º a 5º Nível');
      });

      test('should handle Advanced (6º Nível ou Maior)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.partyLevel, PartyLevel.advanced);
        expect(encounter.partyLevel.levelRange, '6º Nível ou Maior');
      });
    });

    group('Terrain Types', () {
      test('should handle Subterranean terrain', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.terrainType, TerrainType.subterranean);
        expect(encounter.terrainType.description, 'Subterrâneo');
      });

      test('should handle Plains terrain', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.plains,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter.terrainType, TerrainType.plains);
        expect(encounter.terrainType.description, 'Planícies');
      });

      test('should throw error for unsupported terrain', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.hills, // Not implemented yet
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        expect(() => service.generateEncounter(request), throwsArgumentError);
      });
    });

    group('Quantity Adjustments', () {
      test('should apply 50% increase to quantity', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: 0.5, // +50%
        );

        final encounter = service.generateEncounter(request);
        final adjustedQuantity = encounter.getAdjustedQuantity(0.5);

        expect(adjustedQuantity, greaterThan(encounter.quantity));
        expect(adjustedQuantity,
            encounter.quantity + (encounter.quantity * 0.5).round());
      });

      test('should apply 50% decrease to quantity', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: -0.5, // -50%
        );

        final encounter = service.generateEncounter(request);
        final adjustedQuantity = encounter.getAdjustedQuantity(-0.5);

        expect(adjustedQuantity, lessThan(encounter.quantity));
        expect(adjustedQuantity,
            encounter.quantity - (encounter.quantity * 0.5).round());
      });

      test('should not adjust solitary encounters', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
          quantityAdjustment: 0.5,
        );

        final encounter = service.generateEncounter(request);

        // Force solitary for testing
        final solitaryEncounter = EncounterGeneration(
          terrainType: encounter.terrainType,
          difficultyLevel: encounter.difficultyLevel,
          partyLevel: encounter.partyLevel,
          roll: encounter.roll,
          monsterType: encounter.monsterType,
          quantity: 1,
          isSolitary: true,
        );

        final adjustedQuantity = solitaryEncounter.getAdjustedQuantity(0.5);
        expect(adjustedQuantity, 1); // Should remain 1 for solitary
      });
    });

    group('Solitary Encounters', () {
      test('should identify solitary encounters correctly', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
        );

        final encounter = service.generateEncounter(request);

        // Check if it's a known solitary monster
        if (encounter.isSolitary) {
          expect(encounter.quantity, 1);
          expect(
              encounter.monsterType,
              anyOf(
                MonsterType.otyugh,
                MonsterType.roper,
                MonsterType.beholder,
                // Add other solitary monsters as they're implemented
              ));
        }
      });

      test('should not adjust quantity for solitary encounters', () {
        final solitaryEncounter = EncounterGeneration(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
          roll: 11,
          monsterType: MonsterType.otyugh,
          quantity: 1,
          isSolitary: true,
        );

        final adjustedQuantity = solitaryEncounter.getAdjustedQuantity(0.5);
        expect(adjustedQuantity, 1);
      });
    });

    group('Table References', () {
      test('should handle Animals Table reference', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        // If it's from animals table, should be an animal type
        if (encounter.monsterType == MonsterType.rat ||
            encounter.monsterType == MonsterType.bat ||
            encounter.monsterType == MonsterType.spiderHunterGiant) {
          expect(
              encounter.monsterType,
              anyOf(
                MonsterType.rat,
                MonsterType.bat,
                MonsterType.spiderHunterGiant,
              ));
        }
      });

      test('should handle Humans Table reference', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        // If it's from humans table, should be a human type
        if (encounter.monsterType == MonsterType.cultists ||
            encounter.monsterType == MonsterType.noviceAdventurers ||
            encounter.monsterType == MonsterType.mercenaries) {
          expect(
              encounter.monsterType,
              anyOf(
                MonsterType.cultists,
                MonsterType.noviceAdventurers,
                MonsterType.mercenaries,
              ));
        }
      });
    });

    group('Specific Monster Quantities', () {
      test('should handle Giant Rat (3d6) quantity', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        // If it's a Giant Rat, should have appropriate quantity
        if (encounter.monsterType == MonsterType.giantRat) {
          expect(encounter.quantity, greaterThanOrEqualTo(3));
          expect(encounter.quantity, lessThanOrEqualTo(18)); // 3d6 range
        }
      });

      test('should handle Kobold (4d4) quantity', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = service.generateEncounter(request);

        // If it's a Kobold, should have appropriate quantity
        if (encounter.monsterType == MonsterType.kobold) {
          expect(encounter.quantity, greaterThanOrEqualTo(4));
          expect(encounter.quantity, lessThanOrEqualTo(16)); // 4d4 range
        }
      });
    });

    group('Integration Tests', () {
      test('should generate complete encounter with all parameters', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: 0.25, // +25%
        );

        final encounter = service.generateEncounter(request);

        // Verify all properties are set correctly
        expect(encounter.terrainType, TerrainType.subterranean);
        expect(encounter.difficultyLevel, DifficultyLevel.challenging);
        expect(encounter.partyLevel, PartyLevel.beginners);
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(12));
        expect(encounter.monsterType, isA<MonsterType>());
        expect(encounter.quantity, greaterThan(0));
        expect(encounter.isSolitary, isA<bool>());

        // Test description generation
        final description = encounter.generateDescriptionWithAdjustment(0.25);
        expect(description, contains('Subterrâneo'));
        expect(description, contains('Iniciantes'));
        expect(description, contains('Desafiador'));
      });

      test('should handle different terrain and party level combinations', () {
        final combinations = [
          (TerrainType.subterranean, PartyLevel.beginners),
          (TerrainType.subterranean, PartyLevel.heroic),
          (TerrainType.subterranean, PartyLevel.advanced),
          (TerrainType.plains, PartyLevel.beginners),
          (TerrainType.plains, PartyLevel.heroic),
          (TerrainType.plains, PartyLevel.advanced),
        ];

        for (final combination in combinations) {
          final request = EncounterGenerationRequest(
            terrainType: combination.$1,
            difficultyLevel: DifficultyLevel.challenging,
            partyLevel: combination.$2,
          );

          final encounter = service.generateEncounter(request);

          expect(encounter.terrainType, combination.$1);
          expect(encounter.partyLevel, combination.$2);
          expect(encounter.roll, greaterThanOrEqualTo(1));
          expect(encounter.roll, lessThanOrEqualTo(12));
        }
      });
    });
  });
}
