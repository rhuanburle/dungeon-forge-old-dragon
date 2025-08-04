import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/table_enums.dart';
import '../../lib/utils/dice_roller.dart';

void main() {
  group('Deep Verification of Nest, Camp, and Tribe Tables', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.21 - Ninhos Deep Verification', () {
      test('Roll 1: Águia Gigante (1d6) + Plataforma rochosa - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 1 DEEP VERIFICATION ===');
        
        // Test multiple iterations to verify dice resolution
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(1);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          // Verify owner format and dice resolution
          expect(nest.owner, matches(RegExp(r'^\d+ Águia Gigante$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(6));
          
          // Verify characteristic is static
          expect(nest.characteristic, equals('Plataforma rochosa'));
        }
        
        print('✅ Roll 1 deep verification passed - Dice properly resolved!');
      });

      test('Roll 2: Pégaso (1d6) + Oco no topo de árvores - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 2 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(2);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          expect(nest.owner, matches(RegExp(r'^\d+ Pégaso$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(6));
          
          expect(nest.characteristic, equals('Oco no topo de árvores'));
        }
        
        print('✅ Roll 2 deep verification passed - Dice properly resolved!');
      });

      test('Roll 3: Wyvern (1d4) + Grutas de pedra - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 3 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(3);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          expect(nest.owner, matches(RegExp(r'^\d+ Wyvern$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(4));
          
          expect(nest.characteristic, equals('Grutas de pedra'));
        }
        
        print('✅ Roll 3 deep verification passed - Dice properly resolved!');
      });

      test('Roll 4: Grifo (1d4) + Ninho de gravetos - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 4 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(4);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          expect(nest.owner, matches(RegExp(r'^\d+ Grifo$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(4));
          
          expect(nest.characteristic, equals('Ninho de gravetos'));
        }
        
        print('✅ Roll 4 deep verification passed - Dice properly resolved!');
      });

      test('Roll 5: Harpia (1d4) + Contém 1d3 ovos - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 5 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(5);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          expect(nest.owner, matches(RegExp(r'^\d+ Harpia$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(4));
          
          expect(nest.characteristic, matches(RegExp(r'^Contém \d+ ovos$')));
          final eggNumber = int.parse(nest.characteristic.split(' ')[1]);
          expect(eggNumber, greaterThanOrEqualTo(1));
          expect(eggNumber, lessThanOrEqualTo(3));
        }
        
        print('✅ Roll 5 deep verification passed - Dice properly resolved!');
      });

      test('Roll 6: Mantícora (1d4) + Contém 1d2 filhotes - Dice Resolution', () {
        print('\n=== TABELA 4.21 ROLL 6 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final nest = service.generateNestWithRoll(6);
          print('Iteration ${i + 1}: Owner: ${nest.owner}, Characteristic: ${nest.characteristic}');
          
          expect(nest.owner, matches(RegExp(r'^\d+ Mantícora$')));
          final ownerNumber = int.parse(nest.owner.split(' ')[0]);
          expect(ownerNumber, greaterThanOrEqualTo(1));
          expect(ownerNumber, lessThanOrEqualTo(4));
          
          expect(nest.characteristic, matches(RegExp(r'^Contém \d+ filhotes$')));
          final babyNumber = int.parse(nest.characteristic.split(' ')[1]);
          expect(babyNumber, greaterThanOrEqualTo(1));
          expect(babyNumber, lessThanOrEqualTo(2));
        }
        
        print('✅ Roll 6 deep verification passed - Dice properly resolved!');
      });
    });

    group('Table 4.22 - Acampamentos Deep Verification', () {
      test('Roll 1: Bandidos (2d4 x 10) + Elfos (2d10 x 10) + Paliçada - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 1 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(1, 1, 1, 1, 1);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          // Verify bandidos calculation: 2d4 x 10
          expect(camp.type, matches(RegExp(r'^\d+ Bandidos$')));
          final banditNumber = int.parse(camp.type.split(' ')[0]);
          expect(banditNumber, greaterThanOrEqualTo(20)); // 2d4 minimum = 2, so 2*10 = 20
          expect(banditNumber, lessThanOrEqualTo(80)); // 2d4 maximum = 8, so 8*10 = 80
          expect(banditNumber % 10, equals(0)); // Must be multiple of 10
          
          // Verify elfos calculation: 2d10 x 10
          expect(camp.special, matches(RegExp(r'^\d+ Elfos$')));
          final elfNumber = int.parse(camp.special.split(' ')[0]);
          expect(elfNumber, greaterThanOrEqualTo(20)); // 2d10 minimum = 2, so 2*10 = 20
          expect(elfNumber, lessThanOrEqualTo(200)); // 2d10 maximum = 20, so 20*10 = 200
          expect(elfNumber % 10, equals(0)); // Must be multiple of 10
          
          expect(camp.tents, equals('1 a cada 25 membros'));
          expect(camp.watch, equals('Guardas dormindo'));
          expect(camp.defenses, equals('Paliçada'));
        }
        
        print('✅ Roll 1 deep verification passed - All dice properly resolved!');
      });

      test('Roll 2: Bárbaros (3d10 x 10) + Anões (4d10 x 10) + Muro de terra - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 2 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(2, 2, 2, 2, 2);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          // Verify bárbaros calculation: 3d10 x 10
          expect(camp.type, matches(RegExp(r'^\d+ Bárbaros$')));
          final barbarianNumber = int.parse(camp.type.split(' ')[0]);
          expect(barbarianNumber, greaterThanOrEqualTo(30)); // 3d10 minimum = 3, so 3*10 = 30
          expect(barbarianNumber, lessThanOrEqualTo(300)); // 3d10 maximum = 30, so 30*10 = 300
          expect(barbarianNumber % 10, equals(0)); // Must be multiple of 10
          
          // Verify anões calculation: 4d10 x 10
          expect(camp.special, matches(RegExp(r'^\d+ Anões$')));
          final dwarfNumber = int.parse(camp.special.split(' ')[0]);
          expect(dwarfNumber, greaterThanOrEqualTo(40)); // 4d10 minimum = 4, so 4*10 = 40
          expect(dwarfNumber, lessThanOrEqualTo(400)); // 4d10 maximum = 40, so 40*10 = 400
          expect(dwarfNumber % 10, equals(0)); // Must be multiple of 10
          
          expect(camp.tents, equals('1 a cada 10 membros'));
          expect(camp.watch, equals('Sentinelas alertas'));
          expect(camp.defenses, equals('Muro de terra'));
        }
        
        print('✅ Roll 2 deep verification passed - All dice properly resolved!');
      });

      test('Roll 3: Cultistas (2d4) + Jogue na tabela 4.23 + Forte abandonado - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 3 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(3, 3, 3, 3, 3);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          // Verify cultistas calculation: 2d4
          expect(camp.type, matches(RegExp(r'^\d+ Cultistas$')));
          final cultistNumber = int.parse(camp.type.split(' ')[0]);
          expect(cultistNumber, greaterThanOrEqualTo(2)); // 2d4 minimum = 2
          expect(cultistNumber, lessThanOrEqualTo(8)); // 2d4 maximum = 8
          
          expect(camp.special, equals('Jogue na tabela 4.23'));
          expect(camp.tents, equals('1 a cada 5 membros'));
          expect(camp.watch, equals('Vigias em ronda'));
          expect(camp.defenses, equals('Forte abandonado'));
        }
        
        print('✅ Roll 3 deep verification passed - All dice properly resolved!');
      });

      test('Roll 4: Mercenários (7d6) + Jogue na tabela 4.23 + Torre de vigília - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 4 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(4, 4, 4, 4, 4);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          // Verify mercenários calculation: 7d6
          expect(camp.type, matches(RegExp(r'^\d+ Mercenários$')));
          final mercenaryNumber = int.parse(camp.type.split(' ')[0]);
          expect(mercenaryNumber, greaterThanOrEqualTo(7)); // 7d6 minimum = 7
          expect(mercenaryNumber, lessThanOrEqualTo(42)); // 7d6 maximum = 42
          
          expect(camp.special, equals('Jogue na tabela 4.23'));
          expect(camp.tents, equals('Apenas uma grande tenda'));
          expect(camp.watch, equals('Cães de guarda'));
          expect(camp.defenses, equals('Torre de vigília'));
        }
        
        print('✅ Roll 4 deep verification passed - All dice properly resolved!');
      });

      test('Roll 5: Patrulha (2d6) + Jogue na tabela 4.23 + Sem defesas - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 5 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(5, 5, 5, 5, 5);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          // Verify patrulha calculation: 2d6
          expect(camp.type, matches(RegExp(r'^\d+ Patrulha$')));
          final patrolNumber = int.parse(camp.type.split(' ')[0]);
          expect(patrolNumber, greaterThanOrEqualTo(2)); // 2d6 minimum = 2
          expect(patrolNumber, lessThanOrEqualTo(12)); // 2d6 maximum = 12
          
          expect(camp.special, equals('Jogue na tabela 4.23'));
          expect(camp.tents, equals('Não há tendas'));
          expect(camp.watch, equals('Patrulha montada'));
          expect(camp.defenses, equals('Sem defesas'));
        }
        
        print('✅ Roll 5 deep verification passed - All dice properly resolved!');
      });

      test('Roll 6: Especial + Jogue na tabela 4.23 + Sem defesas - Dice Resolution', () {
        print('\n=== TABELA 4.22 ROLL 6 DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final camp = service.generateCampWithRolls(6, 6, 6, 6, 6);
          print('Iteration ${i + 1}:');
          print('  Type: ${camp.type}');
          print('  Special: ${camp.special}');
          print('  Tents: ${camp.tents}');
          print('  Watch: ${camp.watch}');
          print('  Defenses: ${camp.defenses}');
          
          expect(camp.type, equals('Especial'));
          expect(camp.special, equals('Jogue na tabela 4.23'));
          expect(camp.tents, equals('Não há tendas'));
          expect(camp.watch, equals('Sem vigília'));
          expect(camp.defenses, equals('Sem defesas'));
        }
        
        print('✅ Roll 6 deep verification passed - All dice properly resolved!');
      });
    });

    group('Table 4.23 - Tribos Deep Verification', () {
      test('Subterranean - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 SUBTERRANEAN ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Orc', 'Hobgoblin', 'Goblin', 'Drakold', 'Homem das Cavernas', 'Sahuagin'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.subterranean, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Subterranean all rolls deep verification passed!');
      });

      test('Forests - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 FORESTS ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Orc', 'Goblin', 'Ogro', 'Hobgoblin', 'Sibilantes', 'Gnoll'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.forests, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Forests all rolls deep verification passed!');
      });

      test('Plains - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 PLAINS ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Orc', 'Goblin', 'Ogro', 'Hobgoblin', 'Homem Lagarto', 'Gnoll'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.plains, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Plains all rolls deep verification passed!');
      });

      test('Deserts - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 DESERTS ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Ogro', 'Goblin', 'Orc', 'Drakold', 'Homem das Cavernas', 'Sibilantes'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.deserts, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Deserts all rolls deep verification passed!');
      });

      test('Hills - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 HILLS ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Goblin', 'Hobgoblin', 'Ogro', 'Orc', 'Kobold', 'Bugbear'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.hills, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Hills all rolls deep verification passed!');
      });

      test('Mountains - All Rolls (1-6) - Dice Resolution', () {
        print('\n=== TABELA 4.23 MOUNTAINS ALL ROLLS DEEP VERIFICATION ===');
        
        final expectedTypes = ['Ogro', 'Orc', 'Goblin', 'Trogloditas', 'Kobold', 'Bugbear'];
        
        for (int roll = 1; roll <= 6; roll++) {
          final tribe = service.generateTribeWithRoll(TerrainType.mountains, roll);
          print('Roll $roll: Type: ${tribe.type}, Members: ${tribe.members}');
          
          expect(tribe.type, equals(expectedTypes[roll - 1]));
          
          // Verify member count calculations based on type
          _verifyTribeMemberCalculations(tribe);
        }
        
        print('✅ Mountains all rolls deep verification passed!');
      });
    });

    group('Table 4.24 - Detalhando Membros Deep Verification', () {
      test('Bugbear (6d6) - Member Calculations', () {
        print('\n=== TABELA 4.24 BUGBEAR DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final tribe = service.generateTribeWithRoll(TerrainType.hills, 6); // Bugbear
          print('Iteration ${i + 1}:');
          print('  Type: ${tribe.type}');
          print('  Members: ${tribe.members}');
          print('  Soldiers: ${tribe.soldiers}');
          print('  Leaders: ${tribe.leaders}');
          print('  Religious: ${tribe.religious}');
          print('  Special: ${tribe.special}');
          
          expect(tribe.type, equals('Bugbear'));
          
          // Verify member count: 6d6
          expect(tribe.members, greaterThanOrEqualTo(6)); // 6d6 minimum = 6
          expect(tribe.members, lessThanOrEqualTo(36)); // 6d6 maximum = 36
          
          // Verify soldiers: 2 a cada 5
          expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
          
          // Verify leaders: always 1
          expect(tribe.leaders, equals(1));
          
          // Verify religious: none for Bugbear
          expect(tribe.religious, equals(0));
          
          // Verify special: none for Bugbear
          expect(tribe.special, equals(0));
        }
        
        print('✅ Bugbear deep verification passed!');
      });

      test('Drakold (4d10 x 10) - Member Calculations', () {
        print('\n=== TABELA 4.24 DRAKOLD DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final tribe = service.generateTribeWithRoll(TerrainType.subterranean, 4); // Drakold
          print('Iteration ${i + 1}:');
          print('  Type: ${tribe.type}');
          print('  Members: ${tribe.members}');
          print('  Soldiers: ${tribe.soldiers}');
          print('  Leaders: ${tribe.leaders}');
          print('  Religious: ${tribe.religious}');
          print('  Special: ${tribe.special}');
          
          expect(tribe.type, equals('Drakold'));
          
          // Verify member count: 4d10 x 10
          expect(tribe.members, greaterThanOrEqualTo(40)); // 4d10 minimum = 4, so 4*10 = 40
          expect(tribe.members, lessThanOrEqualTo(400)); // 4d10 maximum = 40, so 40*10 = 400
          expect(tribe.members % 10, equals(0)); // Must be multiple of 10
          
          // Verify soldiers: 1 a cada 10
          expect(tribe.soldiers, equals(tribe.members ~/ 10));
          
          // Verify leaders: always 1
          expect(tribe.leaders, equals(1));
          
          // Verify religious: 1 a cada 100
          expect(tribe.religious, equals(tribe.members ~/ 100));
          
          // Verify special: none for Drakold
          expect(tribe.special, equals(0));
        }
        
        print('✅ Drakold deep verification passed!');
      });

      test('Goblin (4d10 x 10) - Member Calculations', () {
        print('\n=== TABELA 4.24 GOBLIN DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final tribe = service.generateTribeWithRoll(TerrainType.hills, 1); // Goblin
          print('Iteration ${i + 1}:');
          print('  Type: ${tribe.type}');
          print('  Members: ${tribe.members}');
          print('  Soldiers: ${tribe.soldiers}');
          print('  Leaders: ${tribe.leaders}');
          print('  Religious: ${tribe.religious}');
          print('  Special: ${tribe.special}');
          
          expect(tribe.type, equals('Goblin'));
          
          // Verify member count: 4d10 x 10
          expect(tribe.members, greaterThanOrEqualTo(40)); // 4d10 minimum = 4, so 4*10 = 40
          expect(tribe.members, lessThanOrEqualTo(400)); // 4d10 maximum = 40, so 40*10 = 400
          expect(tribe.members % 10, equals(0)); // Must be multiple of 10
          
          // Verify soldiers: 1 a cada 5
          expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
          
          // Verify leaders: always 1
          expect(tribe.leaders, equals(1));
          
          // Verify religious: 1 a cada 100
          expect(tribe.religious, equals(tribe.members ~/ 100));
          
          // Verify special: 1 a cada 50
          expect(tribe.special, equals(tribe.members ~/ 50));
        }
        
        print('✅ Goblin deep verification passed!');
      });

      test('Ogro (2d10) - Member Calculations', () {
        print('\n=== TABELA 4.24 OGRO DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final tribe = service.generateTribeWithRoll(TerrainType.deserts, 1); // Ogro
          print('Iteration ${i + 1}:');
          print('  Type: ${tribe.type}');
          print('  Members: ${tribe.members}');
          print('  Soldiers: ${tribe.soldiers}');
          print('  Leaders: ${tribe.leaders}');
          print('  Religious: ${tribe.religious}');
          print('  Special: ${tribe.special}');
          
          expect(tribe.type, equals('Ogro'));
          
          // Verify member count: 2d10
          expect(tribe.members, greaterThanOrEqualTo(2)); // 2d10 minimum = 2
          expect(tribe.members, lessThanOrEqualTo(20)); // 2d10 maximum = 20
          
          // Verify soldiers: 3 a cada 5
          expect(tribe.soldiers, equals((tribe.members * 3) ~/ 5));
          
          // Verify leaders: always 1
          expect(tribe.leaders, equals(1));
          
          // Verify religious: none for Ogro
          expect(tribe.religious, equals(0));
          
          // Verify special: none for Ogro
          expect(tribe.special, equals(0));
        }
        
        print('✅ Ogro deep verification passed!');
      });

      test('Orc (3d10 x 10) - Member Calculations', () {
        print('\n=== TABELA 4.24 ORC DEEP VERIFICATION ===');
        
        for (int i = 0; i < 10; i++) {
          final tribe = service.generateTribeWithRoll(TerrainType.subterranean, 1); // Orc
          print('Iteration ${i + 1}:');
          print('  Type: ${tribe.type}');
          print('  Members: ${tribe.members}');
          print('  Soldiers: ${tribe.soldiers}');
          print('  Leaders: ${tribe.leaders}');
          print('  Religious: ${tribe.religious}');
          print('  Special: ${tribe.special}');
          
          expect(tribe.type, equals('Orc'));
          
          // Verify member count: 3d10 x 10
          expect(tribe.members, greaterThanOrEqualTo(30)); // 3d10 minimum = 3, so 3*10 = 30
          expect(tribe.members, lessThanOrEqualTo(300)); // 3d10 maximum = 30, so 30*10 = 300
          expect(tribe.members % 10, equals(0)); // Must be multiple of 10
          
          // Verify soldiers: 3 a cada 5
          expect(tribe.soldiers, equals((tribe.members * 3) ~/ 5));
          
          // Verify leaders: always 1
          expect(tribe.leaders, equals(1));
          
          // Verify religious: 1 a cada 100
          expect(tribe.religious, equals(tribe.members ~/ 100));
          
          // Verify special: 1 a cada 50
          expect(tribe.special, equals(tribe.members ~/ 50));
        }
        
        print('✅ Orc deep verification passed!');
      });
    });
  });
}

