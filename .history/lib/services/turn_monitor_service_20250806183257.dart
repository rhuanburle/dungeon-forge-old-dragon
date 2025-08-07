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
  int _explorationTurns = 0;
  int _restTurns = 0;

  /// Obtém todos os turnos
  List<Turn> get turns => List.unmodifiable(_turns);

  /// Obtém os dados do grupo
  GroupData get groupData => _groupData;

  /// Obtém todos os encontros
  List<Encounter> get encounters => List.unmodifiable(_encounters);

  /// Obtém o turno atual
  int get currentTurn => _currentTurn;

  /// Obtém turnos de exploração
  int get explorationTurns => _explorationTurns;

  /// Obtém turnos de descanso
  int get restTurns => _restTurns;

  /// Adiciona um novo turno
  void addTurn({
    bool isExploration = false,
    bool isEncounter = false,
    bool isFighting = false,
    bool isResting = false,
    bool isSearching = false,
    bool isMoving = false,
    bool isDoorAction = false,
    bool isTrapAction = false,
    String? notes,
    TurnAction? action,
    TurnResult? result,
  }) {
    final turn = Turn(
      number: _currentTurn,
      isExploration: isExploration,
      isEncounter: isEncounter,
      isFighting: isFighting,
      isResting: isResting,
      isSearching: isSearching,
      isMoving: isMoving,
      isDoorAction: isDoorAction,
      isTrapAction: isTrapAction,
      notes: notes,
      timestamp: DateTime.now(),
      action: action,
      result: result,
    );

    _turns.add(turn);
    _currentTurn++;

    // Atualiza contadores
    if (isExploration || isMoving || isSearching) {
      _explorationTurns++;
    }
    if (isResting) {
      _restTurns++;
    }

    // Atualiza recursos
    _updateResources();
  }

  /// Adiciona uma ação que consome tempo (gasta turno)
  void addTimeConsumingAction({
    required String actionName,
    required int turnsConsumed,
    bool isExploration = false,
    bool isResting = false,
    bool isSearching = false,
    String? notes,
    TurnAction? action,
    TurnResult? result,
  }) {
    // Adiciona turnos baseado no tempo consumido
    for (int i = 0; i < turnsConsumed; i++) {
      addTurn(
        isExploration: isExploration,
        isResting: isResting,
        isSearching: isSearching,
        notes: i == 0 ? notes : null, // Nota apenas no primeiro turno
        action: i == 0 ? action : null,
        result: i == 0 ? result : null,
      );
    }
  }

  /// Adiciona ação de procurar armadilhas (1 turno inteiro)
  void addTrapSearchAction({
    bool isThief = false,
    bool isElf = false,
    TurnResult? result,
  }) {
    addTimeConsumingAction(
      actionName: 'Procurar Armadilhas',
      turnsConsumed: 1,
      isSearching: true,
      notes: 'Procurando armadilhas (1 turno)',
      action: const TurnAction(
        type: ActionType.searchTraps,
        description: 'Procurar Armadilhas',
        isSearching: true,
      ),
      result: result,
    );
  }

  /// Adiciona ação de arrombar porta trancada (1d8 + 4 turnos)
  void addLockedDoorAction({
    bool hasThiefTools = false,
    bool isThief = false,
    TurnResult? result,
  }) {
    final turnsConsumed = DiceRoller.rollStatic(1, 8) + 4; // 1d8 + 4
    
    addTimeConsumingAction(
      actionName: 'Arrombar Porta Trancada',
      turnsConsumed: turnsConsumed,
      notes: 'Arrombando porta trancada ($turnsConsumed turnos)',
      action: TurnAction(
        type: ActionType.breakDoor,
        description: 'Arrombar Porta Trancada',
        doorAction: DoorAction(
          type: DoorType.locked,
          isLocked: true,
          hasThiefTools: hasThiefTools,
        ),
      ),
      result: result,
    );
  }

  /// Adiciona ação de movimento (1 turno)
  void addMovementAction({
    required MovementType movementType,
    TurnAction? action,
  }) {
    addTimeConsumingAction(
      actionName: movementType == MovementType.normal ? 'Movimento Normal' : 'Movimento de Exploração',
      turnsConsumed: 1,
      isExploration: movementType == MovementType.exploration,
      notes: '${movementType.description}',
      action: action,
    );
  }

  /// Adiciona ação de descanso (1 turno)
  void addRestAction() {
    addTimeConsumingAction(
      actionName: 'Descansar',
      turnsConsumed: 1,
      isResting: true,
      notes: 'Descansando (remove exaustão)',
      action: const TurnAction(
        type: ActionType.rest,
        description: 'Descansar',
        isResting: true,
      ),
    );
  }

  /// Adiciona ação de procurar (1 turno)
  void addSearchAction({
    required ActionType searchType,
    TurnResult? result,
  }) {
    addTimeConsumingAction(
      actionName: searchType.description,
      turnsConsumed: 1,
      isSearching: true,
      notes: '${searchType.description}',
      action: TurnAction(
        type: searchType,
        description: searchType.description,
        isSearching: true,
      ),
      result: result,
    );
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

  /// Verifica se é hora de rolar encontro (a cada 2 turnos)
  bool shouldRollEncounter() {
    // A cada 2 turnos deve rolar encontro
    return _currentTurn > 1 && (_currentTurn - 1) % 2 == 0;
  }

  /// Verifica se há encontro (1 em 6 chances, ou 1-2 em 6 com luz/barulho)
  bool checkForEncounter({bool hasLight = false, bool hasNoise = false}) {
    final baseChance = 1;
    final lightBonus = hasLight ? 1 : 0;
    final noiseBonus = hasNoise ? 1 : 0;
    final totalChance = baseChance + lightBonus + noiseBonus;

    final roll = DiceRoller.rollStatic(1, 6);
    return roll <= totalChance;
  }

  /// Gera um encontro aleatório quando o mestre decide rolar
  Encounter generateRandomEncounter() {
    final roll = DiceRoller.rollStatic(1, 10);
    final reactionRoll = DiceRoller.rollStatic(2, 6);
    final distance = calculateEncounterDistance();

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

    // Determina reação baseada no roll de 2d6 (Tabela 6.3)
    EncounterReaction reaction;
    switch (reactionRoll) {
      case 2:
      case 3:
        reaction = EncounterReaction.hostile;
        break;
      case 4:
      case 5:
      case 6:
        reaction = EncounterReaction.threatening;
        break;
      case 7:
      case 8:
      case 9:
        reaction = EncounterReaction.neutral;
        break;
      case 10:
      case 11:
        reaction = EncounterReaction.friendly;
        break;
      case 12:
      default:
        reaction = EncounterReaction.ally;
        break;
    }

    return Encounter(
      roll: roll,
      creature: creature,
      maxHp: maxHp,
      currentHp: maxHp,
      reaction: reaction.description,
      distance: distance,
      type: EncounterType.random,
    );
  }

  /// Calcula a distância do encontro
  int calculateEncounterDistance() {
    return DiceRoller.rollStatic(1, 6) * 3; // 1d6 x 3m
  }

  /// Calcula movimento baseado no tipo
  int calculateMovement(MovementType type) {
    final baseMovement = _groupData.groupMovement;

    switch (type) {
      case MovementType.normal:
        // Movimento normal: taxa de movimento normal
        return baseMovement * 50; // 50 metros por ponto de movimento
      case MovementType.exploration:
        // Movimento de exploração: 5x o movimento por turno
        return baseMovement * 5;
    }
  }

  /// Testa abertura de porta trancada
  TurnResult testLockedDoor({
    bool hasThiefTools = false,
    bool isThief = false,
  }) {
    final roll = DiceRoller.rollStatic(1, 6);
    final success = roll == 1;

    if (success) {
      return const TurnResult(
        success: true,
        description: 'Porta aberta silenciosamente',
        doorOpened: true,
      );
    } else {
      return const TurnResult(
        success: false,
        description:
            'Falha ao abrir a porta. Tentativa eliminou possibilidade de surpresa.',
        doorOpened: false,
      );
    }
  }

  /// Testa abertura de porta emperrada
  TurnResult testStuckDoor({int strengthModifier = 0}) {
    final roll = DiceRoller.rollStatic(1, 6);
    final success = roll <= (1 + strengthModifier);

    if (success) {
      return const TurnResult(
        success: true,
        description: 'Porta forçada com sucesso (produziu barulho)',
        doorOpened: true,
      );
    } else {
      return const TurnResult(
        success: false,
        description: 'Falha ao forçar a porta',
        doorOpened: false,
      );
    }
  }

  /// Testa encontrar porta secreta
  TurnResult testSecretDoor({bool isElf = false, bool isSearching = false}) {
    final roll = DiceRoller.rollStatic(1, 6);
    final baseChance = isSearching ? 1 : 0;
    final elfBonus = isElf ? 1 : 0;
    final success = roll <= (baseChance + elfBonus);

    if (success) {
      return const TurnResult(
        success: true,
        description: 'Porta secreta encontrada!',
        foundSecret: true,
      );
    } else {
      return const TurnResult(
        success: false,
        description: 'Nenhuma porta secreta encontrada',
        foundSecret: false,
      );
    }
  }

  /// Testa procurar armadilhas
  TurnResult testSearchTraps({bool isThief = false, bool isElf = false}) {
    final roll = DiceRoller.rollStatic(1, 6);
    final baseChance = 1;
    final thiefBonus = isThief ? 1 : 0;
    final elfBonus = isElf ? 1 : 0;
    final success = roll <= (baseChance + thiefBonus + elfBonus);

    if (success) {
      return const TurnResult(
        success: true,
        description: 'Armadilha encontrada!',
        foundTrap: true,
      );
    } else {
      return const TurnResult(
        success: false,
        description: 'Nenhuma armadilha encontrada',
        foundTrap: false,
      );
    }
  }

  /// Testa desarmar armadilhas
  TurnResult testDisarmTrap({bool isThief = false}) {
    if (!isThief) {
      return const TurnResult(
        success: false,
        description: 'Apenas Ladrões podem desarmar armadilhas com segurança',
        trapDisarmed: false,
      );
    }

    final roll = DiceRoller.rollStatic(1, 6);
    final success = roll == 1;

    if (success) {
      return const TurnResult(
        success: true,
        description: 'Armadilha desarmada com sucesso',
        trapDisarmed: true,
      );
    } else {
      return const TurnResult(
        success: false,
        description: 'Falha ao desarmar a armadilha',
        trapDisarmed: false,
      );
    }
  }

  /// Testa reação (2d6 + modificador de Carisma)
  TurnResult testReaction({int charismaModifier = 0}) {
    final roll = DiceRoller.rollStatic(2, 6) + charismaModifier;

    EncounterReaction reaction;
    switch (roll) {
      case 2:
      case 3:
        reaction = EncounterReaction.hostile;
        break;
      case 4:
      case 5:
      case 6:
        reaction = EncounterReaction.threatening;
        break;
      case 7:
      case 8:
      case 9:
        reaction = EncounterReaction.neutral;
        break;
      case 10:
      case 11:
        reaction = EncounterReaction.friendly;
        break;
      case 12:
      default:
        reaction = EncounterReaction.ally;
        break;
    }

    return TurnResult(
      success: true,
      description: 'Reação: ${reaction.description}',
      reactionRoll: roll,
    );
  }

  /// Verifica exaustão do grupo
  bool checkExhaustion() {
    // Precisa de 1 turno de descanso a cada 5 turnos de exploração
    return _explorationTurns > 0 &&
        (_explorationTurns % 5) == 0 &&
        _restTurns < (_explorationTurns / 5).floor();
  }

  /// Atualiza recursos (tochas, lanternas, etc.)
  void _updateResources() {
    var newTorchTurns = _groupData.torchTurns;
    var newLanternTurns = _groupData.lanternTurns;

    if (_groupData.hasTorch && newTorchTurns > 0) {
      newTorchTurns--;
    }

    if (_groupData.hasLantern && newLanternTurns > 0) {
      newLanternTurns--;
    }

    _groupData = _groupData.copyWith(
      torchTurns: newTorchTurns,
      lanternTurns: newLanternTurns,
      isExhausted: checkExhaustion(),
    );
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
    _explorationTurns = 0;
    _restTurns = 0;
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
    buffer.writeln(
      'Tocha: ${_groupData.hasTorch ? "Sim (${_groupData.torchTurns} turnos restantes)" : "Não"}',
    );
    buffer.writeln(
      'Lanterna: ${_groupData.hasLantern ? "Sim (${_groupData.lanternTurns} turnos restantes)" : "Não"}',
    );
    buffer.writeln('Exausto: ${_groupData.isExhausted ? "Sim" : "Não"}');
    buffer.writeln('Turnos de Exploração: $_explorationTurns');
    buffer.writeln('Turnos de Descanso: $_restTurns');
    if (_groupData.masterNotes.isNotEmpty) {
      buffer.writeln('Anotações: ${_groupData.masterNotes}');
    }
    buffer.writeln();

    // Turnos
    buffer.writeln('TURNOS:');
    for (final turn in _turns) {
      buffer.writeln('Turno ${turn.number}:');
      if (turn.isExploration) buffer.writeln('  - Exploração');
      if (turn.isEncounter) buffer.writeln('  - Encontro');
      if (turn.isFighting) buffer.writeln('  - Combate');
      if (turn.isResting) buffer.writeln('  - Descanso');
      if (turn.isSearching) buffer.writeln('  - Procurando');
      if (turn.isMoving) buffer.writeln('  - Movimento');
      if (turn.isDoorAction) buffer.writeln('  - Ação de Porta');
      if (turn.isTrapAction) buffer.writeln('  - Ação de Armadilha');

      if (turn.action != null) {
        buffer.writeln('  Ação: ${turn.action!.description}');
        if (turn.action!.movementDistance != null) {
          buffer.writeln('  Distância: ${turn.action!.movementDistance}m');
        }
      }

      if (turn.result != null) {
        buffer.writeln('  Resultado: ${turn.result!.description}');
        if (turn.result!.damage != null) {
          buffer.writeln('  Dano: ${turn.result!.damage}');
        }
      }

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
        if (encounter.distance > 0) {
          buffer.writeln('  Distância: ${encounter.distance}m');
        }
        if (encounter.isSurprise) {
          buffer.writeln('  Surpresa: Sim');
        }
        if (encounter.notes.isNotEmpty) {
          buffer.writeln('  Notas: ${encounter.notes}');
        }
        buffer.writeln();
      }
    }

    return buffer.toString();
  }
}
