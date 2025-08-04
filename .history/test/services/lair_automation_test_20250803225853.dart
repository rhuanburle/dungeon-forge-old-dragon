import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Lair Automation Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Lair Generation Automation', () {
      test('should generate lair automatically with resolved dice rolls', () {
        final lair = service.generateLair();
        
        expect(lair, isA<Lair>());
        expect(lair.type, isA<LairType>());
        expect(lair.occupation, isA<LairOccupation>());
        expect(lair.description, isNotEmpty);
        expect(lair.details, isNotEmpty);
        expect(lair.occupant, isNotEmpty);
        
        print('Lair: ${lair.description}');
        print('Type: ${lair.type.description}');
        print('Occupation: ${lair.occupation.description}');
        print('Occupant: ${lair.occupant}');
      });
    });

    group('Dungeon Generation Automation', () {
      test('should generate dungeon automatically with resolved dice rolls', () {
        final dungeon = service.generateDungeon();
        
        expect(dungeon, isA<Dungeon>());
        expect(dungeon.entry, isNotEmpty);
        expect(dungeon.floors, isA<int>());
        expect(dungeon.rooms, isA<int>());
        expect(dungeon.guardian, isNotEmpty);
        expect(dungeon.description, isNotEmpty);
        
        // Verificar se as rolagens foram resolvidas
        expect(dungeon.floors, greaterThan(0));
        expect(dungeon.rooms, greaterThan(0));
        
        print('Dungeon: ${dungeon.description}');
        print('Entry: ${dungeon.entry}');
        print('Floors: ${dungeon.floors}');
        print('Rooms: ${dungeon.rooms}');
        print('Guardian: ${dungeon.guardian}');
      });
    });

    group('Cave Generation Automation', () {
      test('should generate cave automatically with resolved dice rolls', () {
        final cave = service.generateCave();
        
        expect(cave, isA<Cave>());
        expect(cave.entry, isNotEmpty);
        expect(cave.inhabitant, isNotEmpty);
        expect(cave.description, isNotEmpty);
        
        // Verificar se as rolagens foram resolvidas (números no início)
        expect(cave.inhabitant, matches(RegExp(r'^\d+ ')));
        
        print('Cave: ${cave.description}');
        print('Entry: ${cave.entry}');
        print('Inhabitant: ${cave.inhabitant}');
      });
    });

    group('Burrow Generation Automation', () {
      test('should generate burrow automatically with resolved dice rolls', () {
        final burrow = service.generateBurrow();
        
        expect(burrow, isA<Burrow>());
        expect(burrow.entry, isNotEmpty);
        expect(burrow.occupant, isNotEmpty);
        expect(burrow.treasure, isNotEmpty);
        expect(burrow.description, isNotEmpty);
        
        // Verificar se as rolagens foram resolvidas (números entre parênteses)
        expect(burrow.occupant, matches(RegExp(r'\([^)]*\d+[^)]*\)')));
        
        print('Burrow: ${burrow.description}');
        print('Entry: ${burrow.entry}');
        print('Occupant: ${burrow.occupant}');
        print('Treasure: ${burrow.treasure}');
      });
    });

    group('Nest Generation Automation', () {
      test('should generate nest automatically', () {
        final nest = service.generateNest();
        
        expect(nest, isA<Nest>());
        expect(nest.owner, isNotEmpty);
        expect(nest.characteristic, isNotEmpty);
        expect(nest.description, isNotEmpty);
        
        print('Nest: ${nest.description}');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
      });
    });

    group('Camp Generation Automation', () {
      test('should generate camp automatically with resolved dice rolls', () {
        final camp = service.generateCamp();
        
        expect(camp, isA<Camp>());
        expect(camp.type, isNotEmpty);
        expect(camp.special, isNotEmpty);
        expect(camp.tents, isNotEmpty);
        expect(camp.watch, isNotEmpty);
        expect(camp.defenses, isNotEmpty);
        expect(camp.description, isNotEmpty);
        
        print('Camp: ${camp.description}');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
      });
    });

    group('Tribe Generation Automation', () {
      test('should generate tribe automatically with resolved dice rolls', () {
        final tribe = service.generateTribe(TerrainType.forests);
        
        expect(tribe, isA<Tribe>());
        expect(tribe.type, isNotEmpty);
        expect(tribe.members, isA<int>());
        expect(tribe.soldiers, isA<int>());
        expect(tribe.leaders, isA<int>());
        expect(tribe.religious, isA<int>());
        expect(tribe.special, isA<int>());
        expect(tribe.description, isNotEmpty);
        
        // Verificar se os números são válidos
        expect(tribe.members, greaterThan(0));
        expect(tribe.soldiers, greaterThanOrEqualTo(0));
        expect(tribe.leaders, greaterThanOrEqualTo(0));
        expect(tribe.religious, greaterThanOrEqualTo(0));
        expect(tribe.special, greaterThanOrEqualTo(0));
        
        print('Tribe: ${tribe.description}');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
      });
    });

    group('Multiple Generation Test', () {
      test('should generate multiple lairs without conflicts', () {
        // Gerar múltiplos covis para verificar se não há conflitos
        for (int i = 0; i < 10; i++) {
          final lair = service.generateLair();
          final dungeon = service.generateDungeon();
          final cave = service.generateCave();
          final burrow = service.generateBurrow();
          final nest = service.generateNest();
          final camp = service.generateCamp();
          final tribe = service.generateTribe(TerrainType.mountains);
          
          expect(lair, isA<Lair>());
          expect(dungeon, isA<Dungeon>());
          expect(cave, isA<Cave>());
          expect(burrow, isA<Burrow>());
          expect(nest, isA<Nest>());
          expect(camp, isA<Camp>());
          expect(tribe, isA<Tribe>());
        }
        
        print('✅ All lair types generated successfully!');
      });
    });

    group('Dice Roll Resolution Test', () {
      test('should resolve all dice rolls in lair descriptions', () {
        final lair = service.generateLair();
        
        // Verificar se não há strings de rolagem não resolvidas
        expect(lair.description, isNot(contains('d')));
        expect(lair.occupant, isNot(contains('d')));
        
        if (lair.type == LairType.dungeons) {
          final dungeon = service.generateDungeon();
          expect(dungeon.description, isNot(contains('d')));
        }
        
        print('✅ All dice rolls resolved in lair descriptions!');
      });
    });
  });
} 