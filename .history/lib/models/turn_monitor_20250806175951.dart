// models/turn_monitor.dart

/// Modelo para representar um turno no monitor
class Turn {
  final int number;
  final bool isExploration;
  final bool isEncounter;
  final bool isFighting;
  final bool isResting;
  final bool isSearching;
  final bool isMoving;
  final bool isDoorAction;
  final bool isTrapAction;
  final String? notes;
  final DateTime? timestamp;
  final TurnAction? action;
  final TurnResult? result;

  const Turn({
    required this.number,
    this.isExploration = false,
    this.isEncounter = false,
    this.isFighting = false,
    this.isResting = false,
    this.isSearching = false,
    this.isMoving = false,
    this.isDoorAction = false,
    this.isTrapAction = false,
    this.notes,
    this.timestamp,
    this.action,
    this.result,
  });

  Turn copyWith({
    int? number,
    bool? isExploration,
    bool? isEncounter,
    bool? isFighting,
    bool? isResting,
    bool? isSearching,
    bool? isMoving,
    bool? isDoorAction,
    bool? isTrapAction,
    String? notes,
    DateTime? timestamp,
    TurnAction? action,
    TurnResult? result,
  }) {
    return Turn(
      number: number ?? this.number,
      isExploration: isExploration ?? this.isExploration,
      isEncounter: isEncounter ?? this.isEncounter,
      isFighting: isFighting ?? this.isFighting,
      isResting: isResting ?? this.isResting,
      isSearching: isSearching ?? this.isSearching,
      isMoving: isMoving ?? this.isMoving,
      isDoorAction: isDoorAction ?? this.isDoorAction,
      isTrapAction: isTrapAction ?? this.isTrapAction,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      action: action ?? this.action,
      result: result ?? this.result,
    );
  }
}

/// Modelo para representar dados críticos do grupo
class GroupData {
  final String groupName;
  final int groupMovement;
  final int movementPerTurn;
  final int maxMovement;
  final String masterNotes;
  final bool hasTorch;
  final bool hasLantern;
  final int torchTurns;
  final int lanternTurns;
  final int exhaustionLevel;
  final bool isExhausted;

  const GroupData({
    required this.groupName,
    required this.groupMovement,
    required this.movementPerTurn,
    required this.maxMovement,
    this.masterNotes = '',
    this.hasTorch = false,
    this.hasLantern = false,
    this.torchTurns = 0,
    this.lanternTurns = 0,
    this.exhaustionLevel = 0,
    this.isExhausted = false,
  });

  GroupData copyWith({
    String? groupName,
    int? groupMovement,
    int? movementPerTurn,
    int? maxMovement,
    String? masterNotes,
    bool? hasTorch,
    bool? hasLantern,
    int? torchTurns,
    int? lanternTurns,
    int? exhaustionLevel,
    bool? isExhausted,
  }) {
    return GroupData(
      groupName: groupName ?? this.groupName,
      groupMovement: groupMovement ?? this.groupMovement,
      movementPerTurn: movementPerTurn ?? this.movementPerTurn,
      maxMovement: maxMovement ?? this.maxMovement,
      masterNotes: masterNotes ?? this.masterNotes,
      hasTorch: hasTorch ?? this.hasTorch,
      hasLantern: hasLantern ?? this.hasLantern,
      torchTurns: torchTurns ?? this.torchTurns,
      lanternTurns: lanternTurns ?? this.lanternTurns,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
      isExhausted: isExhausted ?? this.isExhausted,
    );
  }
}

/// Modelo para representar um encontro
class Encounter {
  final int roll;
  final String creature;
  final int maxHp;
  final int currentHp;
  final String reaction;
  final String notes;
  final bool isSurprise;
  final int distance;
  final EncounterType type;

  const Encounter({
    required this.roll,
    required this.creature,
    required this.maxHp,
    required this.currentHp,
    this.reaction = '',
    this.notes = '',
    this.isSurprise = false,
    this.distance = 0,
    this.type = EncounterType.random,
  });

  Encounter copyWith({
    int? roll,
    String? creature,
    int? maxHp,
    int? currentHp,
    String? reaction,
    String? notes,
    bool? isSurprise,
    int? distance,
    EncounterType? type,
  }) {
    return Encounter(
      roll: roll ?? this.roll,
      creature: creature ?? this.creature,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      reaction: reaction ?? this.reaction,
      notes: notes ?? this.notes,
      isSurprise: isSurprise ?? this.isSurprise,
      distance: distance ?? this.distance,
      type: type ?? this.type,
    );
  }
}

