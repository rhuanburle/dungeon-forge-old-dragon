// models/room.dart

class Room {
  final int index;
  final String type;
  final String air;
  final String smell;
  final String sound;
  final String item;
  final String specialItem;
  final String monster1;
  final String monster2;
  final String trap;
  final String specialTrap;
  final String roomCommon;
  final String roomSpecial;
  final String roomSpecial2;
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
    required this.monster1,
    required this.monster2,
    required this.trap,
    required this.specialTrap,
    required this.roomCommon,
    required this.roomSpecial,
    required this.roomSpecial2,
    required this.treasure,
    required this.specialTreasure,
    required this.magicItem,
  });

  @override
  String toString() {
    final monsterText = monster2.isEmpty
        ? 'Monster: $monster1'
        : 'Monsters: $monster1, $monster2';

    return 'Room #$index:\n'
        '  - Type: $type\n'
        '  - Air: $air\n'
        '  - Smell: $smell\n'
        '  - Sound: $sound\n'
        '  - Item: $item\n'
        '  - Special Item: $specialItem\n'
        '  - $monsterText\n'
        '  - Trap: $trap\n'
        '  - Special Trap: $specialTrap\n'
        '  - Room Common: $roomCommon\n'
        '  - Room Special: $roomSpecial\n'
        '  - Room Special 2: $roomSpecial2\n'
        '  - Treasure: $treasure\n'
        '  - Special Treasure: $specialTreasure\n'
        '  - Magic Item: $magicItem\n';
  }

  /// Cria uma cópia da sala com campos opcionais atualizados
  Room copyWith({
    int? index,
    String? type,
    String? air,
    String? smell,
    String? sound,
    String? item,
    String? specialItem,
    String? monster1,
    String? monster2,
    String? trap,
    String? specialTrap,
    String? roomCommon,
    String? roomSpecial,
    String? roomSpecial2,
    String? treasure,
    String? specialTreasure,
    String? magicItem,
  }) {
    return Room(
      index: index ?? this.index,
      type: type ?? this.type,
      air: air ?? this.air,
      smell: smell ?? this.smell,
      sound: sound ?? this.sound,
      item: item ?? this.item,
      specialItem: specialItem ?? this.specialItem,
      monster1: monster1 ?? this.monster1,
      monster2: monster2 ?? this.monster2,
      trap: trap ?? this.trap,
      specialTrap: specialTrap ?? this.specialTrap,
      roomCommon: roomCommon ?? this.roomCommon,
      roomSpecial: roomSpecial ?? this.roomSpecial,
      roomSpecial2: roomSpecial2 ?? this.roomSpecial2,
      treasure: treasure ?? this.treasure,
      specialTreasure: specialTreasure ?? this.specialTreasure,
      magicItem: magicItem ?? this.magicItem,
    );
  }
}
