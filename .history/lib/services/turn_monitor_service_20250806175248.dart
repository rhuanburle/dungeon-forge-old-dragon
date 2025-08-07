// services/turn_monitor_service.dart

import '../models/turn_monitor.dart';
import '../utils/dice_roller.dart';

/// Serviço responsável pelo gerenciamento do Monitor de Turnos
class TurnMonitorService {
  List<Turn> _turns = [];
  GroupData _groupData = const GroupData(
    groupName: '',
    groupMovement: 0,
    movementPerTurn: 0,
    maxMovement: 0,
  );
  List<Encounter> _encounters = [];
  int _currentTurn = 1;

  /// Obtém todos os turnos
  List<Turn> get turns => List.unmodifiable(_turns);

  /// Obtém os dados do grupo
  GroupData get groupData => _groupData;

  /// Obtém todos os encontros
  List<Encounter> get encounters => List.unmodifiable(_encounters);

  /// Obtém o turno atual
  int get currentTurn => _currentTurn;

  /// Adiciona um novo turno
  void addTurn({
    bool isExploration = false,
    bool isEncounter = false,
    bool isFighting = false,
    String? notes,
  }) {
    final turn = Turn(
      number: _currentTurn,
      isExploration: isExploration,
      isEncounter: isEncounter,
      isFighting: isFighting,
      notes: notes,
      timestamp: DateTime.now(),
    );

    _turns.add(turn);
    _currentTurn++;
  }

  /// Atualiza um turno existente
  void updateTurn(int turnNumber, Turn updatedTurn) {
    final index = _turns.indexWhere((turn) => turn.number == turnNumber);
    if (index != -1) {
      _turns[index] = updatedTurn;
    }
  }

  /// Remove um turno
  void removeTurn(int turnNumber) {
    _turns.removeWhere((turn) => turn.number == turnNumber);
    // Reorganiza os números dos turnos
    for (int i = 0; i < _turns.length; i++) {
      _turns[i] = _turns[i].copyWith(number: i + 1);
    }
    _currentTurn = _turns.length + 1;
  }

  /// Atualiza os dados do grupo
  void updateGroupData(GroupData groupData) {
    _groupData = groupData;
  }

  /// Adiciona um encontro
  void addEncounter(Encounter encounter) {
    _encounters.add(encounter);
  }

  /// Remove um encontro
  void removeEncounter(int index) {
    if (index >= 0 && index < _encounters.length) {
      _encounters.removeAt(index);
    }
  }

  /// Atualiza um encontro
  void updateEncounter(int index, Encounter encounter) {
    if (index >= 0 && index < _encounters.length) {
      _encounters[index] = encounter;
    }
  }

  /// Gera um encontro aleatório
  Encounter generateRandomEncounter() {
    final roll = DiceRoller.rollStatic(1, 10);
    final reactionRoll = DiceRoller.rollStatic(2, 6);

    String creature;
    int maxHp;

    // Tabela simples de criaturas baseada no roll
    switch (roll) {
      case 1:
        creature = 'Goblin';
        maxHp = 7;
        break;
      case 2:
        creature = 'Orc';
        maxHp = 15;
        break;
      case 3:
        creature = 'Troll';
        maxHp = 35;
        break;
      case 4:
        creature = 'Dragão';
        maxHp = 50;
        break;
      case 5:
        creature = 'Esqueleto';
        maxHp = 12;
        break;
      case 6:
        creature = 'Zumbi';
        maxHp = 16;
        break;
      case 7:
        creature = 'Gigante';
        maxHp = 45;
        break;
      case 8:
        creature = 'Lobo';
        maxHp = 8;
        break;
      case 9:
        creature = 'Urso';
        maxHp = 25;
        break;
      case 10:
        creature = 'Basilisco';
        maxHp = 40;
        break;
      default:
        creature = 'Criatura Desconhecida';
        maxHp = 20;
    }

    // Determina reação baseada no roll de 2d6
    EncounterReaction reaction;
    switch (reactionRoll) {
      case 2:
      case 3:
        reaction = EncounterReaction.attacksImmediately;
        break;
      case 4:
      case 5:
      case 6:
        reaction = EncounterReaction.hostile;
        break;
      case 7:
      case 8:
      case 9:
        reaction = EncounterReaction.uncertain;
        break;
      case 10:
      case 11:
        reaction = EncounterReaction.neutral;
        break;
      case 12:
      default:
        reaction = EncounterReaction.friendly;
        break;
    }

    return Encounter(
      roll: roll,
      creature: creature,
      maxHp: maxHp,
      currentHp: maxHp,
      reaction: reaction.description,
    );
  }

