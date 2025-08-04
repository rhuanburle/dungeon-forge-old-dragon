import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('Detailed Nest, Camp, and Tribe Tables Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.21 - Ninhos Detailed Tests', () {
      test('Roll 1: Águia Gigante (1d6) + Plataforma rochosa', () {
        final nest = service.generateNestWithRoll(1);
        print('=== TABELA 4.21 ROLL 1 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Águia Gigante')));
        expect(nest.characteristic, equals('Plataforma rochosa'));
        
        final number = int.parse(nest.owner.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
        
        print('✅ Roll 1 detailed verification passed!');
      });

      test('Roll 2: Pégaso (1d6) + Oco no topo de árvores', () {
        final nest = service.generateNestWithRoll(2);
        print('=== TABELA 4.21 ROLL 2 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Pégaso')));
        expect(nest.characteristic, equals('Oco no topo de árvores'));
        
        final number = int.parse(nest.owner.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(6));
        
        print('✅ Roll 2 detailed verification passed!');
      });

      test('Roll 3: Wyvern (1d4) + Grutas de pedra', () {
        final nest = service.generateNestWithRoll(3);
        print('=== TABELA 4.21 ROLL 3 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Wyvern')));
        expect(nest.characteristic, equals('Grutas de pedra'));
        
        final number = int.parse(nest.owner.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(4));
        
        print('✅ Roll 3 detailed verification passed!');
      });

      test('Roll 4: Grifo (1d4) + Ninho de gravetos', () {
        final nest = service.generateNestWithRoll(4);
        print('=== TABELA 4.21 ROLL 4 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Grifo')));
        expect(nest.characteristic, equals('Ninho de gravetos'));
        
        final number = int.parse(nest.owner.split(' ')[0]);
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(4));
        
        print('✅ Roll 4 detailed verification passed!');
      });

      test('Roll 5: Harpia (1d4) + Contém 1d3 ovos', () {
        final nest = service.generateNestWithRoll(5);
        print('=== TABELA 4.21 ROLL 5 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Harpia')));
        expect(nest.characteristic, matches(RegExp(r'Contém \d+ ovos')));
        
        final ownerNumber = int.parse(nest.owner.split(' ')[0]);
        expect(ownerNumber, greaterThanOrEqualTo(1));
        expect(ownerNumber, lessThanOrEqualTo(4));
        
        final eggNumber = int.parse(nest.characteristic.split(' ')[1]);
        expect(eggNumber, greaterThanOrEqualTo(1));
        expect(eggNumber, lessThanOrEqualTo(3));
        
        print('✅ Roll 5 detailed verification passed!');
      });

      test('Roll 6: Mantícora (1d4) + Contém 1d2 filhotes', () {
        final nest = service.generateNestWithRoll(6);
        print('=== TABELA 4.21 ROLL 6 DETAILED ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        expect(nest.owner, matches(RegExp(r'\d+ Mantícora')));
        expect(nest.characteristic, matches(RegExp(r'Contém \d+ filhotes')));
        
        final ownerNumber = int.parse(nest.owner.split(' ')[0]);
        expect(ownerNumber, greaterThanOrEqualTo(1));
        expect(ownerNumber, lessThanOrEqualTo(4));
        
        final babyNumber = int.parse(nest.characteristic.split(' ')[1]);
        expect(babyNumber, greaterThanOrEqualTo(1));
        expect(babyNumber, lessThanOrEqualTo(2));
        
        print('✅ Roll 6 detailed verification passed!');
      });
    });

    group('Table 4.22 - Acampamentos Detailed Tests', () {
      test('Roll 1: Bandidos (2d4 x 10) + Elfos + Paliçada', () {
        final camp = service.generateCampWithRolls(1, 1, 1, 1, 1);
        print('=== TABELA 4.22 ROLL 1 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, matches(RegExp(r'\d+ Bandidos')));
        expect(camp.special, matches(RegExp(r'\d+ Elfos')));
        expect(camp.tents, equals('1 a cada 25 membros'));
        expect(camp.watch, equals('Guardas dormindo'));
        expect(camp.defenses, equals('Paliçada'));
        
        final banditNumber = int.parse(camp.type.split(' ')[0]);
        expect(banditNumber, greaterThanOrEqualTo(20));
        expect(banditNumber, lessThanOrEqualTo(80));
        
        final elfNumber = int.parse(camp.special.split(' ')[0]);
        expect(elfNumber, greaterThanOrEqualTo(20));
        expect(elfNumber, lessThanOrEqualTo(200));
        
        print('✅ Roll 1 detailed verification passed!');
      });

      test('Roll 2: Bárbaros (3d10 x 10) + Anões + Muro de terra', () {
        final camp = service.generateCampWithRolls(2, 2, 2, 2, 2);
        print('=== TABELA 4.22 ROLL 2 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, matches(RegExp(r'\d+ Bárbaros')));
        expect(camp.special, matches(RegExp(r'\d+ Anões')));
        expect(camp.tents, equals('1 a cada 10 membros'));
        expect(camp.watch, equals('Sentinelas alertas'));
        expect(camp.defenses, equals('Muro de terra'));
        
        final barbarianNumber = int.parse(camp.type.split(' ')[0]);
        expect(barbarianNumber, greaterThanOrEqualTo(30));
        expect(barbarianNumber, lessThanOrEqualTo(300));
        
        final dwarfNumber = int.parse(camp.special.split(' ')[0]);
        expect(dwarfNumber, greaterThanOrEqualTo(40));
        expect(dwarfNumber, lessThanOrEqualTo(400));
        
        print('✅ Roll 2 detailed verification passed!');
      });

      test('Roll 3: Cultistas (2d4) + Jogue na tabela 4.23 + Forte abandonado', () {
        final camp = service.generateCampWithRolls(3, 3, 3, 3, 3);
        print('=== TABELA 4.22 ROLL 3 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, matches(RegExp(r'\d+ Cultistas')));
        expect(camp.special, equals('Jogue na tabela 4.23'));
        expect(camp.tents, equals('1 a cada 5 membros'));
        expect(camp.watch, equals('Vigias em ronda'));
        expect(camp.defenses, equals('Forte abandonado'));
        
        final cultistNumber = int.parse(camp.type.split(' ')[0]);
        expect(cultistNumber, greaterThanOrEqualTo(2));
        expect(cultistNumber, lessThanOrEqualTo(8));
        
        print('✅ Roll 3 detailed verification passed!');
      });

      test('Roll 4: Mercenários (7d6) + Jogue na tabela 4.23 + Torre de vigília', () {
        final camp = service.generateCampWithRolls(4, 4, 4, 4, 4);
        print('=== TABELA 4.22 ROLL 4 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, matches(RegExp(r'\d+ Mercenários')));
        expect(camp.special, equals('Jogue na tabela 4.23'));
        expect(camp.tents, equals('Apenas uma grande tenda'));
        expect(camp.watch, equals('Cães de guarda'));
        expect(camp.defenses, equals('Torre de vigília'));
        
        final mercenaryNumber = int.parse(camp.type.split(' ')[0]);
        expect(mercenaryNumber, greaterThanOrEqualTo(7));
        expect(mercenaryNumber, lessThanOrEqualTo(42));
        
        print('✅ Roll 4 detailed verification passed!');
      });

      test('Roll 5: Patrulha (2d6) + Jogue na tabela 4.23 + Sem defesas', () {
        final camp = service.generateCampWithRolls(5, 5, 5, 5, 5);
        print('=== TABELA 4.22 ROLL 5 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, matches(RegExp(r'\d+ Patrulha')));
        expect(camp.special, equals('Jogue na tabela 4.23'));
        expect(camp.tents, equals('Não há tendas'));
        expect(camp.watch, equals('Patrulha montada'));
        expect(camp.defenses, equals('Sem defesas'));
        
        final patrolNumber = int.parse(camp.type.split(' ')[0]);
        expect(patrolNumber, greaterThanOrEqualTo(2));
        expect(patrolNumber, lessThanOrEqualTo(12));
        
        print('✅ Roll 5 detailed verification passed!');
      });

      test('Roll 6: Especial + Jogue na tabela 4.23 + Sem defesas', () {
        final camp = service.generateCampWithRolls(6, 6, 6, 6, 6);
        print('=== TABELA 4.22 ROLL 6 DETAILED ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        expect(camp.type, equals('Especial'));
        expect(camp.special, equals('Jogue na tabela 4.23'));
        expect(camp.tents, equals('Não há tendas'));
        expect(camp.watch, equals('Sem vigília'));
        expect(camp.defenses, equals('Sem defesas'));
        
        print('✅ Roll 6 detailed verification passed!');
      });
    });

    group('Table 4.23 - Tribos Detailed Tests', () {
      test('Subterranean - Roll 1: Orc', () {
        final tribe = service.generateTribeWithRoll(TerrainType.subterranean, 1);
        print('=== TABELA 4.23 SUBTERRANEAN ROLL 1 DETAILED ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        expect(tribe.type, equals('Orc'));
        expect(tribe.members, greaterThanOrEqualTo(30));
        expect(tribe.members, lessThanOrEqualTo(300));
        expect(tribe.soldiers, greaterThanOrEqualTo(18));
        expect(tribe.soldiers, lessThanOrEqualTo(180));
        expect(tribe.leaders, equals(1));
        expect(tribe.religious, greaterThanOrEqualTo(0));
        expect(tribe.religious, lessThanOrEqualTo(3));
        expect(tribe.special, greaterThanOrEqualTo(0));
        expect(tribe.special, lessThanOrEqualTo(6));
        
        print('✅ Subterranean Roll 1 detailed verification passed!');
      });

      test('Forests - Roll 1: Orc', () {
        final tribe = service.generateTribeWithRoll(TerrainType.forests, 1);
        print('=== TABELA 4.23 FORESTS ROLL 1 DETAILED ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        expect(tribe.type, equals('Orc'));
        expect(tribe.members, greaterThanOrEqualTo(30));
        expect(tribe.members, lessThanOrEqualTo(300));
        expect(tribe.soldiers, greaterThanOrEqualTo(18));
        expect(tribe.soldiers, lessThanOrEqualTo(180));
        expect(tribe.leaders, equals(1));
        expect(tribe.religious, greaterThanOrEqualTo(0));
        expect(tribe.religious, lessThanOrEqualTo(3));
        expect(tribe.special, greaterThanOrEqualTo(0));
        expect(tribe.special, lessThanOrEqualTo(6));
        
        print('✅ Forests Roll 1 detailed verification passed!');
      });

      test('Deserts - Roll 1: Ogro', () {
        final tribe = service.generateTribeWithRoll(TerrainType.deserts, 1);
        print('=== TABELA 4.23 DESERTS ROLL 1 DETAILED ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        expect(tribe.type, equals('Ogro'));
        expect(tribe.members, greaterThanOrEqualTo(2));
        expect(tribe.members, lessThanOrEqualTo(20));
        expect(tribe.soldiers, greaterThanOrEqualTo(1));
        expect(tribe.soldiers, lessThanOrEqualTo(12));
        expect(tribe.leaders, equals(1));
        expect(tribe.religious, equals(0));
        expect(tribe.special, equals(0));
        
        print('✅ Deserts Roll 1 detailed verification passed!');
      });

      test('Hills - Roll 1: Goblin', () {
        final tribe = service.generateTribeWithRoll(TerrainType.hills, 1);
        print('=== TABELA 4.23 HILLS ROLL 1 DETAILED ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        expect(tribe.type, equals('Goblin'));
        expect(tribe.members, greaterThanOrEqualTo(40));
        expect(tribe.members, lessThanOrEqualTo(400));
        expect(tribe.soldiers, greaterThanOrEqualTo(16));
        expect(tribe.soldiers, lessThanOrEqualTo(160));
        expect(tribe.leaders, equals(1));
        expect(tribe.religious, greaterThanOrEqualTo(0));
        expect(tribe.religious, lessThanOrEqualTo(4));
        expect(tribe.special, greaterThanOrEqualTo(0));
        expect(tribe.special, lessThanOrEqualTo(8));
        
        print('✅ Hills Roll 1 detailed verification passed!');
      });

      test('Mountains - Roll 1: Ogro', () {
        final tribe = service.generateTribeWithRoll(TerrainType.mountains, 1);
        print('=== TABELA 4.23 MOUNTAINS ROLL 1 DETAILED ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        expect(tribe.type, equals('Ogro'));
        expect(tribe.members, greaterThanOrEqualTo(2));
        expect(tribe.members, lessThanOrEqualTo(20));
        expect(tribe.soldiers, greaterThanOrEqualTo(1));
        expect(tribe.soldiers, lessThanOrEqualTo(12));
        expect(tribe.leaders, equals(1));
        expect(tribe.religious, equals(0));
        expect(tribe.special, equals(0));
        
        print('✅ Mountains Roll 1 detailed verification passed!');
      });
    });
  });
} 