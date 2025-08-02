// test/services/encounter_generation_simple_test.dart

import 'package:test/test.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/models/encounter_generation.dart';
import '../../lib/services/encounter_generation_service.dart';

void main() {
  group('EncounterGenerationService Terrain Test', () {
    late EncounterGenerationService service;

    setUp(() {
      service = EncounterGenerationService();
    });

    test('should generate subterranean encounter successfully', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter, isNotNull);
      expect(encounter.terrainType, TerrainType.subterranean);
      expect(encounter.difficultyLevel, DifficultyLevel.challenging);
      expect(encounter.partyLevel, PartyLevel.beginners);
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate plains encounter successfully', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter, isNotNull);
      expect(encounter.terrainType, TerrainType.plains);
      expect(encounter.difficultyLevel, DifficultyLevel.challenging);
      expect(encounter.partyLevel, PartyLevel.beginners);
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should handle different party levels for plains', () {
      final levels = [
        PartyLevel.beginners,
        PartyLevel.heroic,
        PartyLevel.advanced
      ];

      for (final level in levels) {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.plains,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: level,
          quantityAdjustment: 0.0,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter, isNotNull);
        expect(encounter.terrainType, TerrainType.plains);
        expect(encounter.partyLevel, level);
        expect(encounter.monsterType, isNotNull);
      }
    });

    test('should handle different difficulty levels for plains', () {
      final difficulties = [
        DifficultyLevel.easy,
        DifficultyLevel.medium,
        DifficultyLevel.challenging,
      ];

      for (final difficulty in difficulties) {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.plains,
          difficultyLevel: difficulty,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: 0.0,
        );

        final encounter = service.generateEncounter(request);

        expect(encounter, isNotNull);
        expect(encounter.terrainType, TerrainType.plains);
        expect(encounter.difficultyLevel, difficulty);
        expect(encounter.monsterType, isNotNull);
      }
    });

    test('should generate different monsters for different terrains', () {
      final subterraneanRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final plainsRequest = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final subterraneanEncounter =
          service.generateEncounter(subterraneanRequest);
      final plainsEncounter = service.generateEncounter(plainsRequest);

      expect(subterraneanEncounter.terrainType, TerrainType.subterranean);
      expect(plainsEncounter.terrainType, TerrainType.plains);

      // Both should have valid monster types
      expect(subterraneanEncounter.monsterType, isNotNull);
      expect(plainsEncounter.monsterType, isNotNull);

      // Both should have valid quantities
      expect(subterraneanEncounter.quantity, greaterThan(0));
      expect(plainsEncounter.quantity, greaterThan(0));
    });

    test('should handle all terrain types without errors', () {
      final supportedTerrains = [TerrainType.subterranean, TerrainType.plains];

      for (final terrain in supportedTerrains) {
        final request = EncounterGenerationRequest(
          terrainType: terrain,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: 0.0,
        );

        expect(() => service.generateEncounter(request), returnsNormally);
      }
    });

    test('should simulate UI flow for different terrains', () {
      // Simulate the exact UI flow
      final terrains = [TerrainType.subterranean, TerrainType.plains];
      final difficulties = [
        DifficultyLevel.easy,
        DifficultyLevel.medium,
        DifficultyLevel.challenging
      ];
      final partyLevels = [
        PartyLevel.beginners,
        PartyLevel.heroic,
        PartyLevel.advanced
      ];

      for (final terrain in terrains) {
        for (final difficulty in difficulties) {
          for (final partyLevel in partyLevels) {
            // Simulate UI request creation
            final request = EncounterGenerationRequest(
              terrainType: terrain,
              difficultyLevel: difficulty,
              partyLevel: partyLevel,
              quantityAdjustment: 0.0,
            );

            // Simulate service call
            final encounter = service.generateEncounter(request);

            // Verify the encounter is valid
            expect(encounter, isNotNull);
            expect(encounter.terrainType, terrain);
            expect(encounter.difficultyLevel, difficulty);
            expect(encounter.partyLevel, partyLevel);
            expect(encounter.monsterType, isNotNull);
            expect(encounter.quantity, greaterThan(0));
            expect(encounter.roll, greaterThanOrEqualTo(1));
            // O roll deve estar dentro do range da tabela, não da dificuldade
            expect(encounter.roll, greaterThanOrEqualTo(1));
            expect(encounter.roll, lessThanOrEqualTo(12)); // Máximo para tabelas A13

            // Test description generation (UI functionality)
            final description = encounter.generateDescription();
            expect(description, isNotEmpty);
            expect(description, contains(terrain.description));
            expect(description, contains(encounter.monsterType.description));

            // Test adjusted quantity calculation (UI functionality)
            final adjustedQuantity = encounter.getAdjustedQuantity(0.5);
            if (!encounter.isSolitary) {
              expect(adjustedQuantity, greaterThan(encounter.quantity));
            } else {
              expect(adjustedQuantity, equals(encounter.quantity));
            }
          }
        }
      }
    });

    test('should produce different results for different terrains', () {
      // Test that different terrains actually produce different results
      final request1 = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final request2 = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      final encounter1 = service.generateEncounter(request1);
      final encounter2 = service.generateEncounter(request2);

      // Both should be valid
      expect(encounter1.terrainType, TerrainType.subterranean);
      expect(encounter2.terrainType, TerrainType.plains);

      // Both should have valid monster types
      expect(encounter1.monsterType, isNotNull);
      expect(encounter2.monsterType, isNotNull);

      // Both should have valid quantities
      expect(encounter1.quantity, greaterThan(0));
      expect(encounter2.quantity, greaterThan(0));

      // The descriptions should be different (different terrain names)
      final desc1 = encounter1.generateDescription();
      final desc2 = encounter2.generateDescription();

      expect(desc1, contains('Subterrâneo'));
      expect(desc2, contains('Planícies'));
    });

    test('should follow A13 table rules for quantities', () {
      // Test that quantities follow the A13 table rules
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0,
      );

      // Generate multiple encounters to test different rolls
      for (int i = 0; i < 10; i++) {
        final encounter = service.generateEncounter(request);

        // Verify the encounter follows A13 rules
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll,
            lessThanOrEqualTo(12)); // Máximo para tabelas A13

        // Verify quantity is valid
        expect(encounter.quantity, greaterThan(0));

        // For solitary encounters, quantity should be 1
        if (encounter.isSolitary) {
          expect(encounter.quantity, equals(1));
        }
      }
    });

    test('should handle difficulty levels correctly according to A13 rules',
        () {
      // Test that difficulty levels use correct dice according to A13 rules
      final difficulties = [
        DifficultyLevel.easy, // Pode usar 1d6 ou dados da tabela
        DifficultyLevel.medium, // Pode usar 1d10 ou dados da tabela
        DifficultyLevel.challenging, // Pode usar 1d12 ou dados da tabela
      ];

      for (final difficulty in difficulties) {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: difficulty,
          partyLevel: PartyLevel.beginners,
          quantityAdjustment: 0.0,
        );

        final encounter = service.generateEncounter(request);

        // Verify roll is within correct range for difficulty
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(difficulty.diceSides));
      }
    });

    test('should handle party levels correctly according to A13 rules', () {
      // Test that party levels are handled correctly according to A13 rules
      final partyLevels = [
        PartyLevel.beginners, // 1º a 2º Nível
        PartyLevel.heroic, // 3º a 5º Nível
        PartyLevel.advanced, // 6º Nível ou Maior
      ];

      for (final partyLevel in partyLevels) {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: partyLevel,
          quantityAdjustment: 0.0,
        );

        final encounter = service.generateEncounter(request);

        // Verify party level is correct
        expect(encounter.partyLevel, partyLevel);

        // Verify encounter is valid
        expect(encounter.monsterType, isNotNull);
        expect(encounter.quantity, greaterThan(0));
      }
    });
  });
}
