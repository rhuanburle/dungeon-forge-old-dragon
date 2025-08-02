// test/services/encounter_generation_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/encounter_generation_service.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/models/encounter_generation.dart';

void main() {
  group('EncounterGenerationService', () {
    late EncounterGenerationService service;

    setUp(() {
      service = EncounterGenerationService();
    });

    test('should generate encounter for subterranean terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.subterranean,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.subterranean));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.beginners));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for plains terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.plains,
        difficultyLevel: DifficultyLevel.medium,
        partyLevel: PartyLevel.heroic,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.plains));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.medium));
      expect(encounter.partyLevel, equals(PartyLevel.heroic));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(10));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for hills terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.hills,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.hills));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.advanced));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for mountains terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.mountains,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.mountains));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.beginners));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for swamps terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.swamps,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.heroic,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.swamps));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.heroic));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for glaciers terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.glaciers,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.advanced,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.glaciers));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.advanced));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for deserts terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.deserts,
        difficultyLevel: DifficultyLevel.challenging,
        partyLevel: PartyLevel.beginners,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.deserts));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.challenging));
      expect(encounter.partyLevel, equals(PartyLevel.beginners));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(12));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });

    test('should generate encounter for forests terrain', () {
      final request = EncounterGenerationRequest(
        terrainType: TerrainType.forests,
        difficultyLevel: DifficultyLevel.easy,
        partyLevel: PartyLevel.heroic,
      );

      final encounter = service.generateEncounter(request);

      expect(encounter.terrainType, equals(TerrainType.forests));
      expect(encounter.difficultyLevel, equals(DifficultyLevel.easy));
      expect(encounter.partyLevel, equals(PartyLevel.heroic));
      expect(encounter.roll, greaterThanOrEqualTo(1));
      expect(encounter.roll, lessThanOrEqualTo(6));
      expect(encounter.monsterType, isNotNull);
      expect(encounter.quantity, greaterThan(0));
    });
  });
} 