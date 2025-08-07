// test/services/turn_monitor_service_test.dart

import 'package:flutter_test/flutter_test.dart';
import '../../lib/services/turn_monitor_service.dart';
import '../../lib/models/turn_monitor.dart';

void main() {
  group('TurnMonitorService', () {
    late TurnMonitorService service;

    setUp(() {
      service = TurnMonitorService();
    });

    group('Gerenciamento de Turnos', () {
      test('deve adicionar turno corretamente', () {
        expect(service.turns.length, equals(0));
        expect(service.currentTurn, equals(1));

        service.addTurn();

        expect(service.turns.length, equals(1));
        expect(service.currentTurn, equals(2));
        expect(service.turns.first.number, equals(1));
        expect(service.turns.first.isExploration, isFalse);
        expect(service.turns.first.isEncounter, isFalse);
        expect(service.turns.first.isFighting, isFalse);
      });

      test('deve adicionar turno com ações específicas', () {
        service.addTurn(
          isExploration: true,
          isEncounter: false,
          isFighting: true,
          isResting: false,
          isSearching: false,
          isMoving: false,
          isDoorAction: false,
          isTrapAction: false,
          notes: 'Teste de turno',
        );

        expect(service.turns.length, equals(1));
        expect(service.turns.first.isExploration, isTrue);
        expect(service.turns.first.isEncounter, isFalse);
        expect(service.turns.first.isFighting, isTrue);
        expect(service.turns.first.notes, equals('Teste de turno'));
      });

      test('deve atualizar turno existente', () {
        service.addTurn();

        final updatedTurn = service.turns.first.copyWith(
          isExploration: true,
          notes: 'Turno atualizado',
        );

        service.updateTurn(1, updatedTurn);

        expect(service.turns.first.isExploration, isTrue);
        expect(service.turns.first.notes, equals('Turno atualizado'));
      });

      test('deve remover turno e reorganizar números', () {
        service.addTurn();
        service.addTurn();
        service.addTurn();

        expect(service.turns.length, equals(3));
        expect(service.turns[0].number, equals(1));
        expect(service.turns[1].number, equals(2));
        expect(service.turns[2].number, equals(3));

        service.removeTurn(2);

        expect(service.turns.length, equals(2));
        expect(service.turns[0].number, equals(1));
        expect(service.turns[1].number, equals(2));
        expect(service.currentTurn, equals(3));
      });

      test('deve contar turnos de exploração e descanso', () {
        service.addTurn(isExploration: true);
        service.addTurn(isResting: true);
        service.addTurn(isExploration: true);
        service.addTurn(isMoving: true);

        expect(service.explorationTurns, equals(3));
        expect(service.restTurns, equals(1));
      });
    });

    group('Gerenciamento de Dados do Grupo', () {
      test('deve atualizar dados do grupo', () {
        final groupData = GroupData(
          groupName: 'Grupo Teste',
          groupMovement: 30,
          movementPerTurn: 10,
          maxMovement: 50,
          masterNotes: 'Anotações do mestre',
          hasTorch: true,
          hasLantern: false,
          torchTurns: 6,
          lanternTurns: 0,
          exhaustionLevel: 0,
          isExhausted: false,
        );

        service.updateGroupData(groupData);

        expect(service.groupData.groupName, equals('Grupo Teste'));
        expect(service.groupData.groupMovement, equals(30));
        expect(service.groupData.movementPerTurn, equals(10));
        expect(service.groupData.maxMovement, equals(50));
        expect(service.groupData.masterNotes, equals('Anotações do mestre'));
        expect(service.groupData.hasTorch, isTrue);
        expect(service.groupData.hasLantern, isFalse);
        expect(service.groupData.torchTurns, equals(6));
      });
    });

    group('Gerenciamento de Encontros', () {
      test('deve adicionar encontro', () {
        final encounter = Encounter(
          roll: 5,
          creature: 'Goblin',
          maxHp: 7,
          currentHp: 5,
          reaction: 'Hostil',
          notes: 'Encontro teste',
          isSurprise: false,
          distance: 9,
          type: EncounterType.random,
        );

        service.addEncounter(encounter);

        expect(service.encounters.length, equals(1));
        expect(service.encounters.first.creature, equals('Goblin'));
        expect(service.encounters.first.roll, equals(5));
        expect(service.encounters.first.currentHp, equals(5));
        expect(service.encounters.first.maxHp, equals(7));
        expect(service.encounters.first.distance, equals(9));
      });

      test('deve atualizar encontro', () {
        final encounter = Encounter(
          roll: 5,
          creature: 'Goblin',
          maxHp: 7,
          currentHp: 5,
        );

        service.addEncounter(encounter);

        final updatedEncounter = encounter.copyWith(
          currentHp: 3,
          notes: 'Encontro atualizado',
        );

        service.updateEncounter(0, updatedEncounter);

        expect(service.encounters.first.currentHp, equals(3));
        expect(service.encounters.first.notes, equals('Encontro atualizado'));
      });

      test('deve remover encontro', () {
        final encounter = Encounter(
          roll: 5,
          creature: 'Goblin',
          maxHp: 7,
          currentHp: 5,
        );

        service.addEncounter(encounter);
        expect(service.encounters.length, equals(1));

        service.removeEncounter(0);
        expect(service.encounters.length, equals(0));
      });
    });

    group('Verificação de Encontros', () {
      test('deve verificar se é hora de rolar encontro a cada 2 turnos', () {
        // Primeiro turno não deve rolar
        expect(service.shouldRollEncounter(), isFalse);

        // Adiciona primeiro turno
        service.addTurn();
        expect(service.shouldRollEncounter(), isFalse);

        // Adiciona segundo turno - deve rolar
        service.addTurn();
        expect(service.shouldRollEncounter(), isTrue);

        // Adiciona terceiro turno - não deve rolar
        service.addTurn();
        expect(service.shouldRollEncounter(), isFalse);

        // Adiciona quarto turno - deve rolar
        service.addTurn();
        expect(service.shouldRollEncounter(), isTrue);
      });

      test('deve verificar encontro com probabilidade correta', () {
        int encounters = 0;
        const trials = 1000;

        for (int i = 0; i < trials; i++) {
          if (service.checkForEncounter()) {
            encounters++;
          }
        }

        final probability = encounters / trials;
        // Deve estar próximo de 1/6 (0.167) com margem de erro
        expect(probability, greaterThan(0.15));
        expect(probability, lessThan(0.19));
      });

      test('deve verificar encontro com luz e barulho', () {
        int encounters = 0;
        const trials = 1000;

        for (int i = 0; i < trials; i++) {
          if (service.checkForEncounter(hasLight: true, hasNoise: true)) {
            encounters++;
          }
        }

        final probability = encounters / trials;
        // Deve estar próximo de 3/6 (0.5) com margem de erro
        expect(probability, greaterThan(0.45));
        expect(probability, lessThan(0.55));
      });

      test('deve gerar encontro aleatório com dados válidos', () {
        final encounter = service.generateRandomEncounter();

        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(10));
        expect(encounter.creature, isNotEmpty);
        expect(encounter.maxHp, greaterThan(0));
        expect(encounter.currentHp, equals(encounter.maxHp));
        expect(encounter.reaction, isNotEmpty);
        expect(encounter.distance, greaterThan(0));
        expect(encounter.type, equals(EncounterType.random));
      });

      test('deve calcular distância do encontro corretamente', () {
        final distance = service.calculateEncounterDistance();

        expect(distance, greaterThanOrEqualTo(3));
        expect(distance, lessThanOrEqualTo(18));
        expect(distance % 3, equals(0)); // Deve ser múltiplo de 3
      });
    });

    group('Cálculo de Movimento', () {
      test('deve calcular movimento normal', () {
        service.updateGroupData(
          GroupData(
            groupName: 'Teste',
            groupMovement: 9,
            movementPerTurn: 10,
            maxMovement: 50,
          ),
        );

        final distance = service.calculateMovement(MovementType.normal);
        expect(distance, equals(450)); // 9 * 50
      });

      test('deve calcular movimento de exploração', () {
        service.updateGroupData(
          GroupData(
            groupName: 'Teste',
            groupMovement: 9,
            movementPerTurn: 10,
            maxMovement: 50,
          ),
        );

        final distance = service.calculateMovement(MovementType.exploration);
        expect(distance, equals(45)); // 9 * 5
      });
    });

    group('Testes de Portas', () {
      test('deve testar porta trancada', () {
        final result = service.testLockedDoor(
          hasThiefTools: true,
          isThief: false,
        );

        expect(result.success, isA<bool>());
        expect(result.description, isNotEmpty);
        expect(result.doorOpened, isA<bool>());
      });

      test('deve testar porta emperrada', () {
        final result = service.testStuckDoor(strengthModifier: 2);

        expect(result.success, isA<bool>());
        expect(result.description, isNotEmpty);
        expect(result.doorOpened, isA<bool>());
      });

      test('deve testar porta secreta', () {
        final result = service.testSecretDoor(isElf: false, isSearching: true);

        expect(result.success, isA<bool>());
        expect(result.description, isNotEmpty);
        expect(result.foundSecret, isA<bool>());
      });
    });

    group('Testes de Armadilhas', () {
      test('deve testar procurar armadilhas', () {
        final result = service.testSearchTraps(isThief: false, isElf: false);

        expect(result.success, isA<bool>());
        expect(result.description, isNotEmpty);
        expect(result.foundTrap, isA<bool>());
      });

      test('deve testar desarmar armadilhas', () {
        final result = service.testDisarmTrap(isThief: false);

        expect(result.success, isFalse); // Apenas ladrões podem desarmar
        expect(result.description, isNotEmpty);
        expect(result.trapDisarmed, isFalse);
      });

      test('deve testar desarmar armadilhas como ladrão', () {
        final result = service.testDisarmTrap(isThief: true);

        expect(result.success, isA<bool>());
        expect(result.description, isNotEmpty);
        expect(result.trapDisarmed, isA<bool>());
      });
    });

    group('Testes de Reação', () {
      test('deve testar reação com modificador de carisma', () {
        final result = service.testReaction(charismaModifier: 2);

        expect(result.success, isTrue);
        expect(result.description, isNotEmpty);
        expect(result.reactionRoll, isA<int>());
        expect(result.reactionRoll, greaterThanOrEqualTo(2));
        expect(result.reactionRoll, lessThanOrEqualTo(14));
      });

      test('deve testar reação sem modificador', () {
        final result = service.testReaction(charismaModifier: 0);

        expect(result.success, isTrue);
        expect(result.description, isNotEmpty);
        expect(result.reactionRoll, isA<int>());
        expect(result.reactionRoll, greaterThanOrEqualTo(2));
        expect(result.reactionRoll, lessThanOrEqualTo(12));
      });
    });

    group('Exaustão', () {
      test('deve verificar exaustão corretamente', () {
        // Adiciona 5 turnos de exploração sem descanso
        for (int i = 0; i < 5; i++) {
          service.addTurn(isExploration: true);
        }

        expect(service.explorationTurns, equals(5));
        expect(service.restTurns, equals(0));
        expect(service.checkExhaustion(), isTrue);
      });

      test('deve não estar exausto com descanso adequado', () {
        // Adiciona 5 turnos de exploração e 1 de descanso
        for (int i = 0; i < 5; i++) {
          service.addTurn(isExploration: true);
        }
        service.addTurn(isResting: true);

        expect(service.explorationTurns, equals(5));
        expect(service.restTurns, equals(1));
        expect(service.checkExhaustion(), isFalse);
      });
    });

    group('Períodos do Dia', () {
      test('deve determinar período do dia corretamente', () {
        expect(service.getDayPeriod(6), equals(DayPeriod.morning));
        expect(service.getDayPeriod(12), equals(DayPeriod.afternoon));
        expect(service.getDayPeriod(18), equals(DayPeriod.night));
        expect(service.getDayPeriod(0), equals(DayPeriod.dawn));
        expect(service.getDayPeriod(3), equals(DayPeriod.dawn));
      });

      test('deve determinar tempo crítico corretamente', () {
        expect(service.getCriticalTime(12), equals(CriticalTime.midday));
        expect(service.getCriticalTime(18), equals(CriticalTime.sunset));
        expect(service.getCriticalTime(0), equals(CriticalTime.midnight));
        expect(service.getCriticalTime(6), equals(CriticalTime.sunrise));
        expect(service.getCriticalTime(15), isNull);
      });
    });

    group('Limpeza e Exportação', () {
      test('deve limpar todos os dados', () {
        service.addTurn();
        service.addEncounter(
          Encounter(roll: 1, creature: 'Teste', maxHp: 10, currentHp: 10),
        );
        service.updateGroupData(
          GroupData(
            groupName: 'Teste',
            groupMovement: 10,
            movementPerTurn: 5,
            maxMovement: 20,
          ),
        );

        expect(service.turns.length, greaterThan(0));
        expect(service.encounters.length, greaterThan(0));

        service.clear();

        expect(service.turns.length, equals(0));
        expect(service.encounters.length, equals(0));
        expect(service.currentTurn, equals(1));
        expect(service.explorationTurns, equals(0));
        expect(service.restTurns, equals(0));
        expect(service.groupData.groupName, isEmpty);
      });

      test('deve exportar dados para texto', () {
        service.addTurn(isExploration: true, notes: 'Teste');
        service.updateGroupData(
          GroupData(
            groupName: 'Grupo Teste',
            groupMovement: 30,
            movementPerTurn: 10,
            maxMovement: 50,
            masterNotes: 'Anotações',
            hasTorch: true,
            hasLantern: false,
            torchTurns: 6,
            lanternTurns: 0,
          ),
        );
        service.addEncounter(
          Encounter(
            roll: 5,
            creature: 'Goblin',
            maxHp: 7,
            currentHp: 5,
            reaction: 'Hostil',
            notes: 'Encontro teste',
            distance: 9,
          ),
        );

        final export = service.exportToText();

        expect(export, contains('MONITOR DE TURNOS'));
        expect(export, contains('Grupo Teste'));
        expect(export, contains('Turno 1'));
        expect(export, contains('Goblin'));
        expect(export, contains('Hostil'));
        expect(export, contains('Tocha'));
        expect(export, contains('Exploração'));
        expect(export, contains('Descanso'));
      });
    });

    group('Ações que Consomem Tempo', () {
      test('deve adicionar ação de movimento corretamente', () {
        final initialTurns = service.turns.length;

        service.addMovementAction(
          movementType: MovementType.normal,
          action: TurnAction(
            type: ActionType.move,
            description: 'Movimento Normal',
            movementDistance: 450,
            isExploration: false,
          ),
        );

        expect(service.turns.length, equals(initialTurns + 1));
        expect(service.turns.last.isMoving, isTrue);
        expect(service.turns.last.isExploration, isFalse);
        expect(service.turns.last.action?.movementDistance, equals(450));
      });

      test('deve adicionar ação de movimento de exploração', () {
        final initialTurns = service.turns.length;

        service.addMovementAction(
          movementType: MovementType.exploration,
          action: TurnAction(
            type: ActionType.moveExploration,
            description: 'Movimento de Exploração',
            movementDistance: 45,
            isExploration: true,
          ),
        );

        expect(service.turns.length, equals(initialTurns + 1));
        expect(service.turns.last.isMoving, isTrue);
        expect(service.turns.last.isExploration, isTrue);
        expect(service.turns.last.action?.movementDistance, equals(45));
      });

      test('deve adicionar ação de descanso', () {
        final initialTurns = service.turns.length;
        final initialRestTurns = service.restTurns;

        service.addRestAction();

        expect(service.turns.length, equals(initialTurns + 1));
        expect(service.restTurns, equals(initialRestTurns + 1));
        expect(service.turns.last.isResting, isTrue);
      });

      test('deve adicionar ação de procurar armadilhas (1 turno)', () {
        final initialTurns = service.turns.length;

        service.addTrapSearchAction();

        expect(service.turns.length, equals(initialTurns + 1));
        expect(service.turns.last.isSearching, isTrue);
        expect(service.turns.last.notes, contains('Procurando armadilhas'));
        expect(service.turns.last.action?.type, equals(ActionType.searchTraps));
      });

      test(
        'deve adicionar ação de arrombar porta trancada (1d8 + 4 turnos)',
        () {
          final initialTurns = service.turns.length;

          service.addLockedDoorAction();

          // Deve adicionar entre 5 e 12 turnos (1d8 + 4)
          expect(service.turns.length, greaterThanOrEqualTo(initialTurns + 5));
          expect(service.turns.length, lessThanOrEqualTo(initialTurns + 12));
          expect(
            service.turns.last.notes,
            contains('Arrombando porta trancada'),
          );
          expect(service.turns.last.action?.type, equals(ActionType.breakDoor));
        },
      );

      test('deve adicionar ação de procurar', () {
        final initialTurns = service.turns.length;

        service.addSearchAction(
          searchType: ActionType.search,
          result: const TurnResult(
            success: true,
            description: 'Encontrou algo interessante',
          ),
        );

        expect(service.turns.length, equals(initialTurns + 1));
        expect(service.turns.last.isSearching, isTrue);
        expect(service.turns.last.action?.type, equals(ActionType.search));
        expect(service.turns.last.result?.success, isTrue);
      });
    });
  });
}
