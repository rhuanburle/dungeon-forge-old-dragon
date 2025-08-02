// test/models/dto/dungeon_generation_dto_test.dart

import 'package:test/test.dart';
import '../../../lib/models/dto/dungeon_generation_dto.dart';
import '../../../lib/enums/dungeon_tables.dart';
import '../../../lib/enums/room_tables.dart';

void main() {
  group('DungeonGenerationDto', () {
    late DungeonGenerationDto dto;

    setUp(() {
      dto = const DungeonGenerationDto(
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
    });

    test('should create instance with all required properties', () {
      expect(dto.type, equals(DungeonType.lostConstruction));
      expect(dto.builderOrInhabitant, equals(DungeonBuilder.unknown));
      expect(dto.status, equals(DungeonStatus.cursed));
      expect(dto.objective, equals(DungeonObjective.defend));
      expect(dto.target, equals(DungeonTarget.artifact));
      expect(dto.targetStatus, equals(DungeonTargetStatus.beingSought));
      expect(dto.location, equals(DungeonLocation.scorchingDesert));
      expect(dto.entry, equals(DungeonEntry.behindWaterfall));
      expect(dto.sizeFormula, equals('Grande – 3d6+6'));
      expect(dto.occupantI, equals('Trolls'));
      expect(dto.occupantII, equals('Kobolds'));
      expect(dto.leader, equals('Hobgoblin'));
      expect(dto.rumorSubject, equals(RumorSubject.drunkPeasant));
      expect(dto.rumorAction, equals(RumorAction.seenNear));
      expect(dto.rumorLocation, equals(RumorLocation.autumnReligiousFestival));
    });

    test('fullObjective should combine objective, target and targetStatus', () {
      final expected = 'Defender artefato que está sendo procurado';
      expect(dto.fullObjective, equals(expected));
    });

    test('fullRumor should combine rumor components', () {
      final expected =
          'Um camponês bêbado foi visto próximo a festival religioso do outono';
      expect(dto.fullRumor, equals(expected));
    });

    test('resolveRumorReferences should replace column references', () {
      final dtoWithReferences = const DungeonGenerationDto(
        type: DungeonType.lostConstruction,
        builderOrInhabitant: DungeonBuilder.unknown,
        status: DungeonStatus.cursed,
        objective: DungeonObjective.defend,
        target: DungeonTarget.artifact,
        targetStatus: DungeonTargetStatus.beingSought,
        location: DungeonLocation.scorchingDesert,
        entry: DungeonEntry.behindWaterfall,
        sizeFormula: 'Grande – 3d6+6',
        occupantI: 'Trolls',
        occupantII: 'Kobolds',
        leader: 'Hobgoblin',
        rumorSubject: RumorSubject.primaryOccupant, // Contains [coluna 10]
        rumorAction: RumorAction.seenNear,
        rumorLocation: RumorLocation.autumnReligiousFestival,
      );

      final resolved = dtoWithReferences.fullRumor;

      expect(resolved, contains('Trolls'));
      expect(resolved, isNot(contains('[coluna 10]')));
    });
  });

  group('RoomGenerationDto', () {
    late RoomGenerationDto dto;

    setUp(() {
      dto = const RoomGenerationDto(
        type: RoomType.monster,
        airCurrent: AirCurrent.hotDraft,
        smell: Smell.rottenMeat,
        sound: Sound.metallicScratch,
        foundItem: FoundItem.completelyEmpty,
        specialItem: SpecialItem.monsterCarcasses,
        commonRoom: CommonRoom.dormitory,
        specialRoom: SpecialRoom.trainingRoom,
        specialRoom2: SpecialRoom2.tortureChamber,
        monster: Monster.newMonster,
        trap: Trap.hiddenGuillotine,
        specialTrap: SpecialTrap.waterWell,
        treasure: Treasure.magicItem,
        specialTreasure: SpecialTreasure.rollAgainPlusMagicItem,
        magicItem: MagicItem.any1,
      );
    });

    test('should create instance with all properties', () {
      expect(dto.type, equals(RoomType.monster));
      expect(dto.airCurrent, equals(AirCurrent.hotDraft));
      expect(dto.smell, equals(Smell.rottenMeat));
      expect(dto.sound, equals(Sound.metallicScratch));
      expect(dto.foundItem, equals(FoundItem.completelyEmpty));
      expect(dto.specialItem, equals(SpecialItem.monsterCarcasses));
      expect(dto.commonRoom, equals(CommonRoom.dormitory));
      expect(dto.specialRoom, equals(SpecialRoom.trainingRoom));
      expect(dto.specialRoom2, equals(SpecialRoom2.tortureChamber));
      expect(dto.monster, equals(Monster.newMonster));
      expect(dto.trap, equals(Trap.hiddenGuillotine));
      expect(dto.specialTrap, equals(SpecialTrap.waterWell));
      expect(dto.treasure, equals(Treasure.magicItem));
      expect(
          dto.specialTreasure, equals(SpecialTreasure.rollAgainPlusMagicItem));
      expect(dto.magicItem, equals(MagicItem.any1));
    });

    test('hasTrap should return true for trap and specialTrap types', () {
      final trapDto = dto.copyWith(
          type: RoomType.trap, trap: Trap.hiddenGuillotine, monster: null);
      final specialTrapDto = dto.copyWith(
          type: RoomType.specialTrap,
          specialTrap: SpecialTrap.waterWell,
          monster: null);
      final monsterDto =
          dto.copyWith(type: RoomType.monster, trap: null, specialTrap: null);

      expect(trapDto.hasTraps, isTrue);
      expect(specialTrapDto.hasTraps, isTrue);
      expect(monsterDto.hasTraps, isFalse);
    });

    test('hasMonster should return true for monster type', () {
      final monsterDto = dto.copyWith(
          type: RoomType.monster,
          monster: Monster.newMonster,
          trap: null,
          specialTrap: null);
      final trapDto = dto.copyWith(type: RoomType.trap, monster: null);

      expect(monsterDto.hasMonsters, isTrue);
      expect(trapDto.hasMonsters, isFalse);
    });

    test('should have correct treasure status', () {
      final treasureDto = dto.copyWith(treasure: Treasure.magicItem);
      final noTreasureDto = dto.copyWith(treasure: Treasure.noTreasure);

      expect(treasureDto.hasTreasure, isTrue);
      expect(noTreasureDto.hasTreasure, isFalse);
    });
  });

  group('TreasureDto', () {
    test('should create instance with description', () {
      const dto = TreasureDto(description: 'Test treasure');
      expect(dto.description, equals('Test treasure'));
      expect(dto.hasValue, isFalse);
    });

    test('hasValue should return true when any value is present', () {
      const dtoWithCopper = TreasureDto(description: 'Test', copperPieces: 100);
      const dtoWithSilver = TreasureDto(description: 'Test', silverPieces: 50);
      const dtoWithGold = TreasureDto(description: 'Test', goldPieces: 25);
      const dtoWithGems = TreasureDto(description: 'Test', gems: 3);
      const dtoWithValuable =
          TreasureDto(description: 'Test', valuableObjects: 2);
      const dtoWithMagic =
          TreasureDto(description: 'Test', magicItem: 'Sword +1');
      const dtoEmpty = TreasureDto(description: 'Test');

      expect(dtoWithCopper.hasValue, isTrue);
      expect(dtoWithSilver.hasValue, isTrue);
      expect(dtoWithGold.hasValue, isTrue);
      expect(dtoWithGems.hasValue, isTrue);
      expect(dtoWithValuable.hasValue, isTrue);
      expect(dtoWithMagic.hasValue, isTrue);
      expect(dtoEmpty.hasValue, isFalse);
    });

    test('should handle all treasure types', () {
      const dto = TreasureDto(
        description: 'Full treasure',
        copperPieces: 100,
        silverPieces: 50,
        goldPieces: 25,
        gems: 3,
        valuableObjects: 2,
        magicItem: 'Ring of Power',
      );

      expect(dto.description, equals('Full treasure'));
      expect(dto.copperPieces, equals(100));
      expect(dto.silverPieces, equals(50));
      expect(dto.goldPieces, equals(25));
      expect(dto.gems, equals(3));
      expect(dto.valuableObjects, equals(2));
      expect(dto.magicItem, equals('Ring of Power'));
      expect(dto.hasValue, isTrue);
    });
  });
}

// Extension para facilitar testes
extension RoomGenerationDtoExtension on RoomGenerationDto {
  RoomGenerationDto copyWith({
    RoomType? type,
    AirCurrent? airCurrent,
    Smell? smell,
    Sound? sound,
    FoundItem? foundItem,
    SpecialItem? specialItem,
    CommonRoom? commonRoom,
    SpecialRoom? specialRoom,
    SpecialRoom2? specialRoom2,
    Monster? monster,
    Trap? trap,
    SpecialTrap? specialTrap,
    Treasure? treasure,
    SpecialTreasure? specialTreasure,
    MagicItem? magicItem,
  }) {
    return RoomGenerationDto(
      type: type ?? this.type,
      airCurrent: airCurrent ?? this.airCurrent,
      smell: smell ?? this.smell,
      sound: sound ?? this.sound,
      foundItem: foundItem ?? this.foundItem,
      specialItem: specialItem ?? this.specialItem,
      commonRoom: commonRoom ?? this.commonRoom,
      specialRoom: specialRoom ?? this.specialRoom,
      specialRoom2: specialRoom2 ?? this.specialRoom2,
      monster: monster ?? this.monster,
      trap: trap ?? this.trap,
      specialTrap: specialTrap ?? this.specialTrap,
      treasure: treasure ?? this.treasure,
      specialTreasure: specialTreasure ?? this.specialTreasure,
      magicItem: magicItem ?? this.magicItem,
    );
  }
}
