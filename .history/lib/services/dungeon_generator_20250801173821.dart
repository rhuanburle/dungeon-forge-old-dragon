// services/dungeon_generator.dart

import '../models/dungeon.dart';
import '../models/room.dart';
import '../models/dto/dto.dart';
import 'tables/tables.dart';
import 'treasure_resolver_service.dart';
import 'room_count_calculator.dart';

/// Implements the business rules from Livro I – Capítulo "Mestrando em Masmorras".
///
/// Usage:
///   final generator = DungeonGenerator();
///   final dungeon = generator.generate(level: 3, theme: "Recuperar artefato");
class DungeonGenerator {
  /// Generates a [Dungeon] according to the rules.
  Dungeon generate({
    required int level,
    required String theme,
    int? customRoomCount,
    int? minRooms,
    int? maxRooms,
  }) {
    // Step 1: Roll on the main dungeon table
    final dungeonData = DungeonTableService.roll();

    // Step 2: Calculate rooms count
    final roomsCount = RoomCountCalculator.calculateRoomsCount(
      formula: dungeonData.roomsCountFormula,
      customRoomCount: customRoomCount,
      minRooms: minRooms,
      maxRooms: maxRooms,
    );

    // Step 3: Build rooms
    final rooms = <Room>[];
    for (int i = 1; i <= roomsCount; i++) {
      final roomData = RoomTableService.generateRoomData(
        occupantI: dungeonData.occupant1,
        occupantII: dungeonData.occupant2,
      );

      final room = _buildRoomFromData(i, roomData);
      rooms.add(room);
    }

    // Step 4: Build rumor
    final rumor = _buildRumor(dungeonData);

    return Dungeon(
      type: dungeonData.type,
      builderOrInhabitant: dungeonData.builderOrInhabitant,
      status: dungeonData.status,
      objective: dungeonData.objectiveDescription,
      location: dungeonData.location,
      entry: dungeonData.entry,
      roomsCount: roomsCount,
      occupant1: dungeonData.occupant1,
      occupant2: dungeonData.occupant2,
      leader: dungeonData.leader,
      rumor1: rumor,
      rooms: rooms,
    );
  }

  /// Builds a Room from RoomTableDto data
  Room _buildRoomFromData(int index, RoomTableDto data) {
    // Resolve treasure values
    final resolvedTreasure =
        TreasureResolverService.resolveTreasure(data.treasure);
    final resolvedSpecialTreasure =
        TreasureResolverService.resolveTreasure(data.specialTreasure);
    final resolvedMagicItem =
        TreasureResolverService.resolveMagicItem(data.magicItem);

    return Room(
      index: index,
      type: data.roomType.displayName,
      air: data.air,
      smell: data.smell,
      sound: data.sound,
      item: data.item,
      specialItem: data.specialItem,
      monster1: data.monster1,
      monster2: data.monster2,
      trap: data.trap,
      specialTrap: data.specialTrap,
      roomCommon: data.roomCommon,
      roomSpecial: data.roomSpecial,
      roomSpecial2: data.roomSpecial2,
      treasure: resolvedTreasure,
      specialTreasure: resolvedSpecialTreasure,
      magicItem: resolvedMagicItem,
    );
  }

  /// Builds the complete rumor from dungeon data
  String _buildRumor(DungeonTableDto data) {
    final rumor =
        '${data.rumorSubject} ${data.rumorAction} ${data.rumorContext}';
    return DungeonTableService.resolveColumnReference(rumor, data);
  }
}
