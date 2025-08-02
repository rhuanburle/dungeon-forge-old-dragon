// test/models/encounter_generation_test.dart

import 'package:dungeon_forge/enums/table_enums.dart';
import 'package:dungeon_forge/models/encounter_generation.dart';
import 'package:test/test.dart';

void main() {
  group('EncounterGeneration', () {
    test('should create encounter generation with valid parameters', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        roll: 5,
        monsterType: MonsterType.kobold,
        quantity: 4,
        isSolitary: false,
      );

      expect(encounter.terrainType, TerrainType.subterranean);
      expect(encounter.difficultyLevel, DifficultyLevel.challenging);
      expect(encounter.partyLevel, PartyLevel.beginners);
      expect(encounter.roll, 5);
      expect(encounter.monsterType, MonsterType.kobold);
      expect(encounter.quantity, 4);
      expect(encounter.isSolitary, false);
    });

    test('should create solitary encounter', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
        roll: 11,
        monsterType: MonsterType.otyugh,
        quantity: 1,
        isSolitary: true,
      );

      expect(encounter.isSolitary, true);
      expect(encounter.quantity, 1);
    });

    test('should calculate adjusted quantity with 50% increase', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        roll: 2,
        monsterType: MonsterType.giantRat,
        quantity: 6,
        isSolitary: false,
      );

      final adjustedQuantity =
          encounter.getAdjustedQuantity(0.5); // 50% increase
      expect(adjustedQuantity, 9); // 6 + (6 * 0.5) = 9
    });

    test('should calculate adjusted quantity with 50% decrease', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        roll: 2,
        monsterType: MonsterType.giantRat,
        quantity: 6,
        isSolitary: false,
      );

      final adjustedQuantity =
          encounter.getAdjustedQuantity(-0.5); // 50% decrease
      expect(adjustedQuantity, 3); // 6 - (6 * 0.5) = 3
    });

    test('should return original quantity for solitary encounters', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
        roll: 11,
        monsterType: MonsterType.otyugh,
        quantity: 1,
        isSolitary: true,
      );

      final adjustedQuantity = encounter.getAdjustedQuantity(0.5);
      expect(adjustedQuantity, 1); // Solitary encounters don't get adjusted
    });

    test('should generate description correctly', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        roll: 2,
        monsterType: MonsterType.giantRat,
        quantity: 6,
        isSolitary: false,
      );

      final description = encounter.generateDescription();
      expect(description, contains('Rato Gigante'));
      expect(description, contains('6'));
      expect(description, contains('Subterrâneo'));
      expect(description, contains('Iniciantes'));
    });

    test('should generate description for solitary encounter', () {
      final encounter = EncounterGeneration(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
        roll: 11,
        monsterType: MonsterType.otyugh,
        quantity: 1,
        isSolitary: true,
      );

      final description = encounter.generateDescription();
      expect(description, contains('Otyugh'));
      expect(description, contains('Solitário'));
      expect(description, contains('Avançado'));
    });
  });

  group('EncounterGenerationRequest', () {
    test('should create request with valid parameters', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.0, // No adjustment
      );

      expect(request.terrainType, TerrainType.subterranean);
      expect(request.difficultyLevel, DifficultyLevel.challenging);
      expect(request.partyLevel, PartyLevel.beginners);
      expect(request.quantityAdjustment, 0.0);
    });

    test('should create request with quantity adjustment', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.medium,
        partyLevel: PartyLevel.heroic,
        quantityAdjustment: 0.5, // 50% increase
      );

      expect(request.quantityAdjustment, 0.5);
    });

    test('should validate request parameters', () {
      expect(
          () => EncounterGenerationRequest(
                terrainType: TerrainType.subterranean,
                difficultyLevel: DifficultyLevel.challenging,
                partyLevel: PartyLevel.beginners,
                quantityAdjustment: 0.0,
              ),
          returnsNormally);

      // Test invalid quantity adjustment
      expect(
          () => EncounterGenerationRequest(
                terrainType: TerrainType.subterranean,
                difficultyLevel: DifficultyLevel.challenging,
                partyLevel: PartyLevel.beginners,
                quantityAdjustment: 2.0, // Invalid: more than 100% increase
              ),
          throwsArgumentError);
    });
  });
}
