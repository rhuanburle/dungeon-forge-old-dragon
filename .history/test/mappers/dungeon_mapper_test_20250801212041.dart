// test/mappers/dungeon_mapper_test.dart

import 'package:test/test.dart';
import '../../lib/mappers/dungeon_mapper.dart';
import '../../lib/models/dto/dungeon_generation_dto.dart';
import '../../lib/models/dungeon.dart';
import '../../lib/models/room.dart';
import '../../lib/enums/dungeon_tables.dart';
import '../../lib/enums/room_tables.dart';

void main() {
  // Helper para criar DungeonGenerationDto nos testes
  final testDungeonDto = DungeonGenerationDto(
    type: DungeonType.lostConstruction.description,
    builderOrInhabitant: DungeonBuilder.unknown.description,
    status: DungeonStatus.cursed.description,
    objective: DungeonObjective.defend.description,
    target: DungeonTarget.artifact.description,
    targetStatus: DungeonTargetStatus.beingSought.description,
    location: DungeonLocation.scorchingDesert.description,
    entry: DungeonEntry.behindWaterfall.description,
    sizeFormula: 'Grande – 3d6+6',
    occupantI: 'Trolls',
    occupantII: 'Kobolds',
    leader: 'Hobgoblin',
    rumorSubject: RumorSubject.drunkPeasant.description,
    rumorAction: RumorAction.seenNear.description,
    rumorLocation: RumorLocation.autumnReligiousFestival.description,
  );

  group('DungeonMapper', () {
    group('fromDto', () {
      test('should convert DungeonGenerationDto to Dungeon correctly', () {
        final dto = DungeonGenerationDto(
          type: DungeonType.lostConstruction.description,
          builderOrInhabitant: DungeonBuilder.unknown.description,
          status: DungeonStatus.cursed.description,
          objective: DungeonObjective.defend.description,
          target: DungeonTarget.artifact.description,
          targetStatus: DungeonTargetStatus.beingSought.description,
          location: DungeonLocation.scorchingDesert.description,
          entry: DungeonEntry.behindWaterfall.description,
          sizeFormula: 'Grande – 3d6+6',
          occupantI: 'Trolls',
          occupantII: 'Kobolds',
          leader: 'Hobgoblin',
          rumorSubject: RumorSubject.drunkPeasant.description,
          rumorAction: RumorAction.seenNear.description,
          rumorLocation: RumorLocation.autumnReligiousFestival.description,
        );

        final rooms = <Room>[
          Room(
            index: 1,
            type: 'Test Room',
            air: 'test air',
            smell: 'test smell',
            sound: 'test sound',
            item: 'test item',
            specialItem: '',
            monster1: '',
            monster2: '',
            trap: '',
            specialTrap: '',
            roomCommon: '',
            roomSpecial: '',
            roomSpecial2: '',
            treasure: '',
            specialTreasure: '',
            magicItem: '',
          ),
        ];

        final dungeon = DungeonMapper.fromDto(dto, rooms);

        expect(dungeon.type, equals('Construção Perdida'));
        expect(dungeon.builderOrInhabitant, equals('Desconhecido'));
        expect(dungeon.status, equals('Amaldiçoados'));
        expect(dungeon.objective,
            equals('Defender artefato que está sendo procurado'));
        expect(dungeon.location, equals('Deserto Escaldante'));
        expect(dungeon.entry, equals('Atrás de uma Cachoeira'));
        expect(dungeon.roomsCount, equals(1));
        expect(dungeon.occupant1, equals('Trolls'));
        expect(dungeon.occupant2, equals('Kobolds'));
        expect(dungeon.leader, equals('Hobgoblin'));
        expect(
            dungeon.rumor1,
            equals(
                'Um camponês bêbado foi visto próximo a festival religioso do outono'));
        expect(dungeon.rooms, equals(rooms));
      });

      test('should resolve rumor references correctly', () {
        final dto = DungeonGenerationDto(
          type: DungeonType.lostConstruction.description,
          builderOrInhabitant: DungeonBuilder.unknown.description,
          status: DungeonStatus.cursed.description,
          objective: DungeonObjective.defend.description,
          target: DungeonTarget.artifact.description,
          targetStatus: DungeonTargetStatus.beingSought.description,
          location: DungeonLocation.scorchingDesert.description,
          entry: DungeonEntry.behindWaterfall.description,
          sizeFormula: 'Grande – 3d6+6',
          occupantI: 'Trolls',
          occupantII: 'Kobolds',
          leader: 'Hobgoblin',
          rumorSubject:
              RumorSubject.primaryOccupant.description, // Contains [coluna 10]
          rumorAction: RumorAction.seenNear.description,
          rumorLocation: RumorLocation.autumnReligiousFestival.description,
        );

        final dungeon = DungeonMapper.fromDto(dto, []);

        expect(dungeon.rumor1, contains('Trolls'));
        expect(dungeon.rumor1, isNot(contains('[coluna 10]')));
      });
    });

    group('fromRoomDto', () {
      test('should convert RoomGenerationDto to Room correctly', () {
        final dto = RoomGenerationDto(
          type: RoomType.monster.description,
          airCurrent: AirCurrent.hotDraft.description,
          smell: Smell.rottenMeat.description,
          sound: Sound.metallicScratch.description,
          foundItem: FoundItem.completelyEmpty.description,
          specialItem: SpecialItem.monsterCarcasses.description,
          commonRoom: CommonRoom.dormitory.description,
          specialRoom: SpecialRoom.trainingRoom.description,
          specialRoom2: SpecialRoom2.tortureChamber.description,
          monster: Monster.newMonster.description,
          trap: Trap.hiddenGuillotine.description,
          specialTrap: SpecialTrap.waterWell.description,
          treasure: Treasure.magicItem.description,
          specialTreasure: SpecialTreasure.rollAgainPlusMagicItem.description,
          magicItem: MagicItem.any1.description,
        );

        final room = DungeonMapper.fromRoomDto(dto, 5, testDungeonDto);

        expect(room.index, equals(5));
        expect(room.type, equals('Encontro'));
        expect(room.air, equals('corrente de ar quente'));
        expect(room.smell, equals('cheiro de carne podre'));
        expect(room.sound, equals('arranhado metálico'));
        expect(room.item, equals('completamente vazia'));
        expect(room.specialItem, equals('carcaças de monstros'));
        expect(room.monster1, equals('Novo Monstro'));
        expect(room.monster2, equals(''));
        expect(room.trap, equals('Guilhotina Oculta'));
        expect(room.specialTrap, equals(''));
        expect(room.roomCommon, equals('dormitório'));
        expect(room.roomSpecial, equals('sala de treinamento'));
        expect(room.roomSpecial2, equals(''));
        expect(room.treasure,
            anyOf(equals('Item Mágico'), isNotEmpty)); // May be resolved
        expect(room.specialTreasure, equals(''));
        expect(
            room.magicItem, isNotEmpty); // Should be resolved from '1 Qualquer'
      });

      test('should build room type correctly for special room', () {
        final dto = const RoomGenerationDto(
          type: RoomType.specialRoom,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          specialRoom: SpecialRoom.trainingRoom,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.type, equals('Sala Especial (sala de treinamento)'));
      });

      test('should build room type correctly for trap', () {
        final dto = const RoomGenerationDto(
          type: RoomType.trap,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          trap: Trap.hiddenGuillotine,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.type, equals('Armadilha (Guilhotina Oculta)'));
      });

      test('should build room type correctly for common room', () {
        final dto = const RoomGenerationDto(
          type: RoomType.commonRoom,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          commonRoom: CommonRoom.dormitory,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.type, equals('Sala Comum (dormitório)'));
      });

      test('should build room type correctly for monster encounter', () {
        final dto = const RoomGenerationDto(
          type: RoomType.monster,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.type, equals('Encontro'));
      });

      test('should build room type correctly for special trap', () {
        final dto = const RoomGenerationDto(
          type: RoomType.specialTrap,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          specialTrap: SpecialTrap.waterWell,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.type, equals('Sala Armadilha Especial (Poço de Água)'));
      });

      test('should handle monster with multiple creatures correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.monster,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          monster: Monster.newMonsterPlusOccupantI,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.monster1, equals('Novo Monstro'));
        expect(room.monster2,
            equals('Trolls')); // Should be resolved from 'Ocupante I'
      });

      test('should handle special trap correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.trap,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          trap: Trap.specialTrap,
          specialTrap: SpecialTrap.waterWell,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.trap, equals('Poço de Água'));
        expect(room.specialTrap, equals('Poço de Água'));
      });

      test('should handle special room resolution correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.commonRoom,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          commonRoom: CommonRoom.special,
          specialRoom: SpecialRoom.trainingRoom,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.roomCommon, equals('sala de treinamento'));
        expect(room.roomSpecial, equals('sala de treinamento'));
      });

      test('should handle special room 2 resolution correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.specialRoom,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          specialRoom: SpecialRoom.special2,
          specialRoom2: SpecialRoom2.tortureChamber,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.roomSpecial, equals('câmara de tortura'));
        expect(room.roomSpecial2, equals('câmara de tortura'));
      });

      test('should handle special treasure correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.monster,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          treasure: Treasure.specialTreasure,
          specialTreasure: SpecialTreasure.rollAgainPlusMagicItem,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.treasure,
            isNotEmpty); // Should be resolved by TreasureResolver
        expect(room.specialTreasure, isNotEmpty); // Should be resolved
      });

      test('should handle null/empty values correctly', () {
        final dto = const RoomGenerationDto(
          type: RoomType.commonRoom,
          airCurrent: AirCurrent.hotDraft,
          smell: Smell.rottenMeat,
          sound: Sound.metallicScratch,
          foundItem: FoundItem.completelyEmpty,
          treasure: Treasure.noTreasure,
        );

        final room = DungeonMapper.fromRoomDto(dto, 1, testDungeonDto);
        expect(room.specialItem, equals(''));
        expect(room.monster1, equals(''));
        expect(room.monster2, equals(''));
        expect(room.trap, equals(''));
        expect(room.specialTrap, equals(''));
        expect(room.roomCommon, equals(''));
        expect(room.roomSpecial, equals(''));
        expect(room.roomSpecial2, equals(''));
        expect(room.specialTreasure, equals(''));
        expect(room.magicItem, equals(''));
      });
    });
  });
}