/// Modelo para representar ação de turno
class TurnAction {
  final ActionType type;
  final String description;
  final int? movementDistance;
  final bool isExploration;
  final bool isResting;
  final bool isSearching;
  final DoorAction? doorAction;
  final TrapAction? trapAction;

  const TurnAction({
    required this.type,
    required this.description,
    this.movementDistance,
    this.isExploration = false,
    this.isResting = false,
    this.isSearching = false,
    this.doorAction,
    this.trapAction,
  });
}

/// Modelo para representar resultado de turno
class TurnResult {
  final bool success;
  final String description;
  final int? damage;
  final bool foundSecret;
  final bool foundTrap;
  final bool doorOpened;
  final bool trapDisarmed;
  final int? reactionRoll;

  const TurnResult({
    required this.success,
    required this.description,
    this.damage,
    this.foundSecret = false,
    this.foundTrap = false,
    this.doorOpened = false,
    this.trapDisarmed = false,
    this.reactionRoll,
  });
}

/// Modelo para representar ação de porta
class DoorAction {
  final DoorType type;
  final bool isLocked;
  final bool isStuck;
  final bool isSecret;
  final int strengthModifier;
  final bool hasThiefTools;

  const DoorAction({
    required this.type,
    this.isLocked = false,
    this.isStuck = false,
    this.isSecret = false,
    this.strengthModifier = 0,
    this.hasThiefTools = false,
  });
}

/// Modelo para representar ação de armadilha
class TrapAction {
  final TrapType type;
  final bool isSearching;
  final bool isDisarming;
  final bool isThief;
  final bool isElf;

  const TrapAction({
    required this.type,
    this.isSearching = false,
    this.isDisarming = false,
    this.isThief = false,
    this.isElf = false,
  });
}

/// Enum para representar período do dia
enum DayPeriod {
  morning('Período da Manhã'),
  afternoon('Período da Tarde'),
  night('Período da Noite'),
  dawn('Período da Madrugada');

  const DayPeriod(this.description);
  final String description;
}

/// Enum para representar tempo crítico
enum CriticalTime {
  midday('Meio-dia'),
  sunset('Pôr do Sol'),
  midnight('Meia-noite'),
  sunrise('Nascer do Sol');

  const CriticalTime(this.description);
  final String description;
}

/// Enum para representar ação em masmorra
enum ActionType {
  move('Movimentar-se'),
  moveExploration('Movimentar-se (Exploração)'),
  rest('Descansar'),
  search('Procurar'),
  searchTraps('Procurar Armadilhas'),
  searchSecret('Procurar Passagem Secreta'),
  openDoor('Abrir Porta'),
  breakDoor('Arrombar Porta'),
  forceDoor('Forçar Porta'),
  disarmTrap('Desarmar Armadilha'),
  talk('Conversar'),
  castSpell('Conjurar Magia'),
  combat('Combater'),
  helpEachOther('Ajudar um ao outro'),
  other('Outras ações');

  const ActionType(this.description);
  final String description;
}

/// Enum para representar tipo de porta
enum DoorType {
  normal('Porta Normal'),
  locked('Porta Trancada'),
  stuck('Porta Emperrada'),
  secret('Porta Secreta');

  const DoorType(this.description);
  final String description;
}

/// Enum para representar tipo de armadilha
enum TrapType {
  dart('Dardos Envenenados'),
  pit('Fosso'),
  fallingBlock('Bloco que Cai'),
  guillotine('Guilhotina'),
  acid('Spray Ácido'),
  alarm('Alarme'),
  collapse('Desmoronamento'),
  water('Poço de Água'),
  secret('Porta Secreta'),
  portal('Portal Dimensional'),
  ceiling('Teto Retrátil'),
  other('Outra');

  const TrapType(this.description);
  final String description;
}

/// Enum para representar tipo de encontro
enum EncounterType {
  random('Encontro Aleatório'),
  planned('Encontro Planejado'),
  reaction('Teste de Reação');

  const EncounterType(this.description);
  final String description;
}

/// Enum para representar reação de encontro
enum EncounterReaction {
  hostile('Hostil'),
  threatening('Ameaça'),
  neutral('Neutralidade'),
  friendly('Amigável'),
  ally('Aliado');

  const EncounterReaction(this.description);
  final String description;
}

/// Enum para representar tipo de movimento
enum MovementType {
  normal('Movimento Normal'),
  exploration('Movimento de Exploração');

  const MovementType(this.description);
  final String description;
}
