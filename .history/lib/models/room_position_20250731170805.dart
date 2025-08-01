// models/room_position.dart

import 'room.dart';

class RoomPosition {
  final int x;
  final int y;
  final int width;
  final int height;
  final Room room;
  final bool isEntry;
  bool isBoss;

  RoomPosition({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.room,
    this.isEntry = false,
    this.isBoss = false,
  });

  bool contains(int px, int py) {
    return px >= x && px < x + width && py >= y && py < y + height;
  }

  String get displayName {
    if (isEntry) return 'Entrada';
    if (isBoss) return 'Sala do Chefe';
    return 'Sala ${room.index}';
  }
} 