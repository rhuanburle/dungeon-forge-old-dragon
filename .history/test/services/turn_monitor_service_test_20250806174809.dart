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
    });

    group('Gerenciamento de Dados do Grupo', () {
      test('deve atualizar dados do grupo', () {
        final groupData = GroupData(
          groupName: 'Grupo Teste',
          groupMovement: 30,
          movementPerTurn: 10,
          maxMovement: 50,
          masterNotes: 'Anotações do mestre',
        );

        service.updateGroupData(groupData);

        expect(service.groupData.groupName, equals('Grupo Teste'));
        expect(service.groupData.groupMovement, equals(30));
        expect(service.groupData.movementPerTurn, equals(10));
        expect(service.groupData.maxMovement, equals(50));
        expect(service.groupData.masterNotes, equals('Anotações do mestre'));
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
        );

        service.addEncounter(encounter);

        expect(service.encounters.length, equals(1));
        expect(service.encounters.first.creature, equals('Goblin'));
        expect(service.encounters.first.roll, equals(5));
        expect(service.encounters.first.currentHp, equals(5));
        expect(service.encounters.first.maxHp, equals(7));
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

    group('Geração de Encontros Aleatórios', () {
      test('deve gerar encontro aleatório com dados válidos', () {
        final encounter = service.generateRandomEncounter();

        expect(encounter.roll, greaterThanOrEqualTo(1));
        expect(encounter.roll, lessThanOrEqualTo(10));
        expect(encounter.creature, isNotEmpty);
        expect(encounter.maxHp, greaterThan(0));
        expect(encounter.currentHp, equals(encounter.maxHp));
        expect(encounter.reaction, isNotEmpty);
      });

      test('deve calcular distância do encontro corretamente', () {
        final distance = service.calculateEncounterDistance();

        expect(distance, greaterThanOrEqualTo(3));
        expect(distance, lessThanOrEqualTo(18));
        expect(distance % 3, equals(0)); // Deve ser múltiplo de 3
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
        service.addEncounter(Encounter(
          roll: 1,
          creature: 'Teste',
          maxHp: 10,
          currentHp: 10,
        ));
        service.updateGroupData(GroupData(
          groupName: 'Teste',
          groupMovement: 10,
          movementPerTurn: 5,
          maxMovement: 20,
        ));

        expect(service.turns.length, greaterThan(0));
        expect(service.encounters.length, greaterThan(0));

        service.clear();

        expect(service.turns.length, equals(0));
        expect(service.encounters.length, equals(0));
        expect(service.currentTurn, equals(1));
        expect(service.groupData.groupName, isEmpty);
      });

      test('deve exportar dados para texto', () {
        service.addTurn(isExploration: true, notes: 'Teste');
        service.updateGroupData(GroupData(
          groupName: 'Grupo Teste',
          groupMovement: 30,
          movementPerTurn: 10,
          maxMovement: 50,
          masterNotes: 'Anotações',
        ));
        service.addEncounter(Encounter(
          roll: 5,
          creature: 'Goblin',
          maxHp: 7,
          currentHp: 5,
          reaction: 'Hostil',
          notes: 'Encontro teste',
        ));

        final export = service.exportToText();

        expect(export, contains('MONITOR DE TURNOS'));
        expect(export, contains('Grupo Teste'));
        expect(export, contains('Turno 1'));
        expect(export, contains('Goblin'));
        expect(export, contains('Hostil'));
      });
    });
  });
} 