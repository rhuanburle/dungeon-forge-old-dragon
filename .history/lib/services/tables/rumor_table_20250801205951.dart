// services/tables/rumor_table.dart

import '../../enums/dungeon_tables.dart';

/// Representa a Tabela de Rumores (Colunas 13-15 da Tabela 9.1)
class RumorTable {
  static const List<RumorSubject> _column13 = [
    RumorSubject.decapitatedOccupant,
    RumorSubject.decapitatedOccupant,
    RumorSubject.drunkPeasant,
    RumorSubject.drunkPeasant,
    RumorSubject.primaryOccupant,
    RumorSubject.primaryOccupant,
    RumorSubject.richForeigner,
    RumorSubject.richForeigner,
    RumorSubject.blindMystic,
    RumorSubject.blindMystic,
    RumorSubject.leader,
    RumorSubject.leader,
  ];

  static const List<RumorAction> _column14 = [
    RumorAction.seenNear,
    RumorAction.seenNear,
    RumorAction.capturedIn,
    RumorAction.capturedIn,
    RumorAction.leftTrailsIn,
    RumorAction.leftTrailsIn,
    RumorAction.soughtPriestIn,
    RumorAction.soughtPriestIn,
    RumorAction.killedByWerewolfIn,
    RumorAction.killedByWerewolfIn,
    RumorAction.cursed,
    RumorAction.cursed,
  ];

  static const List<RumorLocation> _column15 = [
    RumorLocation.autumnReligiousFestival,
    RumorLocation.autumnReligiousFestival,
    RumorLocation.villageLastYearDuringEclipse,
    RumorLocation.villageLastYearDuringEclipse,
    RumorLocation.farmWhenSheepDisappeared,
    RumorLocation.farmWhenSheepDisappeared,
    RumorLocation.nearbyVillage,
    RumorLocation.nearbyVillage,
    RumorLocation.springTradeCaravan,
    RumorLocation.springTradeCaravan,
    RumorLocation.winterBlizzard3YearsAgo,
    RumorLocation.winterBlizzard3YearsAgo,
  ];

  /// Obtém o sujeito do rumor baseado no roll (Coluna 13)
  static RumorSubject getColumn13(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column13[roll - 2];
  }

  /// Obtém a ação do rumor baseado no roll (Coluna 14)
  static RumorAction getColumn14(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column14[roll - 2];
  }

  /// Obtém a localização do rumor baseado no roll (Coluna 15)
  static RumorLocation getColumn15(int roll) {
    if (roll < 2 || roll > 12) {
      throw ArgumentError('Roll deve estar entre 2 e 12, recebido: $roll');
    }
    return _column15[roll - 2];
  }
} 