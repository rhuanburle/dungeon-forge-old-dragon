// models/dto/dungeon_table_dto.dart

class DungeonTableDto {
  final String type;
  final String builderOrInhabitant;
  final String status;
  final String objective;
  final String location;
  final String entry;
  final String roomsCountFormula;
  final String occupant1;
  final String occupant2;
  final String leader;
  final String rumorSubject;
  final String rumorAction;
  final String rumorContext;

  const DungeonTableDto({
    required this.type,
    required this.builderOrInhabitant,
    required this.status,
    required this.objective,
    required this.location,
    required this.entry,
    required this.roomsCountFormula,
    required this.occupant1,
    required this.occupant2,
    required this.leader,
    required this.rumorSubject,
    required this.rumorAction,
    required this.rumorContext,
  });

  String get objectiveDescription =>
      '$objective $rumorSubject $rumorAction $rumorContext';
  String get rumorDescription => '$rumorSubject $rumorAction $rumorContext';
}