void _verifyTribeMemberCalculations(Tribe tribe) {
  // Verify member count ranges based on type
  switch (tribe.type) {
    case 'Bugbear':
      expect(tribe.members, greaterThanOrEqualTo(6)); // 6d6 minimum
      expect(tribe.members, lessThanOrEqualTo(36)); // 6d6 maximum
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(0));
      break;
    case 'Drakold':
      expect(tribe.members, greaterThanOrEqualTo(40)); // 4d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(400)); // 4d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals(tribe.members ~/ 10));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 100));
      expect(tribe.special, equals(0));
      break;
    case 'Gnoll':
      expect(tribe.members, greaterThanOrEqualTo(20)); // 2d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(200)); // 2d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(0));
      break;
    case 'Goblin':
      expect(tribe.members, greaterThanOrEqualTo(40)); // 4d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(400)); // 4d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 100));
      expect(tribe.special, equals(tribe.members ~/ 50));
      break;
    case 'Hobgoblin':
      expect(tribe.members, greaterThanOrEqualTo(20)); // 2d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(200)); // 2d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(tribe.members ~/ 20));
      break;
    case 'Homem das Cavernas':
      expect(tribe.members, greaterThanOrEqualTo(30)); // 3d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(300)); // 3d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals(tribe.members ~/ 10));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(0));
      break;
    case 'Homem Lagarto':
      expect(tribe.members, greaterThanOrEqualTo(10)); // 1d4 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(40)); // 1d4 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 20));
      expect(tribe.special, equals(tribe.members ~/ 10));
      break;
    case 'Kobold':
      expect(tribe.members, greaterThanOrEqualTo(40)); // 4d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(400)); // 4d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals(tribe.members ~/ 10));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 100));
      expect(tribe.special, equals(0));
      break;
    case 'Ogro':
      expect(tribe.members, greaterThanOrEqualTo(2)); // 2d10 minimum
      expect(tribe.members, lessThanOrEqualTo(20)); // 2d10 maximum
      expect(tribe.soldiers, equals((tribe.members * 3) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(0));
      break;
    case 'Orc':
      expect(tribe.members, greaterThanOrEqualTo(30)); // 3d10 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(300)); // 3d10 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 3) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 100));
      expect(tribe.special, equals(tribe.members ~/ 50));
      break;
    case 'Sahuagin':
      expect(tribe.members, greaterThanOrEqualTo(4)); // 4d6 minimum
      expect(tribe.members, lessThanOrEqualTo(24)); // 4d6 maximum
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(0));
      expect(tribe.special, equals(tribe.members ~/ 10));
      break;
    case 'Sibilantes':
      expect(tribe.members, greaterThanOrEqualTo(10)); // 1d6 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(60)); // 1d6 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 10));
      expect(tribe.special, equals(tribe.members ~/ 15));
      break;
    case 'Trogloditas':
      expect(tribe.members, greaterThanOrEqualTo(10)); // 1d4 x 10 minimum
      expect(tribe.members, lessThanOrEqualTo(40)); // 1d4 x 10 maximum
      expect(tribe.members % 10, equals(0)); // Must be multiple of 10
      expect(tribe.soldiers, equals((tribe.members * 2) ~/ 5));
      expect(tribe.leaders, equals(1));
      expect(tribe.religious, equals(tribe.members ~/ 20));
      expect(tribe.special, equals(0));
      break;
    default:
      fail('Unknown tribe type: ${tribe.type}');
  }
} 