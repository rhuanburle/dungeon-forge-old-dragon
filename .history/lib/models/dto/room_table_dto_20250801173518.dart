// models/dto/room_table_dto.dart

class RoomTableDto {
  final RoomType roomType;
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

  const RoomTableDto({
    required this.roomType,
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
}

enum RoomType {
  specialRoom,
  trap,
  commonRoom,
  encounter,
  specialTrap,
}

extension RoomTypeExtension on RoomType {
  String get displayName {
    switch (this) {
      case RoomType.specialRoom:
        return 'Sala Especial';
      case RoomType.trap:
        return 'Armadilha';
      case RoomType.commonRoom:
        return 'Sala Comum';
      case RoomType.encounter:
        return 'Encontro';
      case RoomType.specialTrap:
        return 'Sala Armadilha Especial';
    }
  }

  bool get hasTreasureModifier {
    switch (this) {
      case RoomType.trap:
      case RoomType.specialTrap:
        return true;
      case RoomType.encounter:
        return true;
      default:
        return false;
    }
  }

  int get treasureModifier {
    switch (this) {
      case RoomType.trap:
      case RoomType.specialTrap:
        return 1;
      case RoomType.encounter:
        return 2;
      default:
        return 0;
    }
  }
} 