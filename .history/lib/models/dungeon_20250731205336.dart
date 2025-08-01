// models/dungeon.dart

import 'room.dart';

class Dungeon {
  final String type;
  final String builderOrInhabitant;
  final String status;
  final String objective;
  final String location;
  final String entry;
  final int roomsCount;
  final String occupant1;
  final String occupant2;
  final String leader;
  final String rumor1;
  final List<Room> rooms;

  Dungeon({
    required this.type,
    required this.builderOrInhabitant,
    required this.status,
    required this.objective,
    required this.location,
    required this.entry,
    required this.roomsCount,
    required this.occupant1,
    required this.occupant2,
    required this.leader,
    required this.rumor1,
    required this.rooms,
  });

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Dungeon Overview');
    buffer.writeln('- Type: $type');
    buffer.writeln('- Built/Habited by: $builderOrInhabitant');
    buffer.writeln('- Status: $status');
    buffer.writeln('- Objective: $objective');
    buffer.writeln('- Location: $location');
    buffer.writeln('- Entry: $entry');
    buffer.writeln('- Rooms: $roomsCount');
    buffer.writeln('- Occupants:');
    buffer.writeln('  • Primary: $occupant1');
    buffer.writeln('  • Secondary: $occupant2');
    buffer.writeln('  • Leader: $leader');
    buffer.writeln('- Rumors:');
    buffer.writeln('  1) $rumor1');
    buffer.writeln('  2) $rumor2');
    buffer.writeln('  3) $rumor3');
    buffer.writeln('\n--- Rooms ---');
    for (final room in rooms) {
      buffer.writeln(room);
    }
    return buffer.toString();
  }
}
