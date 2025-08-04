import 'package:test/test.dart';
import '../../lib/services/exploration_service.dart';
import '../../lib/models/exploration.dart';
import '../../lib/enums/exploration_enums.dart';

void main() {
  group('Ancestral Automation Tests', () {
    late ExplorationService service;

    setUp(() {
      service = ExplorationService();
    });

    group('Ancestral Discovery Automation', () {
      test('should generate complete ancestral discovery automatically', () {
        final discovery = service.generateAncestralDiscovery();

        expect(discovery, isA<AncestralDiscovery>());
        expect(discovery.type, isA<AncestralThingType>());
        expect(discovery.condition, isA<AncestralCondition>());
        expect(discovery.material, isA<AncestralMaterial>());
        expect(discovery.state, isA<AncestralState>());
        expect(discovery.guardian, isA<AncestralGuardian>());
        expect(discovery.description, isNotEmpty);
        expect(discovery.details, isNotEmpty);

        print('Ancestral Discovery: ${discovery.description}');
        print('Type: ${discovery.type.description}');
        print('Condition: ${discovery.condition.description}');
        print('Material: ${discovery.material.description}');
        print('State: ${discovery.state.description}');
        print('Guardian: ${discovery.guardian.description}');
      });
    });

    group('Ruin Automation', () {
      test('should generate ruins automatically with resolved dice rolls', () {
        final ruin = service.generateRuin();

        expect(ruin, isA<Ruin>());
        expect(ruin.type, isA<RuinType>());
        expect(ruin.description, isNotEmpty);
        expect(ruin.details, isNotEmpty);
        expect(ruin.size, isNotEmpty);
        expect(ruin.defenses, isNotEmpty);

        print('Ruin: ${ruin.description}');
        print('Type: ${ruin.type.description}');
        print('Size: ${ruin.size}');
        print('Defenses: ${ruin.defenses}');
      });
    });

    group('Relic Automation', () {
      test('should generate relics automatically with magic items', () {
        final relic = service.generateRelic();

        expect(relic, isA<Relic>());
        expect(relic.type, isA<RelicType>());
        expect(relic.description, isNotEmpty);
        expect(relic.details, isNotEmpty);
        expect(relic.condition, isNotEmpty);

        print('Relic: ${relic.description}');
        print('Type: ${relic.type.description}');
        print('Condition: ${relic.condition}');
      });
    });

    group('Object Automation', () {
      test('should generate objects automatically', () {
        final object = service.generateObject();

        expect(object, isA<Object>());
        expect(object.type, isA<ObjectType>());
        expect(object.description, isNotEmpty);
        expect(object.details, isNotEmpty);
        expect(object.subtype, isNotEmpty);

        print('Object: ${object.description}');
        print('Type: ${object.type.description}');
        print('Subtype: ${object.subtype}');
      });
    });

    group('Vestige Automation', () {
      test('should generate vestiges automatically', () {
        final vestige = service.generateVestige();

        expect(vestige, isA<Vestige>());
        expect(vestige.type, isA<VestigeType>());
        expect(vestige.description, isNotEmpty);
        expect(vestige.details, isNotEmpty);
        expect(vestige.detail, isNotEmpty);

        print('Vestige: ${vestige.description}');
        print('Type: ${vestige.type.description}');
        print('Detail: ${vestige.detail}');
      });
    });

    group('Ossuary Automation', () {
      test('should generate ossuaries automatically', () {
        final ossuary = service.generateOssuary();

        expect(ossuary, isA<Ossuary>());
        expect(ossuary.type, isA<OssuaryType>());
        expect(ossuary.description, isNotEmpty);
        expect(ossuary.details, isNotEmpty);
        expect(ossuary.size, isNotEmpty);

        print('Ossuary: ${ossuary.description}');
        print('Type: ${ossuary.type.description}');
        print('Size: ${ossuary.size}');
      });
    });

    group('Magical Item Automation', () {
      test('should generate magical items automatically with double rolls', () {
        final magicalItem = service.generateMagicalItem();

        expect(magicalItem, isA<MagicalItem>());
        expect(magicalItem.type, isA<MagicalItemType>());
        expect(magicalItem.description, isNotEmpty);
        expect(magicalItem.details, isNotEmpty);
        expect(magicalItem.power, isNotEmpty);

        print('Magical Item: ${magicalItem.description}');
        print('Type: ${magicalItem.type.description}');
        print('Power: ${magicalItem.power}');
      });
    });

    group('Multiple Generation Test', () {
      test('should generate multiple items without conflicts', () {
        // Gerar múltiplos itens para verificar se não há conflitos
        for (int i = 0; i < 10; i++) {
          final discovery = service.generateAncestralDiscovery();
          final ruin = service.generateRuin();
          final relic = service.generateRelic();
          final object = service.generateObject();
          final vestige = service.generateVestige();
          final ossuary = service.generateOssuary();
          final magicalItem = service.generateMagicalItem();

          expect(discovery, isA<AncestralDiscovery>());
          expect(ruin, isA<Ruin>());
          expect(relic, isA<Relic>());
          expect(object, isA<Object>());
          expect(vestige, isA<Vestige>());
          expect(ossuary, isA<Ossuary>());
          expect(magicalItem, isA<MagicalItem>());
        }

        print('✅ All ancestral discovery types generated successfully!');
      });
    });
  });
}
