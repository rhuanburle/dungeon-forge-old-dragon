// models/room.dart

class Room {
  final int index;
  final String type;
  final String air;
  final String smell;
  final String sound;
  final String item;
  final String specialItem;
  final String monster;
  final String trap;
  final String specialTrap;
  final String treasure;
  final String specialTreasure;
  final String magicItem;

  Room({
    required this.index,
    required this.type,
    required this.air,
    required this.smell,
    required this.sound,
    required this.item,
    required this.specialItem,
    required this.monster,
    required this.trap,
    required this.specialTrap,
    required this.treasure,
    required this.specialTreasure,
    required this.magicItem,
  });

  @override
  String toString() {
    return 'Room #$index:\n'
        '  - Type: $type\n'
        '  - Air: $air\n'
        '  - Smell: $smell\n'
        '  - Sound: $sound\n'
        '  - Item: $item\n'
        '  - Special Item: $specialItem\n'
        '  - Monster: $monster\n'
        '  - Trap: $trap\n'
        '  - Special Trap: $specialTrap\n'
        '  - Treasure: $treasure\n'
        '  - Special Treasure: $specialTreasure\n'
        '  - Magic Item: $magicItem\n';
  }
}
