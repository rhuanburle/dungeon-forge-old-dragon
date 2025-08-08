import 'package:flutter_test/flutter_test.dart';

import '../../lib/services/solo_dragon/solo_dragon_service.dart';

void main() {
  group('@test solo dragon room generation', () {
    test('generates room with all components from A5.4, A5.5, A5.6', () {
      final service = SoloDragonService.withSeed(42);
      final room = service.generateRoom(RoomContext.enteringDungeon);
      
      expect(room.type, isNotEmpty);
      expect(room.doors, isNotEmpty);
      expect(room.content, isNotEmpty);
      // trap and encounter can be empty
      expect(room.trap, isA<String>());
      expect(room.encounter, isA<String>());
      expect(room.treasure, isA<String>());
    });

    test('different contexts generate different room types', () {
      final service = SoloDragonService.withSeed(123);
      
      final enteringRoom = service.generateRoom(RoomContext.enteringDungeon);
      final chamberRoom = service.generateRoom(RoomContext.leavingChamber);
      final corridorRoom = service.generateRoom(RoomContext.leavingCorridor);
      final stairsRoom = service.generateRoom(RoomContext.leavingStairs);
      
      // They should be different (though theoretically could be same by chance)
      final allTypes = [
        enteringRoom.type,
        chamberRoom.type,
        corridorRoom.type,
        stairsRoom.type,
      ];
      
      // At least some should be different
      expect(allTypes.toSet().length, greaterThan(1));
    });

    test('treasure generation follows A5.6 formulas', () {
      final service = SoloDragonService.withSeed(456);
      
      // Generate multiple rooms to find one with treasure
      SoloRoom? roomWithTreasure;
      for (int i = 0; i < 50; i++) {
        final room = service.generateRoom(RoomContext.enteringDungeon);
        if (room.treasure.isNotEmpty) {
          roomWithTreasure = room;
          break;
        }
      }
      
      expect(roomWithTreasure, isNotNull);
      expect(
        roomWithTreasure!.treasure,
        anyOf(
          contains('PO:'),
          contains('PP:'),
          contains('Gemas:'),
          contains('Arte:'),
          contains('Mágicos:'),
        ),
      );
    });
  });
}
