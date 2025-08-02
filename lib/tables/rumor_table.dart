// tables/rumor_table.dart

import '../enums/table_enums.dart';
import 'base_table.dart';

/// Tabela de Rumores (Colunas 13-15 da Tabela 9.1)
///
/// Esta tabela é usada para gerar rumores sobre a masmorra,
/// incluindo sujeito, ação e localização do rumor.
class RumorTable extends TableWithColumnMethods<dynamic> {
  @override
  String get tableName => 'Tabela de Rumores (Colunas 13-15 da Tabela 9.1)';

  @override
  String get description => 'Tabela para gerar rumores sobre a masmorra';

  @override
  int get columnCount => 3;

  @override
  List<List<dynamic>> get columns => [
        _column13, // RumorSubject
        _column14, // RumorAction
        _column15, // RumorLocation
      ];

  // Coluna 13: Sujeito do Rumor
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

  // Coluna 14: Ação do Rumor
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

  // Coluna 15: Localização do Rumor
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

  // Métodos específicos com tipos corretos
  @override
  RumorSubject getColumn1(int roll) => super.getColumn1(roll) as RumorSubject;

  @override
  RumorAction getColumn2(int roll) => super.getColumn2(roll) as RumorAction;

  @override
  RumorLocation getColumn3(int roll) => super.getColumn3(roll) as RumorLocation;
}
