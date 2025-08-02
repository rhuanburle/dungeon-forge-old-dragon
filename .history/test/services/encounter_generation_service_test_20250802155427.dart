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

    // Testes específicos para verificar as regras das tabelas A13
    group('A13 Table Rules', () {
      test('should use correct dice for difficulty levels', () {
        // Fácil: 1d6
        final easyRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.easy,
          partyLevel: PartyLevel.beginners,
        );
        final easyEncounter = service.generateEncounter(easyRequest);
        expect(easyEncounter.roll, greaterThanOrEqualTo(1));
        expect(easyEncounter.roll, lessThanOrEqualTo(6));

        // Médio: 1d10
        final mediumRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.medium,
          partyLevel: PartyLevel.beginners,
        );
        final mediumEncounter = service.generateEncounter(mediumRequest);
        expect(mediumEncounter.roll, greaterThanOrEqualTo(1));
        expect(mediumEncounter.roll, lessThanOrEqualTo(10));

        // Desafiador: 1d12
        final challengingRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );
        final challengingEncounter = service.generateEncounter(
          challengingRequest,
        );
        expect(challengingEncounter.roll, greaterThanOrEqualTo(1));
        expect(challengingEncounter.roll, lessThanOrEqualTo(12));
      });

      test('should handle party levels correctly', () {
        // Iniciantes: 1º a 2º Nível
        final beginnersRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );
        final beginnersEncounter = service.generateEncounter(beginnersRequest);
        expect(beginnersEncounter.partyLevel, equals(PartyLevel.beginners));

        // Heroicos: 3º a 4º Nível (para tabelas A13.1-A13.10)
        final heroicRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.heroic,
        );
        final heroicEncounter = service.generateEncounter(heroicRequest);
        expect(heroicEncounter.partyLevel, equals(PartyLevel.heroic));

        // Avançado: 6º Nível ou Maior
        final advancedRequest = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
        );
        final advancedEncounter = service.generateEncounter(advancedRequest);
        expect(advancedEncounter.partyLevel, equals(PartyLevel.advanced));
      });

      test('should handle solitary encounters correctly', () {
        // Teste para monstros solitários
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        // Gerar múltiplos encontros para verificar se alguns são solitários
        final encounters = <EncounterGeneration>[];
        for (int i = 0; i < 20; i++) {
          encounters.add(service.generateEncounter(request));
        }

        // Verificar se pelo menos alguns encontros são solitários
        final solitaryEncounters = encounters.where((e) => e.isSolitary).length;
        expect(solitaryEncounters, greaterThan(0));
      });

      test('should handle table references correctly', () {
        // Teste para verificar se referências de tabela são tratadas corretamente
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        // Gerar múltiplos encontros para verificar referências de tabela
        final encounters = <EncounterGeneration>[];
        for (int i = 0; i < 30; i++) {
          encounters.add(service.generateEncounter(request));
        }

        // Verificar se encontros foram gerados (mesmo com referências)
        expect(encounters.length, equals(30));
        expect(encounters.every((e) => e.monsterType != null), isTrue);
        expect(encounters.every((e) => e.quantity > 0), isTrue);
      });

      test('should handle different terrain types correctly', () {
        // Teste para verificar se diferentes terrenos usam tabelas corretas
        final terrains = [
          TerrainType.subterranean,
          TerrainType.plains,
          TerrainType.hills,
          TerrainType.mountains,
          TerrainType.swamps,
          TerrainType.glaciers,
          TerrainType.deserts,
          TerrainType.forests,
        ];

        for (final terrain in terrains) {
          final request = EncounterGenerationRequest(
            terrainType: terrain,
            difficultyLevel: DifficultyLevel.challenging,
            partyLevel: PartyLevel.beginners,
          );

          final encounter = service.generateEncounter(request);
          expect(encounter.terrainType, equals(terrain));
          expect(encounter.monsterType, isNotNull);
          expect(encounter.quantity, greaterThan(0));
        }
      });
    });
  });
}
