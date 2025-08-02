// test/services/encounter_generation_service_test.dart

import '../../../lib/enums/table_enums.dart';
import '../../../lib/models/encounter_generation.dart';
import '../../../lib/services/encounter_generation_service.dart';
import 'package:test/test.dart';

void main() {
  group('EncounterGenerationService', () {
    late EncounterGenerationService service;

    setUp(() {
      service = EncounterGenerationService();
    });

    test('should generate encounter for subterranean terrain', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      // Act
      final encounter = service.generateEncounter(request);

      // Assert
      expect(encounter.terrainType, TerrainType.subterranean);
      expect(encounter.difficultyLevel, DifficultyLevel.challenging);
      expect(encounter.partyLevel, PartyLevel.beginners);
      expect(encounter.roll, isA<int>());
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isA<MonsterType>());
      expect(encounter.quantity, isA<int>());
      expect(encounter.quantity, greaterThan(0));
      expect(encounter.isSolitary, isA<bool>());
    });

    test('should generate encounter for plains terrain', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.heroic,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2); // Roll 2 for Hellhound
      when(mockDiceRoller.rollDice(4)).thenReturn(2); // 2d4 for quantity

      // Act
      final encounter = service.generateEncounter(request);

      // Assert
      expect(encounter.terrainType, TerrainType.plains);
      expect(encounter.difficultyLevel, DifficultyLevel.challenging);
      expect(encounter.partyLevel, PartyLevel.heroic);
      expect(encounter.roll, 2);
      expect(encounter.monsterType, MonsterType.hellhound);
      expect(encounter.quantity, 2);
      expect(encounter.isSolitary, false);
    });

    test('should generate solitary encounter', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(11); // Roll 11 for Otyugh (solitary)
      when(mockDiceRoller.rollDice(1)).thenReturn(1); // Quantity for solitary

      // Act
      final encounter = service.generateEncounter(request);

      // Assert
      expect(encounter.monsterType, MonsterType.otyugh);
      expect(encounter.isSolitary, true);
      expect(encounter.quantity, 1);
    });

    test('should handle table references correctly', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(1); // Roll 1 for Animals Table
      when(mockDiceRoller.rollDice(6)).thenReturn(2); // Roll for animal type

      // Act
      final encounter = service.generateEncounter(request);

      // Assert
      expect(encounter.monsterType, MonsterType.rat); // From animals table
      expect(encounter.quantity, 2);
    });

    test('should apply quantity adjustment correctly', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.5, // 50% increase
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2); // Roll 2 for Giant Rat
      when(mockDiceRoller.rollDice(6)).thenReturn(4); // 4d6 for quantity

      // Act
      final encounter = service.generateEncounter(request);

      // Assert
      expect(encounter.quantity, 4);
      final adjustedQuantity = encounter.getAdjustedQuantity(0.5);
      expect(adjustedQuantity, 6); // 4 + (4 * 0.5) = 6
    });

    test('should handle different difficulty levels', () {
      // Test Easy difficulty (1d6)
      final easyRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.easy,
        partyLevel: PartyLevel.beginners,
      );

      when(mockDiceRoller.rollDice(6)).thenReturn(3);

      final easyEncounter = service.generateEncounter(easyRequest);
      expect(easyEncounter.roll, 3);
      expect(easyEncounter.difficultyLevel, DifficultyLevel.easy);

      // Test Medium difficulty (1d10)
      final mediumRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.medium,
        partyLevel: PartyLevel.beginners,
      );

      when(mockDiceRoller.rollDice(10)).thenReturn(7);

      final mediumEncounter = service.generateEncounter(mediumRequest);
      expect(mediumEncounter.roll, 7);
      expect(mediumEncounter.difficultyLevel, DifficultyLevel.medium);
    });

    test('should handle all party levels', () {
      // Test Beginners
      final beginnersRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2);
      when(mockDiceRoller.rollDice(6)).thenReturn(3);

      final beginnersEncounter = service.generateEncounter(beginnersRequest);
      expect(beginnersEncounter.partyLevel, PartyLevel.beginners);

      // Test Heroic
      final heroicRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.heroic,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2);
      when(mockDiceRoller.rollDice(8)).thenReturn(4);

      final heroicEncounter = service.generateEncounter(heroicRequest);
      expect(heroicEncounter.partyLevel, PartyLevel.heroic);

      // Test Advanced
      final advancedRequest = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2);
      when(mockDiceRoller.rollDice(4)).thenReturn(2);

      final advancedEncounter = service.generateEncounter(advancedRequest);
      expect(advancedEncounter.partyLevel, PartyLevel.advanced);
    });

    test('should throw error for invalid roll', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(13); // Invalid roll

      // Act & Assert
      expect(() => service.generateEncounter(request), throwsArgumentError);
    });

    test('should generate description with adjustment', () {
      // Arrange
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
        quantityAdjustment: 0.5,
      );

      when(mockDiceRoller.rollDice(12)).thenReturn(2);
      when(mockDiceRoller.rollDice(6)).thenReturn(4);

      // Act
      final encounter = service.generateEncounter(request);
      final description = encounter.generateDescriptionWithAdjustment(0.5);

      // Assert
      expect(description, contains('Rato Gigante'));
      expect(description, contains('6')); // Adjusted quantity
      expect(description, contains('+50%')); // Adjustment text
    });
  });
} 