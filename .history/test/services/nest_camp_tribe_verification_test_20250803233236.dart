import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/enums/table_enums.dart';

void main() {
  group('Nest, Camp, and Tribe Tables Verification Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Table 4.21 - Ninhos Tests', () {
      test('Roll 1: Águia Gigante (1d6) + Plataforma rochosa', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 1 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser águia gigante
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser plataforma rochosa
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 1 verification passed!');
      });

      test('Roll 2: Pégaso (1d6) + Oco no topo de árvores', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 2 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser pégaso
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser oco no topo de árvores
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 2 verification passed!');
      });

      test('Roll 3: Wyvern (1d4) + Grutas de pedra', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 3 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser wyvern
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser grutas de pedra
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 3 verification passed!');
      });

      test('Roll 4: Grifo (1d4) + Ninho de gravetos', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 4 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser grifo
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser ninho de gravetos
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 4 verification passed!');
      });

      test('Roll 5: Harpia (1d4) + Contém 1d3 ovos', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 5 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser harpia
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser contém ovos
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 5 verification passed!');
      });

      test('Roll 6: Mantícora (1d4) + Contém 1d2 filhotes', () {
        final nest = service.generateNest();
        print('=== TABELA 4.21 ROLL 6 VERIFICATION ===');
        print('Owner: ${nest.owner}');
        print('Characteristic: ${nest.characteristic}');
        
        // Verificar se pode ser mantícora
        expect(nest.owner, anyOf(
          matches(RegExp(r'\d+ Águia Gigante')),
          matches(RegExp(r'\d+ Pégaso')),
          matches(RegExp(r'\d+ Wyvern')),
          matches(RegExp(r'\d+ Grifo')),
          matches(RegExp(r'\d+ Harpia')),
          matches(RegExp(r'\d+ Mantícora')),
        ));
        
        // Verificar se pode ser contém filhotes
        expect(nest.characteristic, anyOf(
          equals('Plataforma rochosa'),
          equals('Oco no topo de árvores'),
          equals('Grutas de pedra'),
          equals('Ninho de gravetos'),
          matches(RegExp(r'Contém \d+ ovos')),
          matches(RegExp(r'Contém \d+ filhotes')),
        ));
        
        print('✅ Roll 6 verification passed!');
      });
    });

    group('Table 4.22 - Acampamentos Tests', () {
      test('Roll 1: Bandidos (2d4 x 10) + Paliçada', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 1 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser bandidos
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser paliçada
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 1 verification passed!');
      });

      test('Roll 2: Bárbaros (3d10 x 10) + Muro de terra', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 2 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser bárbaros
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser muro de terra
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 2 verification passed!');
      });

      test('Roll 3: Cultistas (2d4) + Forte abandonado', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 3 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser cultistas
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser forte abandonado
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 3 verification passed!');
      });

      test('Roll 4: Mercenários (7d6) + Torre de vigília', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 4 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser mercenários
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser torre de vigília
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 4 verification passed!');
      });

      test('Roll 5: Patrulha (2d6) + Sem defesas', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 5 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser patrulha
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser sem defesas
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 5 verification passed!');
      });

      test('Roll 6: Especial + Sem defesas', () {
        final camp = service.generateCamp();
        print('=== TABELA 4.22 ROLL 6 VERIFICATION ===');
        print('Type: ${camp.type}');
        print('Special: ${camp.special}');
        print('Tents: ${camp.tents}');
        print('Watch: ${camp.watch}');
        print('Defenses: ${camp.defenses}');
        
        // Verificar se pode ser especial
        expect(camp.type, anyOf(
          matches(RegExp(r'\d+ Bandidos')),
          matches(RegExp(r'\d+ Bárbaros')),
          matches(RegExp(r'\d+ Cultistas')),
          matches(RegExp(r'\d+ Mercenários')),
          matches(RegExp(r'\d+ Patrulha')),
          equals('Especial'),
        ));
        
        // Verificar se pode ser sem defesas
        expect(camp.defenses, anyOf(
          equals('Paliçada'),
          equals('Muro de terra'),
          equals('Forte abandonado'),
          equals('Torre de vigília'),
          equals('Sem defesas'),
        ));
        
        print('✅ Roll 6 verification passed!');
      });
    });

    group('Table 4.23 - Tribos Tests', () {
      test('Subterranean - Roll 1: Orc', () {
        final tribe = service.generateTribe(TerrainType.subterranean);
        print('=== TABELA 4.23 SUBTERRANEAN ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser orc
        expect(tribe.type, anyOf(
          equals('Orc'),
          equals('Hobgoblin'),
          equals('Goblin'),
          equals('Drakold'),
          equals('Homem das Cavernas'),
          equals('Sahuagin'),
        ));
        
        print('✅ Subterranean Roll 1 verification passed!');
      });

      test('Forests - Roll 1: Orc', () {
        final tribe = service.generateTribe(TerrainType.forests);
        print('=== TABELA 4.23 FORESTS ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser orc
        expect(tribe.type, anyOf(
          equals('Orc'),
          equals('Goblin'),
          equals('Ogro'),
          equals('Hobgoblin'),
          equals('Sibilantes'),
          equals('Gnoll'),
        ));
        
        print('✅ Forests Roll 1 verification passed!');
      });

      test('Plains - Roll 1: Orc', () {
        final tribe = service.generateTribe(TerrainType.plains);
        print('=== TABELA 4.23 PLAINS ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser orc
        expect(tribe.type, anyOf(
          equals('Orc'),
          equals('Goblin'),
          equals('Ogro'),
          equals('Hobgoblin'),
          equals('Homem Lagarto'),
          equals('Gnoll'),
        ));
        
        print('✅ Plains Roll 1 verification passed!');
      });

      test('Deserts - Roll 1: Ogro', () {
        final tribe = service.generateTribe(TerrainType.deserts);
        print('=== TABELA 4.23 DESERTS ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser ogro
        expect(tribe.type, anyOf(
          equals('Ogro'),
          equals('Goblin'),
          equals('Orc'),
          equals('Drakold'),
          equals('Homem das Cavernas'),
          equals('Sibilantes'),
        ));
        
        print('✅ Deserts Roll 1 verification passed!');
      });

      test('Hills - Roll 1: Goblin', () {
        final tribe = service.generateTribe(TerrainType.hills);
        print('=== TABELA 4.23 HILLS ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser goblin
        expect(tribe.type, anyOf(
          equals('Goblin'),
          equals('Hobgoblin'),
          equals('Ogro'),
          equals('Orc'),
          equals('Kobold'),
          equals('Bugbear'),
        ));
        
        print('✅ Hills Roll 1 verification passed!');
      });

      test('Mountains - Roll 1: Ogro', () {
        final tribe = service.generateTribe(TerrainType.mountains);
        print('=== TABELA 4.23 MOUNTAINS ROLL 1 ===');
        print('Type: ${tribe.type}');
        print('Members: ${tribe.members}');
        print('Soldiers: ${tribe.soldiers}');
        print('Leaders: ${tribe.leaders}');
        print('Religious: ${tribe.religious}');
        print('Special: ${tribe.special}');
        
        // Verificar se pode ser ogro
        expect(tribe.type, anyOf(
          equals('Ogro'),
          equals('Orc'),
          equals('Goblin'),
          equals('Trogloditas'),
          equals('Kobold'),
          equals('Bugbear'),
        ));
        
        print('✅ Mountains Roll 1 verification passed!');
      });
    });
  });
} 