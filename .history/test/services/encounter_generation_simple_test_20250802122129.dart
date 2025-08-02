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
      final levels = [PartyLevel.beginners, PartyLevel.heroic, PartyLevel.advanced];
      
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

      final subterraneanEncounter = service.generateEncounter(subterraneanRequest);
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
  });
}
