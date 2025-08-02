// test/mappers/dungeon_mapper_test.dart

import 'package:test/test.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/mappers/dungeon_mapper.dart';
import '../../lib/models/dungeon.dart';
import '../../lib/models/dto/dungeon_generation_dto.dart';
import '../../lib/models/room.dart';

void main() {
  group('DungeonMapper', () {
    late DungeonGenerationDto testDto;
    late List<Room> testRooms;

    setUp(() {
      testDto = DungeonGenerationDto(
        type: DungeonType.lostConstruction,
        builderOrInhabitant: DungeonBuilder.unknown,
        status: DungeonStatus.lost,
        objective: DungeonObjective.defend,
        target: DungeonTarget.treasure,
        targetStatus: DungeonTargetStatus.intact,
        location: DungeonLocation.wildForest,
        entry: DungeonEntry.secretTunnel,
        sizeFormula: '1d6 + 4 salas',
        occupantI: 'Trolls',
        occupantII: 'Kobolds',
        leader: 'Hobgoblin',
        rumorSubject: RumorSubject.drunkPeasant,
        rumorAction: RumorAction.seenNear,
        rumorLocation: RumorLocation.nearbyVillage,
      );

      testRooms = [
        Room(
          index: 1,
          type: 'Sala Comum',
          air: 'sem corrente de ar',
          smell: 'sem cheiro especial',
          sound: 'nenhum som especial',
          item: 'completamente vazia',
          specialItem: '',
          monster1: '',
          monster2: '',
          trap: '',
          specialTrap: '',
          roomCommon: 'dormitório',
          roomSpecial: '',
          roomSpecial2: '',
          treasure: 'Nenhum',
          specialTreasure: '',
          magicItem: '',
        ),
      ];
    });

    test('should convert DungeonGenerationDto to Dungeon', () {
      final dungeon = DungeonMapper.fromDto(testDto, testRooms);

      expect(dungeon.type, equals('Construção Perdida'));
      expect(dungeon.builderOrInhabitant, equals('Desconhecido'));
      expect(dungeon.status, equals('Perdidos'));
      expect(dungeon.objective, equals('Defender tesouro que está intacto'));
      expect(dungeon.location, equals('Floresta Selvagem'));
      expect(dungeon.entry, equals('Túnel Secreto'));
      expect(dungeon.roomsCount, equals(1));
      expect(dungeon.occupant1, equals('Trolls'));
      expect(dungeon.occupant2, equals('Kobolds'));
      expect(dungeon.leader, equals('Hobgoblin'));
      expect(
          dungeon.rumor1,
          equals(
              'Um camponês bêbado foi visto próximo a aldeia vizinha próxima'));
      expect(dungeon.rooms, equals(testRooms));
    });

    test('should convert Dungeon to DungeonGenerationDto', () {
      final dungeon = Dungeon(
        type: 'Construção Perdida',
        builderOrInhabitant: 'Desconhecido',
        status: 'Perdidos',
        objective: 'Defender tesouro que está intacto',
        location: 'Floresta Selvagem',
        entry: 'Túnel Secreto',
        roomsCount: 1,
        occupant1: 'Trolls',
        occupant2: 'Kobolds',
        leader: 'Hobgoblin',
        rumor1: 'Um camponês bêbado foi visto próximo a aldeia vizinha próxima',
        rooms: testRooms,
      );

      final dto = DungeonMapper.toDto(dungeon);

      expect(dto.type, equals(DungeonType.lostConstruction));
      expect(dto.builderOrInhabitant, equals(DungeonBuilder.unknown));
      expect(dto.status, equals(DungeonStatus.lost));
      expect(dto.objective, equals(DungeonObjective.defend));
      expect(dto.target, equals(DungeonTarget.treasure));
      expect(dto.targetStatus, equals(DungeonTargetStatus.intact));
      expect(dto.location, equals(DungeonLocation.wildForest));
      expect(dto.entry, equals(DungeonEntry.secretTunnel));
      expect(dto.sizeFormula, equals('1d6 + 4 salas'));
      expect(dto.occupantI, equals('Trolls'));
      expect(dto.occupantII, equals('Kobolds'));
      expect(dto.leader, equals('Hobgoblin'));
      expect(dto.rumorSubject, equals(RumorSubject.drunkPeasant));
      expect(dto.rumorAction, equals(RumorAction.seenNear));
      expect(dto.rumorLocation, equals(RumorLocation.nearbyVillage));
    });

    test('should handle unknown descriptions with default values', () {
      final dungeon = Dungeon(
        type: 'Unknown Type',
        builderOrInhabitant: 'Unknown Builder',
        status: 'Unknown Status',
        objective: 'Unknown Objective',
        location: 'Unknown Location',
        entry: 'Unknown Entry',
        roomsCount: 1,
        occupant1: 'Unknown Occupant',
        occupant2: 'Unknown Occupant 2',
        leader: 'Unknown Leader',
        rumor1: 'Unknown Rumor',
        rooms: testRooms,
      );

      final dto = DungeonMapper.toDto(dungeon);

      // Should use default values for unknown descriptions
      expect(dto.type, equals(DungeonType.lostConstruction));
      expect(dto.builderOrInhabitant, equals(DungeonBuilder.unknown));
      expect(dto.status, equals(DungeonStatus.lost));
      expect(dto.objective, equals(DungeonObjective.defend));
      expect(dto.target, equals(DungeonTarget.treasure));
      expect(dto.targetStatus, equals(DungeonTargetStatus.intact));
      expect(dto.location, equals(DungeonLocation.wildForest));
      expect(dto.entry, equals(DungeonEntry.secretTunnel));
    });
  });
}
