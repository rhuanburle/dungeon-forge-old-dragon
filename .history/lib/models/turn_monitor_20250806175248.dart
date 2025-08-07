// models/turn_monitor.dart

/// Modelo para representar um turno no monitor
class Turn {
  final int number;
  final bool isExploration;
  final bool isEncounter;
  final bool isFighting;
  final String? notes;
  final DateTime? timestamp;

  const Turn({
    required this.number,
    this.isExploration = false,
    this.isEncounter = false,
    this.isFighting = false,
    this.notes,
    this.timestamp,
  });

  Turn copyWith({
    int? number,
    bool? isExploration,
    bool? isEncounter,
    bool? isFighting,
    String? notes,
    DateTime? timestamp,
  }) {
    return Turn(
      number: number ?? this.number,
      isExploration: isExploration ?? this.isExploration,
      isEncounter: isEncounter ?? this.isEncounter,
      isFighting: isFighting ?? this.isFighting,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
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

  const GroupData({
    required this.groupName,
    required this.groupMovement,
    required this.movementPerTurn,
    required this.maxMovement,
    this.masterNotes = '',
  });

  GroupData copyWith({
    String? groupName,
    int? groupMovement,
    int? movementPerTurn,
    int? maxMovement,
    String? masterNotes,
  }) {
    return GroupData(
      groupName: groupName ?? this.groupName,
      groupMovement: groupMovement ?? this.groupMovement,
      movementPerTurn: movementPerTurn ?? this.movementPerTurn,
      maxMovement: maxMovement ?? this.maxMovement,
      masterNotes: masterNotes ?? this.masterNotes,
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

  const Encounter({
    required this.roll,
    required this.creature,
    required this.maxHp,
    required this.currentHp,
    this.reaction = '',
    this.notes = '',
  });

  Encounter copyWith({
    int? roll,
    String? creature,
    int? maxHp,
    int? currentHp,
    String? reaction,
    String? notes,
  }) {
    return Encounter(
      roll: roll ?? this.roll,
      creature: creature ?? this.creature,
      maxHp: maxHp ?? this.maxHp,
      currentHp: currentHp ?? this.currentHp,
      reaction: reaction ?? this.reaction,
      notes: notes ?? this.notes,
    );
  }
}

/// Modelo para representar período do dia
enum DayPeriod {
  morning('Período da Manhã'),
  afternoon('Período da Tarde'),
  night('Período da Noite'),
  dawn('Período da Madrugada');

  const DayPeriod(this.description);
  final String description;
}

/// Modelo para representar tempo crítico
enum CriticalTime {
  midday('Meio-dia'),
  sunset('Pôr do Sol'),
  midnight('Meia-noite'),
  sunrise('Nascer do Sol');

  const CriticalTime(this.description);
  final String description;
}

/// Modelo para representar ação em masmorra
enum DungeonAction {
  move('Movimentar-se'),
  talk('Conversar'),
  search('Procurar'),
  overcomeObstacle('Ultrapassar obstáculo'),
  stayAlert('Ficar atento aos arredores'),
  castRitual('Conjurar ritual'),
  combat('Combater'),
  helpEachOther('Ajudar um ao outro'),
  other('Outras ações');

  const DungeonAction(this.description);
  final String description;
}

/// Modelo para representar reação de encontro
enum EncounterReaction {
  attacksImmediately('Ataca na hora'),
  hostile('Hostil. Pode atacar'),
  uncertain('Incerto, ameaçado'),
  neutral('Neutro, pode negociar'),
  friendly('Amigável');

  const EncounterReaction(this.description);
  final String description;
}