  /// Calcula a distância do encontro
  int calculateEncounterDistance() {
    return DiceRoller.rollStatic(1, 6) * 3; // 1d6 x 3m
  }

  /// Verifica se há encontro (1 em 6 chances)
  bool checkForEncounter() {
    return DiceRoller.rollStatic(1, 6) == 1;
  }

  /// Obtém o período do dia baseado na hora
  DayPeriod getDayPeriod(int hour) {
    if (hour >= 6 && hour < 12) {
      return DayPeriod.morning;
    } else if (hour >= 12 && hour < 18) {
      return DayPeriod.afternoon;
    } else if (hour >= 18 && hour < 24) {
      return DayPeriod.night;
    } else {
      return DayPeriod.dawn;
    }
  }

  /// Obtém o tempo crítico baseado na hora
  CriticalTime? getCriticalTime(int hour) {
    switch (hour) {
      case 12:
        return CriticalTime.midday;
      case 18:
        return CriticalTime.sunset;
      case 0:
        return CriticalTime.midnight;
      case 6:
        return CriticalTime.sunrise;
      default:
        return null;
    }
  }

  /// Limpa todos os dados
  void clear() {
    _turns.clear();
    _encounters.clear();
    _currentTurn = 1;
    _groupData = const GroupData(
      groupName: '',
      groupMovement: 0,
      movementPerTurn: 0,
      maxMovement: 0,
    );
  }

  /// Exporta os dados para formato de texto
  String exportToText() {
    final buffer = StringBuffer();
    buffer.writeln('=== MONITOR DE TURNOS ===');
    buffer.writeln();

    // Dados do grupo
    buffer.writeln('DADOS DO GRUPO:');
    buffer.writeln('Nome: ${_groupData.groupName}');
    buffer.writeln('Movimento do Grupo: ${_groupData.groupMovement}');
    buffer.writeln('Movimento por Turno: ${_groupData.movementPerTurn}');
    buffer.writeln('Movimento Máximo: ${_groupData.maxMovement}');
    buffer.writeln('Anotações: ${_groupData.masterNotes}');
    buffer.writeln();

    // Turnos
    buffer.writeln('TURNOS:');
    for (final turn in _turns) {
      buffer.writeln('Turno ${turn.number}:');
      buffer.writeln('  Exploração: ${turn.isExploration ? "Sim" : "Não"}');
      buffer.writeln('  Encontro: ${turn.isEncounter ? "Sim" : "Não"}');
      buffer.writeln('  Combate: ${turn.isFighting ? "Sim" : "Não"}');
      if (turn.notes != null && turn.notes!.isNotEmpty) {
        buffer.writeln('  Notas: ${turn.notes}');
      }
      buffer.writeln();
    }

    // Encontros
    if (_encounters.isNotEmpty) {
      buffer.writeln('ENCONTROS:');
      for (final encounter in _encounters) {
        buffer.writeln('Roll: ${encounter.roll} - ${encounter.creature}');
        buffer.writeln('  PV: ${encounter.currentHp}/${encounter.maxHp}');
        buffer.writeln('  Reação: ${encounter.reaction}');
        if (encounter.notes.isNotEmpty) {
          buffer.writeln('  Notas: ${encounter.notes}');
        }
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}
