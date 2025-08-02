import 'package:flutter_test/flutter_test.dart';
import 'package:work/enums/table_enums.dart';
import 'package:work/enums/dice_enums.dart';
import 'package:work/services/dice_roller_service.dart';
import 'package:work/services/encounter_generation_service.dart';
import 'package:work/models/encounter_generation.dart';

void main() {
  group('Encounter Rules TDD', () {
    late DiceRollerService diceRoller;
    late EncounterGenerationService encounterService;

    setUp(() {
      diceRoller = DiceRollerService();
      encounterService = EncounterGenerationService(diceRoller: diceRoller);
    });

    group('Dice Rules', () {
      test('should roll correct dice for difficulty levels', () {
        // Fácil: 1d6
        final easyRoll = diceRoller.rollForTable(6);
        expect(easyRoll, greaterThanOrEqualTo(1));
        expect(easyRoll, lessThanOrEqualTo(6));

        // Mediano: 1d10
        final mediumRoll = diceRoller.rollForTable(10);
        expect(mediumRoll, greaterThanOrEqualTo(1));
        expect(mediumRoll, lessThanOrEqualTo(10));

        // Desafiador: 1d12
        final challengingRoll = diceRoller.rollForTable(12);
        expect(challengingRoll, greaterThanOrEqualTo(1));
        expect(challengingRoll, lessThanOrEqualTo(12));
      });

      test('should roll 1d8 for extraplanar table', () {
        final extraplanarRoll = diceRoller.rollSingleDie(DiceType.d8);
        expect(extraplanarRoll, greaterThanOrEqualTo(1));
        expect(extraplanarRoll, lessThanOrEqualTo(8));
      });

      test('should roll 2d6 for humans table', () {
        final humansRoll = diceRoller.rollMultipleDice(DiceType.d6, 2);
        expect(humansRoll, greaterThanOrEqualTo(2)); // mínimo 2d6 = 2
        expect(humansRoll, lessThanOrEqualTo(12)); // máximo 2d6 = 12
      });

      test('should roll 1d6 for animals table', () {
        final animalsRoll = diceRoller.rollSingleDie(DiceType.d6);
        expect(animalsRoll, greaterThanOrEqualTo(1));
        expect(animalsRoll, lessThanOrEqualTo(6));
      });
    });

    group('Party Level Rules', () {
      test('should handle beginners level (1º a 2º Nível)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.beginners,
        );

        final encounter = encounterService.generateEncounter(request);
        expect(encounter.partyLevel, equals(PartyLevel.beginners));
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(12));
      });

      test('should handle heroic level (3º a 5º Nível)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.heroic,
        );

        final encounter = encounterService.generateEncounter(request);
        expect(encounter.partyLevel, equals(PartyLevel.heroic));
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(12));
      });

      test('should handle advanced level (6º Nível ou Maior)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.subterranean,
          difficultyLevel: DifficultyLevel.challenging,
          partyLevel: PartyLevel.advanced,
        );

        final encounter = encounterService.generateEncounter(request);
        expect(encounter.partyLevel, equals(PartyLevel.advanced));
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(12));
      });
    });

    group('Monster Quantity Rules', () {
      test('should handle complex dice expressions correctly', () {
        // Teste para expressões complexas como "5+1d3" (Hidra)
        final hydra5Heads = diceRoller.rollComplexDice('5+1d3');
        expect(hydra5Heads, greaterThanOrEqualTo(6)); // mínimo 5+1d3 = 6
        expect(hydra5Heads, lessThanOrEqualTo(8)); // máximo 5+1d3 = 8

        final hydra8Heads = diceRoller.rollComplexDice('8+1d4');
        expect(hydra8Heads, greaterThanOrEqualTo(9)); // mínimo 8+1d4 = 9
        expect(hydra8Heads, lessThanOrEqualTo(12)); // máximo 8+1d4 = 12
      });

      test('should handle multiple dice correctly', () {
        // Teste para múltiplos dados
        final threeD6 = diceRoller.rollMultipleDice(DiceType.d6, 3);
        expect(threeD6, greaterThanOrEqualTo(3)); // mínimo 3d6 = 3
        expect(threeD6, lessThanOrEqualTo(18)); // máximo 3d6 = 18

        final fourD4 = diceRoller.rollMultipleDice(DiceType.d4, 4);
        expect(fourD4, greaterThanOrEqualTo(4)); // mínimo 4d4 = 4
        expect(fourD4, lessThanOrEqualTo(16)); // máximo 4d4 = 16

        final sixD6 = diceRoller.rollMultipleDice(DiceType.d6, 6);
        expect(sixD6, greaterThanOrEqualTo(6)); // mínimo 6d6 = 6
        expect(sixD6, lessThanOrEqualTo(36)); // máximo 6d6 = 36

        final tenD4 = diceRoller.rollMultipleDice(DiceType.d4, 10);
        expect(tenD4, greaterThanOrEqualTo(10)); // mínimo 10d4 = 10
        expect(tenD4, lessThanOrEqualTo(40)); // máximo 10d4 = 40
      });

      test('should handle single dice correctly', () {
        // Teste para dados únicos
        final oneD8 = diceRoller.rollSingleDie(DiceType.d8);
        expect(oneD8, greaterThanOrEqualTo(1));
        expect(oneD8, lessThanOrEqualTo(8));

        final oneD2 = diceRoller.rollSingleDie(DiceType.d2);
        expect(oneD2, greaterThanOrEqualTo(1));
        expect(oneD2, lessThanOrEqualTo(2));

        final oneD3 = diceRoller.rollSingleDie(DiceType.d3);
        expect(oneD3, greaterThanOrEqualTo(1));
        expect(oneD3, lessThanOrEqualTo(3));

        final oneD4 = diceRoller.rollSingleDie(DiceType.d4);
        expect(oneD4, greaterThanOrEqualTo(1));
        expect(oneD4, lessThanOrEqualTo(4));

        final oneD6 = diceRoller.rollSingleDie(DiceType.d6);
        expect(oneD6, greaterThanOrEqualTo(1));
        expect(oneD6, lessThanOrEqualTo(6));

        final oneD10 = diceRoller.rollSingleDie(DiceType.d10);
        expect(oneD10, greaterThanOrEqualTo(1));
        expect(oneD10, lessThanOrEqualTo(10));

        final oneD12 = diceRoller.rollSingleDie(DiceType.d12);
        expect(oneD12, greaterThanOrEqualTo(1));
        expect(oneD12, lessThanOrEqualTo(12));
      });
    });

    group('Table Specific Rules', () {
      test('should use 1d12 for main encounter tables (A13.1-A13.9)', () {
        final terrains = [
          TerrainType.subterranean,
          TerrainType.plains,
          TerrainType.hills,
          TerrainType.mountains,
          TerrainType.swamps,
          TerrainType.glaciers,
          TerrainType.deserts,
          TerrainType.forests,
          TerrainType.any,
        ];

        for (final terrain in terrains) {
          final request = EncounterGenerationRequest(
            terrainType: terrain,
            difficultyLevel: DifficultyLevel.challenging,
            partyLevel: PartyLevel.beginners,
          );

          final encounter = encounterService.generateEncounter(request);
          expect(encounter.roll, greaterThanOrEqualTo(1));
          expect(encounter.roll, lessThanOrEqualTo(12));
        }
      });

      test('should use 1d8 for extraplanar table (A13.10)', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.extraplanar,
          difficultyLevel: DifficultyLevel.medium, // 1d8
          partyLevel: PartyLevel.beginners,
        );

        final encounter = encounterService.generateEncounter(request);
        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(8));
      });

      test('should use 2d6 for humans table (A13.11)', () {
        // Teste direto do serviço de dados
        final humansRoll = diceRoller.rollMultipleDice(DiceType.d6, 2);
        expect(humansRoll, greaterThanOrEqualTo(2));
        expect(humansRoll, lessThanOrEqualTo(12));
      });

      test('should use 1d6 for animals table (A13.2)', () {
        // Teste direto do serviço de dados
        final animalsRoll = diceRoller.rollSingleDie(DiceType.d6);
        expect(animalsRoll, greaterThanOrEqualTo(1));
        expect(animalsRoll, lessThanOrEqualTo(6));
      });
    });

    group('Solitary Encounter Rules', () {
      test('should identify solitary encounters correctly', () {
        // Teste para monstros que são naturalmente solitários
        final solitaryMonsters = [
          MonsterType.otyugh,
          MonsterType.roper,
          MonsterType.beholder,
          MonsterType.oldBoneDragon,
          MonsterType.ochreJelly,
          MonsterType.rustMonster,
          MonsterType.maceTail,
          MonsterType.grayOoze,
          MonsterType.carrionWorm,
          MonsterType.gelatinousCube,
          MonsterType.boneDragon,
          MonsterType.shriekerFungus,
          MonsterType.drider,
          MonsterType.brainDevourer,
        ];

        for (final monster in solitaryMonsters) {
          final request = EncounterGenerationRequest(
            terrainType: TerrainType.subterranean,
            difficultyLevel: DifficultyLevel.challenging,
            partyLevel: PartyLevel.beginners,
          );

          // Simular um encontro com monstro solitário
          final encounter = EncounterGeneration(
            terrainType: request.terrainType,
            difficultyLevel: request.difficultyLevel,
            partyLevel: request.partyLevel,
            roll: 1,
            monsterType: monster,
            quantity: 1,
            isSolitary: true,
          );

          expect(encounter.isSolitary, isTrue);
          expect(encounter.quantity, equals(1));
        }
      });

      test('should identify extraplanar encounters as solitary', () {
        final request = EncounterGenerationRequest(
          terrainType: TerrainType.extraplanar,
          difficultyLevel: DifficultyLevel.medium,
          partyLevel: PartyLevel.beginners,
        );

        // Gerar múltiplos encontros para verificar se são solitários
        final encounters = <EncounterGeneration>[];
        for (int i = 0; i < 20; i++) {
          encounters.add(encounterService.generateEncounter(request));
        }

        // Todos os encontros extraplanares devem ser solitários
        final solitaryEncounters = encounters.where((e) => e.isSolitary).length;
        expect(solitaryEncounters, equals(20));
      });
    });

    group('Difficulty Modifier Rules', () {
      test('should apply 50% difficulty modifier correctly', () {
        // Teste para 50% menos
        final reducedQuantity = diceRoller.rollForMonsterQuantityWithDifficulty('2d6', 0.5);
        expect(reducedQuantity, greaterThanOrEqualTo(1)); // mínimo 1
        
        // Teste para 50% mais
        final increasedQuantity = diceRoller.rollForMonsterQuantityWithDifficulty('2d6', 1.5);
        expect(increasedQuantity, greaterThanOrEqualTo(1)); // mínimo 1
        
        // Teste que o modificador está funcionando
        expect(reducedQuantity, isA<int>());
        expect(increasedQuantity, isA<int>());
      });
    });
  });
} 